Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49394 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726972AbeK1QzQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 11:55:16 -0500
Date: Tue, 27 Nov 2018 21:54:43 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/6] xfstests: add copy/dedupe/clone to fsx/fsstress
Message-ID: <20181128055443.GA8111@magnolia>
References: <154215237717.21151.11976488103599724788.stgit@magnolia>
 <20181119052251.GQ2279@dhcp-12-117.nay.redhat.com>
 <20181119104547.GR2279@dhcp-12-117.nay.redhat.com>
 <20181119163809.GX4235@magnolia>
 <20181123073301.GA2299@dhcp-12-149.nay.redhat.com>
 <20181124165921.GE6783@magnolia>
 <20181125161928.GM3889@desktop>
 <20181126203855.GF6783@magnolia>
 <20181128025726.GO3889@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128025726.GO3889@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Nov 28, 2018 at 10:57:26AM +0800, Eryu Guan wrote:
> On Mon, Nov 26, 2018 at 12:38:55PM -0800, Darrick J. Wong wrote:
> > On Mon, Nov 26, 2018 at 12:19:28AM +0800, Eryu Guan wrote:
> > > On Sat, Nov 24, 2018 at 08:59:21AM -0800, Darrick J. Wong wrote:
> > > > On Fri, Nov 23, 2018 at 03:33:01PM +0800, Zorro Lang wrote:
> > > > > On Mon, Nov 19, 2018 at 08:38:09AM -0800, Darrick J. Wong wrote:
> > > > > > On Mon, Nov 19, 2018 at 06:45:47PM +0800, Zorro Lang wrote:
> > > > > > > On Mon, Nov 19, 2018 at 01:22:52PM +0800, Zorro Lang wrote:
> > > > > > > > On Tue, Nov 13, 2018 at 03:39:37PM -0800, Darrick J. Wong wrote:
> > > > > > > > > Hi all,
> > > > > > > > > 
> > > > > > > > > This series adds to fsx support for FICLONERANGE, FIDEDUPERANGE, and
> > > > > > > > > copy_file_range.  It adds to fsstress support for copy_file_range.
> > > > > > > > > There are known failures in 4.20-rc2, particularly with copy_file_range,
> > > > > > > > > so these patches provide a fstests base for everyone to start/continue
> > > > > > > > > looking for bugs.
> > > > > > > > 
> > > > > > > > Hi Darrick,
> > > > > > > > 
> > > > > > > > Your patches triggered 2 new failures on g/091 and g/263, refer to [1]. I can't
> > > > > > > > reproduce these failures on original xfstests [2]. I saw you were talking about g/091
> > > > > > > > in #xfs. Are these two failures same issue?
> > > > > > 
> > > > > > Most probably.  Dave and I are still digging through all the new
> > > > > > failures that show up in g/091, g/263, and g/127 once clonerange starts
> > > > > > happening.
> > > > > 
> > > > > Hi Darrick,
> > > > > 
> > > > > I just tried NFS, [1] tested with original xfstests, [2] tested with your
> > > > > patches. Looks like your patches bring in new failures to NFS test:
> > > > > g/075, g/112 and g/127.
> > > > 
> > > > Uh... it would be much more helpful to send along the golden output
> > > > diffs that show where fsx went bad (as well as the nfs configuration),
> > > 
> > > I was testing against a loop-mount nfsv4.2 server. The diff is like
> > > 
> > > @@ -1,3 +1,46 @@
> > >  QA output created by 263
> > >  fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
> > >  fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
> > > +Seed set to 1
> > > +skipping zero size read
> > > +truncating to largest ever: 0xe400
> > > +copying to largest ever: 0x1f400
> > > +cloning to largest ever: 0x70000
> > > +copy range: 0x4b000 to 0x64000 at 0x2800
> > > +do_copy_range:: Resource temporarily unavailable
> > 
> > Hmm, well, -EAGAIN isn't documented as a valid return code in the
> > manpage, but I guess it wouldn't hurt to retry.  For that matter, I
> > should probably amend do_copy_file_range to use syscall() so that we
> > don't pick up the glibc wrapper by the same name.
> 
> Ah, this is not the error I usually see. A more common pattern I saw is
> do_copy_range fails with EINVAL.

Aha, yes... it's right there in nfs4_copy_file_range.  Uggh.

> skipping zero size read
> 3 mapwrite      0x8e7c thru     0x1507f (0xc204 bytes)
> 16 read 0xa5d5 thru     0x1507f (0xaaab bytes)
> 20 mapwrite     0x1a687 thru    0x2151d (0x6e97 bytes)
> 21 read 0x130b5 thru    0x16a8c (0x39d8 bytes)
> 24 read 0x1f899 thru    0x2151d (0x1c85 bytes)
> truncating to largest ever: 0x1abb7
> 25 trunc        from 0x2151e to 0x1abb7
> 26 mapread      0x1731a thru    0x1abb6 (0x389d bytes)
> 31 write        0x371bd thru    0x3dbdd (0x6a21 bytes)
> 35 write        0x3b913 thru    0x3ffff (0x46ed bytes)
> 36 write        0x283af thru    0x3341f (0xb071 bytes)
> 37 mapread      0x29ebb thru    0x35ef6 (0xc03c bytes)
> 38 write        0x25c9 thru     0x63d2  (0x3e0a bytes)
> 39 mapwrite     0x16f57 thru    0x1e75a (0x7804 bytes)
> 42 mapread      0x36992 thru    0x3aa7d (0x40ec bytes)
> 43 mapread      0x1f22b thru    0x23b9f (0x4975 bytes)
> 45 trunc        from 0x40000 to 0x1356b
> 46 write        0xaf3e thru     0x185d3 (0xd696 bytes)
> 48 write        0x1c700 thru    0x20d2c (0x462d bytes)
> truncating to largest ever: 0x1fdbf
> 52 trunc        from 0x20d2d to 0x1fdbf
> copying to largest ever: 0x27a75
> 58 copy from 0x86a9 to 0x12fe2, (0xa939 bytes) at 0x1d13c
> copy range: 0x86a9 to 0x12fe2 at 0x1d13c
> do_copy_range:: Invalid argument
> 
> > 
> > > +LOG DUMP (32 total operations):
> > > +1(  1 mod 256): SKIPPED (no operation)
> > > +2(  2 mod 256): SKIPPED (no operation)
> > > +3(  3 mod 256): SKIPPED (no operation)
> > > +4(  4 mod 256): TRUNCATE UP    from 0x0 to 0xe400
> > > +5(  5 mod 256): INSERT 0x6000 thru 0x17fff     (0x12000 bytes)
> > > +6(  6 mod 256): ZERO     0x91be thru 0x1edf5   (0x15c38 bytes)
> > > +7(  7 mod 256): WRITE    0x3ac00 thru 0x3cdff  (0x2200 bytes) HOLE
> > > +8(  8 mod 256): MAPREAD  0x36000 thru 0x3be19  (0x5e1a bytes)
> > > +9(  9 mod 256): MAPWRITE 0x73200 thru 0x7928c  (0x608d bytes)
> > > +10( 10 mod 256): MAPREAD  0x3d000 thru 0x3f9c2 (0x29c3 bytes)
> > > +11( 11 mod 256): COLLAPSE 0x2b000 thru 0x44fff (0x1a000 bytes)
> > > +12( 12 mod 256): PUNCH    0x495fa thru 0x5f28c (0x15c93 bytes)
> > > +13( 13 mod 256): FALLOC   0x2f42a thru 0x4a8f4 (0x1b4ca bytes) INTERIOR
> > > +14( 14 mod 256): ZERO     0x530b7 thru 0x5f28c (0xc1d6 bytes)
> > > +15( 15 mod 256): MAPWRITE 0x55e00 thru 0x70d6e (0x1af6f bytes)
> > > +16( 16 mod 256): READ     0x2e000 thru 0x38fff (0xb000 bytes)
> > > +17( 17 mod 256): COLLAPSE 0x3f000 thru 0x4efff (0x10000 bytes)
> > > +18( 18 mod 256): COPY 0x28000 thru 0x42fff     (0x1b000 bytes) to 0x4400 thru 0x1f3ff
> > > +19( 19 mod 256): COLLAPSE 0x2c000 thru 0x44fff (0x19000 bytes)
> > > +20( 20 mod 256): WRITE    0x54a00 thru 0x709ff (0x1c000 bytes) HOLE
> > > +21( 21 mod 256): READ     0x53000 thru 0x69fff (0x17000 bytes)
> > > +22( 22 mod 256): MAPWRITE 0x1f200 thru 0x394bb (0x1a2bc bytes)
> > > +23( 23 mod 256): MAPREAD  0x43000 thru 0x5a2d8 (0x172d9 bytes)
> > > +24( 24 mod 256): MAPWRITE 0x23000 thru 0x38812 (0x15813 bytes)
> > > +25( 25 mod 256): WRITE    0x47800 thru 0x587ff (0x11000 bytes)
> > > +26( 26 mod 256): CLONE 0x3000 thru 0x11fff     (0xf000 bytes) to 0x61000 thru 0x6ffff
> > > +27( 27 mod 256): READ     0x6c000 thru 0x6efff (0x3000 bytes)
> > > +28( 28 mod 256): DEDUPE 0x12000 thru 0x1dfff   (0xc000 bytes) to 0x4000 thru 0xffff
> > > +29( 29 mod 256): INSERT 0x31000 thru 0x32fff   (0x2000 bytes)
> > > +30( 30 mod 256): FALLOC   0x2deac thru 0x49915 (0x1ba69 bytes) INTERIOR
> > > +31( 31 mod 256): DEDUPE 0x6f000 thru 0x71fff   (0x3000 bytes) to 0x25000 thru 0x27fff
> > > +32( 32 mod 256): COPY 0x4b000 thru 0x63fff     (0x19000 bytes) to 0x2800 thru 0x1b7ff
> > > +Log of operations saved to "/mnt/test/junk.fsxops"; replay with --replay-ops
> > > +Correct content saved for comparison
> > > +(maybe hexdump "/mnt/test/junk" vs "/mnt/test/junk.fsxgood")
> > > 
> > > And it seems like that NFSv4 doesn't like clone_file_range if src and
> > > dst point to the same file.
> > 
> > How did you conclude that nfs4 doesn't it like clone_file_range if src
> > == dest?  Operation 26 in the fsxlog shows that it did such a clone and
> > succeeded.
> 
> I typed the wrong operation name.. it should be "copy_file_range" not
> "clone_file_range".
> 
> And if I do a manual test on NFSv4.2, I got
> 
> # xfs_io -fc "copy_range -s 0 -d 0 -l 5 /mnt/test/fsx/112.0" /mnt/test/fsx/112.0
> copy_range: Invalid argument
> 
> # xfs_io -fc "copy_range -s 0 -d 0 -l 0 /mnt/test/fsx/112.0" /mnt/test/fsx/112.1
> 
> copy_range on the same file fails with "Invalid argument" but copy to a
> new file succeeds. So I guess NFS doesn't like/support copy_file_range
> if src == dst.

<nod> Ok, I'll rework the test_copy_range function to try a 1-byte copy.
Thanks for the info.

--D

> Thanks,
> Eryu
