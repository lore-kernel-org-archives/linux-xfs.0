Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754976AbeART75 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jan 2018 14:59:57 -0500
Date: Thu, 18 Jan 2018 14:59:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_repair: couldn't map inode 2089979520, err = 117
Message-ID: <20180118195954.GC56446@bfoster.bfoster>
References: <alpine.DEB.2.21.9.1801172204210.14759@trent.utfs.org>
 <20180118183636.GB56446@bfoster.bfoster>
 <20180118185546.GI25805@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180118185546.GI25805@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christian Kujau <lists@nerdbynature.de>, linux-xfs@vger.kernel.org

On Thu, Jan 18, 2018 at 10:55:46AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 18, 2018 at 01:36:37PM -0500, Brian Foster wrote:
> > On Wed, Jan 17, 2018 at 10:27:19PM -0800, Christian Kujau wrote:
> > > Hi,
> > > 
> > > after a(nother) power outage this disk enclosure (containing two seperate 
> > > disks, connected via USB) was acting up and while one of the disks seems 
> > > to have died, the other one still works and no more hardware errors are 
> > > reported for the enclosure or the disk.
> > > 
> > > The XFS file system on this disk can be mounted (!) and data can be read, 
> > > but an xfs_repair fails to complete: http://nerdbynature.de/bits/4.14/xfs/
> > > 
> > > I have (compressed) xfs_metadump images available if anyone is interested.
> > > 
> > > A timeline of events:
> > > 
> > >  * disk enclosure[0] connected to a Raspbery Pi (aarch64)
> > >  * power failure, and possible power spike after power came back
> > >  * RPI and disk enclosure disconnected from power.
> > >  * disk enclosure connected to an x86-64 machine with lots of RAM
> > >  * xfs_repair (Fedora 27, xfsprogs-4.12) attempted, but the disk enclosure
> > >    was still trying to handle the other (failing) disk and the repair
> > >    failed after some USB resets.
> > >  * failed disk was removed from the enclosure, no more hardware errors 
> > >    since, but still xfs_repair is unable to complete.
> > > 
> > > After a chat on #xfs, Eric and Dave remarked:
> > > 
> > > > error 117 means the inode is corrupted; probably shouldn't be at that 
> > > > stage, probably indicates a repair bug? just looking at the first few 
> > > > errors
> > > > bad magic # 0x49414233 in btbno block 28/134141
> > > > bad magic # 0x46494233 in btcnt block 30/870600
> > > > the first magic is IAB3 the 2nd is FIB3 those are magic numbers for
> > > > xfs, but not for the type of block it thought it was checking
> > > 
> > > ...and also:
> > > 
> > > > cross linked btrees does tend to indicate something went badly wrong
> > > > at the hardware level
> > > 
> > > So, with all that (failed xfs_repair runs that were interrupted by 
> > > hardware faults and also possibly flaky USB controller[0]) - has anybody 
> > > an idea on how to convince xfs_repair to still clean up this mess? Or is 
> > > there no other way than to restore from backup?
> > > 
> > 
> > After looking at one of Christian's metadumps, it looks like this is a
> > possible regression as of the inline directory fork verification bits. I
> > don't have the full cause, but xfs_repair explodes due to the parent
> > inode validation in xfs_iformat_fork -> xfs_dir2_sf_verify() when
> > processing directory inode 2089979520. A quick test without the verifier
> > allows repair to complete.
> > 
> > Christian, for the time being I suppose you could try a slightly older
> > xfs_repair and see if that gets you anywhere. v4.10 or so appears to not
> > include the associated commits.
> 
> Ahhhurrgh.  Yes, right now xfsprogs is rather inflexible about the
> verifiers -- the directory repairer decides that it can simply reset the
> parent pointer, but then libxfs_iget & friends barf because the sf
> directory verifier fails, and there's no way to turn that off.
> 
> Well, there /is/ a way -- refactor the sf verifiers such that they're
> (optionally) called by _iget so that repair can load the inode w/o
> verifiers, make the corrections, and write everything back out.  That
> refactoring will appear in Linux 4.16, so I imagine xfs_repair 4.16 will
> get back on track with that.
> 

Ah, right. I thought this whole problem sounded familiar and hadn't
quite been able to put my finger on it yet. I recall some of the
discussion around refactoring those bits for verification flexibility in
userspace. It looks like that stuff just hasn't made it into userspace
yet.. thanks!

Brian

> FWIW I think a reasonable reproducer is running xfs/384 with:
> 
> SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
> SCRATCH_XFS_LIST_FUZZ_VERBS=random
> 
> set in the environment (assumes v5 filesystem, etc.)
> 
> In the meantime, yeah, what Brian said.
> 
> --D
> 
> > Brian
> > 
> > > Thanks,
> > > Christian.
> > > 
> > > [0] When the disk enclosure is connected to the Raspberry Pi 3, the kernel 
> > >     usually recognizes it as follows:
> > > 
> > > usb 1-1.4: new high-speed USB device number 4 using dwc2
> > > usb 1-1.4: New USB device found, idVendor=7825, idProduct=a2a8
> > > usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=5
> > > usb 1-1.4: Product: ElitePro Dual U3FW
> > > usb 1-1.4: Manufacturer: OWC
> > > usb 1-1.4: SerialNumber: DB9876543211160
> > > usb 1-1.4: The driver for the USB controller dwc2_hsotg does not support scatter-gather which is
> > > usb 1-1.4: required by the UAS driver. Please try an other USB controller if you wish to use UAS.
> > > usb 1-1.4: The driver for the USB controller dwc2_hsotg does not support scatter-gather which is
> > > usb 1-1.4: required by the UAS driver. Please try an other USB controller if you wish to use UAS.
> > > usb-storage 1-1.4:1.0: USB Mass Storage device detected
> > > scsi host0: usb-storage 1-1.4:1.0
> > > scsi 0:0:0:0: Direct-Access     ElitePro Dual U3FW-1      0006 PQ: 0 ANSI: 6
> > > scsi 0:0:0:1: Direct-Access     ElitePro Dual U3FW-2      0006 PQ: 0 ANSI: 6
> > > sd 0:0:0:0: Attached scsi generic sg0 type 0
> > > sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
> > > sd 0:0:0:0: [sda] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
> > > sd 0:0:0:0: [sda] Write Protect is off
> > > sd 0:0:0:0: [sda] Mode Sense: 47 00 10 08
> > > sd 0:0:0:0: [sda] No Caching mode page found
> > > sd 0:0:0:0: [sda] Assuming drive cache: write through
> > > sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
> > > [...] 
> > > 
> > > 
> > > -- 
> > > BOFH excuse #449:
> > > 
> > > greenpeace free'd the mallocs
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
