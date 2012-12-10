Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBALgsKs006277 for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 15:42:54 -0600
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [195.71.86.230]) by
	cuda.sgi.com with ESMTP id Eiy8uvHLDvq0O5cx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Dec 2012 13:45:21 -0800 (PST)
Date: Mon, 10 Dec 2012 22:45:11 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: XFS write cache flush policy
Message-ID: <20121210214511.GA32466@citd.de>
References: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
	<20121208192927.GA17875@citd.de> <20121210005820.GG15784@dastard>
	<20121210091239.GA21114@citd.de> <50C64C17.9080206@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50C64C17.9080206@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Lin Li <sdeber@gmail.com>, xfs@oss.sgi.com

On 10.12.2012 14:54, Eric Sandeen wrote:
> On 12/10/12 3:12 AM, Matthias Schniedermeyer wrote:
> > On 10.12.2012 11:58, Dave Chinner wrote:
> >> On Sat, Dec 08, 2012 at 08:29:27PM +0100, Matthias Schniedermeyer wrote:
> >>> On 06.12.2012 09:51, Lin Li wrote:
> >>>> Hi, Guys. I recently suffered a huge data loss on power cut on an XFS
> >>>> partition. The problem was that I copied a lot of files (roughly 20Gb) to
> >>>> an XFS partition, then 10 hours later, I got an unexpected power cut. As a
> >>>> result, all these newly copied files disappeared as if they had never been
> >>>> copied. I tried to check and repair the partition, but xfs_check reports no
> >>>> error at all. So I guess the problem is that the meta data for these files
> >>>> were all kept in the cache (64Mb) and were never committed to the hard
> >>>> disk.
> >>>>
> >>>> What is the cache flush policy for XFS? Does it always reserve some fixed
> >>>> space in cache for metadata? I asked because I thought since I copied such
> >>>> a huge amount of data, at least some of these files must be fully committed
> >>>> to the hard disk, then cache is only 64Mb anyway. But the reality is all of
> >>>> them were lost. the only possibility I can think is some part of the cache
> >>>> was reserved for meta data, so even the cache is fully filled, this part
> >>>> will not be written to the disk. Am I right?
> >>>
> >>> I have the same problem, several times.
> >>>
> >>> The latest just an hour ago.
> >>> I'm copying a HDD onto another. Plain rsync -a /src/ /tgt/ Both HDDs are 
> >>> 3TB SATA-drives in a USB3-enclosure with a dm-crypt layer in between.
> >>> About 45 minutes into copying the target HDD disconnects for a moment.
> >>> 45minutes means someting over 200GB were copied, each file is about 
> >>> 900MB.
> >>> After remounting the filesystems there were exactly 0 files.
> >>
> >> This sounds like an entirely different problem to what the OP
> >> reported.
> > 
> > For me it sounds only like different timing.
> > Otherwise i don't see much difference in files vanished after a few 
> > hours(of inactiviry) and a few minutes (while still beeing active).
> > 
> >> Did the filesystem have an error returned?
> > 
> > No.
> > 
> >> i.e. did it shut down (what's in dmesg)?
> > 
> > There's not much XFS could have done after the block-device vanished.
> 
> except to shut down...

Which it eventually did.

This is everything from the "disconnect" up to the point the syslog got 
quiet again. It took XFS nearly a minute to realize the block-device 
went away. And the impression of "a moment" that stuck in my mind was 
actually 30 seconds. That's slight longer that "a moment". :-)

This is only from the first time.

- snip -
Dec  8 19:33:15 leeloo kernel: [4823478.632190] usb 2-4: USB disconnect, device number 9
Dec  8 19:33:25 leeloo kernel: [4823488.440268] quiet_error: 183252 callbacks suppressed
Dec  8 19:33:25 leeloo kernel: [4823488.440271] Buffer I/O error on device dm-5, logical block 116125685
Dec  8 19:33:25 leeloo kernel: [4823488.440272] lost page write due to I/O error on dm-5
Dec  8 19:33:25 leeloo kernel: [4823488.440274] Buffer I/O error on device dm-5, logical block 116125686
Dec  8 19:33:25 leeloo kernel: [4823488.440274] lost page write due to I/O error on dm-5
Dec  8 19:33:25 leeloo kernel: [4823488.440275] Buffer I/O error on device dm-5, logical block 116125687
Dec  8 19:33:25 leeloo kernel: [4823488.440276] lost page write due to I/O error on dm-5
Dec  8 19:33:25 leeloo kernel: [4823488.440277] Buffer I/O error on device dm-5, logical block 116125688
Dec  8 19:33:25 leeloo kernel: [4823488.440277] lost page write due to I/O error on dm-5
Dec  8 19:33:25 leeloo kernel: [4823488.440278] Buffer I/O error on device dm-5, logical block 116125689
Dec  8 19:33:25 leeloo kernel: [4823488.440279] lost page write due to I/O error on dm-5
Dec  8 19:33:25 leeloo kernel: [4823488.440280] Buffer I/O error on device dm-5, logical block 116125690
Dec  8 19:33:25 leeloo kernel: [4823488.440280] lost page write due to I/O error on dm-5
Dec  8 19:33:25 leeloo kernel: [4823488.440281] Buffer I/O error on device dm-5, logical block 116125691
Dec  8 19:33:25 leeloo kernel: [4823488.440282] lost page write due to I/O error on dm-5
Dec  8 19:33:25 leeloo kernel: [4823488.440282] Buffer I/O error on device dm-5, logical block 116125692
Dec  8 19:33:25 leeloo kernel: [4823488.440283] lost page write due to I/O error on dm-5
Dec  8 19:33:25 leeloo kernel: [4823488.440284] Buffer I/O error on device dm-5, logical block 116125693
Dec  8 19:33:25 leeloo kernel: [4823488.440284] lost page write due to I/O error on dm-5
Dec  8 19:33:25 leeloo kernel: [4823488.440285] Buffer I/O error on device dm-5, logical block 116125694
Dec  8 19:33:25 leeloo kernel: [4823488.440286] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.007306] scsi 143:0:0:0: [sdc] Unhandled error code
Dec  8 19:33:45 leeloo kernel: [4823509.007308] scsi 143:0:0:0: [sdc]
Dec  8 19:33:45 leeloo kernel: [4823509.007309] Result: hostbyte=0x05 driverbyte=0x00
Dec  8 19:33:45 leeloo kernel: [4823509.007310] scsi 143:0:0:0: [sdc] CDB:
Dec  8 19:33:45 leeloo kernel: [4823509.007311] cdb[0]=0x2a: 2a 00 37 57 8e 00 00 00 f0 00
Dec  8 19:33:45 leeloo kernel: [4823509.007315] end_request: I/O error, dev sdc, sector 928484864
Dec  8 19:33:45 leeloo kernel: [4823509.007322] scsi 143:0:0:0: rejecting I/O to offline device
Dec  8 19:33:45 leeloo kernel: [4823509.007324] scsi 143:0:0:0: [sdc] killing request
Dec  8 19:33:45 leeloo kernel: [4823509.008018] scsi 143:0:0:0: [sdc] Unhandled error code
Dec  8 19:33:45 leeloo kernel: [4823509.008019] scsi 143:0:0:0: [sdc]
Dec  8 19:33:45 leeloo kernel: [4823509.008020] Result: hostbyte=0x01 driverbyte=0x00
Dec  8 19:33:45 leeloo kernel: [4823509.008021] scsi 143:0:0:0: [sdc] CDB:
Dec  8 19:33:45 leeloo kernel: [4823509.008021] cdb[0]=0x2a: 2a 00 37 57 8e f0 00 00 f0 00
Dec  8 19:33:45 leeloo kernel: [4823509.008024] end_request: I/O error, dev sdc, sector 928485104
Dec  8 19:33:45 leeloo kernel: [4823509.008032] quiet_error: 28666 callbacks suppressed
Dec  8 19:33:45 leeloo kernel: [4823509.008033] Buffer I/O error on device dm-5, logical block 116050587
Dec  8 19:33:45 leeloo kernel: [4823509.008033] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.008035] Buffer I/O error on device dm-5, logical block 116050588
Dec  8 19:33:45 leeloo kernel: [4823509.008036] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.008037] Buffer I/O error on device dm-5, logical block 116050589
Dec  8 19:33:45 leeloo kernel: [4823509.008037] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.008038] Buffer I/O error on device dm-5, logical block 116050590
Dec  8 19:33:45 leeloo kernel: [4823509.008039] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.008040] Buffer I/O error on device dm-5, logical block 116050591
Dec  8 19:33:45 leeloo kernel: [4823509.008040] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.008041] Buffer I/O error on device dm-5, logical block 116050592
Dec  8 19:33:45 leeloo kernel: [4823509.008042] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.008043] Buffer I/O error on device dm-5, logical block 116050593
Dec  8 19:33:45 leeloo kernel: [4823509.008043] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.008044] Buffer I/O error on device dm-5, logical block 116050594
Dec  8 19:33:45 leeloo kernel: [4823509.008045] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.008046] Buffer I/O error on device dm-5, logical block 116050595
Dec  8 19:33:45 leeloo kernel: [4823509.008046] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.008047] Buffer I/O error on device dm-5, logical block 116050596
Dec  8 19:33:45 leeloo kernel: [4823509.008048] lost page write due to I/O error on dm-5
Dec  8 19:33:45 leeloo kernel: [4823509.224036] usb 2-4: new SuperSpeed USB device number 11 using xhci_hcd
Dec  8 19:33:45 leeloo kernel: [4823509.235665] usb 2-4: New USB device found, idVendor=174c, idProduct=5106
Dec  8 19:33:45 leeloo kernel: [4823509.235667] usb 2-4: New USB device strings: Mfr=2, Product=3, SerialNumber=1
Dec  8 19:33:45 leeloo kernel: [4823509.235669] usb 2-4: Product: AS2105
Dec  8 19:33:45 leeloo kernel: [4823509.235670] usb 2-4: Manufacturer: ASMedia
Dec  8 19:33:45 leeloo kernel: [4823509.235672] usb 2-4: SerialNumber:      WD-WMXXXXXXXXXX
Dec  8 19:33:45 leeloo kernel: [4823509.236341] scsi145 : usb-storage 2-4:1.0
Dec  8 19:33:46 leeloo kernel: [4823510.238640] scsi 145:0:0:0: Direct-Access     WDC WD30 EZRX-00DC0B0     80.0 PQ: 0 ANSI: 5
Dec  8 19:33:46 leeloo kernel: [4823510.238764] sd 145:0:0:0: Attached scsi generic sg2 type 0
Dec  8 19:33:46 leeloo kernel: [4823510.238916] sd 145:0:0:0: [sdf] Very big device. Trying to use READ CAPACITY(16).
Dec  8 19:33:46 leeloo kernel: [4823510.239036] sd 145:0:0:0: [sdf] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Dec  8 19:33:46 leeloo kernel: [4823510.239275] sd 145:0:0:0: [sdf] Write Protect is off
Dec  8 19:33:46 leeloo kernel: [4823510.239278] sd 145:0:0:0: [sdf] Mode Sense: 23 00 00 00
Dec  8 19:33:46 leeloo kernel: [4823510.239511] sd 145:0:0:0: [sdf] No Caching mode page present
Dec  8 19:33:46 leeloo kernel: [4823510.239513] sd 145:0:0:0: [sdf] Assuming drive cache: write through
Dec  8 19:33:46 leeloo kernel: [4823510.239773] sd 145:0:0:0: [sdf] Very big device. Trying to use READ CAPACITY(16).
Dec  8 19:33:46 leeloo kernel: [4823510.240372] sd 145:0:0:0: [sdf] No Caching mode page present
Dec  8 19:33:46 leeloo kernel: [4823510.240374] sd 145:0:0:0: [sdf] Assuming drive cache: write through
Dec  8 19:33:47 leeloo kernel: [4823510.897149]  sdf: sdf1
Dec  8 19:33:47 leeloo kernel: [4823510.897492] sd 145:0:0:0: [sdf] Very big device. Trying to use READ CAPACITY(16).
Dec  8 19:33:47 leeloo kernel: [4823510.898087] sd 145:0:0:0: [sdf] No Caching mode page present
Dec  8 19:33:47 leeloo kernel: [4823510.898089] sd 145:0:0:0: [sdf] Assuming drive cache: write through
Dec  8 19:33:47 leeloo kernel: [4823510.898090] sd 145:0:0:0: [sdf] Attached SCSI disk
Dec  8 19:33:50 leeloo kernel: [4823514.018803] quiet_error: 630666 callbacks suppressed
Dec  8 19:33:50 leeloo kernel: [4823514.018805] Buffer I/O error on device dm-5, logical block 161908073
Dec  8 19:33:50 leeloo kernel: [4823514.018806] lost page write due to I/O error on dm-5
Dec  8 19:33:50 leeloo kernel: [4823514.018808] Buffer I/O error on device dm-5, logical block 161908074
Dec  8 19:33:50 leeloo kernel: [4823514.018808] lost page write due to I/O error on dm-5
Dec  8 19:33:50 leeloo kernel: [4823514.018809] Buffer I/O error on device dm-5, logical block 161908075
Dec  8 19:33:50 leeloo kernel: [4823514.018810] lost page write due to I/O error on dm-5
Dec  8 19:33:50 leeloo kernel: [4823514.018811] Buffer I/O error on device dm-5, logical block 161908076
Dec  8 19:33:50 leeloo kernel: [4823514.018811] lost page write due to I/O error on dm-5
Dec  8 19:33:50 leeloo kernel: [4823514.018812] Buffer I/O error on device dm-5, logical block 161908077
Dec  8 19:33:50 leeloo kernel: [4823514.018813] lost page write due to I/O error on dm-5
Dec  8 19:33:50 leeloo kernel: [4823514.018814] Buffer I/O error on device dm-5, logical block 161908078
Dec  8 19:33:50 leeloo kernel: [4823514.018814] lost page write due to I/O error on dm-5
Dec  8 19:33:50 leeloo kernel: [4823514.018815] Buffer I/O error on device dm-5, logical block 161908079
Dec  8 19:33:50 leeloo kernel: [4823514.018815] lost page write due to I/O error on dm-5
Dec  8 19:33:50 leeloo kernel: [4823514.018816] Buffer I/O error on device dm-5, logical block 161908080
Dec  8 19:33:50 leeloo kernel: [4823514.018817] lost page write due to I/O error on dm-5
Dec  8 19:33:50 leeloo kernel: [4823514.018818] Buffer I/O error on device dm-5, logical block 161908081
Dec  8 19:33:50 leeloo kernel: [4823514.018818] lost page write due to I/O error on dm-5
Dec  8 19:33:50 leeloo kernel: [4823514.018819] Buffer I/O error on device dm-5, logical block 161908082
Dec  8 19:33:50 leeloo kernel: [4823514.018820] lost page write due to I/O error on dm-5
Dec  8 19:33:58 leeloo kernel: [4823521.715578] quiet_error: 85723 callbacks suppressed
Dec  8 19:33:58 leeloo kernel: [4823521.715581] Buffer I/O error on device dm-5, logical block 184699823
Dec  8 19:33:58 leeloo kernel: [4823521.715581] lost page write due to I/O error on dm-5
Dec  8 19:33:58 leeloo kernel: [4823521.715583] Buffer I/O error on device dm-5, logical block 184699824
Dec  8 19:33:58 leeloo kernel: [4823521.715584] lost page write due to I/O error on dm-5
Dec  8 19:33:58 leeloo kernel: [4823521.715585] Buffer I/O error on device dm-5, logical block 184699825
Dec  8 19:33:58 leeloo kernel: [4823521.715585] lost page write due to I/O error on dm-5
Dec  8 19:33:58 leeloo kernel: [4823521.715586] Buffer I/O error on device dm-5, logical block 184699826
Dec  8 19:33:58 leeloo kernel: [4823521.715587] lost page write due to I/O error on dm-5
Dec  8 19:33:58 leeloo kernel: [4823521.715588] Buffer I/O error on device dm-5, logical block 184699827
Dec  8 19:33:58 leeloo kernel: [4823521.715588] lost page write due to I/O error on dm-5
Dec  8 19:33:58 leeloo kernel: [4823521.715589] Buffer I/O error on device dm-5, logical block 184699828
Dec  8 19:33:58 leeloo kernel: [4823521.715590] lost page write due to I/O error on dm-5
Dec  8 19:33:58 leeloo kernel: [4823521.715591] Buffer I/O error on device dm-5, logical block 184699829
Dec  8 19:33:58 leeloo kernel: [4823521.715591] lost page write due to I/O error on dm-5
Dec  8 19:33:58 leeloo kernel: [4823521.715592] Buffer I/O error on device dm-5, logical block 184699830
Dec  8 19:33:58 leeloo kernel: [4823521.715592] lost page write due to I/O error on dm-5
Dec  8 19:33:58 leeloo kernel: [4823521.715593] Buffer I/O error on device dm-5, logical block 184699831
Dec  8 19:33:58 leeloo kernel: [4823521.715594] lost page write due to I/O error on dm-5
Dec  8 19:33:58 leeloo kernel: [4823521.715595] Buffer I/O error on device dm-5, logical block 184699832
Dec  8 19:33:58 leeloo kernel: [4823521.715595] lost page write due to I/O error on dm-5
Dec  8 19:34:03 leeloo kernel: [4823526.789092] quiet_error: 322000 callbacks suppressed
Dec  8 19:34:03 leeloo kernel: [4823526.789095] Buffer I/O error on device dm-5, logical block 184786877
Dec  8 19:34:03 leeloo kernel: [4823526.789095] lost page write due to I/O error on dm-5
Dec  8 19:34:03 leeloo kernel: [4823526.789097] Buffer I/O error on device dm-5, logical block 184786878
Dec  8 19:34:03 leeloo kernel: [4823526.789098] lost page write due to I/O error on dm-5
Dec  8 19:34:03 leeloo kernel: [4823526.789099] Buffer I/O error on device dm-5, logical block 184786879
Dec  8 19:34:03 leeloo kernel: [4823526.789099] lost page write due to I/O error on dm-5
Dec  8 19:34:03 leeloo kernel: [4823526.789100] Buffer I/O error on device dm-5, logical block 184786880
Dec  8 19:34:03 leeloo kernel: [4823526.789101] lost page write due to I/O error on dm-5
Dec  8 19:34:03 leeloo kernel: [4823526.789101] Buffer I/O error on device dm-5, logical block 184786881
Dec  8 19:34:03 leeloo kernel: [4823526.789102] lost page write due to I/O error on dm-5
Dec  8 19:34:03 leeloo kernel: [4823526.789103] Buffer I/O error on device dm-5, logical block 184786882
Dec  8 19:34:03 leeloo kernel: [4823526.789103] lost page write due to I/O error on dm-5
Dec  8 19:34:03 leeloo kernel: [4823526.789104] Buffer I/O error on device dm-5, logical block 184786883
Dec  8 19:34:03 leeloo kernel: [4823526.789105] lost page write due to I/O error on dm-5
Dec  8 19:34:03 leeloo kernel: [4823526.789106] Buffer I/O error on device dm-5, logical block 184786884
Dec  8 19:34:03 leeloo kernel: [4823526.789106] lost page write due to I/O error on dm-5
Dec  8 19:34:03 leeloo kernel: [4823526.789107] Buffer I/O error on device dm-5, logical block 184786885
Dec  8 19:34:03 leeloo kernel: [4823526.789108] lost page write due to I/O error on dm-5
Dec  8 19:34:03 leeloo kernel: [4823526.789109] Buffer I/O error on device dm-5, logical block 184786886
Dec  8 19:34:03 leeloo kernel: [4823526.789109] lost page write due to I/O error on dm-5
Dec  8 19:34:07 leeloo kernel: [4823530.941221] XFS (dm-5): metadata I/O error: block 0x8 ("xfs_buf_iodone_callbacks") error 19 numblks 8
Dec  8 19:34:07 leeloo kernel: [4823530.970765] XFS (dm-5): metadata I/O error: block 0xaea85300 ("xlog_iodone") error 19 numblks 64
Dec  8 19:34:07 leeloo kernel: [4823530.970768] XFS (dm-5): xfs_do_force_shutdown(0x2) called from line 1074 of file /xssd/usr_src/linux/fs/xfs/xfs_log.c.  Return address = 0xffffffff8128ee79
Dec  8 19:34:07 leeloo kernel: [4823530.970904] XFS (dm-5): Log I/O Error Detected.  Shutting down filesystem
Dec  8 19:34:07 leeloo kernel: [4823530.970906] XFS (dm-5): xfs_log_force: error 5 returned.
Dec  8 19:34:07 leeloo kernel: [4823530.970906] XFS (dm-5): Please umount the filesystem and rectify the problem(s)
Dec  8 19:34:07 leeloo kernel: [4823530.971033] XFS (dm-5): metadata I/O error: block 0xaea85340 ("xlog_iodone") error 19 numblks 64
Dec  8 19:34:07 leeloo kernel: [4823530.971034] XFS (dm-5): xfs_do_force_shutdown(0x2) called from line 1074 of file /xssd/usr_src/linux/fs/xfs/xfs_log.c.  Return address = 0xffffffff8128ee79
Dec  8 19:34:07 leeloo kernel: [4823530.971158] XFS (dm-5): metadata I/O error: block 0xaea85380 ("xlog_iodone") error 19 numblks 64
Dec  8 19:34:07 leeloo kernel: [4823530.971159] XFS (dm-5): xfs_do_force_shutdown(0x2) called from line 1074 of file /xssd/usr_src/linux/fs/xfs/xfs_log.c.  Return address = 0xffffffff8128ee79
Dec  8 19:34:07 leeloo kernel: [4823530.971208] XFS (dm-5): metadata I/O error: block 0xaea853c0 ("xlog_iodone") error 19 numblks 64
Dec  8 19:34:07 leeloo kernel: [4823530.971209] XFS (dm-5): xfs_do_force_shutdown(0x2) called from line 1074 of file /xssd/usr_src/linux/fs/xfs/xfs_log.c.  Return address = 0xffffffff8128ee79
Dec  8 19:34:07 leeloo kernel: [4823531.243692] XFS (dm-5): xfs_log_force: error 5 returned.
Dec  8 19:34:07 leeloo kernel: [4823531.243699] XFS (dm-5): xfs_do_force_shutdown(0x1) called from line 1160 of file /xssd/usr_src/linux/fs/xfs/xfs_buf.c.  Return address = 0xffffffff8123f23f
- snip -

There was also a second, third and fourth time with that HDD/enclosure. 
The third one was actually "interesting", i had to reboot the computer 
to recover from that.
Reboot in that case also meant that the kernel got updated to 3.6.9 And 
the fourth time was also kind of interesting, because the machine 
spontaneously rebooted.

After that the copy went through. And another copy of >2TB from an other 
set of HDDs went without a hitch through that night.
The verify-run of the above HDD went through without a hitch.

> > A dis-/r-eappierung block-device gets a new name because the old name is 
> > still "in use", the block-devic gets cleaned up after 'umount'ing and 
> > closing the dm-crypt device.
> > 
> > When the USB3-HDD disconnected it reappered a moment later under a new 
> > name, it bounced between sdc <-> sdf.
> > 
> > In syslog it's a plain "USB disconnect, device number XX" message.
> > Followed by a standard new device found message-bombardment. In between 
> > there are some error-messages, but as it's pratically a yanked out and 
> > replugged cable, a little complaing by the kernel is to be expected.
> 
> Sure, but Dave asked if the filesystem shut down.  XFS messages would
> tell you that; *were* there messages from XFS in the log from the event?
> Sometimes "a little complaining" can be quite informative.  :)

OK. See above.

> >> Did you run repair in between the shutdown and remount?
> > 
> > No.
> > 
> > XFS (dm-3): Mounting Filesystem
> > XFS (dm-3): Starting recovery (logdev: internal)
> > XFS (dm-3): Ending recovery (logdev: internal)
> > 
> >> How many files in that 200GB of data?
> > 
> > At 0.9GB/file at least 220.
> > 
> >> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >>
> >> Basically, you have an IO error situation, and you have dm-crypt
> >> in-between buffering an unknown about of changes. In my experience,
> >> data loss eventsi are rarely filesystem problems when USB drives or
> >> dm-crypt is involved...
> > 
> > I don't know the inner workings auf dm-*, but shouldn't it behave 
> > transparent and rely on the block-layer for buffering.
> 
> I think that's partly why Dave asked you to test it, to check
> that theory ;)

Currently i'm in the process of replacing a bunch of HDDs, so i won't 
come to that for at least a few days. At even then i can't test it 
EXACTLY because i don't have any free HDDs identical to the one that was 
part of above log-messages (at the moment).

But i can test one of the old HDDs before i throw them out, with the 
exact enclosure that was part of above Log messages.

> >>> After that i started a "while true; do sync ; done"-loop in the 
> >>> background.
> >>> And just while i was writing this email the HDD disconnected a second 
> >>> time. But this time the files up until the last 'sync' were retained.
> >>
> >> Exactly as I'd expect.
> >>
> >>> And something like this has happend to me at least a half dozen times in 
> >>> the last few month. I think the first time was with kernel 3.5.X, when i 
> >>> was actually booting into 3.6 with a plain "reboot" (filesystem might 
> >>> not have been umounted cleanly.), after the reboot the changes of about 
> >>> the last half hour were gone. e.g. i had renamed a directory about 15 
> >>> minutes before i rebooted and after the reboot the directory had it's 
> >>> old name back.
> >>>
> >>> Kernel in all but (maybe)one case is between 3.6 and 3.6.2 (currently), 
> >>> the first time MIGHT have been something around 3.5.8 but i'm not sure. 
> >>> HDDs were either connected by plain SATA(AHCI) or by USB3 enclosure. All 
> >>> affected filesystems were/are with a dm-crypt layer inbetween.
> >>
> >> Given that dm-crypt is the common factor here, I'd start by ruling
> >> that out. i.e. reproduce the problem without dm-crypt being used.
> > 
> > That's a slight problem for me, pratically everything i have is 
> > encrypted.
> 
> But this is an external drive; you could run a similar test with unencrypted
> data on a different hard drive, to try to get to the bottom of this
> problem, right?

Will try, but i guess i will have to "emulate" the disconnect by 
physically yanking out the cable, it's not like random errors are 
predicatable. ;-)



-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
