Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E8DE7F3F
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 16:18:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D952304053
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 14:18:36 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id PbXUJlIjXoEb55ry for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 14:18:34 -0800 (PST)
Message-ID: <5283FAB8.3070307@sandeen.net>
Date: Wed, 13 Nov 2013 16:18:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com>
	<20131113185645.GA20869@infradead.org>
	<5283CE2E.2070702@sandeen.net> <20131113212658.GJ6188@dastard>
	<5283EFFE.5090700@redhat.com> <20131113221009.GK6188@dastard>
In-Reply-To: <20131113221009.GK6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On 11/13/13, 4:10 PM, Dave Chinner wrote:

...

> Yet all modern bios implementations you find in hardware can boot 4k
> sector devices just fine.

hm can they really?  Most drives have 512 emulation.

> So, what bios does qemu use?
> 
> $ man qemu
> .....
> QEMU uses the PC BIOS from the Bochs project and the Plex86/Bochs
> LGPL VGA BIOS.
> .....
> 
> So what we have here is an *open source bios* that doesn't handle
> drives 4k sector sizes. There's the problem that needs to be fixed....

And if it wants to boot a guest OS that doesn't handle 4k sectors?
 
<snip>

>> it's our checks in XFS that fail.
> 
> No they don't - they are working just fine. We've told XFS that the
> sector size is X, and therefore we don't allow IO in smaller units,
> data or metadata.  That's the whole point of the filesystem having a
> configurable sector size - we can *enforce* a larger minimum IO
> requirement than the underlying hardware supports.

Semantics.  Yes, they work just fine, by failing the call.

> We've done this for years - e.g. long time ago MD devices had a
> massive performance penalty for sub-page sized IOs, so mkfs set the
> sector size to 4k to avoid that problem, even though we could have
> done 512 byte IOs to the underlying devices.
> 
> Lets fix the problem at the source - the bios that doesn't support
> 4k sector devices - like we've done for all the other utilities that
> need to be aware of disk sector sizes....

I don't disagree with that, but by looking at a 4k/512 drive and deciding
to make 4k sectors, we now present guests with something that barely
exists in the real world: a hard 4k drive w/ no 512 logical fallback.

Hacking up sector sizes in fs/xfs is probably the wrong way to go,
but I'm not sure that essentially forcing hard 4k sectors on every
qemu guest hosted on xfs is a great path either.

Sure, the bios should support 4k - I can ask about that.  But I think
the concern above still stands: in effect we present a device which is
less flexible than the real hardware beneath it; we've removed a
compatibility layer that plenty of software still depends on.

I'm not sure that's the best idea; at best it's unexpected.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
