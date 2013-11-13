Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 01A917F53
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 15:27:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D426F8F8040
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:27:02 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	I5512npHBM8hH0Sg for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 13:27:01 -0800 (PST)
Date: Thu, 14 Nov 2013 08:26:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
Message-ID: <20131113212658.GJ6188@dastard>
References: <5283C41D.7070503@redhat.com>
	<20131113185645.GA20869@infradead.org>
	<5283CE2E.2070702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5283CE2E.2070702@sandeen.net>
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

On Wed, Nov 13, 2013 at 01:08:30PM -0600, Eric Sandeen wrote:
> On 11/13/13, 12:56 PM, Christoph Hellwig wrote:
> > On Wed, Nov 13, 2013 at 12:25:33PM -0600, Eric Sandeen wrote:
> >> Pure RFC; this might be crazy.  Here's the problem I'm trying to solve:
> >>
> >> Today, mkfs.xfs will select a 4k sector size for a 4k physical / 512 logical
> >> drive.  (that change was done by me).  The thought was that it'd be an
> >> efficiency gain to not make the drive do the (possible) RMW cycles on
> >> 512-byte log IO, primarily.
> >>
> >> However, now this restricts all DIO to 4k alignment, not the otherwise-
> >> possible 512.
> >>
> >> This came up when qemu-kvm, in cache=none mode, tries to boot off an
> >> image hosted on such a filesystem, and its bios wants to do a 512 byte
> >> direct IO read off the disk - it fails.
> >>
> >> But I'm wondering - the buftarg's bt_sshift and bt_smask are only used
> >> in a few places.  
> > 
> > No need to mess with kernel code IFF we want to change that, just keep
> > the sector size at 512 bytes and set a log stripe unit at mkfs time.
> > 
> > I have to admit that I'm not really sure if that's what we really want,
> > through.  A drive that has a larger physical block size will need
> > read-modify-write cycles internally, which we try to avoid.
> 
> Yeah, the problem comes up when it is 100% impossible to boot a
> qemu-kvm guest hosted on such a filesystem/drive.  :(

No it's not. Just use cache=writethrough and the page cache will
take care of the mismatch when it occurs.

> (of course I guess that means it fails on a hard 4k drive too)

And on any other filesystem that thinks it has sectors larger than
512 bytes underlying it (e.g. cdrom has a 2k sector size).

> I don't know what the guest sees for logical/physical on its
> file-backed block device in these cases.

Seems like that's the avenue for improvement here to me. i.e. expose
the correct values to the guest so it's mkfs does the right thing.
Or, alternatively, make qemu buffer non-aligned/sized IOs itself
internally.

After all, it has been told to use direct IO, and when that happens
it is the application's responsibility to ensure IO alignment
requirements are met...

> Anyway, if we took your suggestion, normal internal fs operations
> (log IO) wouldn't RMW.  But we'd still presumably advertise and allow
> smaller DIO sizes, which are inefficient.  We could advertise 4k, but
> still allow 512 for less-smart apps, maybe?

I'd say such a problem is a matter of user education and making qemu
aware of logical/physical differences - hacking weird corner cases
into what a sector size means is only going to lead to confusion and
bite us in unexpected ways...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
