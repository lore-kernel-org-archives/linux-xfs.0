Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0295B7F51
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 16:10:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DCC9A304048
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 14:10:15 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	1tDTD55DbY4pBukX for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 14:10:13 -0800 (PST)
Date: Thu, 14 Nov 2013 09:10:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
Message-ID: <20131113221009.GK6188@dastard>
References: <5283C41D.7070503@redhat.com>
	<20131113185645.GA20869@infradead.org>
	<5283CE2E.2070702@sandeen.net> <20131113212658.GJ6188@dastard>
	<5283EFFE.5090700@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5283EFFE.5090700@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 13, 2013 at 03:32:46PM -0600, Eric Sandeen wrote:
> On 11/13/13, 3:26 PM, Dave Chinner wrote:
> > On Wed, Nov 13, 2013 at 01:08:30PM -0600, Eric Sandeen wrote:
> >> On 11/13/13, 12:56 PM, Christoph Hellwig wrote:
> >>> On Wed, Nov 13, 2013 at 12:25:33PM -0600, Eric Sandeen wrote:
> >>>> Pure RFC; this might be crazy.  Here's the problem I'm trying to solve:
> >>>>
> >>>> Today, mkfs.xfs will select a 4k sector size for a 4k physical / 512 logical
> >>>> drive.  (that change was done by me).  The thought was that it'd be an
> >>>> efficiency gain to not make the drive do the (possible) RMW cycles on
> >>>> 512-byte log IO, primarily.
> >>>>
> >>>> However, now this restricts all DIO to 4k alignment, not the otherwise-
> >>>> possible 512.
> >>>>
> >>>> This came up when qemu-kvm, in cache=none mode, tries to boot off an
> >>>> image hosted on such a filesystem, and its bios wants to do a 512 byte
> >>>> direct IO read off the disk - it fails.
> >>>>
> >>>> But I'm wondering - the buftarg's bt_sshift and bt_smask are only used
> >>>> in a few places.  
> >>>
> >>> No need to mess with kernel code IFF we want to change that, just keep
> >>> the sector size at 512 bytes and set a log stripe unit at mkfs time.
> >>>
> >>> I have to admit that I'm not really sure if that's what we really want,
> >>> through.  A drive that has a larger physical block size will need
> >>> read-modify-write cycles internally, which we try to avoid.
> >>
> >> Yeah, the problem comes up when it is 100% impossible to boot a
> >> qemu-kvm guest hosted on such a filesystem/drive.  :(
> > 
> > No it's not. Just use cache=writethrough and the page cache will
> > take care of the mismatch when it occurs.
> 
> Sorry, I meant impossible w/ cache=none.
> 
> TBH, I don't know what best practice is.

No idea what best practice for the virt side is, but best practice
from a storage perspective is that everything in the IO stack should
use the sector size from the underlying layer. Given that virt adds
layers to the storage stack above the filesystem, that means it
needs to support whatever sector size the filesystem is using...

> >> (of course I guess that means it fails on a hard 4k drive too)
> > 
> > And on any other filesystem that thinks it has sectors larger than
> > 512 bytes underlying it (e.g. cdrom has a 2k sector size).
> > 
> >> I don't know what the guest sees for logical/physical on its
> >> file-backed block device in these cases.
> > 
> > Seems like that's the avenue for improvement here to me. i.e. expose
> > the correct values to the guest so it's mkfs does the right thing.
> > Or, alternatively, make qemu buffer non-aligned/sized IOs itself
> > internally.
> 
> The guest never _boots_ - it's not a guest mkfs issue.

Oh, that wasn't clear.

> The guest bios wants to read 512 via DIO off the image on this 4k
> sector FS, and fails.

So the bios has never been updated to handle 4k sector devices?

> > After all, it has been told to use direct IO, and when that happens
> > it is the application's responsibility to ensure IO alignment
> > requirements are met...
> 
> Agreed, but in talking to a qemu guy... 
> 
> "In my understanding, that's a limitation that directly comes from the BIOS interface."
> "int 13h just assumes 512 bytes"
> 
> But this is above my pay grade.  I don't speak BIOS.

Yet all modern bios implementations you find in hardware can boot 4k
sector devices just fine. So, what bios does qemu use?

$ man qemu
.....
QEMU uses the PC BIOS from the Bochs project and the Plex86/Bochs
LGPL VGA BIOS.
.....

So what we have here is an *open source bios* that doesn't handle
drives 4k sector sizes. There's the problem that needs to be fixed....

> >> Anyway, if we took your suggestion, normal internal fs operations
> >> (log IO) wouldn't RMW.  But we'd still presumably advertise and allow
> >> smaller DIO sizes, which are inefficient.  We could advertise 4k, but
> >> still allow 512 for less-smart apps, maybe?
> > 
> > I'd say such a problem is a matter of user education and making qemu
> > aware of logical/physical differences - hacking weird corner cases
> > into what a sector size means is only going to lead to confusion and
> > bite us in unexpected ways...
> 
> Probably so; hence the "crazy" disclaimer.  ;)
> 
> But it does seem a little odd to semi-artificially reject DIOs which
> the drive could actually handle.
> 
> Indeed, do_blockdev_direct_IO looks right at the logical block size,
> and allows it:
> 
>         if (offset & blocksize_mask) {
>                 if (bdev)
>                         blkbits = blksize_bits(bdev_logical_block_size(bdev));
>                 blocksize_mask = (1 << blkbits) - 1;
>                 if (offset & blocksize_mask)
>                         goto out;
>         }
> 
> it's our checks in XFS that fail.

No they don't - they are working just fine. We've told XFS that the
sector size is X, and therefore we don't allow IO in smaller units,
data or metadata.  That's the whole point of the filesystem having a
configurable sector size - we can *enforce* a larger minimum IO
requirement than the underlying hardware supports.

We've done this for years - e.g. long time ago MD devices had a
massive performance penalty for sub-page sized IOs, so mkfs set the
sector size to 4k to avoid that problem, even though we could have
done 512 byte IOs to the underlying devices.

Lets fix the problem at the source - the bios that doesn't support
4k sector devices - like we've done for all the other utilities that
need to be aware of disk sector sizes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
