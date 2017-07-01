Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26544 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751851AbdGAQiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Jul 2017 12:38:13 -0400
Date: Sat, 1 Jul 2017 09:38:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Re: Any tips for moving to reflink?
Message-ID: <20170701163802.GX5874@birch.djwong.org>
References: <20170701023529.GP5874@birch.djwong.org>
 <03eb6ac0-6c6e-0494-b008-25a187b43e12@enkore.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03eb6ac0-6c6e-0494-b008-25a187b43e12@enkore.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marian Beermann <public@enkore.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Jul 01, 2017 at 01:41:43PM +0200, Marian Beermann wrote:
> Hi
> 
> > > I'm planning to use this reflink feature for instant local snapshots
> > > and then use my backup software of choice, borg, to keep a long time
> > > history of my work on a remote server. Since borg stores data in a
> > > dedup fashion I can also backup the reflink snapshots and they won't
> > > take additional space. The only drawback is that today borg need to
> > > hash all the files found in a reflink directory in order to find out
> > > about dedup blocks. I asked a question on the borg mailing list
> > > https://github.com/borgbackup/borg/issues/2743 and apparently it
> > > won't be an issue to add a feature to support XFS in order to
> > > identify the physical extents. Is rmapbt required for that?
> >
> > borgbackup will probably need to call the GETFSMAP ioctl, which won't
> > land until 4.12.  On xfs, rmapbt is needed to supply data block
> > ownership info, which is what borgbackup (and bees, and...) say they
> > want to be smarter about dedup.
> 
> My understanding so far was that FIEMAP would be sufficient to query the
> extents associated with a file. Shouldn't this be sufficient to know
> whether two files on the same file system refer to the same data?

Not necessarily -- FIEMAP provides physical offset into a device but
does not actually identify which one, which is a problem on multi-device
filesystems such as btrfs and XFS.  IIRC btrfs creates a virtual
physical offset space consisting of all the devices one after the other,
but then you have to know /that/ mapping too.  GETFSMAP by contrast
tells you which device and where on that device.

--D

> 
> Cheers, Marian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
