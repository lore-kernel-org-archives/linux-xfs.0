Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F21427F37
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 18:34:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFCBA8F804C
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 16:34:30 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zuKyc00GktmQwOoJ for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 16:34:28 -0800 (PST)
Date: Thu, 14 Nov 2013 11:34:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
Message-ID: <20131114003402.GL6188@dastard>
References: <5283C41D.7070503@redhat.com>
	<20131113185645.GA20869@infradead.org>
	<5283CE2E.2070702@sandeen.net> <20131113212658.GJ6188@dastard>
	<5283EFFE.5090700@redhat.com> <20131113221009.GK6188@dastard>
	<5283FAB8.3070307@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5283FAB8.3070307@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 13, 2013 at 04:18:32PM -0600, Eric Sandeen wrote:
> On 11/13/13, 4:10 PM, Dave Chinner wrote:
> 
> ...
> 
> > Yet all modern bios implementations you find in hardware can boot 4k
> > sector devices just fine.
> 
> hm can they really?  Most drives have 512 emulation.
.....
> > We've done this for years - e.g. long time ago MD devices had a
> > massive performance penalty for sub-page sized IOs, so mkfs set the
> > sector size to 4k to avoid that problem, even though we could have
> > done 512 byte IOs to the underlying devices.
> > 
> > Lets fix the problem at the source - the bios that doesn't support
> > 4k sector devices - like we've done for all the other utilities that
> > need to be aware of disk sector sizes....
> 
> I don't disagree with that, but by looking at a 4k/512 drive and deciding
> to make 4k sectors, we now present guests with something that barely
> exists in the real world: a hard 4k drive w/ no 512 logical fallback.

Yet we've been doing this for *years*. And working around the
limitations of direct IO as we've moved tools to use it. e.g:

commit f63fd26819b82c766f9e31a28daaa16f387baaa3
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Oct 10 01:08:31 2011 +0000

    repair: handle repair of image files on large sector size filesystems
    
    Because repair uses direct IO, it cannot do IO smaller than a sector
    on the underlying device. When repairing a filesystem image, the
    filesystem hosting the image may have a sector size larger than the
    sector size of the image, and so single image sector reads and
    writes will fail.
    
    To avoid this, when checking a file and there is a sector size
    mismatch like this, turn off direct IO. While there, fix a compile
    bug in the IO_DEBUG option for libxfs which was found during triage.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Alex Elder <aelder@sgi.com>

> Hacking up sector sizes in fs/xfs is probably the wrong way to go,
> but I'm not sure that essentially forcing hard 4k sectors on every
> qemu guest hosted on xfs is a great path either.

Just how widespread is the problem?  This is the first actual report
of this problem I've heard of, and the above commit came from seeing
the problem on my own system (I've got a 3.5TB MD RAID6 volume that
mkfs defaulted to 4k sector size when I made it *4 years ago*).

> Sure, the bios should support 4k - I can ask about that.  But I think
> the concern above still stands: in effect we present a device which is
> less flexible than the real hardware beneath it; we've removed a
> compatibility layer that plenty of software still depends on.

Regardless of the XFS side of things, we need to get all the
software that fails with 4k sectors fixed. That's been our modus
operandi since advanced format drives first appeared on the scene
years ago. Why should we suddenly treat qemu differently, especially
when there appears to be a simple workaround (cache=writethrough).

Yes, I'm being a hard-nosed bastard about this - we can change mkfs
defaults to go back to 512 byte sectors if we choose to, but that
doesn't fix the problem for everyone out there who already has 4k
sector filesystems. And that means qemu needs to be fixed, not
anything on the XFS side....

> I'm not sure that's the best idea; at best it's unexpected.

We never had any guarantee of 512 byte sectors on filesystems. There
never was any "compatibility layer". Direct IO exposes the
filesystem sector size directly to applications, and any application
that does direct IO is expected to handle this, no matter how
"unexpected" it is. Qemu is no exception.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
