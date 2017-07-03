Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39875 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932407AbdGCQ6z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2017 12:58:55 -0400
Date: Mon, 3 Jul 2017 09:58:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Any tips for moving to reflink?
Message-ID: <20170703165846.GB5874@birch.djwong.org>
References: <20170701023529.GP5874@birch.djwong.org>
 <03eb6ac0-6c6e-0494-b008-25a187b43e12@enkore.de>
 <20170701163802.GX5874@birch.djwong.org>
 <e8fbb00d-4fe3-19e4-47ee-3dc65e2636b4@enkore.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8fbb00d-4fe3-19e4-47ee-3dc65e2636b4@enkore.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marian Beermann <public@enkore.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Jul 02, 2017 at 06:40:25PM +0200, Marian Beermann wrote:
> On 01.07.2017 18:38, Darrick J. Wong wrote:
> > On Sat, Jul 01, 2017 at 01:41:43PM +0200, Marian Beermann wrote:
> >> Hi
> >>
> >>>> I'm planning to use this reflink feature for instant local snapshots
> >>>> and then use my backup software of choice, borg, to keep a long time
> >>>> history of my work on a remote server. Since borg stores data in a
> >>>> dedup fashion I can also backup the reflink snapshots and they won't
> >>>> take additional space. The only drawback is that today borg need to
> >>>> hash all the files found in a reflink directory in order to find out
> >>>> about dedup blocks. I asked a question on the borg mailing list
> >>>> https://github.com/borgbackup/borg/issues/2743 and apparently it
> >>>> won't be an issue to add a feature to support XFS in order to
> >>>> identify the physical extents. Is rmapbt required for that?
> >>>
> >>> borgbackup will probably need to call the GETFSMAP ioctl, which won't
> >>> land until 4.12.  On xfs, rmapbt is needed to supply data block
> >>> ownership info, which is what borgbackup (and bees, and...) say they
> >>> want to be smarter about dedup.
> >>
> >> My understanding so far was that FIEMAP would be sufficient to query the
> >> extents associated with a file. Shouldn't this be sufficient to know
> >> whether two files on the same file system refer to the same data?
> > 
> > Not necessarily -- FIEMAP provides physical offset into a device but
> > does not actually identify which one, which is a problem on multi-device
> > filesystems such as btrfs and XFS.  IIRC btrfs creates a virtual
> > physical offset space consisting of all the devices one after the other,
> > but then you have to know /that/ mapping too.  GETFSMAP by contrast
> > tells you which device and where on that device.
> > 
> 
> I see. If FIEMAP reports same data, while describing different data,
> then it certainly breaks one of the main uses of it (detecting identical
> data)?

In theory, given that FIEMAP does not itself return a device identifier,
you're supposed to know which device for which it's returning extent
information a priori.  That's no help at all to the hapless application
writer, of course.

AFAICT, ocfs2 and ext4 have supported FIEMAP since its introduction; for
these two filesystems the device info is easily guessable since they
only support putting files on a single device.

For btrfs you'd have to figure out how it maps devices to its physical
offset address space.  There's probably an ioctl to query the
appropriate btree, but I don't know how.

For XFS you have to query the inode attributes via FS_IOC_FSGETXATTR,
look for the FS_XFLAG_REALTIME flag, and choose between the data device
or the realtime device (which you can find by parsing /proc/mounts).

Not broken, per se, just insufficient for today's needs, hence GETFSMAP.
Though, opening files by inode number isn't straightforward either.

> To clarify the intended;
> 
> Borg would essentially hash the output of FIEMAP/GETFSMAP for a given
> file and compare this hash with a previous hash.
> 
> If the two hashes don't match,
> then Borg would re-process the entire file.
> 
> It'd be possible to make this more granular, on a per-extent basis

Keep in mind that XFS only does CoW if it has to, so file contents don't
necessarily change the extent map.

--D

> 
> Cheers, Marian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
