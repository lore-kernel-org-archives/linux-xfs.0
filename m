Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65DcG5u003487 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 08:38:17 -0500
Message-ID: <4E1313C1.6020309@gmail.com>
Date: Tue, 05 Jul 2011 16:38:09 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS internal error (memory corruption)
References: <4E12A927.9020102@gmail.com> <20110705130932.GF1026@dastard>
In-Reply-To: <20110705130932.GF1026@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-masters@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 07/05/2011 04:09 PM, Dave Chinner wrote:
> On Tue, Jul 05, 2011 at 09:03:19AM +0300, T=F6r=F6k Edwin wrote:
>> Hi,
>>
>> Yesterday when running 'shutdown -Pfh now', it hung using 99% CPU in sys=
 [*]
>> Looking at the console there was a message about XFS "Corruption of in-m=
emory data detected", and about XFS_WANT_CORRUPTED_GOTO.
> =

> So you had a btree corruption.
> =

>> Had to shutdown the machine via SysRQ u + o.
>>
>> Today when I booted I got this message:
>> [    9.786494] XFS (md1p2): Mounting Filesystem
>> [    9.927590] XFS (md1p2): Starting recovery (logdev: /dev/disk/by-id/s=
csi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-part5)
>> [   10.385941] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1638 =
of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff8122b80e
>> [   10.385943]
>> [   10.386007] Pid: 1990, comm: mount Not tainted 3.0.0-rc5 #155
>> [   10.386009] Call Trace:
>> [   10.386014]  [<ffffffff812551ca>] xfs_error_report+0x3a/0x40
>> [   10.386017]  [<ffffffff8122b80e>] ? xfs_free_extent+0xce/0x120
>> [   10.386019]  [<ffffffff81227e06>] ? xfs_alloc_lookup_eq+0x16/0x20
>> [   10.386021]  [<ffffffff81228f4a>] xfs_free_ag_extent+0x6aa/0x780
>> [   10.386023]  [<ffffffff8122b80e>] xfs_free_extent+0xce/0x120
>> [   10.386026]  [<ffffffff8127b0ff>] ? kmem_zone_alloc+0x5f/0xe0
>> [   10.386029]  [<ffffffff81268e9f>] xlog_recover_process_efi+0x15f/0x1a0
>> [   10.386031]  [<ffffffff8126ab26>] xlog_recover_process_efis.isra.4+0x=
76/0xc0
>> [   10.386033]  [<ffffffff8126de62>] xlog_recover_finish+0x22/0xc0
>> [   10.386035]  [<ffffffff81265aa4>] xfs_log_mount_finish+0x24/0x30
>> [   10.386038]  [<ffffffff81270aab>] xfs_mountfs+0x45b/0x720
>> [   10.386040]  [<ffffffff81288741>] xfs_fs_fill_super+0x1f1/0x2e0
>> [   10.386042]  [<ffffffff811573aa>] mount_bdev+0x1aa/0x1f0
>> [   10.386044]  [<ffffffff81288550>] ? xfs_parseargs+0xb90/0xb90
>> [   10.386046]  [<ffffffff812866b0>] xfs_fs_mount+0x10/0x20
>> [   10.386048]  [<ffffffff81157c3e>] mount_fs+0x3e/0x1b0
>> [   10.386051]  [<ffffffff81171807>] vfs_kern_mount+0x57/0xa0
>> [   10.386052]  [<ffffffff81171c4f>] do_kern_mount+0x4f/0x100
>> [   10.386054]  [<ffffffff811732dc>] do_mount+0x19c/0x840
>> [   10.386057]  [<ffffffff8110fa12>] ? __get_free_pages+0x12/0x50
>> [   10.386059]  [<ffffffff81172fc5>] ? copy_mount_options+0x35/0x170
>> [   10.386061]  [<ffffffff81173d0b>] sys_mount+0x8b/0xe0
>> [   10.386064]  [<ffffffff814c19fb>] system_call_fastpath+0x16/0x1b
>> [   10.386071] XFS (md1p2): Failed to recover EFIs
>> [   10.386097] XFS (md1p2): log mount finish failed
>> [   10.428562] XFS (md1p3): Mounting Filesystem
>> [   10.609949] XFS (md1p3): Ending clean mount
>>
>> FWIW I got a message about EFIs yesterday too, but everything else worke=
d:
>> Jul  4 09:42:54 debian kernel: [   11.439861] XFS (md1p2): Mounting File=
system
>> Jul  4 09:42:54 debian kernel: [   11.599815] XFS (md1p2): Starting reco=
very (logdev: /dev/disk/by-id/scsi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-par=
t5)
>> Jul  4 09:42:54 debian kernel: [   11.787980] XFS (md1p2): I/O error occ=
urred: meta-data dev md1p2 block 0x117925a8       ("xfs_trans_read_buf") er=
ror 5 buf c
>> ount 4096
>> Jul  4 09:42:54 debian kernel: [   11.788044] XFS (md1p2): Failed to rec=
over EFIs
>> Jul  4 09:42:54 debian kernel: [   11.788065] XFS (md1p2): log mount fin=
ish failed
>> Jul  4 09:42:54 debian kernel: [   11.831077] XFS (md1p3): Mounting File=
system
>> Jul  4 09:42:54 debian kernel: [   12.009647] XFS (md1p3): Ending clean =
mount
> =

> Looks like you might have a dying disk. That's a IO error on read
> that has been reported back to XFS, and it warned that bad things
> happened. Maybe XFS should have shut down, though.

Ah I had /dev/sdd kicked out of the RAID array, and a lot of SATA EH resets.
Those were apparently caused by a loose SATA cable:
https://lkml.org/lkml/2011/7/5/22
Those errors were for /dev/sdd though, not /dev/sdi (the XFS log disk).

Once I re-plugged all the SATA cables, and re-added /dev/sdd to the RAID ar=
ray, all seemed well:

Jul  4 09:59:22 debian kernel: [   11.613073] XFS (md1p2): Mounting Filesys=
tem
Jul  4 09:59:22 debian kernel: [   11.782051] XFS (md1p2): Starting recover=
y (logdev: /dev/disk/by-id/scsi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-part5)
Jul  4 09:59:22 debian kernel: [   12.020766] XFS (md1p2): Ending recovery =
(logdev: /dev/disk/by-id/scsi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-part5)
Jul  4 09:59:22 debian kernel: [   12.031038] XFS (md1p3): Mounting Filesys=
tem
Jul  4 09:59:22 debian kernel: [   12.196238] XFS (md1p3): Ending clean mou=
nt

But when I shutdown the system later that day I got that log corruption err=
or.
Could it be that the log  / some data on the disk was still corrupted (desp=
ite the successful mount, and RAID resync), which caused the
log error later?

The log is not on the RAID array though, it is on a separate disk, and that=
 disk is indeed older than all
the other disks. Still SMART doesn't show any errors, and I've run a SMART =
short self-test, and conveyance self-test, and those didn't log any errors =
either.


>> UUID=3D6f7c65b9-40b2-4b05-9157-522a67f65c4a /mnt/var_data   xfs     defa=
ults,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,logdev=3D/dev/disk/by-i=
d/scsi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-part5 0 2
>>
>> I can't mount the FS anymore:
>> mount: Structure needs cleaning
> =

> Obviously - you've got corrupted free space btrees thanks to the IO
> error during recovery and the later operations that were done on it.
> Now log recovery can't complete without hitting those corruptions.

Is the corruption in the log, or in the FS itself?
The FS itself could've been damaged when kicked out of the RAID.

> =

>> So I used xfs_repair /dev/md1p2 -l /dev/sdi5 -L, and then I could mount =
the log.
> =

> Did you replace the faulty disk? If not,this will just happen
> again...

Not yet, as I'm not sure if the problem was with the SATA cables
(and kicking out of sdd from the RAID), or the log disk itself.
And SMART shows no errors on the disk.

> =

>> I did save the faulty log-file, let me know if you need it:
>> -rw-r--r-- 1 edwin edwin 2.9M Jul  5 09:00 sdi5.xz
>>
>> This is on a 3.0-rc5 kernel, my .config is below:
>>
>> I've run perf top with the hung shutdown, and it showed me something lik=
e this:
>>      1964.00 16.3% filemap_fdatawait_range         /lib/modules/3.0.0-rc=
5/build/vmlinux
>>              1831.00 15.2% _raw_spin_lock                  /lib/modules/=
3.0.0-rc5/build/vmlinux
>>              1316.00 10.9% iput                            /lib/modules/=
3.0.0-rc5/build/vmlinux
>>              1265.00 10.5% _atomic_dec_and_lock            /lib/modules/=
3.0.0-rc5/build/vmlinux
>>               998.00  8.3% _raw_spin_unlock                /lib/modules/=
3.0.0-rc5/build/vmlinux
>>               731.00  6.1% sync_inodes_sb                  /lib/modules/=
3.0.0-rc5/build/vmlinux
>>               724.00  6.0% find_get_pages_tag              /lib/modules/=
3.0.0-rc5/build/vmlinux
>>               580.00  4.8% radix_tree_gang_lookup_tag_slot /lib/modules/=
3.0.0-rc5/build/vmlinux
>>               525.00  4.3% __rcu_read_unlock               /lib/modules/=
3.0.0-rc5/build/vmlinux
> =

> Looks like it is running around trying to write back data, stuck
> somewhere in the code outside XFS. I haven't seen anything like this
> before.
> =

> Still, the root cause is likely a bad disk or driver, so finding and
> fixing that is probably the first thing you should do...

OK, I'll see if this happens again, and I'll replace the disk if it does.

Although is there supposed to be a performance benefit from having a separa=
te log disk with XFS?
IIRC it has a disadvantage that you can't use barriers properly.
But if I'd move the log to be stored with the FS (on the RAID10 array), wil=
l XFS be able to use barriers there,
or RAID still prevents barriers from working?

Thanks,
--Edwin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
