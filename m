Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D4CB7FD1
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 16:56:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA55FAC006
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 14:56:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S0RZlAwJ6Vk1FU7y (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 14:56:54 -0800 (PST)
Date: Thu, 29 Jan 2015 17:56:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: RE : xfs_repair fails with corrupt dinode
Message-ID: <20150129225646.GA24547@laptop.bfoster>
References: <587A9635632B174A943E53AF3B58A9082E3BE068CE@vanda>
	<20150129173414.GL17652@laptop.bfoster>
	<587A9635632B174A943E53AF3B58A9082E3BE068D0@vanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <587A9635632B174A943E53AF3B58A9082E3BE068D0@vanda>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "SCHEFFER, Philippe" <Philippe.SCHEFFER@inist.fr>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jan 29, 2015 at 11:09:48PM +0100, SCHEFFER, Philippe wrote:
> I join info in attached files.
> =

> Chronology:
> Problem detected on FS.

Do you have a record/log of the original problem? Did the fs shutdown?

> FS unmounted
> multiple xfs_repair -P  with message in my precedent mail
> A try to remount FS give a kernel panic

I suspect a problem during log replay. Do you have a record of this
panic? From your comments, I take it this is now 100% reproducible.

There's quite a lot of noise in the repair output besides the final
error. Did repair ever complain about a dirty log?

Brian

> FS is unmounted actually.  =

> =

> Metadump compressed file is 1,4 Gb
> =

> Philippe
> ________________________________________
> De : Brian Foster [bfoster@redhat.com]
> Date d'envoi : jeudi 29 janvier 2015 18:34
> =C0 : SCHEFFER, Philippe
> Cc : xfs@oss.sgi.com
> Objet : Re: xfs_repair fails with corrupt dinode
> =

> On Thu, Jan 29, 2015 at 04:48:15PM +0100, SCHEFFER, Philippe wrote:
> > Hi,
> >
> > I have a corrupted xfs filesytem. When I try to repair I get this error=
 :
> > disconnected inode 1427919, moving to lost+found
> > corrupt dinode 1427919, extent total =3D 1, nblocks =3D 0.  This is a b=
ug.
> > Please capture the filesystem metadata with xfs_metadump and
> > report it to xfs@oss.sgi.com.
> > cache_node_purge: refcount was 1, not zero (node=3D0x1f6c19620)
> >
> > fatal error -- 117 - couldn't iget disconnected inode
> >
> > I captured metada with xfs_metadump but the file is 1,4Gb long. I can't=
 send it to you.
> >
> =

> What kernel/xfsprogs version, xfs_info, mount options? Do you have the
> full xfs_repair output? In general:
> =

> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_whe=
n_reporting_a_problem.3F
> =

> It's not clear to me from your report whether repair fixed this or
> failed itself. Also, can you compress the metadump image?
> =

> Brian
> =

> > I printed inode1427919 :
> >
> > xfs_db> inode 1427919
> > xfs_db> print
> > core.magic =3D 0x494e
> > core.mode =3D 0100644
> > core.version =3D 2
> > core.format =3D 2 (extents)
> > core.nlinkv2 =3D 1
> > core.onlink =3D 0
> > core.projid_lo =3D 0
> > core.projid_hi =3D 0
> > core.uid =3D 1144
> > core.gid =3D 1144
> > core.flushiter =3D 19
> > core.atime.sec =3D Fri Jan  9 21:50:25 2015
> > core.atime.nsec =3D 132886289
> > core.mtime.sec =3D Wed Oct 15 16:28:33 2014
> > core.mtime.nsec =3D 166360243
> > core.ctime.sec =3D Wed Oct 15 16:28:33 2014
> > core.ctime.nsec =3D 166360243
> > core.size =3D 2536
> > core.nblocks =3D 1
> > core.extsize =3D 0
> > core.nextents =3D 1
> > core.naextents =3D 0
> > core.forkoff =3D 0
> > core.aformat =3D 2 (extents)
> > core.dmevmask =3D 0
> > core.dmstate =3D 0
> > core.newrtbm =3D 0
> > core.prealloc =3D 0
> > core.realtime =3D 0
> > core.immutable =3D 0
> > core.append =3D 0
> > core.sync =3D 0
> > core.noatime =3D 0
> > core.nodump =3D 0
> > core.rtinherit =3D 0
> > core.projinherit =3D 0
> > core.nosymlinks =3D 0
> > core.extsz =3D 0
> > core.extszinherit =3D 0
> > core.nodefrag =3D 0
> > core.filestream =3D 0
> > core.gen =3D 837444118
> > next_unlinked =3D null
> > u.bmx[0] =3D [startoff,startblock,blockcount,extentflag] 0:[0,320660992=
,1,0]
> >
> > What could I do for solve this problem.
> >
> > Thanks in advance.
> >
> > Philippe
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

> Linux vp-istex-li 3.11.0-26-generic #45~precise1-Ubuntu SMP Tue Jul 15 04=
:02:35 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> =

> xfs_repair version 3.1.7
> =

> VM 32 CPU on VMWare ESXI 5.5
> =

> MemTotal:       24683648 kB
> MemFree:         4992604 kB
> Buffers:        10428516 kB
> Cached:          4465552 kB
> SwapCached:          752 kB
> Active:          5067924 kB
> Inactive:       10256284 kB
> Active(anon):     211816 kB
> Inactive(anon):   218672 kB
> Active(file):    4856108 kB
> Inactive(file): 10037612 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:       1998844 kB
> SwapFree:        1990580 kB
> Dirty:              1336 kB
> Writeback:             0 kB
> AnonPages:        429844 kB
> Mapped:            12460 kB
> Shmem:                36 kB
> Slab:            4116292 kB
> SReclaimable:    4006612 kB
> SUnreclaim:       109680 kB
> KernelStack:        5040 kB
> PageTables:         4660 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    14340668 kB
> Committed_AS:     708304 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      233228 kB
> VmallocChunk:   34340507648 kB
> HardwareCorrupted:     0 kB
> AnonHugePages:         0 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:       92032 kB
> DirectMap2M:    25073664 kB
> =

> rootfs / rootfs rw 0 0
> sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
> proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> udev /dev devtmpfs rw,relatime,size=3D12331992k,nr_inodes=3D3082998,mode=
=3D755 0 0
> devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxm=
ode=3D000 0 0
> tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=3D2468368k,mode=3D755 0 0
> /dev/mapper/system-root / ext4 rw,relatime,errors=3Dremount-ro,data=3Dord=
ered 0 0
> none /sys/fs/fuse/connections fusectl rw,relatime 0 0
> none /sys/kernel/debug debugfs rw,relatime 0 0
> none /sys/kernel/security securityfs rw,relatime 0 0
> none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=3D5120k 0 0
> none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
> /dev/mapper/system-tmp /tmp ext4 rw,relatime,data=3Dordered 0 0
> /dev/mapper/system-home /home ext4 rw,relatime,data=3Dordered 0 0
> /dev/mapper/system-opt /opt ext4 rw,relatime,data=3Dordered 0 0
> /dev/mapper/system-usr /usr ext4 rw,relatime,data=3Dordered 0 0
> /dev/mapper/system-var /var ext4 rw,relatime,data=3Dordered 0 0
> /dev/mapper/data-lvol0 /applis/istex ext4 rw,relatime,data=3Dordered 0 0
> /dev/mapper/data-lvol1 /applis/getstate ext4 rw,relatime,data=3Dordered 0=
 0
> /dev/sde /data/brut/elsevier ext3 ro,relatime,errors=3Dcontinue,barrier=
=3D1,data=3Dordered 0 0
> /dev/sdf /data/brut/rsc ext3 ro,relatime,errors=3Dcontinue,barrier=3D1,da=
ta=3Dordered 0 0
> /dev/sdh /data/oup xfs ro,relatime,attr2,inode64,noquota 0 0
> /dev/sdi /data/rsc xfs rw,relatime,attr2,inode64,noquota 0 0
> /dev/sdn /data/nature xfs rw,relatime,attr2,inode64,noquota 0 0
> /dev/sdo /data/brill xfs rw,relatime,attr2,inode64,noquota 0 0
> /dev/sdp /data/iop xfs rw,relatime,attr2,inode64,noquota 0 0
> /dev/mapper/vgistex--brut-lvol00 /data/brut/wiley xfs rw,relatime,attr2,i=
node64,noquota 0 0
> /dev/mapper/vgistex--work-lvol00 /data/brut/temp xfs rw,relatime,attr2,in=
ode64,noquota 0 0
> /dev/mapper/vgistex--sample-lvol0 /data/sample ext3 rw,relatime,errors=3D=
continue,barrier=3D1,data=3Dordered 0 0
> /dev/mapper/vgistex--corpus-lvol00 /data/springer ext3 ro,relatime,errors=
=3Dcontinue,barrier=3D1,data=3Dordered 0 0
> /dev/mapper/vgistex--corpus-lvol01 /data/ecco ext4 ro,relatime,data=3Dord=
ered 0 0
> /dev/mapper/vgeebo-lvol00 /data/eebo ext3 ro,relatime,errors=3Dcontinue,b=
arrier=3D1,data=3Dordered 0 0
> /dev/mapper/vgistex--corpus-lvol02 /data/wiley xfs ro,relatime,attr2,inod=
e64,noquota 0 0
> /dev/mapper/vgli2-lvol0 /applis/istex/corpusOutput ext4 rw,relatime,data=
=3Dordered 0 0
> /dev/mapper/vgli2-lvol1 /applis/istex/li2 ext4 rw,relatime,data=3Dordered=
 0 0
> /dev/sda1 /boot ext2 rw,relatime,errors=3Dcontinue,user_xattr,acl 0 0
> rpc_pipefs /run/rpc_pipefs rpc_pipefs rw,relatime 0 0
> nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
> =

> major minor  #blocks  name
> =

>   11        0    1048575 sr0
>    8        0   16777216 sda
>    8        1     488281 sda1
>    8        2   16287910 sda2
>    8       32 10737418240 sdc
>    8       48 1073741824 sdd
>    8       64 5368709120 sde
>    8       80 2147483648 sdf
>    8       96 4294967296 sdg
>    8      128  125829120 sdi
>    8      144 1389363200 sdj
>    8      160 2147483648 sdk
>    8      192 1045430272 sdm
>    8      176 2147483648 sdl
>    8      112 1180696576 sdh
>    8      208  262144000 sdn
>    8      224  262144000 sdo
>    8       16  104857600 sdb
>    8      240  314572800 sdp
>   65       48 3221225472 sdt
>   65       64 10737418240 sdu
>   65       80 5153960755 sdv
>   65        0  262144000 sdq
>   65       16 2684354560 sdr
>   65       32 10737418240 sds
>  252        0 1045426176 dm-0
>  252        1 1389330432 dm-1
>  252        2 2147450880 dm-2
>  252        3 2147450880 dm-3
>  252        4 3219456000 dm-4
>  252        5 10737090560 dm-5
>  252        6 21474430976 dm-6
>  252        7 1073737728 dm-7
>  252        8 2684321792 dm-8
>  252        9     512000 dm-9
>  252       10  104341504 dm-10
>  252       11    2306048 dm-11
>  252       12    1048576 dm-12
>  252       13    2097152 dm-13
>  252       14    1048576 dm-14
>  252       15    3145728 dm-15
>  252       16    3416064 dm-16
>  252       17    1998848 dm-17
> =

>   VG             #PV #LV #SN Attr   VSize   VFree  =

>   data             1   2   0 wz--n- 100,00g      0 =

>   system           1   7   0 wz--n-  15,53g   1,17g
>   vgeebo           1   1   0 wz--n-   1,29t      0 =

>   vgistex-brut     1   1   0 wz--n-   2,50t      0 =

>   vgistex-corpus   3   3   0 wz--n-   7,00t   1,66g
>   vgistex-sample   1   1   0 wz--n- 997,00g      0 =

>   vgistex-work     1   1   0 wz--n-  10,00t 288,00m
>   vgli2            3   2   0 wz--n-  21,00t 388,00m
> =

>   LV     VG             Attr   LSize    Origin Snap%  Move Log Copy%  Con=
vert
>   lvol0  data           -wi-ao   99,51g                                  =
    =

>   lvol1  data           -wi-ao  500,00m                                  =
    =

>   home   system         -wi-ao    1,00g                                  =
    =

>   opt    system         -wi-ao    2,00g                                  =
    =

>   root   system         -wi-ao    2,20g                                  =
    =

>   swap   system         -wi-ao    1,91g                                  =
    =

>   tmp    system         -wi-ao    1,00g                                  =
    =

>   usr    system         -wi-ao    3,26g                                  =
    =

>   var    system         -wi-ao    3,00g                                  =
    =

>   lvol00 vgeebo         -wi-ao    1,29t                                  =
    =

>   lvol00 vgistex-brut   -wi-ao    2,50t                                  =
    =

>   lvol00 vgistex-corpus -wi-ao    2,00t                                  =
    =

>   lvol01 vgistex-corpus -wi-ao    2,00t                                  =
    =

>   lvol02 vgistex-corpus -wi-ao    3,00t                                  =
    =

>   lvol0  vgistex-sample -wi-ao  997,00g                                  =
    =

>   lvol00 vgistex-work   -wi-ao   10,00t                                  =
    =

>   lvol0  vgli2          -wi-ao   20,00t                                  =
    =

>   lvol1  vgli2          -wi-ao 1024,00g                                  =
    =

> =

> Disks : Disk Array, connection FC
> no information about write cache
> BBWC : no information
> =

> xfs_info : not possible, FS not mounted. Last try of mount give a Kernel =
panic.
> =

> [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x14] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x16] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x18] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x1a] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x1c] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x1e] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x22] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x24] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x26] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x28] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x2a] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x2c] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x2e] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x32] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x34] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x36] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x38] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x3a] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x3c] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x3e] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x42] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x44] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x46] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x48] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x4a] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x4c] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x4e] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x52] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x54] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x56] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x58] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x5a] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x5c] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x5e] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x62] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x64] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x66] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x68] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x6a] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x6c] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x6e] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x72] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x74] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x76] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x78] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x7a] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x7c] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x7e] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI =
0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086af01 base: 0xfed00000
> [    0.000000] smpboot: Allowing 64 CPUs, 32 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000c9fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000ca000-0x000cbfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000cc000-0x000dbfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfee0000-0xbfefefff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfeff000-0xbfefffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xefffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xf7ffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfebfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfedfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfffdffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfffe0000-0xffffffff]
> [    0.000000] e820: [mem 0xc0000000-0xefffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:6=
4 nr_node_ids:4
> [    0.000000] PERCPU: Embedded 29 pages/cpu @ffff8801b9400000 s86720 r81=
92 d23872 u262144
> [    0.000000] pcpu-alloc: s86720 r8192 d23872 u262144 alloc=3D1*2097152
> [    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11 12=
 13 14 15 =

> [    0.000000] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 [0] 24 25 26 27 28=
 29 30 31 =

> [    0.000000] pcpu-alloc: [0] 32 36 40 44 48 52 56 60 [1] 33 37 41 45 49=
 53 57 61 =

> [    0.000000] pcpu-alloc: [2] 34 38 42 46 50 54 58 62 [3] 35 39 43 47 51=
 55 59 63 =

> [    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  To=
tal pages: 6193001
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.11.0-26-gener=
ic root=3D/dev/mapper/system-root ro
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - baili=
ng!
> [    0.000000] Memory: 24663956K/25165304K available (7520K kernel code, =
1081K rwdata, 4076K rodata, 1392K init, 1428K bss, 501348K reserved)
> [    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D64=
, Nodes=3D4
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=3D256 to nr_cpu_ids=3D6=
4.
> [    0.000000] 	Offload RCU callbacks from all CPUs
> [    0.000000] 	Offload RCU callbacks from CPUs: 0-255.
> [    0.000000] NR_IRQS:16640 nr_irqs:1192 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 100663296 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
> [    0.000000] Enabling automatic NUMA balancing. Configure with numa_bal=
ancing=3D or the kernel.numa_balancing sysctl
> [    0.000000] hpet clockevent registered
> [    0.004000] TSC freq read from hypervisor : 2599.998 MHz
> [    0.004000] tsc: Detected 2599.998 MHz processor
> [    0.000037] Calibrating delay loop (skipped) preset value.. 5199.99 Bo=
goMIPS (lpj=3D10399992)
> [    0.000366] pid_max: default: 65536 minimum: 512
> [    0.000790] Security Framework initialized
> [    0.001102] AppArmor: AppArmor initialized
> [    0.001264] Yama: becoming mindful.
> [    0.012931] Dentry cache hash table entries: 4194304 (order: 13, 33554=
432 bytes)
> [    0.049179] Inode-cache hash table entries: 2097152 (order: 12, 167772=
16 bytes)
> [    0.057400] Mount-cache hash table entries: 256
> [    0.060055] Initializing cgroup subsys memory
> [    0.060232] Initializing cgroup subsys devices
> [    0.060362] Initializing cgroup subsys freezer
> [    0.060489] Initializing cgroup subsys blkio
> [    0.060616] Initializing cgroup subsys perf_event
> [    0.060751] Initializing cgroup subsys hugetlb
> [    0.061030] Disabled fast string operations
> [    0.061152] CPU: Physical Processor ID: 0
> [    0.061273] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.061273] ENERGY_PERF_BIAS: View and update with x86_energy_perf_pol=
icy(8)
> [    0.061519] mce: CPU supports 0 MCE banks
> [    0.061656] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.061656] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0
> [    0.061656] tlb_flushall_shift: 5
> [    0.062158] Freeing SMP alternatives memory: 28K (ffffffff81e6c000 - f=
fffffff81e73000)
> [    0.070504] ACPI: Core revision 20130517
> [    0.097925] ACPI: All ACPI Tables successfully acquired
> [    0.116321] ftrace: allocating 31320 entries in 123 pages
> [    0.166050] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=
=3D-1
> [    0.205908] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-2660 v3 @ 2.60GHz (=
fam: 06, model: 2d, stepping: 02)
> [    0.311691] Performance Events: 16-deep LBR, SandyBridge events, core =
PMU driver.
> [    0.312004] perf_event_intel: PEBS disabled due to CPU errata, please =
upgrade microcode
> [    0.312187] perf_event_intel: CPUID marked event: 'cpu cycles' unavail=
able
> [    0.312330] perf_event_intel: CPUID marked event: 'instructions' unava=
ilable
> [    0.312474] perf_event_intel: CPUID marked event: 'bus cycles' unavail=
able
> [    0.312616] perf_event_intel: CPUID marked event: 'cache references' u=
navailable
> [    0.312789] perf_event_intel: CPUID marked event: 'cache misses' unava=
ilable
> [    0.312933] perf_event_intel: CPUID marked event: 'branch instructions=
' unavailable
> [    0.313121] perf_event_intel: CPUID marked event: 'branch misses' unav=
ailable
> [    0.313284] ... version:                1
> [    0.313390] ... bit width:              48
> [    0.313497] ... generic registers:      4
> [    0.313604] ... value mask:             0000ffffffffffff
> [    0.313753] ... max period:             000000007fffffff
> [    0.313876] ... fixed-purpose events:   0
> [    0.313983] ... event mask:             000000000000000f
> [    0.321038] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.333406] Disabled fast string operations
> [    0.333451] mce: CPU supports 0 MCE banks
> [    0.345998] Disabled fast string operations
> [    0.346040] mce: CPU supports 0 MCE banks
> [    0.358471] Disabled fast string operations
> [    0.358514] mce: CPU supports 0 MCE banks
> [    0.370904] Disabled fast string operations
> [    0.370946] mce: CPU supports 0 MCE banks
> [    0.383464] Disabled fast string operations
> [    0.383506] mce: CPU supports 0 MCE banks
> [    0.395808] Disabled fast string operations
> [    0.395850] mce: CPU supports 0 MCE banks
> [    0.408067] Disabled fast string operations
> [    0.408109] mce: CPU supports 0 MCE banks
> [    0.420397] Disabled fast string operations
> [    0.420439] mce: CPU supports 0 MCE banks
> [    0.433275] Disabled fast string operations
> [    0.433352] mce: CPU supports 0 MCE banks
> [    0.446980] Disabled fast string operations
> [    0.447022] mce: CPU supports 0 MCE banks
> [    0.459304] Disabled fast string operations
> [    0.459346] mce: CPU supports 0 MCE banks
> [    0.471870] Disabled fast string operations
> [    0.471912] mce: CPU supports 0 MCE banks
> [    0.484153] Disabled fast string operations
> [    0.484195] mce: CPU supports 0 MCE banks
> [    0.496635] Disabled fast string operations
> [    0.496678] mce: CPU supports 0 MCE banks
> [    0.509008] Disabled fast string operations
> [    0.509050] mce: CPU supports 0 MCE banks
> [    0.521422] Disabled fast string operations
> [    0.521468] mce: CPU supports 0 MCE banks
> [    0.533948] Disabled fast string operations
> [    0.533991] mce: CPU supports 0 MCE banks
> [    0.546267] Disabled fast string operations
> [    0.546309] mce: CPU supports 0 MCE banks
> [    0.558625] Disabled fast string operations
> [    0.558668] mce: CPU supports 0 MCE banks
> [    0.570919] Disabled fast string operations
> [    0.570961] mce: CPU supports 0 MCE banks
> [    0.583346] Disabled fast string operations
> [    0.583389] mce: CPU supports 0 MCE banks
> [    0.596617] Disabled fast string operations
> [    0.596660] mce: CPU supports 0 MCE banks
> [    0.609041] Disabled fast string operations
> [    0.609084] mce: CPU supports 0 MCE banks
> [    0.621419] Disabled fast string operations
> [    0.621462] mce: CPU supports 0 MCE banks
> [    0.635479] Disabled fast string operations
> [    0.635521] mce: CPU supports 0 MCE banks
> [    0.647855] Disabled fast string operations
> [    0.647898] mce: CPU supports 0 MCE banks
> [    0.660167] Disabled fast string operations
> [    0.660209] mce: CPU supports 0 MCE banks
> [    0.672557] Disabled fast string operations
> [    0.672600] mce: CPU supports 0 MCE banks
> [    0.684883] Disabled fast string operations
> [    0.684925] mce: CPU supports 0 MCE banks
> [    0.697234] Disabled fast string operations
> [    0.697298] mce: CPU supports 0 MCE banks
> [    0.709667] Disabled fast string operations
> [    0.709710] mce: CPU supports 0 MCE banks
> [    0.321330] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #=
7 #8 #9 #10 #11 #12 #13 #14 #15 #16 #17 #18 #19 #20 #21 #22 #23 #24 #25 #26=
 #27 #28 #29 #30 #31
> [    0.709942] Brought up 32 CPUs
> [    0.710390] smpboot: Total of 32 processors activated (166399.87 BogoM=
IPS)
> [    0.713421] x86 PAT enabled: cpu 4, old 0x0, new 0x7010600070106
> [    0.713976] x86 PAT enabled: cpu 25, old 0x0, new 0x7010600070106
> [    0.714638] x86 PAT enabled: cpu 27, old 0x0, new 0x7010600070106
> [    0.715264] x86 PAT enabled: cpu 5, old 0x0, new 0x7010600070106
> [    0.715847] x86 PAT enabled: cpu 29, old 0x0, new 0x7010600070106
> [    0.716509] x86 PAT enabled: cpu 20, old 0x0, new 0x7010600070106
> [    0.717136] x86 PAT enabled: cpu 1, old 0x0, new 0x7010600070106
> [    0.717704] x86 PAT enabled: cpu 2, old 0x0, new 0x7010600070106
> [    0.718254] x86 PAT enabled: cpu 13, old 0x0, new 0x7010600070106
> [    0.718911] x86 PAT enabled: cpu 12, old 0x0, new 0x7010600070106
> [    0.719602] x86 PAT enabled: cpu 9, old 0x0, new 0x7010600070106
> [    0.720267] x86 PAT enabled: cpu 10, old 0x0, new 0x7010600070106
> [    0.720937] x86 PAT enabled: cpu 26, old 0x0, new 0x7010600070106
> [    0.721601] x86 PAT enabled: cpu 3, old 0x0, new 0x7010600070106
> [    0.722292] x86 PAT enabled: cpu 21, old 0x0, new 0x7010600070106
> [    0.723076] x86 PAT enabled: cpu 16, old 0x0, new 0x7010600070106
> [    0.723676] x86 PAT enabled: cpu 19, old 0x0, new 0x7010600070106
> [    0.724329] x86 PAT enabled: cpu 30, old 0x0, new 0x7010600070106
> [    0.724978] x86 PAT enabled: cpu 14, old 0x0, new 0x7010600070106
> [    0.725637] x86 PAT enabled: cpu 15, old 0x0, new 0x7010600070106
> [    0.726249] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
> [    0.726534] x86 PAT enabled: cpu 11, old 0x0, new 0x7010600070106
> [    0.727192] x86 PAT enabled: cpu 24, old 0x0, new 0x7010600070106
> [    0.727721] x86 PAT enabled: cpu 22, old 0x0, new 0x7010600070106
> [    0.728259] x86 PAT enabled: cpu 6, old 0x0, new 0x7010600070106
> [    0.728909] x86 PAT enabled: cpu 31, old 0x0, new 0x7010600070106
> [    0.729578] x86 PAT enabled: cpu 28, old 0x0, new 0x7010600070106
> [    0.730233] x86 PAT enabled: cpu 18, old 0x0, new 0x7010600070106
> [    0.730861] x86 PAT enabled: cpu 23, old 0x0, new 0x7010600070106
> [    0.731396] x86 PAT enabled: cpu 7, old 0x0, new 0x7010600070106
> [    0.732041] x86 PAT enabled: cpu 8, old 0x0, new 0x7010600070106
> [    0.732723] x86 PAT enabled: cpu 17, old 0x0, new 0x7010600070106
> [    0.735180] devtmpfs: initialized
> [    0.740241] EVM: security.selinux
> [    0.740373] EVM: security.SMACK64
> [    0.740488] EVM: security.capability
> [    0.740787] PM: Registering ACPI NVS region [mem 0xbfeff000-0xbfefffff=
] (4096 bytes)
> [    0.743028] regulator-dummy: no parameters
> [    0.743376] RTC time: 14:45:23, date: 01/29/15
> [    0.743654] NET: Registered protocol family 16
> [    0.744000] ACPI: bus type PCI registered
> [    0.744112] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.744618] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf00000=
00-0xf7ffffff] (base 0xf0000000)
> [    0.744823] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E=
820
> [    0.765536] PCI: Using configuration type 1 for base access
> [    0.769132] bio: create slab <bio-0> at 0
> [    0.771260] ACPI: Added _OSI(Module Device)
> [    0.771378] ACPI: Added _OSI(Processor Device)
> [    0.771491] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.771606] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.782728] ACPI: EC: Look up EC in DSDT
> [    0.802552] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    1.296781] ACPI: Interpreter enabled
> [    1.296919] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20130517/hwxface-571)
> [    1.297185] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S3_] (20130517/hwxface-571)
> [    1.297465] ACPI: (supports S0 S1 S4 S5)
> [    1.297572] ACPI: Using IOAPIC for interrupt routing
> [    1.297741] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
> [    1.332387] ACPI: No dock devices found.
> [   13.095391] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
> [   13.095917] acpi PNP0A03:00: Requesting ACPI _OSC control (0x1d)
> [   13.096565] acpi PNP0A03:00: ACPI _OSC control (0x15) granted
> [   13.099408] PCI host bridge to bus 0000:00
> [   13.099529] pci_bus 0000:00: root bus resource [bus 00-7f]
> [   13.099657] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
> [   13.099820] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3=
fff]
> [   13.099963] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7=
fff]
> [   13.100105] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000db=
fff]
> [   13.100248] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebff=
fff]
> [   13.100391] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [   13.100525] pci_bus 0000:00: root bus resource [io  0x0d00-0xfeff]
> [   13.100775] pci 0000:00:00.0: [8086:7190] type 00 class 0x060000
> [   13.101757] pci 0000:00:01.0: [8086:7191] type 01 class 0x060400
> [   13.102738] pci 0000:00:07.0: [8086:7110] type 00 class 0x060100
> [   13.103996] pci 0000:00:07.1: [8086:7111] type 00 class 0x01018a
> [   13.110725] pci 0000:00:07.1: reg 0x20: [io  0x1060-0x106f]
> [   13.113788] pci 0000:00:07.3: [8086:7113] type 00 class 0x068000
> [   13.124569] pci 0000:00:07.3: quirk: [io  0x1000-0x103f] claimed by PI=
IX4 ACPI
> [   13.124779] pci 0000:00:07.3: quirk: [io  0x1040-0x104f] claimed by PI=
IX4 SMB
> [   13.125540] pci 0000:00:07.7: [15ad:0740] type 00 class 0x088000
> [   13.129653] pci 0000:00:07.7: reg 0x10: [io  0x1080-0x10bf]
> [   13.134294] pci 0000:00:07.7: reg 0x14: [mem 0xfebfe000-0xfebfffff 64b=
it]
> [   13.151606] pci 0000:00:0f.0: [15ad:0405] type 00 class 0x030000
> [   13.177123] pci 0000:00:0f.0: reg 0x10: [io  0x1070-0x107f]
> [   13.199197] pci 0000:00:0f.0: reg 0x14: [mem 0xec000000-0xefffffff pre=
f]
> [   13.221500] pci 0000:00:0f.0: reg 0x18: [mem 0xfe000000-0xfe7fffff]
> [   13.312771] pci 0000:00:0f.0: reg 0x30: [mem 0x00000000-0x00007fff pre=
f]
> [   13.313562] pci 0000:00:10.0: [1000:0030] type 00 class 0x010000
> [   13.319427] pci 0000:00:10.0: reg 0x10: [io  0x1400-0x14ff]
> [   13.325462] pci 0000:00:10.0: reg 0x14: [mem 0xfeba0000-0xfebbffff 64b=
it]
> [   13.331228] pci 0000:00:10.0: reg 0x1c: [mem 0xfebc0000-0xfebdffff 64b=
it]
> [   13.343302] pci 0000:00:10.0: reg 0x30: [mem 0x00000000-0x00003fff pre=
f]
> [   13.343807] pci 0000:00:11.0: [15ad:0790] type 01 class 0x060401
> [   13.344844] pci 0000:00:11.0: System wakeup disabled by ACPI
> [   13.345287] pci 0000:00:15.0: [15ad:07a0] type 01 class 0x060400
> [   13.346539] pci 0000:00:15.0: PME# supported from D0 D3hot D3cold
> [   13.346971] pci 0000:00:15.0: System wakeup disabled by ACPI
> [   13.347356] pci 0000:00:15.1: [15ad:07a0] type 01 class 0x060400
> [   13.348530] pci 0000:00:15.1: PME# supported from D0 D3hot D3cold
> [   13.348893] pci 0000:00:15.1: System wakeup disabled by ACPI
> [   13.349275] pci 0000:00:15.2: [15ad:07a0] type 01 class 0x060400
> [   13.350492] pci 0000:00:15.2: PME# supported from D0 D3hot D3cold
> [   13.350861] pci 0000:00:15.2: System wakeup disabled by ACPI
> [   13.351238] pci 0000:00:15.3: [15ad:07a0] type 01 class 0x060400
> [   13.352391] pci 0000:00:15.3: PME# supported from D0 D3hot D3cold
> [   13.352751] pci 0000:00:15.3: System wakeup disabled by ACPI
> [   13.353116] pci 0000:00:15.4: [15ad:07a0] type 01 class 0x060400
> [   13.354339] pci 0000:00:15.4: PME# supported from D0 D3hot D3cold
> [   13.354707] pci 0000:00:15.4: System wakeup disabled by ACPI
> [   13.355110] pci 0000:00:15.5: [15ad:07a0] type 01 class 0x060400
> [   13.356276] pci 0000:00:15.5: PME# supported from D0 D3hot D3cold
> [   13.356641] pci 0000:00:15.5: System wakeup disabled by ACPI
> [   13.357029] pci 0000:00:15.6: [15ad:07a0] type 01 class 0x060400
> [   13.358232] pci 0000:00:15.6: PME# supported from D0 D3hot D3cold
> [   13.358608] pci 0000:00:15.6: System wakeup disabled by ACPI
> [   13.358979] pci 0000:00:15.7: [15ad:07a0] type 01 class 0x060400
> [   13.360126] pci 0000:00:15.7: PME# supported from D0 D3hot D3cold
> [   13.360488] pci 0000:00:15.7: System wakeup disabled by ACPI
> [   13.360852] pci 0000:00:16.0: [15ad:07a0] type 01 class 0x060400
> [   13.362041] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [   13.362435] pci 0000:00:16.0: System wakeup disabled by ACPI
> [   13.362811] pci 0000:00:16.1: [15ad:07a0] type 01 class 0x060400
> [   13.363955] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
> [   13.364314] pci 0000:00:16.1: System wakeup disabled by ACPI
> [   13.364688] pci 0000:00:16.2: [15ad:07a0] type 01 class 0x060400
> [   13.365831] pci 0000:00:16.2: PME# supported from D0 D3hot D3cold
> [   13.366244] pci 0000:00:16.2: System wakeup disabled by ACPI
> [   13.366625] pci 0000:00:16.3: [15ad:07a0] type 01 class 0x060400
> [   13.367774] pci 0000:00:16.3: PME# supported from D0 D3hot D3cold
> [   13.368133] pci 0000:00:16.3: System wakeup disabled by ACPI
> [   13.368512] pci 0000:00:16.4: [15ad:07a0] type 01 class 0x060400
> [   13.369660] pci 0000:00:16.4: PME# supported from D0 D3hot D3cold
> [   13.370064] pci 0000:00:16.4: System wakeup disabled by ACPI
> [   13.370973] pci 0000:00:16.5: [15ad:07a0] type 01 class 0x060400
> [   13.372127] pci 0000:00:16.5: PME# supported from D0 D3hot D3cold
> [   13.372498] pci 0000:00:16.5: System wakeup disabled by ACPI
> [   13.372866] pci 0000:00:16.6: [15ad:07a0] type 01 class 0x060400
> [   13.374043] pci 0000:00:16.6: PME# supported from D0 D3hot D3cold
> [   13.374413] pci 0000:00:16.6: System wakeup disabled by ACPI
> [   13.374781] pci 0000:00:16.7: [15ad:07a0] type 01 class 0x060400
> [   13.375925] pci 0000:00:16.7: PME# supported from D0 D3hot D3cold
> [   13.376296] pci 0000:00:16.7: System wakeup disabled by ACPI
> [   13.376661] pci 0000:00:17.0: [15ad:07a0] type 01 class 0x060400
> [   13.377805] pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
> [   13.378239] pci 0000:00:17.0: System wakeup disabled by ACPI
> [   13.378617] pci 0000:00:17.1: [15ad:07a0] type 01 class 0x060400
> [   13.379777] pci 0000:00:17.1: PME# supported from D0 D3hot D3cold
> [   13.380144] pci 0000:00:17.1: System wakeup disabled by ACPI
> [   13.380514] pci 0000:00:17.2: [15ad:07a0] type 01 class 0x060400
> [   13.381660] pci 0000:00:17.2: PME# supported from D0 D3hot D3cold
> [   13.382077] pci 0000:00:17.2: System wakeup disabled by ACPI
> [   13.382474] pci 0000:00:17.3: [15ad:07a0] type 01 class 0x060400
> [   13.383624] pci 0000:00:17.3: PME# supported from D0 D3hot D3cold
> [   13.383987] pci 0000:00:17.3: System wakeup disabled by ACPI
> [   13.384358] pci 0000:00:17.4: [15ad:07a0] type 01 class 0x060400
> [   13.385513] pci 0000:00:17.4: PME# supported from D0 D3hot D3cold
> [   13.385873] pci 0000:00:17.4: System wakeup disabled by ACPI
> [   13.386313] pci 0000:00:17.5: [15ad:07a0] type 01 class 0x060400
> [   13.387459] pci 0000:00:17.5: PME# supported from D0 D3hot D3cold
> [   13.387836] pci 0000:00:17.5: System wakeup disabled by ACPI
> [   13.388242] pci 0000:00:17.6: [15ad:07a0] type 01 class 0x060400
> [   13.389418] pci 0000:00:17.6: PME# supported from D0 D3hot D3cold
> [   13.389788] pci 0000:00:17.6: System wakeup disabled by ACPI
> [   13.390226] pci 0000:00:17.7: [15ad:07a0] type 01 class 0x060400
> [   13.391370] pci 0000:00:17.7: PME# supported from D0 D3hot D3cold
> [   13.391740] pci 0000:00:17.7: System wakeup disabled by ACPI
> [   13.392112] pci 0000:00:18.0: [15ad:07a0] type 01 class 0x060400
> [   13.393256] pci 0000:00:18.0: PME# supported from D0 D3hot D3cold
> [   13.393624] pci 0000:00:18.0: System wakeup disabled by ACPI
> [   13.394024] pci 0000:00:18.1: [15ad:07a0] type 01 class 0x060400
> [   13.395191] pci 0000:00:18.1: PME# supported from D0 D3hot D3cold
> [   13.395559] pci 0000:00:18.1: System wakeup disabled by ACPI
> [   13.395927] pci 0000:00:18.2: [15ad:07a0] type 01 class 0x060400
> [   13.397072] pci 0000:00:18.2: PME# supported from D0 D3hot D3cold
> [   13.397437] pci 0000:00:18.2: System wakeup disabled by ACPI
> [   13.397804] pci 0000:00:18.3: [15ad:07a0] type 01 class 0x060400
> [   13.399000] pci 0000:00:18.3: PME# supported from D0 D3hot D3cold
> [   13.399400] pci 0000:00:18.3: System wakeup disabled by ACPI
> [   13.399792] pci 0000:00:18.4: [15ad:07a0] type 01 class 0x060400
> [   13.400935] pci 0000:00:18.4: PME# supported from D0 D3hot D3cold
> [   13.401315] pci 0000:00:18.4: System wakeup disabled by ACPI
> [   13.401685] pci 0000:00:18.5: [15ad:07a0] type 01 class 0x060400
> [   13.402872] pci 0000:00:18.5: PME# supported from D0 D3hot D3cold
> [   13.403237] pci 0000:00:18.5: System wakeup disabled by ACPI
> [   13.403607] pci 0000:00:18.6: [15ad:07a0] type 01 class 0x060400
> [   13.404749] pci 0000:00:18.6: PME# supported from D0 D3hot D3cold
> [   13.405109] pci 0000:00:18.6: System wakeup disabled by ACPI
> [   13.405473] pci 0000:00:18.7: [15ad:07a0] type 01 class 0x060400
> [   13.406667] pci 0000:00:18.7: PME# supported from D0 D3hot D3cold
> [   13.407040] pci 0000:00:18.7: System wakeup disabled by ACPI
> [   13.408004] pci 0000:00:01.0: PCI bridge to [bus 01]
> [   13.408884] acpiphp: Slot [32] registered
> [   13.409036] acpiphp: Slot [33] registered
> [   13.409187] acpiphp: Slot [34] registered
> [   13.409331] acpiphp: Slot [35] registered
> [   13.409486] acpiphp: Slot [36] registered
> [   13.409635] acpiphp: Slot [37] registered
> [   13.409777] acpiphp: Slot [38] registered
> [   13.409920] acpiphp: Slot [39] registered
> [   13.410105] acpiphp: Slot [40] registered
> [   13.410251] acpiphp: Slot [41] registered
> [   13.410392] acpiphp: Slot [42] registered
> [   13.410540] acpiphp: Slot [43] registered
> [   13.410682] acpiphp: Slot [44] registered
> [   13.410822] acpiphp: Slot [45] registered
> [   13.410963] acpiphp: Slot [46] registered
> [   13.411103] acpiphp: Slot [47] registered
> [   13.411246] acpiphp: Slot [48] registered
> [   13.411387] acpiphp: Slot [49] registered
> [   13.411529] acpiphp: Slot [50] registered
> [   13.411676] acpiphp: Slot [51] registered
> [   13.411819] acpiphp: Slot [52] registered
> [   13.411960] acpiphp: Slot [53] registered
> [   13.412101] acpiphp: Slot [54] registered
> [   13.412245] acpiphp: Slot [55] registered
> [   13.412387] acpiphp: Slot [56] registered
> [   13.412529] acpiphp: Slot [57] registered
> [   13.412677] acpiphp: Slot [58] registered
> [   13.412820] acpiphp: Slot [59] registered
> [   13.412962] acpiphp: Slot [60] registered
> [   13.413104] acpiphp: Slot [61] registered
> [   13.413253] acpiphp: Slot [62] registered
> [   13.413395] acpiphp: Slot [63] registered
> [   13.413617] pci 0000:02:01.0: [1000:0030] type 00 class 0x010000
> [   13.419827] pci 0000:02:01.0: reg 0x10: [io  0x2000-0x20ff]
> [   13.427561] pci 0000:02:01.0: reg 0x14: [mem 0xfd5c0000-0xfd5dffff 64b=
it]
> [   13.433911] pci 0000:02:01.0: reg 0x1c: [mem 0xfd5e0000-0xfd5fffff 64b=
it]
> [   13.445941] pci 0000:02:01.0: reg 0x30: [mem 0x00000000-0x00003fff pre=
f]
> [   13.446222] pci 0000:02:01.0: System wakeup disabled by ACPI
> [   13.446516] pci 0000:02:02.0: [15ad:0774] type 00 class 0x0c0300
> [   13.452307] pci 0000:02:02.0: reg 0x20: [io  0x2400-0x241f]
> [   13.454816] pci 0000:02:02.0: System wakeup disabled by ACPI
> [   13.455086] pci 0000:02:03.0: [15ad:0770] type 00 class 0x0c0320
> [   13.457746] pci 0000:02:03.0: reg 0x10: [mem 0xfd5bf000-0xfd5bffff]
> [   13.472279] pci 0000:02:03.0: System wakeup disabled by ACPI
> [   13.472947] pci 0000:00:11.0: PCI bridge to [bus 02] (subtractive deco=
de)
> [   13.473133] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
> [   13.473176] pci 0000:00:11.0:   bridge window [mem 0xfd500000-0xfdffff=
ff]
> [   13.473250] pci 0000:00:11.0:   bridge window [mem 0xebb00000-0xebffff=
ff 64bit pref]
> [   13.473254] pci 0000:00:11.0:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
> [   13.473256] pci 0000:00:11.0:   bridge window [mem 0x000d0000-0x000d3f=
ff] (subtractive decode)
> [   13.473259] pci 0000:00:11.0:   bridge window [mem 0x000d4000-0x000d7f=
ff] (subtractive decode)
> [   13.473262] pci 0000:00:11.0:   bridge window [mem 0x000d8000-0x000dbf=
ff] (subtractive decode)
> [   13.473265] pci 0000:00:11.0:   bridge window [mem 0xc0000000-0xfebfff=
ff] (subtractive decode)
> [   13.473268] pci 0000:00:11.0:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
> [   13.473270] pci 0000:00:11.0:   bridge window [io  0x0d00-0xfeff] (sub=
tractive decode)
> [   13.474299] pci 0000:03:00.0: [15ad:07b0] type 00 class 0x020000
> [   13.482626] pci 0000:03:00.0: reg 0x10: [mem 0xfd4fb000-0xfd4fbfff]
> [   13.491238] pci 0000:03:00.0: reg 0x14: [mem 0xfd4fc000-0xfd4fcfff]
> [   13.499267] pci 0000:03:00.0: reg 0x18: [mem 0xfd4fe000-0xfd4fffff]
> [   13.507066] pci 0000:03:00.0: reg 0x1c: [io  0x4000-0x400f]
> [   13.532261] pci 0000:03:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pre=
f]
> [   13.532944] pci 0000:03:00.0: supports D1 D2
> [   13.532948] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [   13.533215] pci 0000:03:00.0: System wakeup disabled by ACPI
> [   13.533431] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
> [   13.533732] pci 0000:00:15.0: PCI bridge to [bus 03]
> [   13.533888] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
> [   13.533924] pci 0000:00:15.0:   bridge window [mem 0xfd400000-0xfd4fff=
ff]
> [   13.533992] pci 0000:00:15.0:   bridge window [mem 0xeba00000-0xebafff=
ff 64bit pref]
> [   13.534884] pci 0000:00:15.1: PCI bridge to [bus 04]
> [   13.535045] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
> [   13.535081] pci 0000:00:15.1:   bridge window [mem 0xfd000000-0xfd0fff=
ff]
> [   13.535148] pci 0000:00:15.1:   bridge window [mem 0xeb600000-0xeb6fff=
ff 64bit pref]
> [   13.535960] pci 0000:00:15.2: PCI bridge to [bus 05]
> [   13.536117] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
> [   13.536153] pci 0000:00:15.2:   bridge window [mem 0xfcc00000-0xfccfff=
ff]
> [   13.536220] pci 0000:00:15.2:   bridge window [mem 0xeb200000-0xeb2fff=
ff 64bit pref]
> [   13.537016] pci 0000:00:15.3: PCI bridge to [bus 06]
> [   13.537206] pci 0000:00:15.3:   bridge window [mem 0xfc800000-0xfc8fff=
ff]
> [   13.537276] pci 0000:00:15.3:   bridge window [mem 0xeae00000-0xeaefff=
ff 64bit pref]
> [   13.538131] pci 0000:00:15.4: PCI bridge to [bus 07]
> [   13.538334] pci 0000:00:15.4:   bridge window [mem 0xfc400000-0xfc4fff=
ff]
> [   13.538401] pci 0000:00:15.4:   bridge window [mem 0xeaa00000-0xeaafff=
ff 64bit pref]
> [   13.539205] pci 0000:00:15.5: PCI bridge to [bus 08]
> [   13.539398] pci 0000:00:15.5:   bridge window [mem 0xfc000000-0xfc0fff=
ff]
> [   13.539472] pci 0000:00:15.5:   bridge window [mem 0xea600000-0xea6fff=
ff 64bit pref]
> [   13.540282] pci 0000:00:15.6: PCI bridge to [bus 09]
> [   13.540473] pci 0000:00:15.6:   bridge window [mem 0xfbc00000-0xfbcfff=
ff]
> [   13.540540] pci 0000:00:15.6:   bridge window [mem 0xea200000-0xea2fff=
ff 64bit pref]
> [   13.541335] pci 0000:00:15.7: PCI bridge to [bus 0a]
> [   13.541525] pci 0000:00:15.7:   bridge window [mem 0xfb800000-0xfb8fff=
ff]
> [   13.541592] pci 0000:00:15.7:   bridge window [mem 0xe9e00000-0xe9efff=
ff 64bit pref]
> [   13.542414] pci 0000:00:16.0: PCI bridge to [bus 0b]
> [   13.542574] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
> [   13.542609] pci 0000:00:16.0:   bridge window [mem 0xfd300000-0xfd3fff=
ff]
> [   13.542676] pci 0000:00:16.0:   bridge window [mem 0xeb900000-0xeb9fff=
ff 64bit pref]
> [   13.543491] pci 0000:00:16.1: PCI bridge to [bus 0c]
> [   13.543669] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
> [   13.543705] pci 0000:00:16.1:   bridge window [mem 0xfcf00000-0xfcffff=
ff]
> [   13.543772] pci 0000:00:16.1:   bridge window [mem 0xeb500000-0xeb5fff=
ff 64bit pref]
> [   13.544562] pci 0000:00:16.2: PCI bridge to [bus 0d]
> [   13.544720] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
> [   13.544756] pci 0000:00:16.2:   bridge window [mem 0xfcb00000-0xfcbfff=
ff]
> [   13.544823] pci 0000:00:16.2:   bridge window [mem 0xeb100000-0xeb1fff=
ff 64bit pref]
> [   13.545615] pci 0000:00:16.3: PCI bridge to [bus 0e]
> [   13.545805] pci 0000:00:16.3:   bridge window [mem 0xfc700000-0xfc7fff=
ff]
> [   13.545872] pci 0000:00:16.3:   bridge window [mem 0xead00000-0xeadfff=
ff 64bit pref]
> [   13.546680] pci 0000:00:16.4: PCI bridge to [bus 0f]
> [   13.546871] pci 0000:00:16.4:   bridge window [mem 0xfc300000-0xfc3fff=
ff]
> [   13.546938] pci 0000:00:16.4:   bridge window [mem 0xea900000-0xea9fff=
ff 64bit pref]
> [   13.547733] pci 0000:00:16.5: PCI bridge to [bus 10]
> [   13.547922] pci 0000:00:16.5:   bridge window [mem 0xfbf00000-0xfbffff=
ff]
> [   13.547990] pci 0000:00:16.5:   bridge window [mem 0xea500000-0xea5fff=
ff 64bit pref]
> [   13.548797] pci 0000:00:16.6: PCI bridge to [bus 11]
> [   13.548987] pci 0000:00:16.6:   bridge window [mem 0xfbb00000-0xfbbfff=
ff]
> [   13.549054] pci 0000:00:16.6:   bridge window [mem 0xea100000-0xea1fff=
ff 64bit pref]
> [   13.549848] pci 0000:00:16.7: PCI bridge to [bus 12]
> [   13.550055] pci 0000:00:16.7:   bridge window [mem 0xfb700000-0xfb7fff=
ff]
> [   13.550124] pci 0000:00:16.7:   bridge window [mem 0xe9d00000-0xe9dfff=
ff 64bit pref]
> [   13.550932] pci 0000:00:17.0: PCI bridge to [bus 13]
> [   13.551091] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
> [   13.551127] pci 0000:00:17.0:   bridge window [mem 0xfd200000-0xfd2fff=
ff]
> [   13.551197] pci 0000:00:17.0:   bridge window [mem 0xeb800000-0xeb8fff=
ff 64bit pref]
> [   13.551996] pci 0000:00:17.1: PCI bridge to [bus 14]
> [   13.552154] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
> [   13.552190] pci 0000:00:17.1:   bridge window [mem 0xfce00000-0xfcefff=
ff]
> [   13.552257] pci 0000:00:17.1:   bridge window [mem 0xeb400000-0xeb4fff=
ff 64bit pref]
> [   13.553047] pci 0000:00:17.2: PCI bridge to [bus 15]
> [   13.553206] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
> [   13.553242] pci 0000:00:17.2:   bridge window [mem 0xfca00000-0xfcafff=
ff]
> [   13.553311] pci 0000:00:17.2:   bridge window [mem 0xeb000000-0xeb0fff=
ff 64bit pref]
> [   13.554144] pci 0000:00:17.3: PCI bridge to [bus 16]
> [   13.554337] pci 0000:00:17.3:   bridge window [mem 0xfc600000-0xfc6fff=
ff]
> [   13.554404] pci 0000:00:17.3:   bridge window [mem 0xeac00000-0xeacfff=
ff 64bit pref]
> [   13.555212] pci 0000:00:17.4: PCI bridge to [bus 17]
> [   13.555401] pci 0000:00:17.4:   bridge window [mem 0xfc200000-0xfc2fff=
ff]
> [   13.555467] pci 0000:00:17.4:   bridge window [mem 0xea800000-0xea8fff=
ff 64bit pref]
> [   13.556270] pci 0000:00:17.5: PCI bridge to [bus 18]
> [   13.556458] pci 0000:00:17.5:   bridge window [mem 0xfbe00000-0xfbefff=
ff]
> [   13.556525] pci 0000:00:17.5:   bridge window [mem 0xea400000-0xea4fff=
ff 64bit pref]
> [   13.557363] pci 0000:00:17.6: PCI bridge to [bus 19]
> [   13.557555] pci 0000:00:17.6:   bridge window [mem 0xfba00000-0xfbafff=
ff]
> [   13.557622] pci 0000:00:17.6:   bridge window [mem 0xea000000-0xea0fff=
ff 64bit pref]
> [   13.558480] pci 0000:00:17.7: PCI bridge to [bus 1a]
> [   13.558688] pci 0000:00:17.7:   bridge window [mem 0xfb600000-0xfb6fff=
ff]
> [   13.558755] pci 0000:00:17.7:   bridge window [mem 0xe9c00000-0xe9cfff=
ff 64bit pref]
> [   13.559560] pci 0000:00:18.0: PCI bridge to [bus 1b]
> [   13.559716] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
> [   13.559752] pci 0000:00:18.0:   bridge window [mem 0xfd100000-0xfd1fff=
ff]
> [   13.559819] pci 0000:00:18.0:   bridge window [mem 0xeb700000-0xeb7fff=
ff 64bit pref]
> [   13.560621] pci 0000:00:18.1: PCI bridge to [bus 1c]
> [   13.560776] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
> [   13.560812] pci 0000:00:18.1:   bridge window [mem 0xfcd00000-0xfcdfff=
ff]
> [   13.560879] pci 0000:00:18.1:   bridge window [mem 0xeb300000-0xeb3fff=
ff 64bit pref]
> [   13.561674] pci 0000:00:18.2: PCI bridge to [bus 1d]
> [   13.561861] pci 0000:00:18.2:   bridge window [mem 0xfc900000-0xfc9fff=
ff]
> [   13.561933] pci 0000:00:18.2:   bridge window [mem 0xeaf00000-0xeaffff=
ff 64bit pref]
> [   13.562791] pci 0000:00:18.3: PCI bridge to [bus 1e]
> [   13.562981] pci 0000:00:18.3:   bridge window [mem 0xfc500000-0xfc5fff=
ff]
> [   13.563048] pci 0000:00:18.3:   bridge window [mem 0xeab00000-0xeabfff=
ff 64bit pref]
> [   13.563869] pci 0000:00:18.4: PCI bridge to [bus 1f]
> [   13.564057] pci 0000:00:18.4:   bridge window [mem 0xfc100000-0xfc1fff=
ff]
> [   13.564125] pci 0000:00:18.4:   bridge window [mem 0xea700000-0xea7fff=
ff 64bit pref]
> [   13.564937] pci 0000:00:18.5: PCI bridge to [bus 20]
> [   13.565125] pci 0000:00:18.5:   bridge window [mem 0xfbd00000-0xfbdfff=
ff]
> [   13.565192] pci 0000:00:18.5:   bridge window [mem 0xea300000-0xea3fff=
ff 64bit pref]
> [   13.565990] pci 0000:00:18.6: PCI bridge to [bus 21]
> [   13.566220] pci 0000:00:18.6:   bridge window [mem 0xfb900000-0xfb9fff=
ff]
> [   13.566290] pci 0000:00:18.6:   bridge window [mem 0xe9f00000-0xe9ffff=
ff 64bit pref]
> [   13.567101] pci 0000:00:18.7: PCI bridge to [bus 22]
> [   13.567291] pci 0000:00:18.7:   bridge window [mem 0xfb500000-0xfb5fff=
ff]
> [   13.567361] pci 0000:00:18.7:   bridge window [mem 0xe9b00000-0xe9bfff=
ff 64bit pref]
> [   13.570639] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 1=
4 15)
> [   13.571329] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 1=
4 15)
> [   13.572025] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 1=
4 15)
> [   13.572754] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 1=
4 15)
> [   13.974320] memory memory2: ACPI handle is already set
> [   13.974488] acpi PNP0C80:01: acpi_memory_enable_device() error
> [   14.046358] memory memory3: ACPI handle is already set
> [   14.046507] acpi PNP0C80:03: acpi_memory_enable_device() error
> [   14.106381] memory memory4: ACPI handle is already set
> [   14.106544] acpi PNP0C80:05: acpi_memory_enable_device() error
> [   14.174329] memory memory5: ACPI handle is already set
> [   14.174477] acpi PNP0C80:07: acpi_memory_enable_device() error
> [   14.246495] memory memory6: ACPI handle is already set
> [   14.246640] acpi PNP0C80:09: acpi_memory_enable_device() error
> [   14.314465] memory memory7: ACPI handle is already set
> [   14.314608] acpi PNP0C80:0b: acpi_memory_enable_device() error
> [   14.370472] memory memory8: ACPI handle is already set
> [   14.370621] acpi PNP0C80:0d: acpi_memory_enable_device() error
> [   14.438432] memory memory9: ACPI handle is already set
> [   14.438577] acpi PNP0C80:0f: acpi_memory_enable_device() error
> [   14.498445] memory memory10: ACPI handle is already set
> [   14.498590] acpi PNP0C80:11: acpi_memory_enable_device() error
> [   14.562553] memory memory11: ACPI handle is already set
> [   14.562697] acpi PNP0C80:13: acpi_memory_enable_device() error
> [   14.646493] memory memory12: ACPI handle is already set
> [   14.646638] acpi PNP0C80:15: acpi_memory_enable_device() error
> [   14.710576] memory memory13: ACPI handle is already set
> [   14.710721] acpi PNP0C80:17: acpi_memory_enable_device() error
> [   14.782586] memory memory14: ACPI handle is already set
> [   14.782729] acpi PNP0C80:19: acpi_memory_enable_device() error
> [   14.854654] memory memory15: ACPI handle is already set
> [   14.854799] acpi PNP0C80:1b: acpi_memory_enable_device() error
> [   14.922626] memory memory16: ACPI handle is already set
> [   14.922788] acpi PNP0C80:1d: acpi_memory_enable_device() error
> [   14.990728] memory memory17: ACPI handle is already set
> [   14.990874] acpi PNP0C80:1f: acpi_memory_enable_device() error
> [   15.046702] memory memory18: ACPI handle is already set
> [   15.046846] acpi PNP0C80:21: acpi_memory_enable_device() error
> [   15.102717] memory memory19: ACPI handle is already set
> [   15.102862] acpi PNP0C80:23: acpi_memory_enable_device() error
> [   15.178804] memory memory20: ACPI handle is already set
> [   15.178978] acpi PNP0C80:25: acpi_memory_enable_device() error
> [   15.242764] memory memory21: ACPI handle is already set
> [   15.242936] acpi PNP0C80:27: acpi_memory_enable_device() error
> [   15.318798] memory memory22: ACPI handle is already set
> [   15.318975] acpi PNP0C80:29: acpi_memory_enable_device() error
> [   15.386863] memory memory23: ACPI handle is already set
> [   15.387045] acpi PNP0C80:2b: acpi_memory_enable_device() error
> [   15.458828] memory memory32: ACPI handle is already set
> [   15.458988] acpi PNP0C80:2d: acpi_memory_enable_device() error
> [   15.522865] memory memory33: ACPI handle is already set
> [   15.523024] acpi PNP0C80:2f: acpi_memory_enable_device() error
> [   15.586940] memory memory34: ACPI handle is already set
> [   15.587101] acpi PNP0C80:31: acpi_memory_enable_device() error
> [   15.646927] memory memory35: ACPI handle is already set
> [   15.647073] acpi PNP0C80:33: acpi_memory_enable_device() error
> [   15.722949] memory memory36: ACPI handle is already set
> [   15.723097] acpi PNP0C80:35: acpi_memory_enable_device() error
> [   15.810989] memory memory37: ACPI handle is already set
> [   15.811137] acpi PNP0C80:37: acpi_memory_enable_device() error
> [   15.883033] memory memory38: ACPI handle is already set
> [   15.883209] acpi PNP0C80:39: acpi_memory_enable_device() error
> [   15.946983] memory memory39: ACPI handle is already set
> [   15.947131] acpi PNP0C80:3b: acpi_memory_enable_device() error
> [   16.031036] memory memory40: ACPI handle is already set
> [   16.031183] acpi PNP0C80:3d: acpi_memory_enable_device() error
> [   16.099048] memory memory41: ACPI handle is already set
> [   16.099195] acpi PNP0C80:3f: acpi_memory_enable_device() error
> [   16.163064] memory memory42: ACPI handle is already set
> [   16.163211] acpi PNP0C80:41: acpi_memory_enable_device() error
> [   16.215078] memory memory43: ACPI handle is already set
> [   16.215224] acpi PNP0C80:43: acpi_memory_enable_device() error
> [   16.275102] memory memory44: ACPI handle is already set
> [   16.275247] acpi PNP0C80:45: acpi_memory_enable_device() error
> [   16.339045] memory memory45: ACPI handle is already set
> [   16.339193] acpi PNP0C80:47: acpi_memory_enable_device() error
> [   16.399107] memory memory46: ACPI handle is already set
> [   16.399256] acpi PNP0C80:49: acpi_memory_enable_device() error
> [   16.475199] memory memory47: ACPI handle is already set
> [   16.475346] acpi PNP0C80:4b: acpi_memory_enable_device() error
> [   16.543204] memory memory48: ACPI handle is already set
> [   16.543352] acpi PNP0C80:4d: acpi_memory_enable_device() error
> [   16.611148] memory memory49: ACPI handle is already set
> [   16.611297] acpi PNP0C80:4f: acpi_memory_enable_device() error
> [   16.679233] memory memory50: ACPI handle is already set
> [   16.679380] acpi PNP0C80:51: acpi_memory_enable_device() error
> [   16.747269] memory memory51: ACPI handle is already set
> [   16.747415] acpi PNP0C80:53: acpi_memory_enable_device() error
> [   16.811332] memory memory52: ACPI handle is already set
> [   16.811869] acpi PNP0C80:55: acpi_memory_enable_device() error
> [   16.871355] memory memory53: ACPI handle is already set
> [   16.871503] acpi PNP0C80:57: acpi_memory_enable_device() error
> [   16.935344] memory memory54: ACPI handle is already set
> [   16.935493] acpi PNP0C80:59: acpi_memory_enable_device() error
> [   17.011381] memory memory55: ACPI handle is already set
> [   17.011534] acpi PNP0C80:5b: acpi_memory_enable_device() error
> [   17.079359] memory memory56: ACPI handle is already set
> [   17.079507] acpi PNP0C80:5d: acpi_memory_enable_device() error
> [   17.143342] memory memory57: ACPI handle is already set
> [   17.143492] acpi PNP0C80:5f: acpi_memory_enable_device() error
> [   17.211402] memory memory58: ACPI handle is already set
> [   17.211553] acpi PNP0C80:61: acpi_memory_enable_device() error
> [   17.279581] memory memory59: ACPI handle is already set
> [   17.279740] acpi PNP0C80:63: acpi_memory_enable_device() error
> [   17.351417] memory memory60: ACPI handle is already set
> [   17.351566] acpi PNP0C80:65: acpi_memory_enable_device() error
> [   17.427488] memory memory61: ACPI handle is already set
> [   17.427637] acpi PNP0C80:67: acpi_memory_enable_device() error
> [   17.499436] memory memory62: ACPI handle is already set
> [   17.499585] acpi PNP0C80:69: acpi_memory_enable_device() error
> [   17.559544] memory memory63: ACPI handle is already set
> [   17.559691] acpi PNP0C80:6b: acpi_memory_enable_device() error
> [   17.615576] memory memory64: ACPI handle is already set
> [   17.615724] acpi PNP0C80:6d: acpi_memory_enable_device() error
> [   17.683591] memory memory65: ACPI handle is already set
> [   17.683739] acpi PNP0C80:6f: acpi_memory_enable_device() error
> [   17.751608] memory memory66: ACPI handle is already set
> [   17.751756] acpi PNP0C80:71: acpi_memory_enable_device() error
> [   17.815672] memory memory67: ACPI handle is already set
> [   17.815819] acpi PNP0C80:73: acpi_memory_enable_device() error
> [   17.871673] memory memory68: ACPI handle is already set
> [   17.871823] acpi PNP0C80:75: acpi_memory_enable_device() error
> [   17.931720] memory memory69: ACPI handle is already set
> [   17.931868] acpi PNP0C80:77: acpi_memory_enable_device() error
> [   18.011724] memory memory70: ACPI handle is already set
> [   18.011877] acpi PNP0C80:79: acpi_memory_enable_device() error
> [   18.075779] memory memory71: ACPI handle is already set
> [   18.075927] acpi PNP0C80:7b: acpi_memory_enable_device() error
> [   18.139773] memory memory72: ACPI handle is already set
> [   18.139923] acpi PNP0C80:7d: acpi_memory_enable_device() error
> [   18.211786] memory memory73: ACPI handle is already set
> [   18.211934] acpi PNP0C80:7f: acpi_memory_enable_device() error
> [   18.267783] memory memory74: ACPI handle is already set
> [   18.267931] acpi PNP0C80:81: acpi_memory_enable_device() error
> [   18.343759] memory memory75: ACPI handle is already set
> [   18.343907] acpi PNP0C80:83: acpi_memory_enable_device() error
> [   18.411883] memory memory76: ACPI handle is already set
> [   18.412032] acpi PNP0C80:85: acpi_memory_enable_device() error
> [   18.471877] memory memory77: ACPI handle is already set
> [   18.472026] acpi PNP0C80:87: acpi_memory_enable_device() error
> [   18.523870] memory memory78: ACPI handle is already set
> [   18.524021] acpi PNP0C80:89: acpi_memory_enable_device() error
> [   18.591922] memory memory79: ACPI handle is already set
> [   18.592071] acpi PNP0C80:8b: acpi_memory_enable_device() error
> [   18.655918] memory memory80: ACPI handle is already set
> [   18.656068] acpi PNP0C80:8d: acpi_memory_enable_device() error
> [   18.727902] memory memory81: ACPI handle is already set
> [   18.728052] acpi PNP0C80:8f: acpi_memory_enable_device() error
> [   18.787982] memory memory82: ACPI handle is already set
> [   18.788139] acpi PNP0C80:91: acpi_memory_enable_device() error
> [   18.859915] memory memory83: ACPI handle is already set
> [   18.860064] acpi PNP0C80:93: acpi_memory_enable_device() error
> [   18.928076] memory memory84: ACPI handle is already set
> [   18.928225] acpi PNP0C80:95: acpi_memory_enable_device() error
> [   19.000031] memory memory85: ACPI handle is already set
> [   19.000183] acpi PNP0C80:97: acpi_memory_enable_device() error
> [   19.072045] memory memory86: ACPI handle is already set
> [   19.072195] acpi PNP0C80:99: acpi_memory_enable_device() error
> [   19.120123] memory memory87: ACPI handle is already set
> [   19.120273] acpi PNP0C80:9b: acpi_memory_enable_device() error
> [   19.196056] memory memory88: ACPI handle is already set
> [   19.196206] acpi PNP0C80:9d: acpi_memory_enable_device() error
> [   19.284092] memory memory89: ACPI handle is already set
> [   19.284241] acpi PNP0C80:9f: acpi_memory_enable_device() error
> [   19.344077] memory memory90: ACPI handle is already set
> [   19.344228] acpi PNP0C80:a1: acpi_memory_enable_device() error
> [   19.400173] memory memory91: ACPI handle is already set
> [   19.400324] acpi PNP0C80:a3: acpi_memory_enable_device() error
> [   19.476181] memory memory92: ACPI handle is already set
> [   19.476333] acpi PNP0C80:a5: acpi_memory_enable_device() error
> [   19.544151] memory memory93: ACPI handle is already set
> [   19.544302] acpi PNP0C80:a7: acpi_memory_enable_device() error
> [   19.608285] memory memory94: ACPI handle is already set
> [   19.608536] acpi PNP0C80:a9: acpi_memory_enable_device() error
> [   19.668224] memory memory95: ACPI handle is already set
> [   19.668376] acpi PNP0C80:ab: acpi_memory_enable_device() error
> [   19.740199] memory memory96: ACPI handle is already set
> [   19.740360] acpi PNP0C80:ad: acpi_memory_enable_device() error
> [   19.808273] memory memory97: ACPI handle is already set
> [   19.808424] acpi PNP0C80:af: acpi_memory_enable_device() error
> [   19.880322] memory memory98: ACPI handle is already set
> [   19.880473] acpi PNP0C80:b1: acpi_memory_enable_device() error
> [   19.936371] memory memory99: ACPI handle is already set
> [   19.936536] acpi PNP0C80:b3: acpi_memory_enable_device() error
> [   19.988428] memory memory100: ACPI handle is already set
> [   19.988604] acpi PNP0C80:b5: acpi_memory_enable_device() error
> [   20.056351] memory memory101: ACPI handle is already set
> [   20.056504] acpi PNP0C80:b7: acpi_memory_enable_device() error
> [   20.128383] memory memory102: ACPI handle is already set
> [   20.128547] acpi PNP0C80:b9: acpi_memory_enable_device() error
> [   20.208325] memory memory103: ACPI handle is already set
> [   20.208480] acpi PNP0C80:bb: acpi_memory_enable_device() error
> [   20.272515] memory memory104: ACPI handle is already set
> [   20.272669] acpi PNP0C80:bd: acpi_memory_enable_device() error
> [   20.344459] memory memory105: ACPI handle is already set
> [   20.344611] acpi PNP0C80:bf: acpi_memory_enable_device() error
> [   20.404507] memory memory106: ACPI handle is already set
> [   20.404658] acpi PNP0C80:c1: acpi_memory_enable_device() error
> [   20.460438] memory memory107: ACPI handle is already set
> [   20.460590] acpi PNP0C80:c3: acpi_memory_enable_device() error
> [   20.524512] memory memory108: ACPI handle is already set
> [   20.524664] acpi PNP0C80:c5: acpi_memory_enable_device() error
> [   20.592490] memory memory109: ACPI handle is already set
> [   20.592647] acpi PNP0C80:c7: acpi_memory_enable_device() error
> [   20.660533] memory memory110: ACPI handle is already set
> [   20.660708] acpi PNP0C80:c9: acpi_memory_enable_device() error
> [   20.716619] memory memory111: ACPI handle is already set
> [   20.716787] acpi PNP0C80:cb: acpi_memory_enable_device() error
> [   20.776715] memory memory112: ACPI handle is already set
> [   20.776893] acpi PNP0C80:cd: acpi_memory_enable_device() error
> [   20.836665] memory memory113: ACPI handle is already set
> [   20.836834] acpi PNP0C80:cf: acpi_memory_enable_device() error
> [   20.916586] memory memory114: ACPI handle is already set
> [   20.916752] acpi PNP0C80:d1: acpi_memory_enable_device() error
> [   20.992739] memory memory115: ACPI handle is already set
> [   20.992906] acpi PNP0C80:d3: acpi_memory_enable_device() error
> [   21.056764] memory memory116: ACPI handle is already set
> [   21.056940] acpi PNP0C80:d5: acpi_memory_enable_device() error
> [   21.124754] memory memory117: ACPI handle is already set
> [   21.124920] acpi PNP0C80:d7: acpi_memory_enable_device() error
> [   21.192803] memory memory118: ACPI handle is already set
> [   21.192968] acpi PNP0C80:d9: acpi_memory_enable_device() error
> [   21.260879] memory memory119: ACPI handle is already set
> [   21.261040] acpi PNP0C80:db: acpi_memory_enable_device() error
> [   21.332793] memory memory120: ACPI handle is already set
> [   21.332952] acpi PNP0C80:dd: acpi_memory_enable_device() error
> [   21.396872] memory memory121: ACPI handle is already set
> [   21.397038] acpi PNP0C80:df: acpi_memory_enable_device() error
> [   21.460825] memory memory122: ACPI handle is already set
> [   21.460991] acpi PNP0C80:e1: acpi_memory_enable_device() error
> [   21.540890] memory memory123: ACPI handle is already set
> [   21.541034] acpi PNP0C80:e3: acpi_memory_enable_device() error
> [   21.620926] memory memory124: ACPI handle is already set
> [   21.621095] acpi PNP0C80:e5: acpi_memory_enable_device() error
> [   21.700967] memory memory125: ACPI handle is already set
> [   21.701137] acpi PNP0C80:e7: acpi_memory_enable_device() error
> [   21.765058] memory memory126: ACPI handle is already set
> [   21.765229] acpi PNP0C80:e9: acpi_memory_enable_device() error
> [   21.840968] memory memory127: ACPI handle is already set
> [   21.841139] acpi PNP0C80:eb: acpi_memory_enable_device() error
> [   21.920979] memory memory128: ACPI handle is already set
> [   21.921147] acpi PNP0C80:ed: acpi_memory_enable_device() error
> [   22.005114] memory memory129: ACPI handle is already set
> [   22.005282] acpi PNP0C80:ef: acpi_memory_enable_device() error
> [   22.068993] memory memory130: ACPI handle is already set
> [   22.069151] acpi PNP0C80:f1: acpi_memory_enable_device() error
> [   22.141117] memory memory131: ACPI handle is already set
> [   22.141270] acpi PNP0C80:f3: acpi_memory_enable_device() error
> [   22.213101] memory memory132: ACPI handle is already set
> [   22.213256] acpi PNP0C80:f5: acpi_memory_enable_device() error
> [   22.285105] memory memory133: ACPI handle is already set
> [   22.285258] acpi PNP0C80:f7: acpi_memory_enable_device() error
> [   22.353123] memory memory134: ACPI handle is already set
> [   22.353278] acpi PNP0C80:f9: acpi_memory_enable_device() error
> [   22.421247] memory memory135: ACPI handle is already set
> [   22.421401] acpi PNP0C80:fb: acpi_memory_enable_device() error
> [   22.477073] memory memory136: ACPI handle is already set
> [   22.477228] acpi PNP0C80:fd: acpi_memory_enable_device() error
> [   22.537129] memory memory137: ACPI handle is already set
> [   22.537284] acpi PNP0C80:ff: acpi_memory_enable_device() error
> [   22.597272] memory memory138: ACPI handle is already set
> [   22.597426] acpi PNP0C80:101: acpi_memory_enable_device() error
> [   22.677258] memory memory139: ACPI handle is already set
> [   22.677413] acpi PNP0C80:103: acpi_memory_enable_device() error
> [   22.741283] memory memory140: ACPI handle is already set
> [   22.741437] acpi PNP0C80:105: acpi_memory_enable_device() error
> [   22.801308] memory memory141: ACPI handle is already set
> [   22.801464] acpi PNP0C80:107: acpi_memory_enable_device() error
> [   22.865334] memory memory142: ACPI handle is already set
> [   22.865857] acpi PNP0C80:109: acpi_memory_enable_device() error
> [   22.929320] memory memory143: ACPI handle is already set
> [   22.929476] acpi PNP0C80:10b: acpi_memory_enable_device() error
> [   22.989401] memory memory144: ACPI handle is already set
> [   22.989556] acpi PNP0C80:10d: acpi_memory_enable_device() error
> [   23.045404] memory memory145: ACPI handle is already set
> [   23.045558] acpi PNP0C80:10f: acpi_memory_enable_device() error
> [   23.117382] memory memory146: ACPI handle is already set
> [   23.117538] acpi PNP0C80:111: acpi_memory_enable_device() error
> [   23.177423] memory memory147: ACPI handle is already set
> [   23.177637] acpi PNP0C80:113: acpi_memory_enable_device() error
> [   23.245410] memory memory148: ACPI handle is already set
> [   23.245565] acpi PNP0C80:115: acpi_memory_enable_device() error
> [   23.329443] memory memory149: ACPI handle is already set
> [   23.329598] acpi PNP0C80:117: acpi_memory_enable_device() error
> [   23.393557] memory memory150: ACPI handle is already set
> [   23.393713] acpi PNP0C80:119: acpi_memory_enable_device() error
> [   23.461435] memory memory151: ACPI handle is already set
> [   23.461591] acpi PNP0C80:11b: acpi_memory_enable_device() error
> [   23.533510] memory memory152: ACPI handle is already set
> [   23.533665] acpi PNP0C80:11d: acpi_memory_enable_device() error
> [   23.601567] memory memory153: ACPI handle is already set
> [   23.601722] acpi PNP0C80:11f: acpi_memory_enable_device() error
> [   23.669553] memory memory154: ACPI handle is already set
> [   23.669707] acpi PNP0C80:121: acpi_memory_enable_device() error
> [   23.745544] memory memory155: ACPI handle is already set
> [   23.745705] acpi PNP0C80:123: acpi_memory_enable_device() error
> [   23.809639] memory memory156: ACPI handle is already set
> [   23.809797] acpi PNP0C80:125: acpi_memory_enable_device() error
> [   23.877656] memory memory157: ACPI handle is already set
> [   23.877812] acpi PNP0C80:127: acpi_memory_enable_device() error
> [   23.945644] memory memory158: ACPI handle is already set
> [   23.945801] acpi PNP0C80:129: acpi_memory_enable_device() error
> [   24.017664] memory memory159: ACPI handle is already set
> [   24.017822] acpi PNP0C80:12b: acpi_memory_enable_device() error
> [   24.089651] memory memory160: ACPI handle is already set
> [   24.089809] acpi PNP0C80:12d: acpi_memory_enable_device() error
> [   24.153746] memory memory161: ACPI handle is already set
> [   24.153903] acpi PNP0C80:12f: acpi_memory_enable_device() error
> [   24.209739] memory memory162: ACPI handle is already set
> [   24.209895] acpi PNP0C80:131: acpi_memory_enable_device() error
> [   24.281750] memory memory163: ACPI handle is already set
> [   24.281906] acpi PNP0C80:133: acpi_memory_enable_device() error
> [   24.361711] memory memory164: ACPI handle is already set
> [   24.361868] acpi PNP0C80:135: acpi_memory_enable_device() error
> [   24.433874] memory memory165: ACPI handle is already set
> [   24.434031] acpi PNP0C80:137: acpi_memory_enable_device() error
> [   24.493860] memory memory166: ACPI handle is already set
> [   24.494017] acpi PNP0C80:139: acpi_memory_enable_device() error
> [   24.565903] memory memory167: ACPI handle is already set
> [   24.566061] acpi PNP0C80:13b: acpi_memory_enable_device() error
> [   24.633905] memory memory168: ACPI handle is already set
> [   24.634130] acpi PNP0C80:13d: acpi_memory_enable_device() error
> [   24.701889] memory memory169: ACPI handle is already set
> [   24.702131] acpi PNP0C80:13f: acpi_memory_enable_device() error
> [   24.769931] memory memory170: ACPI handle is already set
> [   24.770165] acpi PNP0C80:141: acpi_memory_enable_device() error
> [   24.833905] memory memory171: ACPI handle is already set
> [   24.834064] acpi PNP0C80:143: acpi_memory_enable_device() error
> [   24.905885] memory memory172: ACPI handle is already set
> [   24.906044] acpi PNP0C80:145: acpi_memory_enable_device() error
> [   24.990025] memory memory173: ACPI handle is already set
> [   24.990189] acpi PNP0C80:147: acpi_memory_enable_device() error
> [   25.070078] memory memory174: ACPI handle is already set
> [   25.070241] acpi PNP0C80:149: acpi_memory_enable_device() error
> [   25.134071] memory memory175: ACPI handle is already set
> [   25.134228] acpi PNP0C80:14b: acpi_memory_enable_device() error
> [   25.198069] memory memory176: ACPI handle is already set
> [   25.198232] acpi PNP0C80:14d: acpi_memory_enable_device() error
> [   25.274068] memory memory177: ACPI handle is already set
> [   25.274227] acpi PNP0C80:14f: acpi_memory_enable_device() error
> [   25.346172] memory memory178: ACPI handle is already set
> [   25.346414] acpi PNP0C80:151: acpi_memory_enable_device() error
> [   25.406194] memory memory179: ACPI handle is already set
> [   25.406359] acpi PNP0C80:153: acpi_memory_enable_device() error
> [   25.482241] memory memory180: ACPI handle is already set
> [   25.482403] acpi PNP0C80:155: acpi_memory_enable_device() error
> [   25.558193] memory memory181: ACPI handle is already set
> [   25.558411] acpi PNP0C80:157: acpi_memory_enable_device() error
> [   25.626205] memory memory182: ACPI handle is already set
> [   25.626365] acpi PNP0C80:159: acpi_memory_enable_device() error
> [   25.686239] memory memory183: ACPI handle is already set
> [   25.686397] acpi PNP0C80:15b: acpi_memory_enable_device() error
> [   25.762651] memory memory184: ACPI handle is already set
> [   25.762811] acpi PNP0C80:15d: acpi_memory_enable_device() error
> [   25.850298] memory memory185: ACPI handle is already set
> [   25.850458] acpi PNP0C80:15f: acpi_memory_enable_device() error
> [   25.930294] memory memory186: ACPI handle is already set
> [   25.930452] acpi PNP0C80:161: acpi_memory_enable_device() error
> [   26.002376] memory memory187: ACPI handle is already set
> [   26.002606] acpi PNP0C80:163: acpi_memory_enable_device() error
> [   26.074340] memory memory188: ACPI handle is already set
> [   26.074502] acpi PNP0C80:165: acpi_memory_enable_device() error
> [   26.150408] memory memory189: ACPI handle is already set
> [   26.150617] acpi PNP0C80:167: acpi_memory_enable_device() error
> [   26.218401] memory memory190: ACPI handle is already set
> [   26.218576] acpi PNP0C80:169: acpi_memory_enable_device() error
> [   26.286428] memory memory191: ACPI handle is already set
> [   26.286605] acpi PNP0C80:16b: acpi_memory_enable_device() error
> [   26.350489] memory memory192: ACPI handle is already set
> [   26.350663] acpi PNP0C80:16d: acpi_memory_enable_device() error
> [   26.410511] memory memory193: ACPI handle is already set
> [   26.410678] acpi PNP0C80:16f: acpi_memory_enable_device() error
> [   26.490431] memory memory194: ACPI handle is already set
> [   26.490603] acpi PNP0C80:171: acpi_memory_enable_device() error
> [   26.558570] memory memory195: ACPI handle is already set
> [   26.558730] acpi PNP0C80:173: acpi_memory_enable_device() error
> [   26.630620] memory memory196: ACPI handle is already set
> [   26.630780] acpi PNP0C80:175: acpi_memory_enable_device() error
> [   26.686590] memory memory197: ACPI handle is already set
> [   26.686748] acpi PNP0C80:177: acpi_memory_enable_device() error
> [   26.750584] memory memory198: ACPI handle is already set
> [   26.750746] acpi PNP0C80:179: acpi_memory_enable_device() error
> [   26.818607] memory memory199: ACPI handle is already set
> [   26.818766] acpi PNP0C80:17b: acpi_memory_enable_device() error
> [   27.883115] ACPI: Enabled 2 GPEs in block 00 to 0F
> [   27.883332] ACPI: \_SB_.PCI0: notify handler is installed
> [   27.884204] Found 1 acpi root devices
> [   27.884622] vgaarb: device added: PCI:0000:00:0f.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
> [   27.884833] vgaarb: loaded
> [   27.884923] vgaarb: bridge control possible 0000:00:0f.0
> [   27.885367] SCSI subsystem initialized
> [   27.885475] ACPI: bus type ATA registered
> [   27.886018] libata version 3.00 loaded.
> [   27.887022] ACPI: bus type USB registered
> [   27.887164] usbcore: registered new interface driver usbfs
> [   27.887300] usbcore: registered new interface driver hub
> [   27.887534] usbcore: registered new device driver usb
> [   27.888452] PCI: Using ACPI for IRQ routing
> [   27.935098] PCI: pci_cache_line_size set to 64 bytes
> [   27.936665] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
> [   27.936670] e820: reserve RAM buffer [mem 0xbfee0000-0xbfffffff]
> [   27.936867] NetLabel: Initializing
> [   27.936974] NetLabel:  domain hash size =3D 128
> [   27.937086] NetLabel:  protocols =3D UNLABELED CIPSOv4
> [   27.937218] NetLabel:  unlabeled traffic allowed by default
> [   27.937650] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0, 0,=
 0, 0, 0, 0, 0, 0, 0
> [   27.938397] hpet0: 16 comparators, 64-bit 14.318180 MHz counter
> [   27.950508] Switched to clocksource hpet
> [   27.967656] AppArmor: AppArmor Filesystem Enabled
> [   27.967982] pnp: PnP ACPI init
> [   27.968098] ACPI: bus type PNP registered
> [   27.968646] system 00:00: [io  0x1000-0x103f] could not be reserved
> [   27.968788] system 00:00: [io  0x1040-0x104f] has been reserved
> [   27.968921] system 00:00: [io  0x0cf0-0x0cf1] has been reserved
> [   27.969055] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
> [   27.969073] pnp 00:01: [dma 4]
> [   27.969096] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [   27.969130] pnp 00:02: Plug and Play ACPI device, IDs PNP0001 (active)
> [   27.969234] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
> [   27.969266] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
> [   27.969353] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
> [   27.969406] pnp 00:06: Plug and Play ACPI device, IDs PNP0f13 (active)
> [   27.969841] system 00:07: [mem 0xfed00000-0xfed003ff] has been reserved
> [   27.969989] system 00:07: Plug and Play ACPI device, IDs PNP0103 PNP0c=
01 (active)
> [   27.973271] pnp 00:08: Plug and Play ACPI device, IDs PNP0400 (active)
> [   27.973713] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
> [   27.974127] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
> [   27.974438] pnp 00:0b: [dma 2]
> [   27.974529] pnp 00:0b: Plug and Play ACPI device, IDs PNP0700 (active)
> [   27.974954] system 00:0c: [io  0xfce0-0xfcff] has been reserved
> [   27.975099] system 00:0c: [mem 0xf0000000-0xf7ffffff] has been reserved
> [   27.975243] system 00:0c: [mem 0xfe800000-0xfe9fffff] has been reserved
> [   27.975386] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
> [   28.011141] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.018705] pnp 00:0e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.026823] pnp 00:0f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.034772] pnp 00:10: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.042791] pnp 00:11: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.050774] pnp 00:12: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.058779] pnp 00:13: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.066773] pnp 00:14: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.074856] pnp 00:15: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.082788] pnp 00:16: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.090793] pnp 00:17: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.098806] pnp 00:18: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.106855] pnp 00:19: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.114756] pnp 00:1a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.122840] pnp 00:1b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.130806] pnp 00:1c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.138829] pnp 00:1d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.146840] pnp 00:1e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.154837] pnp 00:1f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.162863] pnp 00:20: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.170846] pnp 00:21: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.178849] pnp 00:22: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.186739] pnp 00:23: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.194871] pnp 00:24: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.202894] pnp 00:25: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.210885] pnp 00:26: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.218740] pnp 00:27: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.226916] pnp 00:28: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.234817] pnp 00:29: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.242862] pnp 00:2a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.250806] pnp 00:2b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.258929] pnp 00:2c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.266872] pnp 00:2d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.274901] pnp 00:2e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.282870] pnp 00:2f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.290885] pnp 00:30: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.298875] pnp 00:31: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.306866] pnp 00:32: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.314863] pnp 00:33: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.322829] pnp 00:34: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.330847] pnp 00:35: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.338860] pnp 00:36: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.346928] pnp 00:37: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.354847] pnp 00:38: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.362929] pnp 00:39: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.370864] pnp 00:3a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.378895] pnp 00:3b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.386897] pnp 00:3c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.395024] pnp 00:3d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.402933] pnp 00:3e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.410839] pnp 00:3f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.418890] pnp 00:40: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.426990] pnp 00:41: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.434943] pnp 00:42: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.442960] pnp 00:43: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.450991] pnp 00:44: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.458976] pnp 00:45: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.471054] pnp 00:46: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.483009] pnp 00:47: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.495052] pnp 00:48: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.503008] pnp 00:49: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.510985] pnp 00:4a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.522961] pnp 00:4b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.531036] pnp 00:4c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.538949] pnp 00:4d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.546878] pnp 00:4e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.559037] pnp 00:4f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.567013] pnp 00:50: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.574990] pnp 00:51: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.587051] pnp 00:52: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.599030] pnp 00:53: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.611033] pnp 00:54: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.622972] pnp 00:55: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.635094] pnp 00:56: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.643006] pnp 00:57: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.651058] pnp 00:58: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.659022] pnp 00:59: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.667004] pnp 00:5a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.675048] pnp 00:5b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.687039] pnp 00:5c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.695047] pnp 00:5d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.703044] pnp 00:5e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.711069] pnp 00:5f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.719017] pnp 00:60: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.727035] pnp 00:61: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.735085] pnp 00:62: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.743072] pnp 00:63: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.755120] pnp 00:64: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.763797] pnp 00:65: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.775084] pnp 00:66: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.787078] pnp 00:67: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.799078] pnp 00:68: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.807099] pnp 00:69: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.819121] pnp 00:6a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.831103] pnp 00:6b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.839098] pnp 00:6c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.847083] pnp 00:6d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.855133] pnp 00:6e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.863135] pnp 00:6f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.871106] pnp 00:70: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.879137] pnp 00:71: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.887124] pnp 00:72: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.895114] pnp 00:73: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.903120] pnp 00:74: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.911194] pnp 00:75: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.919153] pnp 00:76: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.927083] pnp 00:77: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.935142] pnp 00:78: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.943202] pnp 00:79: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.951146] pnp 00:7a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.959167] pnp 00:7b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.967144] pnp 00:7c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.975145] pnp 00:7d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.983230] pnp 00:7e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.991223] pnp 00:7f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   28.999150] pnp 00:80: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.007238] pnp 00:81: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.015181] pnp 00:82: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.023087] pnp 00:83: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.031130] pnp 00:84: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.039212] pnp 00:85: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.047247] pnp 00:86: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.055205] pnp 00:87: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.063239] pnp 00:88: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.071269] pnp 00:89: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.079226] pnp 00:8a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.087248] pnp 00:8b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.095273] pnp 00:8c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.103251] pnp 00:8d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.111257] pnp 00:8e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.119250] pnp 00:8f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.127261] pnp 00:90: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.135123] pnp 00:91: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.143172] pnp 00:92: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.151160] pnp 00:93: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.159172] pnp 00:94: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.167166] pnp 00:95: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.175189] pnp 00:96: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.183237] pnp 00:97: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.191344] pnp 00:98: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.199230] pnp 00:99: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.207254] pnp 00:9a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.215252] pnp 00:9b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.223262] pnp 00:9c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.231257] pnp 00:9d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.239154] pnp 00:9e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.247272] pnp 00:9f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.255260] pnp 00:a0: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.263917] pnp 00:a1: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.271230] pnp 00:a2: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.279233] pnp 00:a3: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.287271] pnp 00:a4: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.295268] pnp 00:a5: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.303279] pnp 00:a6: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.311298] pnp 00:a7: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.319295] pnp 00:a8: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.327482] pnp 00:a9: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.335303] pnp 00:aa: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.343300] pnp 00:ab: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.351305] pnp 00:ac: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.359336] pnp 00:ad: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.367302] pnp 00:ae: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.375345] pnp 00:af: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.383342] pnp 00:b0: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.391312] pnp 00:b1: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.399266] pnp 00:b2: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.407309] pnp 00:b3: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.415339] pnp 00:b4: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.423291] pnp 00:b5: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.431342] pnp 00:b6: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.439292] pnp 00:b7: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.447348] pnp 00:b8: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.455369] pnp 00:b9: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.463344] pnp 00:ba: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.471359] pnp 00:bb: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.479396] pnp 00:bc: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.487364] pnp 00:bd: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.495371] pnp 00:be: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.503359] pnp 00:bf: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.511312] pnp 00:c0: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.519342] pnp 00:c1: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.527366] pnp 00:c2: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.535366] pnp 00:c3: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.543391] pnp 00:c4: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.551416] pnp 00:c5: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.559421] pnp 00:c6: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.567336] pnp 00:c7: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.575453] pnp 00:c8: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.583426] pnp 00:c9: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.591436] pnp 00:ca: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.599448] pnp 00:cb: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.607461] pnp 00:cc: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.615453] pnp 00:cd: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.623437] pnp 00:ce: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.631429] pnp 00:cf: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.639435] pnp 00:d0: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.647386] pnp 00:d1: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.655447] pnp 00:d2: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.663473] pnp 00:d3: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.671446] pnp 00:d4: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.679435] pnp 00:d5: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.687464] pnp 00:d6: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.695438] pnp 00:d7: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.703456] pnp 00:d8: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.711468] pnp 00:d9: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.719480] pnp 00:da: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.727443] pnp 00:db: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.735477] pnp 00:dc: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.743501] pnp 00:dd: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.751471] pnp 00:de: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.759469] pnp 00:df: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.767485] pnp 00:e0: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.775534] pnp 00:e1: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.783537] pnp 00:e2: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.791510] pnp 00:e3: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.799513] pnp 00:e4: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.807526] pnp 00:e5: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.815538] pnp 00:e6: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.823527] pnp 00:e7: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.831591] pnp 00:e8: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.839503] pnp 00:e9: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.847475] pnp 00:ea: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.855493] pnp 00:eb: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.863537] pnp 00:ec: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.871531] pnp 00:ed: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.879499] pnp 00:ee: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.887567] pnp 00:ef: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.895517] pnp 00:f0: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.903604] pnp 00:f1: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.911572] pnp 00:f2: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.919526] pnp 00:f3: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.927566] pnp 00:f4: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.935543] pnp 00:f5: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.943442] pnp 00:f6: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.951512] pnp 00:f7: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.959701] pnp 00:f8: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.967599] pnp 00:f9: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.975596] pnp 00:fa: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.983589] pnp 00:fb: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.991591] pnp 00:fc: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   29.999588] pnp 00:fd: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.007539] pnp 00:fe: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.015566] pnp 00:ff: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.023505] pnp 00:100: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.031536] pnp 00:101: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.039525] pnp 00:102: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.047590] pnp 00:103: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.055542] pnp 00:104: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.063586] pnp 00:105: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.071591] pnp 00:106: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.079604] pnp 00:107: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.087663] pnp 00:108: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.095684] pnp 00:109: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.103622] pnp 00:10a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.111560] pnp 00:10b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.119608] pnp 00:10c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.127647] pnp 00:10d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.135621] pnp 00:10e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.143713] pnp 00:10f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.152624] pnp 00:110: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.159634] pnp 00:111: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.167628] pnp 00:112: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.175650] pnp 00:113: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.183622] pnp 00:114: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.191674] pnp 00:115: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.199683] pnp 00:116: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.207730] pnp 00:117: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.215663] pnp 00:118: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.223679] pnp 00:119: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.231658] pnp 00:11a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.239652] pnp 00:11b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.247683] pnp 00:11c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.255682] pnp 00:11d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.264384] pnp 00:11e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.271668] pnp 00:11f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.279661] pnp 00:120: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.287698] pnp 00:121: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.295703] pnp 00:122: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.303748] pnp 00:123: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.311737] pnp 00:124: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.319709] pnp 00:125: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.327729] pnp 00:126: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.335708] pnp 00:127: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.343733] pnp 00:128: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.351674] pnp 00:129: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.359626] pnp 00:12a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.367694] pnp 00:12b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.375739] pnp 00:12c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.383613] pnp 00:12d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.391741] pnp 00:12e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.399740] pnp 00:12f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.407743] pnp 00:130: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.415742] pnp 00:131: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.423738] pnp 00:132: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.431740] pnp 00:133: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.439769] pnp 00:134: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.447775] pnp 00:135: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.455753] pnp 00:136: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.463785] pnp 00:137: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.471785] pnp 00:138: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.479800] pnp 00:139: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.487759] pnp 00:13a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.495807] pnp 00:13b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.503745] pnp 00:13c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.511808] pnp 00:13d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.519765] pnp 00:13e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.527812] pnp 00:13f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.535806] pnp 00:140: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.543794] pnp 00:141: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.551761] pnp 00:142: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.559724] pnp 00:143: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.567818] pnp 00:144: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.575781] pnp 00:145: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.583771] pnp 00:146: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.591777] pnp 00:147: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.599820] pnp 00:148: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.607813] pnp 00:149: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.615807] pnp 00:14a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.623806] pnp 00:14b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.631834] pnp 00:14c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.639828] pnp 00:14d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.647837] pnp 00:14e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.655782] pnp 00:14f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.663798] pnp 00:150: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.671849] pnp 00:151: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.679834] pnp 00:152: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.687737] pnp 00:153: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.695877] pnp 00:154: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.703885] pnp 00:155: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.711857] pnp 00:156: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.719863] pnp 00:157: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.727881] pnp 00:158: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.735892] pnp 00:159: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.743846] pnp 00:15a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.751885] pnp 00:15b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.759893] pnp 00:15c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.767796] pnp 00:15d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.775934] pnp 00:15e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.783854] pnp 00:15f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.791903] pnp 00:160: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.799933] pnp 00:161: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.807921] pnp 00:162: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.815921] pnp 00:163: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.823944] pnp 00:164: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.831939] pnp 00:165: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.839906] pnp 00:166: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.847883] pnp 00:167: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.855890] pnp 00:168: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.863885] pnp 00:169: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.871869] pnp 00:16a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.879918] pnp 00:16b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.887951] pnp 00:16c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.895873] pnp 00:16d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.903899] pnp 00:16e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.911944] pnp 00:16f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.919926] pnp 00:170: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.927988] pnp 00:171: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.935966] pnp 00:172: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.943899] pnp 00:173: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.951918] pnp 00:174: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.959949] pnp 00:175: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.967957] pnp 00:176: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.975990] pnp 00:177: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.983921] pnp 00:178: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.991997] pnp 00:179: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   30.999990] pnp 00:17a: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.008080] pnp 00:17b: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.016005] pnp 00:17c: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.024005] pnp 00:17d: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.031978] pnp 00:17e: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.039988] pnp 00:17f: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.048009] pnp 00:180: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.055946] pnp 00:181: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.063977] pnp 00:182: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.071936] pnp 00:183: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.080002] pnp 00:184: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.088040] pnp 00:185: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.096003] pnp 00:186: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.104015] pnp 00:187: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.112019] pnp 00:188: Plug and Play ACPI device, IDs PNP0c80 (active)
> [   31.620118] pnp: PnP ACPI: found 393 devices
> [   31.620260] ACPI: bus type PNP unregistered
> [   31.627702] pci 0000:00:15.3: bridge window [io  0x1000-0x0fff] to [bu=
s 06] add_size 1000
> [   31.627805] pci 0000:00:15.4: bridge window [io  0x1000-0x0fff] to [bu=
s 07] add_size 1000
> [   31.627926] pci 0000:00:15.5: bridge window [io  0x1000-0x0fff] to [bu=
s 08] add_size 1000
> [   31.628027] pci 0000:00:15.6: bridge window [io  0x1000-0x0fff] to [bu=
s 09] add_size 1000
> [   31.628126] pci 0000:00:15.7: bridge window [io  0x1000-0x0fff] to [bu=
s 0a] add_size 1000
> [   31.628512] pci 0000:00:16.3: bridge window [io  0x1000-0x0fff] to [bu=
s 0e] add_size 1000
> [   31.628611] pci 0000:00:16.4: bridge window [io  0x1000-0x0fff] to [bu=
s 0f] add_size 1000
> [   31.628709] pci 0000:00:16.5: bridge window [io  0x1000-0x0fff] to [bu=
s 10] add_size 1000
> [   31.628807] pci 0000:00:16.6: bridge window [io  0x1000-0x0fff] to [bu=
s 11] add_size 1000
> [   31.628907] pci 0000:00:16.7: bridge window [io  0x1000-0x0fff] to [bu=
s 12] add_size 1000
> [   31.629293] pci 0000:00:17.3: bridge window [io  0x1000-0x0fff] to [bu=
s 16] add_size 1000
> [   31.629394] pci 0000:00:17.4: bridge window [io  0x1000-0x0fff] to [bu=
s 17] add_size 1000
> [   31.629494] pci 0000:00:17.5: bridge window [io  0x1000-0x0fff] to [bu=
s 18] add_size 1000
> [   31.629593] pci 0000:00:17.6: bridge window [io  0x1000-0x0fff] to [bu=
s 19] add_size 1000
> [   31.629691] pci 0000:00:17.7: bridge window [io  0x1000-0x0fff] to [bu=
s 1a] add_size 1000
> [   31.629987] pci 0000:00:18.2: bridge window [io  0x1000-0x0fff] to [bu=
s 1d] add_size 1000
> [   31.630086] pci 0000:00:18.3: bridge window [io  0x1000-0x0fff] to [bu=
s 1e] add_size 1000
> [   31.630186] pci 0000:00:18.4: bridge window [io  0x1000-0x0fff] to [bu=
s 1f] add_size 1000
> [   31.630285] pci 0000:00:18.5: bridge window [io  0x1000-0x0fff] to [bu=
s 20] add_size 1000
> [   31.630385] pci 0000:00:18.6: bridge window [io  0x1000-0x0fff] to [bu=
s 21] add_size 1000
> [   31.630484] pci 0000:00:18.7: bridge window [io  0x1000-0x0fff] to [bu=
s 22] add_size 1000
> [   31.630512] pci 0000:00:15.3: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630515] pci 0000:00:15.4: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630518] pci 0000:00:15.5: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630521] pci 0000:00:15.6: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630524] pci 0000:00:15.7: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630526] pci 0000:00:16.3: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630529] pci 0000:00:16.4: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630532] pci 0000:00:16.5: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630534] pci 0000:00:16.6: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630537] pci 0000:00:16.7: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630540] pci 0000:00:17.3: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630542] pci 0000:00:17.4: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630545] pci 0000:00:17.5: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630547] pci 0000:00:17.6: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630550] pci 0000:00:17.7: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630553] pci 0000:00:18.2: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630555] pci 0000:00:18.3: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630558] pci 0000:00:18.4: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630560] pci 0000:00:18.5: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630563] pci 0000:00:18.6: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630565] pci 0000:00:18.7: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
> [   31.630573] pci 0000:00:0f.0: BAR 6: assigned [mem 0xc0000000-0xc0007f=
ff pref]
> [   31.631066] pci 0000:00:10.0: BAR 6: assigned [mem 0xc0008000-0xc000bf=
ff pref]
> [   31.631330] pci 0000:00:15.3: BAR 13: can't assign io (size 0x1000)
> [   31.631470] pci 0000:00:15.4: BAR 13: can't assign io (size 0x1000)
> [   31.631606] pci 0000:00:15.5: BAR 13: can't assign io (size 0x1000)
> [   31.631742] pci 0000:00:15.6: BAR 13: can't assign io (size 0x1000)
> [   31.631882] pci 0000:00:15.7: BAR 13: can't assign io (size 0x1000)
> [   31.632046] pci 0000:00:16.3: BAR 13: can't assign io (size 0x1000)
> [   31.632186] pci 0000:00:16.4: BAR 13: can't assign io (size 0x1000)
> [   31.632322] pci 0000:00:16.5: BAR 13: can't assign io (size 0x1000)
> [   31.632458] pci 0000:00:16.6: BAR 13: can't assign io (size 0x1000)
> [   31.632607] pci 0000:00:16.7: BAR 13: can't assign io (size 0x1000)
> [   31.632743] pci 0000:00:17.3: BAR 13: can't assign io (size 0x1000)
> [   31.632878] pci 0000:00:17.4: BAR 13: can't assign io (size 0x1000)
> [   31.633013] pci 0000:00:17.5: BAR 13: can't assign io (size 0x1000)
> [   31.633149] pci 0000:00:17.6: BAR 13: can't assign io (size 0x1000)
> [   31.633285] pci 0000:00:17.7: BAR 13: can't assign io (size 0x1000)
> [   31.633428] pci 0000:00:18.2: BAR 13: can't assign io (size 0x1000)
> [   31.633563] pci 0000:00:18.3: BAR 13: can't assign io (size 0x1000)
> [   31.633699] pci 0000:00:18.4: BAR 13: can't assign io (size 0x1000)
> [   31.633834] pci 0000:00:18.5: BAR 13: can't assign io (size 0x1000)
> [   31.633969] pci 0000:00:18.6: BAR 13: can't assign io (size 0x1000)
> [   31.634104] pci 0000:00:18.7: BAR 13: can't assign io (size 0x1000)
> [   31.634335] pci 0000:00:18.7: BAR 13: can't assign io (size 0x1000)
> [   31.634472] pci 0000:00:18.6: BAR 13: can't assign io (size 0x1000)
> [   31.634607] pci 0000:00:18.5: BAR 13: can't assign io (size 0x1000)
> [   31.634743] pci 0000:00:18.4: BAR 13: can't assign io (size 0x1000)
> [   31.634879] pci 0000:00:18.3: BAR 13: can't assign io (size 0x1000)
> [   31.635014] pci 0000:00:18.2: BAR 13: can't assign io (size 0x1000)
> [   31.635149] pci 0000:00:17.7: BAR 13: can't assign io (size 0x1000)
> [   31.635284] pci 0000:00:17.6: BAR 13: can't assign io (size 0x1000)
> [   31.636084] pci 0000:00:17.5: BAR 13: can't assign io (size 0x1000)
> [   31.636222] pci 0000:00:17.4: BAR 13: can't assign io (size 0x1000)
> [   31.636358] pci 0000:00:17.3: BAR 13: can't assign io (size 0x1000)
> [   31.636494] pci 0000:00:16.7: BAR 13: can't assign io (size 0x1000)
> [   31.636655] pci 0000:00:16.6: BAR 13: can't assign io (size 0x1000)
> [   31.636810] pci 0000:00:16.5: BAR 13: can't assign io (size 0x1000)
> [   31.636966] pci 0000:00:16.4: BAR 13: can't assign io (size 0x1000)
> [   31.637122] pci 0000:00:16.3: BAR 13: can't assign io (size 0x1000)
> [   31.637277] pci 0000:00:15.7: BAR 13: can't assign io (size 0x1000)
> [   31.637433] pci 0000:00:15.6: BAR 13: can't assign io (size 0x1000)
> [   31.637576] pci 0000:00:15.5: BAR 13: can't assign io (size 0x1000)
> [   31.637711] pci 0000:00:15.4: BAR 13: can't assign io (size 0x1000)
> [   31.637846] pci 0000:00:15.3: BAR 13: can't assign io (size 0x1000)
> [   31.637984] pci 0000:00:01.0: PCI bridge to [bus 01]
> [   31.638277] pci 0000:02:01.0: BAR 6: assigned [mem 0xebb00000-0xebb03f=
ff pref]
> [   31.638450] pci 0000:00:11.0: PCI bridge to [bus 02]
> [   31.638589] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
> [   31.638770] pci 0000:00:11.0:   bridge window [mem 0xfd500000-0xfdffff=
ff]
> [   31.638944] pci 0000:00:11.0:   bridge window [mem 0xebb00000-0xebffff=
ff 64bit pref]
> [   31.639196] pci 0000:03:00.0: BAR 6: assigned [mem 0xeba00000-0xeba0ff=
ff pref]
> [   31.639368] pci 0000:00:15.0: PCI bridge to [bus 03]
> [   31.639505] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
> [   31.639687] pci 0000:00:15.0:   bridge window [mem 0xfd400000-0xfd4fff=
ff]
> [   31.639860] pci 0000:00:15.0:   bridge window [mem 0xeba00000-0xebafff=
ff 64bit pref]
> [   31.640199] pci 0000:00:15.1: PCI bridge to [bus 04]
> [   31.640343] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
> [   31.640524] pci 0000:00:15.1:   bridge window [mem 0xfd000000-0xfd0fff=
ff]
> [   31.640697] pci 0000:00:15.1:   bridge window [mem 0xeb600000-0xeb6fff=
ff 64bit pref]
> [   31.640954] pci 0000:00:15.2: PCI bridge to [bus 05]
> [   31.641091] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
> [   31.641300] pci 0000:00:15.2:   bridge window [mem 0xfcc00000-0xfccfff=
ff]
> [   31.641475] pci 0000:00:15.2:   bridge window [mem 0xeb200000-0xeb2fff=
ff 64bit pref]
> [   31.641734] pci 0000:00:15.3: PCI bridge to [bus 06]
> [   31.641903] pci 0000:00:15.3:   bridge window [mem 0xfc800000-0xfc8fff=
ff]
> [   31.642084] pci 0000:00:15.3:   bridge window [mem 0xeae00000-0xeaefff=
ff 64bit pref]
> [   31.642347] pci 0000:00:15.4: PCI bridge to [bus 07]
> [   31.642517] pci 0000:00:15.4:   bridge window [mem 0xfc400000-0xfc4fff=
ff]
> [   31.642691] pci 0000:00:15.4:   bridge window [mem 0xeaa00000-0xeaafff=
ff 64bit pref]
> [   31.642949] pci 0000:00:15.5: PCI bridge to [bus 08]
> [   31.643117] pci 0000:00:15.5:   bridge window [mem 0xfc000000-0xfc0fff=
ff]
> [   31.643291] pci 0000:00:15.5:   bridge window [mem 0xea600000-0xea6fff=
ff 64bit pref]
> [   31.643548] pci 0000:00:15.6: PCI bridge to [bus 09]
> [   31.643716] pci 0000:00:15.6:   bridge window [mem 0xfbc00000-0xfbcfff=
ff]
> [   31.643891] pci 0000:00:15.6:   bridge window [mem 0xea200000-0xea2fff=
ff 64bit pref]
> [   31.644172] pci 0000:00:15.7: PCI bridge to [bus 0a]
> [   31.644343] pci 0000:00:15.7:   bridge window [mem 0xfb800000-0xfb8fff=
ff]
> [   31.644517] pci 0000:00:15.7:   bridge window [mem 0xe9e00000-0xe9efff=
ff 64bit pref]
> [   31.644771] pci 0000:00:16.0: PCI bridge to [bus 0b]
> [   31.644908] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
> [   31.645089] pci 0000:00:16.0:   bridge window [mem 0xfd300000-0xfd3fff=
ff]
> [   31.645263] pci 0000:00:16.0:   bridge window [mem 0xeb900000-0xeb9fff=
ff 64bit pref]
> [   31.645531] pci 0000:00:16.1: PCI bridge to [bus 0c]
> [   31.645668] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
> [   31.645848] pci 0000:00:16.1:   bridge window [mem 0xfcf00000-0xfcffff=
ff]
> [   31.646022] pci 0000:00:16.1:   bridge window [mem 0xeb500000-0xeb5fff=
ff 64bit pref]
> [   31.646279] pci 0000:00:16.2: PCI bridge to [bus 0d]
> [   31.646417] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
> [   31.646597] pci 0000:00:16.2:   bridge window [mem 0xfcb00000-0xfcbfff=
ff]
> [   31.646771] pci 0000:00:16.2:   bridge window [mem 0xeb100000-0xeb1fff=
ff 64bit pref]
> [   31.647025] pci 0000:00:16.3: PCI bridge to [bus 0e]
> [   31.647193] pci 0000:00:16.3:   bridge window [mem 0xfc700000-0xfc7fff=
ff]
> [   31.647368] pci 0000:00:16.3:   bridge window [mem 0xead00000-0xeadfff=
ff 64bit pref]
> [   31.647623] pci 0000:00:16.4: PCI bridge to [bus 0f]
> [   31.647792] pci 0000:00:16.4:   bridge window [mem 0xfc300000-0xfc3fff=
ff]
> [   31.647984] pci 0000:00:16.4:   bridge window [mem 0xea900000-0xea9fff=
ff 64bit pref]
> [   31.648241] pci 0000:00:16.5: PCI bridge to [bus 10]
> [   31.648412] pci 0000:00:16.5:   bridge window [mem 0xfbf00000-0xfbffff=
ff]
> [   31.648586] pci 0000:00:16.5:   bridge window [mem 0xea500000-0xea5fff=
ff 64bit pref]
> [   31.648840] pci 0000:00:16.6: PCI bridge to [bus 11]
> [   31.649008] pci 0000:00:16.6:   bridge window [mem 0xfbb00000-0xfbbfff=
ff]
> [   31.649186] pci 0000:00:16.6:   bridge window [mem 0xea100000-0xea1fff=
ff 64bit pref]
> [   31.649444] pci 0000:00:16.7: PCI bridge to [bus 12]
> [   31.649613] pci 0000:00:16.7:   bridge window [mem 0xfb700000-0xfb7fff=
ff]
> [   31.649786] pci 0000:00:16.7:   bridge window [mem 0xe9d00000-0xe9dfff=
ff 64bit pref]
> [   31.650044] pci 0000:00:17.0: PCI bridge to [bus 13]
> [   31.650180] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
> [   31.650362] pci 0000:00:17.0:   bridge window [mem 0xfd200000-0xfd2fff=
ff]
> [   31.650536] pci 0000:00:17.0:   bridge window [mem 0xeb800000-0xeb8fff=
ff 64bit pref]
> [   31.650790] pci 0000:00:17.1: PCI bridge to [bus 14]
> [   31.650928] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
> [   31.651128] pci 0000:00:17.1:   bridge window [mem 0xfce00000-0xfcefff=
ff]
> [   31.651324] pci 0000:00:17.1:   bridge window [mem 0xeb400000-0xeb4fff=
ff 64bit pref]
> [   31.651616] pci 0000:00:17.2: PCI bridge to [bus 15]
> [   31.651773] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
> [   31.651989] pci 0000:00:17.2:   bridge window [mem 0xfca00000-0xfcafff=
ff]
> [   31.652163] pci 0000:00:17.2:   bridge window [mem 0xeb000000-0xeb0fff=
ff 64bit pref]
> [   31.652420] pci 0000:00:17.3: PCI bridge to [bus 16]
> [   31.652589] pci 0000:00:17.3:   bridge window [mem 0xfc600000-0xfc6fff=
ff]
> [   31.652762] pci 0000:00:17.3:   bridge window [mem 0xeac00000-0xeacfff=
ff 64bit pref]
> [   31.653021] pci 0000:00:17.4: PCI bridge to [bus 17]
> [   31.653190] pci 0000:00:17.4:   bridge window [mem 0xfc200000-0xfc2fff=
ff]
> [   31.653364] pci 0000:00:17.4:   bridge window [mem 0xea800000-0xea8fff=
ff 64bit pref]
> [   31.653618] pci 0000:00:17.5: PCI bridge to [bus 18]
> [   31.653785] pci 0000:00:17.5:   bridge window [mem 0xfbe00000-0xfbefff=
ff]
> [   31.653958] pci 0000:00:17.5:   bridge window [mem 0xea400000-0xea4fff=
ff 64bit pref]
> [   31.654211] pci 0000:00:17.6: PCI bridge to [bus 19]
> [   31.654380] pci 0000:00:17.6:   bridge window [mem 0xfba00000-0xfbafff=
ff]
> [   31.654553] pci 0000:00:17.6:   bridge window [mem 0xea000000-0xea0fff=
ff 64bit pref]
> [   31.654806] pci 0000:00:17.7: PCI bridge to [bus 1a]
> [   31.654974] pci 0000:00:17.7:   bridge window [mem 0xfb600000-0xfb6fff=
ff]
> [   31.655148] pci 0000:00:17.7:   bridge window [mem 0xe9c00000-0xe9cfff=
ff 64bit pref]
> [   31.655411] pci 0000:00:18.0: PCI bridge to [bus 1b]
> [   31.655548] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
> [   31.655729] pci 0000:00:18.0:   bridge window [mem 0xfd100000-0xfd1fff=
ff]
> [   31.655903] pci 0000:00:18.0:   bridge window [mem 0xeb700000-0xeb7fff=
ff 64bit pref]
> [   31.656179] pci 0000:00:18.1: PCI bridge to [bus 1c]
> [   31.656317] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
> [   31.656497] pci 0000:00:18.1:   bridge window [mem 0xfcd00000-0xfcdfff=
ff]
> [   31.656670] pci 0000:00:18.1:   bridge window [mem 0xeb300000-0xeb3fff=
ff 64bit pref]
> [   31.656923] pci 0000:00:18.2: PCI bridge to [bus 1d]
> [   31.657091] pci 0000:00:18.2:   bridge window [mem 0xfc900000-0xfc9fff=
ff]
> [   31.657265] pci 0000:00:18.2:   bridge window [mem 0xeaf00000-0xeaffff=
ff 64bit pref]
> [   31.657520] pci 0000:00:18.3: PCI bridge to [bus 1e]
> [   31.657689] pci 0000:00:18.3:   bridge window [mem 0xfc500000-0xfc5fff=
ff]
> [   31.657862] pci 0000:00:18.3:   bridge window [mem 0xeab00000-0xeabfff=
ff 64bit pref]
> [   31.658121] pci 0000:00:18.4: PCI bridge to [bus 1f]
> [   31.658289] pci 0000:00:18.4:   bridge window [mem 0xfc100000-0xfc1fff=
ff]
> [   31.658462] pci 0000:00:18.4:   bridge window [mem 0xea700000-0xea7fff=
ff 64bit pref]
> [   31.658715] pci 0000:00:18.5: PCI bridge to [bus 20]
> [   31.658884] pci 0000:00:18.5:   bridge window [mem 0xfbd00000-0xfbdfff=
ff]
> [   31.659058] pci 0000:00:18.5:   bridge window [mem 0xea300000-0xea3fff=
ff 64bit pref]
> [   31.659316] pci 0000:00:18.6: PCI bridge to [bus 21]
> [   31.659486] pci 0000:00:18.6:   bridge window [mem 0xfb900000-0xfb9fff=
ff]
> [   31.659659] pci 0000:00:18.6:   bridge window [mem 0xe9f00000-0xe9ffff=
ff 64bit pref]
> [   31.659913] pci 0000:00:18.7: PCI bridge to [bus 22]
> [   31.660101] pci 0000:00:18.7:   bridge window [mem 0xfb500000-0xfb5fff=
ff]
> [   31.660275] pci 0000:00:18.7:   bridge window [mem 0xe9b00000-0xe9bfff=
ff 64bit pref]
> [   31.660604] pci 0000:00:01.0: setting latency timer to 64
> [   31.662725] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
> [   31.662728] pci_bus 0000:00: resource 5 [mem 0x000d0000-0x000d3fff]
> [   31.662731] pci_bus 0000:00: resource 6 [mem 0x000d4000-0x000d7fff]
> [   31.662734] pci_bus 0000:00: resource 7 [mem 0x000d8000-0x000dbfff]
> [   31.662736] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xfebfffff]
> [   31.662739] pci_bus 0000:00: resource 9 [io  0x0000-0x0cf7]
> [   31.662742] pci_bus 0000:00: resource 10 [io  0x0d00-0xfeff]
> [   31.662745] pci_bus 0000:02: resource 0 [io  0x2000-0x3fff]
> [   31.662748] pci_bus 0000:02: resource 1 [mem 0xfd500000-0xfdffffff]
> [   31.662751] pci_bus 0000:02: resource 2 [mem 0xebb00000-0xebffffff 64b=
it pref]
> [   31.662753] pci_bus 0000:02: resource 4 [mem 0x000a0000-0x000bffff]
> [   31.662756] pci_bus 0000:02: resource 5 [mem 0x000d0000-0x000d3fff]
> [   31.662758] pci_bus 0000:02: resource 6 [mem 0x000d4000-0x000d7fff]
> [   31.662761] pci_bus 0000:02: resource 7 [mem 0x000d8000-0x000dbfff]
> [   31.662763] pci_bus 0000:02: resource 8 [mem 0xc0000000-0xfebfffff]
> [   31.662766] pci_bus 0000:02: resource 9 [io  0x0000-0x0cf7]
> [   31.662768] pci_bus 0000:02: resource 10 [io  0x0d00-0xfeff]
> [   31.662771] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
> [   31.662774] pci_bus 0000:03: resource 1 [mem 0xfd400000-0xfd4fffff]
> [   31.662776] pci_bus 0000:03: resource 2 [mem 0xeba00000-0xebafffff 64b=
it pref]
> [   31.662779] pci_bus 0000:04: resource 0 [io  0x8000-0x8fff]
> [   31.662782] pci_bus 0000:04: resource 1 [mem 0xfd000000-0xfd0fffff]
> [   31.662784] pci_bus 0000:04: resource 2 [mem 0xeb600000-0xeb6fffff 64b=
it pref]
> [   31.662787] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
> [   31.662789] pci_bus 0000:05: resource 1 [mem 0xfcc00000-0xfccfffff]
> [   31.662792] pci_bus 0000:05: resource 2 [mem 0xeb200000-0xeb2fffff 64b=
it pref]
> [   31.662795] pci_bus 0000:06: resource 1 [mem 0xfc800000-0xfc8fffff]
> [   31.662797] pci_bus 0000:06: resource 2 [mem 0xeae00000-0xeaefffff 64b=
it pref]
> [   31.662800] pci_bus 0000:07: resource 1 [mem 0xfc400000-0xfc4fffff]
> [   31.662803] pci_bus 0000:07: resource 2 [mem 0xeaa00000-0xeaafffff 64b=
it pref]
> [   31.662805] pci_bus 0000:08: resource 1 [mem 0xfc000000-0xfc0fffff]
> [   31.662808] pci_bus 0000:08: resource 2 [mem 0xea600000-0xea6fffff 64b=
it pref]
> [   31.662811] pci_bus 0000:09: resource 1 [mem 0xfbc00000-0xfbcfffff]
> [   31.662814] pci_bus 0000:09: resource 2 [mem 0xea200000-0xea2fffff 64b=
it pref]
> [   31.662816] pci_bus 0000:0a: resource 1 [mem 0xfb800000-0xfb8fffff]
> [   31.662819] pci_bus 0000:0a: resource 2 [mem 0xe9e00000-0xe9efffff 64b=
it pref]
> [   31.662821] pci_bus 0000:0b: resource 0 [io  0x5000-0x5fff]
> [   31.662824] pci_bus 0000:0b: resource 1 [mem 0xfd300000-0xfd3fffff]
> [   31.662826] pci_bus 0000:0b: resource 2 [mem 0xeb900000-0xeb9fffff 64b=
it pref]
> [   31.662829] pci_bus 0000:0c: resource 0 [io  0x9000-0x9fff]
> [   31.662832] pci_bus 0000:0c: resource 1 [mem 0xfcf00000-0xfcffffff]
> [   31.662834] pci_bus 0000:0c: resource 2 [mem 0xeb500000-0xeb5fffff 64b=
it pref]
> [   31.662837] pci_bus 0000:0d: resource 0 [io  0xd000-0xdfff]
> [   31.662839] pci_bus 0000:0d: resource 1 [mem 0xfcb00000-0xfcbfffff]
> [   31.662842] pci_bus 0000:0d: resource 2 [mem 0xeb100000-0xeb1fffff 64b=
it pref]
> [   31.662845] pci_bus 0000:0e: resource 1 [mem 0xfc700000-0xfc7fffff]
> [   31.662847] pci_bus 0000:0e: resource 2 [mem 0xead00000-0xeadfffff 64b=
it pref]
> [   31.662850] pci_bus 0000:0f: resource 1 [mem 0xfc300000-0xfc3fffff]
> [   31.662853] pci_bus 0000:0f: resource 2 [mem 0xea900000-0xea9fffff 64b=
it pref]
> [   31.662856] pci_bus 0000:10: resource 1 [mem 0xfbf00000-0xfbffffff]
> [   31.662858] pci_bus 0000:10: resource 2 [mem 0xea500000-0xea5fffff 64b=
it pref]
> [   31.662861] pci_bus 0000:11: resource 1 [mem 0xfbb00000-0xfbbfffff]
> [   31.662864] pci_bus 0000:11: resource 2 [mem 0xea100000-0xea1fffff 64b=
it pref]
> [   31.662866] pci_bus 0000:12: resource 1 [mem 0xfb700000-0xfb7fffff]
> [   31.662869] pci_bus 0000:12: resource 2 [mem 0xe9d00000-0xe9dfffff 64b=
it pref]
> [   31.662872] pci_bus 0000:13: resource 0 [io  0x6000-0x6fff]
> [   31.662874] pci_bus 0000:13: resource 1 [mem 0xfd200000-0xfd2fffff]
> [   31.662877] pci_bus 0000:13: resource 2 [mem 0xeb800000-0xeb8fffff 64b=
it pref]
> [   31.662879] pci_bus 0000:14: resource 0 [io  0xa000-0xafff]
> [   31.662882] pci_bus 0000:14: resource 1 [mem 0xfce00000-0xfcefffff]
> [   31.662884] pci_bus 0000:14: resource 2 [mem 0xeb400000-0xeb4fffff 64b=
it pref]
> [   31.662887] pci_bus 0000:15: resource 0 [io  0xe000-0xefff]
> [   31.662889] pci_bus 0000:15: resource 1 [mem 0xfca00000-0xfcafffff]
> [   31.662892] pci_bus 0000:15: resource 2 [mem 0xeb000000-0xeb0fffff 64b=
it pref]
> [   31.662895] pci_bus 0000:16: resource 1 [mem 0xfc600000-0xfc6fffff]
> [   31.662897] pci_bus 0000:16: resource 2 [mem 0xeac00000-0xeacfffff 64b=
it pref]
> [   31.662900] pci_bus 0000:17: resource 1 [mem 0xfc200000-0xfc2fffff]
> [   31.662903] pci_bus 0000:17: resource 2 [mem 0xea800000-0xea8fffff 64b=
it pref]
> [   31.662905] pci_bus 0000:18: resource 1 [mem 0xfbe00000-0xfbefffff]
> [   31.662908] pci_bus 0000:18: resource 2 [mem 0xea400000-0xea4fffff 64b=
it pref]
> [   31.662911] pci_bus 0000:19: resource 1 [mem 0xfba00000-0xfbafffff]
> [   31.662913] pci_bus 0000:19: resource 2 [mem 0xea000000-0xea0fffff 64b=
it pref]
> [   31.662916] pci_bus 0000:1a: resource 1 [mem 0xfb600000-0xfb6fffff]
> [   31.662919] pci_bus 0000:1a: resource 2 [mem 0xe9c00000-0xe9cfffff 64b=
it pref]
> [   31.662921] pci_bus 0000:1b: resource 0 [io  0x7000-0x7fff]
> [   31.662924] pci_bus 0000:1b: resource 1 [mem 0xfd100000-0xfd1fffff]
> [   31.662926] pci_bus 0000:1b: resource 2 [mem 0xeb700000-0xeb7fffff 64b=
it pref]
> [   31.662929] pci_bus 0000:1c: resource 0 [io  0xb000-0xbfff]
> [   31.662931] pci_bus 0000:1c: resource 1 [mem 0xfcd00000-0xfcdfffff]
> [   31.662934] pci_bus 0000:1c: resource 2 [mem 0xeb300000-0xeb3fffff 64b=
it pref]
> [   31.662937] pci_bus 0000:1d: resource 1 [mem 0xfc900000-0xfc9fffff]
> [   31.662940] pci_bus 0000:1d: resource 2 [mem 0xeaf00000-0xeaffffff 64b=
it pref]
> [   31.662943] pci_bus 0000:1e: resource 1 [mem 0xfc500000-0xfc5fffff]
> [   31.662945] pci_bus 0000:1e: resource 2 [mem 0xeab00000-0xeabfffff 64b=
it pref]
> [   31.662948] pci_bus 0000:1f: resource 1 [mem 0xfc100000-0xfc1fffff]
> [   31.662951] pci_bus 0000:1f: resource 2 [mem 0xea700000-0xea7fffff 64b=
it pref]
> [   31.662954] pci_bus 0000:20: resource 1 [mem 0xfbd00000-0xfbdfffff]
> [   31.662957] pci_bus 0000:20: resource 2 [mem 0xea300000-0xea3fffff 64b=
it pref]
> [   31.662959] pci_bus 0000:21: resource 1 [mem 0xfb900000-0xfb9fffff]
> [   31.662962] pci_bus 0000:21: resource 2 [mem 0xe9f00000-0xe9ffffff 64b=
it pref]
> [   31.662965] pci_bus 0000:22: resource 1 [mem 0xfb500000-0xfb5fffff]
> [   31.662967] pci_bus 0000:22: resource 2 [mem 0xe9b00000-0xe9bfffff 64b=
it pref]
> [   31.663092] NET: Registered protocol family 2
> [   31.664275] TCP established hash table entries: 262144 (order: 10, 419=
4304 bytes)
> [   31.667409] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
> [   31.667771] TCP: Hash tables configured (established 262144 bind 65536)
> [   31.668931] TCP: reno registered
> [   31.669117] UDP hash table entries: 16384 (order: 7, 524288 bytes)
> [   31.669425] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
> [   31.670895] NET: Registered protocol family 1
> [   31.671025] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [   31.671299] pci 0000:00:0f.0: Boot video device
> [   31.674503] PCI: CLS 32 bytes, default 64
> [   31.674611] Trying to unpack rootfs image as initramfs...
> [   32.225993] Freeing initrd memory: 17592K (ffff880035d94000 - ffff8800=
36ec2000)
> [   32.226197] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [   32.226337] software IO TLB [mem 0xbbee0000-0xbfee0000] (64MB) mapped =
at [ffff8800bbee0000-ffff8800bfedffff]
> [   32.226896] Simple Boot Flag at 0x36 set to 0x80
> [   32.230884] Switched to clocksource tsc
> [   32.234089] Scanning for low memory corruption every 60 seconds
> [   32.235859] Initialise module verification
> [   32.236086] audit: initializing netlink socket (disabled)
> [   32.236274] type=3D2000 audit(1422542753.954:1): initialized
> [   32.280116] bounce pool size: 64 pages
> [   32.280221] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [   32.282659] zbud: loaded
> [   32.282882] VFS: Disk quotas dquot_6.5.2
> [   32.283037] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [   32.284009] fuse init (API version 7.22)
> [   32.284192] msgmni has been set to 32768
> [   32.285865] Key type asymmetric registered
> [   32.285937] Asymmetric key parser 'x509' registered
> [   32.286047] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 252)
> [   32.286471] io scheduler noop registered
> [   32.286536] io scheduler deadline registered (default)
> [   32.286653] io scheduler cfq registered
> [   32.287100] pcieport 0000:00:15.0: irq 40 for MSI/MSI-X
> [   32.287689] pcieport 0000:00:15.1: irq 41 for MSI/MSI-X
> [   32.288309] pcieport 0000:00:15.2: irq 42 for MSI/MSI-X
> [   32.288880] pcieport 0000:00:15.3: irq 43 for MSI/MSI-X
> [   32.289448] pcieport 0000:00:15.4: irq 44 for MSI/MSI-X
> [   32.290011] pcieport 0000:00:15.5: irq 45 for MSI/MSI-X
> [   32.290587] pcieport 0000:00:15.6: irq 46 for MSI/MSI-X
> [   32.291138] pcieport 0000:00:15.7: irq 47 for MSI/MSI-X
> [   32.291690] pcieport 0000:00:16.0: irq 48 for MSI/MSI-X
> [   32.292251] pcieport 0000:00:16.1: irq 49 for MSI/MSI-X
> [   32.292812] pcieport 0000:00:16.2: irq 50 for MSI/MSI-X
> [   32.293387] pcieport 0000:00:16.3: irq 51 for MSI/MSI-X
> [   32.293936] pcieport 0000:00:16.4: irq 52 for MSI/MSI-X
> [   32.294490] pcieport 0000:00:16.5: irq 53 for MSI/MSI-X
> [   32.295045] pcieport 0000:00:16.6: irq 54 for MSI/MSI-X
> [   32.295601] pcieport 0000:00:16.7: irq 55 for MSI/MSI-X
> [   32.296150] pcieport 0000:00:17.0: irq 56 for MSI/MSI-X
> [   32.296727] pcieport 0000:00:17.1: irq 57 for MSI/MSI-X
> [   32.297279] pcieport 0000:00:17.2: irq 58 for MSI/MSI-X
> [   32.297843] pcieport 0000:00:17.3: irq 59 for MSI/MSI-X
> [   32.298397] pcieport 0000:00:17.4: irq 60 for MSI/MSI-X
> [   32.298940] pcieport 0000:00:17.5: irq 61 for MSI/MSI-X
> [   32.299497] pcieport 0000:00:17.6: irq 62 for MSI/MSI-X
> [   32.300050] pcieport 0000:00:17.7: irq 63 for MSI/MSI-X
> [   32.300642] pcieport 0000:00:18.0: irq 64 for MSI/MSI-X
> [   32.301199] pcieport 0000:00:18.1: irq 65 for MSI/MSI-X
> [   32.301748] pcieport 0000:00:18.2: irq 66 for MSI/MSI-X
> [   32.302315] pcieport 0000:00:18.3: irq 67 for MSI/MSI-X
> [   32.302863] pcieport 0000:00:18.4: irq 68 for MSI/MSI-X
> [   32.303420] pcieport 0000:00:18.5: irq 69 for MSI/MSI-X
> [   32.303956] pcieport 0000:00:18.6: irq 70 for MSI/MSI-X
> [   32.304527] pcieport 0000:00:18.7: irq 71 for MSI/MSI-X
> [   32.305015] pcieport 0000:00:15.0: Signaling PME through PCIe PME inte=
rrupt
> [   32.305112] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
> [   32.305215] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme load=
ed
> [   32.305324] pcieport 0000:00:15.1: Signaling PME through PCIe PME inte=
rrupt
> [   32.305433] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme load=
ed
> [   32.305535] pcieport 0000:00:15.2: Signaling PME through PCIe PME inte=
rrupt
> [   32.305641] pcie_pme 0000:00:15.2:pcie01: service driver pcie_pme load=
ed
> [   32.305741] pcieport 0000:00:15.3: Signaling PME through PCIe PME inte=
rrupt
> [   32.305843] pcie_pme 0000:00:15.3:pcie01: service driver pcie_pme load=
ed
> [   32.305943] pcieport 0000:00:15.4: Signaling PME through PCIe PME inte=
rrupt
> [   32.306050] pcie_pme 0000:00:15.4:pcie01: service driver pcie_pme load=
ed
> [   32.306156] pcieport 0000:00:15.5: Signaling PME through PCIe PME inte=
rrupt
> [   32.306258] pcie_pme 0000:00:15.5:pcie01: service driver pcie_pme load=
ed
> [   32.306367] pcieport 0000:00:15.6: Signaling PME through PCIe PME inte=
rrupt
> [   32.306469] pcie_pme 0000:00:15.6:pcie01: service driver pcie_pme load=
ed
> [   32.306577] pcieport 0000:00:15.7: Signaling PME through PCIe PME inte=
rrupt
> [   32.306678] pcie_pme 0000:00:15.7:pcie01: service driver pcie_pme load=
ed
> [   32.306788] pcieport 0000:00:16.0: Signaling PME through PCIe PME inte=
rrupt
> [   32.306891] pcie_pme 0000:00:16.0:pcie01: service driver pcie_pme load=
ed
> [   32.306992] pcieport 0000:00:16.1: Signaling PME through PCIe PME inte=
rrupt
> [   32.307104] pcie_pme 0000:00:16.1:pcie01: service driver pcie_pme load=
ed
> [   32.307206] pcieport 0000:00:16.2: Signaling PME through PCIe PME inte=
rrupt
> [   32.307309] pcie_pme 0000:00:16.2:pcie01: service driver pcie_pme load=
ed
> [   32.307418] pcieport 0000:00:16.3: Signaling PME through PCIe PME inte=
rrupt
> [   32.307524] pcie_pme 0000:00:16.3:pcie01: service driver pcie_pme load=
ed
> [   32.307626] pcieport 0000:00:16.4: Signaling PME through PCIe PME inte=
rrupt
> [   32.307727] pcie_pme 0000:00:16.4:pcie01: service driver pcie_pme load=
ed
> [   32.307827] pcieport 0000:00:16.5: Signaling PME through PCIe PME inte=
rrupt
> [   32.307929] pcie_pme 0000:00:16.5:pcie01: service driver pcie_pme load=
ed
> [   32.308029] pcieport 0000:00:16.6: Signaling PME through PCIe PME inte=
rrupt
> [   32.308139] pcie_pme 0000:00:16.6:pcie01: service driver pcie_pme load=
ed
> [   32.308252] pcieport 0000:00:16.7: Signaling PME through PCIe PME inte=
rrupt
> [   32.308369] pcie_pme 0000:00:16.7:pcie01: service driver pcie_pme load=
ed
> [   32.308483] pcieport 0000:00:17.0: Signaling PME through PCIe PME inte=
rrupt
> [   32.308587] pcie_pme 0000:00:17.0:pcie01: service driver pcie_pme load=
ed
> [   32.308693] pcieport 0000:00:17.1: Signaling PME through PCIe PME inte=
rrupt
> [   32.308794] pcie_pme 0000:00:17.1:pcie01: service driver pcie_pme load=
ed
> [   32.308895] pcieport 0000:00:17.2: Signaling PME through PCIe PME inte=
rrupt
> [   32.308996] pcie_pme 0000:00:17.2:pcie01: service driver pcie_pme load=
ed
> [   32.309103] pcieport 0000:00:17.3: Signaling PME through PCIe PME inte=
rrupt
> [   32.309207] pcie_pme 0000:00:17.3:pcie01: service driver pcie_pme load=
ed
> [   32.309311] pcieport 0000:00:17.4: Signaling PME through PCIe PME inte=
rrupt
> [   32.309425] pcie_pme 0000:00:17.4:pcie01: service driver pcie_pme load=
ed
> [   32.309528] pcieport 0000:00:17.5: Signaling PME through PCIe PME inte=
rrupt
> [   32.309631] pcie_pme 0000:00:17.5:pcie01: service driver pcie_pme load=
ed
> [   32.309731] pcieport 0000:00:17.6: Signaling PME through PCIe PME inte=
rrupt
> [   32.309833] pcie_pme 0000:00:17.6:pcie01: service driver pcie_pme load=
ed
> [   32.309932] pcieport 0000:00:17.7: Signaling PME through PCIe PME inte=
rrupt
> [   32.310034] pcie_pme 0000:00:17.7:pcie01: service driver pcie_pme load=
ed
> [   32.310142] pcieport 0000:00:18.0: Signaling PME through PCIe PME inte=
rrupt
> [   32.310245] pcie_pme 0000:00:18.0:pcie01: service driver pcie_pme load=
ed
> [   32.310362] pcieport 0000:00:18.1: Signaling PME through PCIe PME inte=
rrupt
> [   32.310482] pcie_pme 0000:00:18.1:pcie01: service driver pcie_pme load=
ed
> [   32.310585] pcieport 0000:00:18.2: Signaling PME through PCIe PME inte=
rrupt
> [   32.310691] pcie_pme 0000:00:18.2:pcie01: service driver pcie_pme load=
ed
> [   32.310792] pcieport 0000:00:18.3: Signaling PME through PCIe PME inte=
rrupt
> [   32.310894] pcie_pme 0000:00:18.3:pcie01: service driver pcie_pme load=
ed
> [   32.310994] pcieport 0000:00:18.4: Signaling PME through PCIe PME inte=
rrupt
> [   32.311102] pcie_pme 0000:00:18.4:pcie01: service driver pcie_pme load=
ed
> [   32.311205] pcieport 0000:00:18.5: Signaling PME through PCIe PME inte=
rrupt
> [   32.311309] pcie_pme 0000:00:18.5:pcie01: service driver pcie_pme load=
ed
> [   32.311418] pcieport 0000:00:18.6: Signaling PME through PCIe PME inte=
rrupt
> [   32.311521] pcie_pme 0000:00:18.6:pcie01: service driver pcie_pme load=
ed
> [   32.311623] pcieport 0000:00:18.7: Signaling PME through PCIe PME inte=
rrupt
> [   32.311724] pcie_pme 0000:00:18.7:pcie01: service driver pcie_pme load=
ed
> [   32.311749] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [   32.312279] pciehp 0000:00:15.0:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.312753] pciehp 0000:00:15.0:pcie04: service driver pciehp loaded
> [   32.312814] pciehp 0000:00:15.1:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.313195] pciehp 0000:00:15.1:pcie04: service driver pciehp loaded
> [   32.313256] pciehp 0000:00:15.2:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.313636] pciehp 0000:00:15.2:pcie04: service driver pciehp loaded
> [   32.313696] pciehp 0000:00:15.3:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.314085] pciehp 0000:00:15.3:pcie04: service driver pciehp loaded
> [   32.314153] pciehp 0000:00:15.4:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.314563] pciehp 0000:00:15.4:pcie04: service driver pciehp loaded
> [   32.314636] pciehp 0000:00:15.5:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.315004] pciehp 0000:00:15.5:pcie04: service driver pciehp loaded
> [   32.315065] pciehp 0000:00:15.6:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.315446] pciehp 0000:00:15.6:pcie04: service driver pciehp loaded
> [   32.315507] pciehp 0000:00:15.7:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.315879] pciehp 0000:00:15.7:pcie04: service driver pciehp loaded
> [   32.315940] pciehp 0000:00:16.0:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.316318] pciehp 0000:00:16.0:pcie04: service driver pciehp loaded
> [   32.316386] pciehp 0000:00:16.1:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.316741] pciehp 0000:00:16.1:pcie04: service driver pciehp loaded
> [   32.316801] pciehp 0000:00:16.2:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.317162] pciehp 0000:00:16.2:pcie04: service driver pciehp loaded
> [   32.317226] pciehp 0000:00:16.3:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.317619] pciehp 0000:00:16.3:pcie04: service driver pciehp loaded
> [   32.317680] pciehp 0000:00:16.4:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.318050] pciehp 0000:00:16.4:pcie04: service driver pciehp loaded
> [   32.318110] pciehp 0000:00:16.5:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.318504] pciehp 0000:00:16.5:pcie04: service driver pciehp loaded
> [   32.318565] pciehp 0000:00:16.6:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.318914] pciehp 0000:00:16.6:pcie04: service driver pciehp loaded
> [   32.318974] pciehp 0000:00:16.7:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.319339] pciehp 0000:00:16.7:pcie04: service driver pciehp loaded
> [   32.319400] pciehp 0000:00:17.0:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.319747] pciehp 0000:00:17.0:pcie04: service driver pciehp loaded
> [   32.319807] pciehp 0000:00:17.1:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.320152] pciehp 0000:00:17.1:pcie04: service driver pciehp loaded
> [   32.320232] pciehp 0000:00:17.2:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.320609] pciehp 0000:00:17.2:pcie04: service driver pciehp loaded
> [   32.320669] pciehp 0000:00:17.3:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.321024] pciehp 0000:00:17.3:pcie04: service driver pciehp loaded
> [   32.321084] pciehp 0000:00:17.4:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.321445] pciehp 0000:00:17.4:pcie04: service driver pciehp loaded
> [   32.321510] pciehp 0000:00:17.5:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.321864] pciehp 0000:00:17.5:pcie04: service driver pciehp loaded
> [   32.321924] pciehp 0000:00:17.6:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.322279] pciehp 0000:00:17.6:pcie04: service driver pciehp loaded
> [   32.322346] pciehp 0000:00:17.7:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.322701] pciehp 0000:00:17.7:pcie04: service driver pciehp loaded
> [   32.322761] pciehp 0000:00:18.0:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.323101] pciehp 0000:00:18.0:pcie04: service driver pciehp loaded
> [   32.323160] pciehp 0000:00:18.1:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.323578] pciehp 0000:00:18.1:pcie04: service driver pciehp loaded
> [   32.323639] pciehp 0000:00:18.2:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.323981] pciehp 0000:00:18.2:pcie04: service driver pciehp loaded
> [   32.324040] pciehp 0000:00:18.3:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.324427] pciehp 0000:00:18.3:pcie04: service driver pciehp loaded
> [   32.324493] pciehp 0000:00:18.4:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.324845] pciehp 0000:00:18.4:pcie04: service driver pciehp loaded
> [   32.324905] pciehp 0000:00:18.5:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.325266] pciehp 0000:00:18.5:pcie04: service driver pciehp loaded
> [   32.325334] pciehp 0000:00:18.6:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.325691] pciehp 0000:00:18.6:pcie04: service driver pciehp loaded
> [   32.325751] pciehp 0000:00:18.7:pcie04: HPC vendor_id 15ad device_id 7=
a0 ss_vid 15ad ss_did 7a0
> [   32.326090] pciehp 0000:00:18.7:pcie04: service driver pciehp loaded
> [   32.326096] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [   32.326247] intel_idle: does not run on family 6 model 45
> [   32.326483] ACPI: AC Adapter [ACAD] (on-line)
> [   32.326873] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
> [   32.326979] ACPI: Power Button [PWRF]
> [   32.337503] GHES: HEST is not enabled!
> [   32.338074] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [   32.366133] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
> [   32.393946] 00:0a: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
> [   32.399228] Linux agpgart interface v0.103
> [   32.399593] agpgart-intel 0000:00:00.0: Intel 440BX Chipset
> [   32.402650] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
> [   32.404895] brd: module loaded
> [   32.405841] loop: module loaded
> [   32.406173] megasas: 06.600.18.00-rc1 Wed. May. 15 17:00:00 PDT 2013
> [   32.406344] ata_piix 0000:00:07.1: version 2.13
> [   32.406906] scsi0 : ata_piix
> [   32.407078] scsi1 : ata_piix
> [   32.407172] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x1060 ir=
q 14
> [   32.407255] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x1068 ir=
q 15
> [   32.407602] libphy: Fixed MDIO Bus: probed
> [   32.407741] tun: Universal TUN/TAP device driver, 1.6
> [   32.407810] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [   32.407938] PPP generic driver version 2.4.2
> [   32.408069] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [   32.408158] ehci-pci: EHCI PCI platform driver
> [   32.408706] ehci-pci 0000:02:03.0: EHCI Host Controller
> [   32.408786] ehci-pci 0000:02:03.0: new USB bus registered, assigned bu=
s number 1
> [   32.409066] ehci-pci 0000:02:03.0: cache line size of 32 is not suppor=
ted
> [   32.409092] ehci-pci 0000:02:03.0: irq 17, io mem 0xfd5bf000
> [   32.420275] ehci-pci 0000:02:03.0: USB 2.0 started, EHCI 1.00
> [   32.420431] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
> [   32.420516] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
> [   32.420614] usb usb1: Product: EHCI Host Controller
> [   32.420681] usb usb1: Manufacturer: Linux 3.11.0-26-generic ehci_hcd
> [   32.420759] usb usb1: SerialNumber: 0000:02:03.0
> [   32.420937] hub 1-0:1.0: USB hub found
> [   32.421003] hub 1-0:1.0: 6 ports detected
> [   32.421286] ehci-platform: EHCI generic platform driver
> [   32.421382] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [   32.421487] ohci-pci: OHCI PCI platform driver
> [   32.421564] ohci-platform: OHCI generic platform driver
> [   32.421647] uhci_hcd: USB Universal Host Controller Interface driver
> [   32.422087] uhci_hcd 0000:02:02.0: UHCI Host Controller
> [   32.422164] uhci_hcd 0000:02:02.0: new USB bus registered, assigned bu=
s number 2
> [   32.422534] uhci_hcd 0000:02:02.0: irq 16, io base 0x00002400
> [   32.422728] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
> [   32.422812] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
> [   32.422910] usb usb2: Product: UHCI Host Controller
> [   32.422977] usb usb2: Manufacturer: Linux 3.11.0-26-generic uhci_hcd
> [   32.423054] usb usb2: SerialNumber: 0000:02:02.0
> [   32.423218] hub 2-0:1.0: USB hub found
> [   32.423285] hub 2-0:1.0: 2 ports detected
> [   32.423896] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at =
0x60,0x64 irq 1,12
> [   32.425323] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   32.425466] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   32.425854] mousedev: PS/2 mouse device common for all mice
> [   32.428035] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input1
> [   32.446537] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [   32.446729] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvr=
am, hpet irqs
> [   32.447188] device-mapper: uevent: version 1.0.3
> [   32.447444] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialise=
d: dm-devel@redhat.com
> [   32.447662] cpuidle: using governor ladder
> [   32.447727] cpuidle: using governor menu
> [   32.447841] ledtrig-cpu: registered to indicate activity on CPUs
> [   32.448850] TCP: cubic registered
> [   32.449041] NET: Registered protocol family 10
> [   32.449448] NET: Registered protocol family 17
> [   32.449529] Key type dns_resolver registered
> [   32.450236] PM: Hibernation image not present or could not be loaded.
> [   32.450242] Loading module verification certificates
> [   32.451133] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 05f7=
9677c64ce29c19b2aaf989bed111ed47632f'
> [   32.451266] registered taskstats version 1
> [   32.456718] Key type trusted registered
> [   32.459942] Key type encrypted registered
> [   32.463210] AppArmor: AppArmor sha1 policy hashing enabled
> [   32.471989] regulator-dummy: disabling
> [   32.472388]   Magic number: 15:867:789
> [   32.472549] pnp 00:17c: hash matches
> [   32.472668] pcieport 0000:00:16.7: hash matches
> [   32.472890] acpi PNP0C80:28: hash matches
> [   32.473495] rtc_cmos 00:03: setting system clock to 2015-01-29 14:45:5=
5 UTC (1422542755)
> [   32.473830] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [   32.473909] EDD information not available.
> [   32.571691] ata2.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001, =
max UDMA/33
> [   32.588503] ata2.00: configured for UDMA/33
> [   32.589327] scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 =
1.00 PQ: 0 ANSI: 5
> [   32.590032] sr0: scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 =
cdda tray
> [   32.590138] cdrom: Uniform CD-ROM driver Revision: 3.20
> [   32.590467] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [   32.590634] sr 1:0:0:0: Attached scsi generic sg0 type 5
> [   32.593010] Freeing unused kernel memory: 1392K (ffffffff81d10000 - ff=
ffffff81e6c000)
> [   32.593121] Write protecting the kernel read-only data: 12288k
> [   32.595623] Freeing unused kernel memory: 660K (ffff88000175b000 - fff=
f880001800000)
> [   32.596141] Freeing unused kernel memory: 20K (ffff880001bfb000 - ffff=
880001c00000)
> [   32.640940] udevd[386]: starting version 175
> [   32.656792] VMware vmxnet3 virtual NIC driver - version 1.1.30.0-k-NAPI
> [   32.657866] vmxnet3 0000:03:00.0: # of Tx queues : 8, # of Rx queues :=
 8
> [   32.683969] vmxnet3 0000:03:00.0: irq 72 for MSI/MSI-X
> [   32.684070] vmxnet3 0000:03:00.0: irq 73 for MSI/MSI-X
> [   32.684188] vmxnet3 0000:03:00.0: irq 74 for MSI/MSI-X
> [   32.684244] vmxnet3 0000:03:00.0: irq 75 for MSI/MSI-X
> [   32.684297] vmxnet3 0000:03:00.0: irq 76 for MSI/MSI-X
> [   32.684422] vmxnet3 0000:03:00.0: irq 77 for MSI/MSI-X
> [   32.684480] vmxnet3 0000:03:00.0: irq 78 for MSI/MSI-X
> [   32.684534] vmxnet3 0000:03:00.0: irq 79 for MSI/MSI-X
> [   32.684588] vmxnet3 0000:03:00.0: irq 80 for MSI/MSI-X
> [   32.685771] vmxnet3 0000:03:00.0 eth0: NIC Link is Up 10000 Mbps
> [   32.694740] VMware PVSCSI driver - version 1.0.2.0-k
> [   32.732073] Floppy drive(s): fd0 is 1.44M
> [   32.740394] usb 2-1: new full-speed USB device number 2 using uhci_hcd
> [   32.754581] FDC 0 is a post-1991 82077
> [   32.842417] Fusion MPT base driver 3.04.20
> [   32.842556] Copyright (c) 1999-2008 LSI Corporation
> [   32.852036] Fusion MPT SPI Host driver 3.04.20
> [   32.853626] mptbase: ioc0: Initiating bringup
> [   32.891154] usb 2-1: New USB device found, idVendor=3D0e0f, idProduct=
=3D0003
> [   32.891318] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
> [   32.891470] usb 2-1: Product: VMware Virtual USB Mouse
> [   32.891594] usb 2-1: Manufacturer: VMware
> [   32.924935] ioc0: LSI53C1030 B0: Capabilities=3D{Initiator}
> [   33.012525] usb 2-2: new full-speed USB device number 3 using uhci_hcd
> [   33.086134] scsi2 : ioc0: LSI53C1030 B0, FwRev=3D01032920h, Ports=3D1,=
 MaxQ=3D128, IRQ=3D17
> [   33.167745] usb 2-2: New USB device found, idVendor=3D0e0f, idProduct=
=3D0002
> [   33.167905] usb 2-2: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
> [   33.168056] usb 2-2: Product: VMware Virtual USB Hub
> [   33.179352] hub 2-2:1.0: USB hub found
> [   33.184691] hub 2-2:1.0: 7 ports detected
> [   33.197226] scsi 2:0:0:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.197752] scsi target2:0:0: Beginning Domain Validation
> [   33.198710] scsi target2:0:0: Domain Validation skipping write tests
> [   33.198859] scsi target2:0:0: Ending Domain Validation
> [   33.199040] scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.199517] scsi 2:0:1:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.199774] scsi target2:0:1: Beginning Domain Validation
> [   33.199800] mptbase: ioc1: Initiating bringup
> [   33.200981] scsi target2:0:1: Domain Validation skipping write tests
> [   33.201124] scsi target2:0:1: Ending Domain Validation
> [   33.201299] scsi target2:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.201732] scsi 2:0:2:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.201939] scsi target2:0:2: Beginning Domain Validation
> [   33.202600] scsi target2:0:2: Domain Validation skipping write tests
> [   33.202740] scsi target2:0:2: Ending Domain Validation
> [   33.202916] scsi target2:0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.203436] scsi 2:0:3:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.203648] scsi target2:0:3: Beginning Domain Validation
> [   33.204306] scsi target2:0:3: Domain Validation skipping write tests
> [   33.204445] scsi target2:0:3: Ending Domain Validation
> [   33.204660] scsi target2:0:3: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.205079] scsi 2:0:4:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.205295] scsi target2:0:4: Beginning Domain Validation
> [   33.205959] scsi target2:0:4: Domain Validation skipping write tests
> [   33.206098] scsi target2:0:4: Ending Domain Validation
> [   33.206280] scsi target2:0:4: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.206821] scsi 2:0:5:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.207073] scsi target2:0:5: Beginning Domain Validation
> [   33.207745] scsi target2:0:5: Domain Validation skipping write tests
> [   33.207884] scsi target2:0:5: Ending Domain Validation
> [   33.208073] scsi target2:0:5: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.208486] scsi 2:0:6:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.208810] scsi target2:0:6: Beginning Domain Validation
> [   33.209787] scsi target2:0:6: Domain Validation skipping write tests
> [   33.209931] scsi target2:0:6: Ending Domain Validation
> [   33.210127] scsi target2:0:6: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.210670] scsi 2:0:8:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.210898] scsi target2:0:8: Beginning Domain Validation
> [   33.211554] scsi target2:0:8: Domain Validation skipping write tests
> [   33.211693] scsi target2:0:8: Ending Domain Validation
> [   33.211888] scsi target2:0:8: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.212376] scsi 2:0:9:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.212631] scsi target2:0:9: Beginning Domain Validation
> [   33.213292] scsi target2:0:9: Domain Validation skipping write tests
> [   33.213432] scsi target2:0:9: Ending Domain Validation
> [   33.213632] scsi target2:0:9: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.214101] scsi 2:0:10:0: Direct-Access     VMware   Virtual disk    =
 1.0  PQ: 0 ANSI: 2
> [   33.214337] scsi target2:0:10: Beginning Domain Validation
> [   33.214989] scsi target2:0:10: Domain Validation skipping write tests
> [   33.215129] scsi target2:0:10: Ending Domain Validation
> [   33.215337] scsi target2:0:10: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, =
offset 127)
> [   33.215813] scsi 2:0:11:0: Direct-Access     VMware   Virtual disk    =
 1.0  PQ: 0 ANSI: 2
> [   33.216062] scsi target2:0:11: Beginning Domain Validation
> [   33.216747] scsi target2:0:11: Domain Validation skipping write tests
> [   33.216888] scsi target2:0:11: Ending Domain Validation
> [   33.217103] scsi target2:0:11: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, =
offset 127)
> [   33.217579] scsi 2:0:12:0: Direct-Access     VMware   Virtual disk    =
 1.0  PQ: 0 ANSI: 2
> [   33.217823] scsi target2:0:12: Beginning Domain Validation
> [   33.218492] scsi target2:0:12: Domain Validation skipping write tests
> [   33.218636] scsi target2:0:12: Ending Domain Validation
> [   33.218888] scsi target2:0:12: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, =
offset 127)
> [   33.219448] scsi 2:0:13:0: Direct-Access     VMware   Virtual disk    =
 1.0  PQ: 0 ANSI: 2
> [   33.219735] scsi target2:0:13: Beginning Domain Validation
> [   33.220504] hidraw: raw HID events driver (C) Jiri Kosina
> [   33.220520] scsi target2:0:13: Domain Validation skipping write tests
> [   33.220522] scsi target2:0:13: Ending Domain Validation
> [   33.220636] scsi target2:0:13: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, =
offset 127)
> [   33.220932] scsi 2:0:14:0: Direct-Access     VMware   Virtual disk    =
 1.0  PQ: 0 ANSI: 2
> [   33.221004] scsi target2:0:14: Beginning Domain Validation
> [   33.221551] scsi target2:0:14: Domain Validation skipping write tests
> [   33.221722] scsi target2:0:14: Ending Domain Validation
> [   33.221982] scsi target2:0:14: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, =
offset 127)
> [   33.222474] scsi 2:0:15:0: Direct-Access     VMware   Virtual disk    =
 1.0  PQ: 0 ANSI: 2
> [   33.222730] scsi target2:0:15: Beginning Domain Validation
> [   33.223385] scsi target2:0:15: Domain Validation skipping write tests
> [   33.223525] scsi target2:0:15: Ending Domain Validation
> [   33.223750] scsi target2:0:15: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, =
offset 127)
> [   33.224896] sd 2:0:0:0: Attached scsi generic sg1 type 0
> [   33.224900] sd 2:0:0:0: [sda] 33554432 512-byte logical blocks: (17.1 =
GB/16.0 GiB)
> [   33.224934] sd 2:0:0:0: [sda] Write Protect is off
> [   33.224937] sd 2:0:0:0: [sda] Mode Sense: 61 00 00 00
> [   33.224986] sd 2:0:0:0: [sda] Cache data unavailable
> [   33.224988] sd 2:0:0:0: [sda] Assuming drive cache: write through
> [   33.226291] sd 2:0:0:0: [sda] Cache data unavailable
> [   33.226432] sd 2:0:0:0: [sda] Assuming drive cache: write through
> [   33.226557] sd 2:0:1:0: Attached scsi generic sg2 type 0
> [   33.226907] sd 2:0:1:0: [sdb] 209715200 512-byte logical blocks: (107 =
GB/100 GiB)
> [   33.226966] sd 2:0:2:0: Attached scsi generic sg3 type 0
> [   33.227202] sd 2:0:2:0: [sdc] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.227293] sd 2:0:2:0: [sdc] 21474836480 512-byte logical blocks: (10=
.9 TB/10.0 TiB)
> [   33.227323] sd 2:0:2:0: [sdc] Write Protect is off
> [   33.227325] sd 2:0:2:0: [sdc] Mode Sense: 61 00 00 00
> [   33.227353] sd 2:0:2:0: [sdc] Cache data unavailable
> [   33.227355] sd 2:0:2:0: [sdc] Assuming drive cache: write through
> [   33.227441] sd 2:0:3:0: Attached scsi generic sg4 type 0
> [   33.227514]  sda: sda1 sda2
> [   33.227593] sd 2:0:3:0: [sdd] 2147483648 512-byte logical blocks: (1.0=
9 TB/1.00 TiB)
> [   33.227721] sd 2:0:3:0: [sdd] Write Protect is off
> [   33.227724] sd 2:0:3:0: [sdd] Mode Sense: 61 00 00 00
> [   33.227821] sd 2:0:3:0: [sdd] Cache data unavailable
> [   33.227825] sd 2:0:3:0: [sdd] Assuming drive cache: write through
> [   33.227929] sd 2:0:2:0: [sdc] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.228129] sd 2:0:4:0: [sde] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.228147] sd 2:0:4:0: Attached scsi generic sg5 type 0
> [   33.228238] sd 2:0:4:0: [sde] 10737418240 512-byte logical blocks: (5.=
49 TB/5.00 TiB)
> [   33.228328] sd 2:0:4:0: [sde] Write Protect is off
> [   33.228331] sd 2:0:4:0: [sde] Mode Sense: 61 00 00 00
> [   33.228418] sd 2:0:3:0: [sdd] Cache data unavailable
> [   33.228419] sd 2:0:3:0: [sdd] Assuming drive cache: write through
> [   33.228434] sd 2:0:4:0: [sde] Cache data unavailable
> [   33.228436] sd 2:0:4:0: [sde] Assuming drive cache: write through
> [   33.228504] sd 2:0:5:0: Attached scsi generic sg6 type 0
> [   33.228563] sd 2:0:0:0: [sda] Cache data unavailable
> [   33.228565] sd 2:0:0:0: [sda] Assuming drive cache: write through
> [   33.228757] sd 2:0:0:0: [sda] Attached SCSI disk
> [   33.228831] sd 2:0:5:0: [sdf] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.228992] sd 2:0:5:0: [sdf] 4294967296 512-byte logical blocks: (2.1=
9 TB/2.00 TiB)
> [   33.229044] sd 2:0:4:0: [sde] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.229052] sd 2:0:2:0: [sdc] Cache data unavailable
> [   33.229054] sd 2:0:2:0: [sdc] Assuming drive cache: write through
> [   33.229095] sd 2:0:6:0: Attached scsi generic sg7 type 0
> [   33.229118] sd 2:0:5:0: [sdf] Write Protect is off
> [   33.229122] sd 2:0:5:0: [sdf] Mode Sense: 61 00 00 00
> [   33.229279] sd 2:0:5:0: [sdf] Cache data unavailable
> [   33.229281] sd 2:0:5:0: [sdf] Assuming drive cache: write through
> [   33.229287] sd 2:0:4:0: [sde] Cache data unavailable
> [   33.229288] sd 2:0:4:0: [sde] Assuming drive cache: write through
> [   33.229400] sd 2:0:8:0: Attached scsi generic sg8 type 0
> [   33.229566] sd 2:0:6:0: [sdg] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.229609] sd 2:0:6:0: [sdg] 8589934592 512-byte logical blocks: (4.3=
9 TB/4.00 TiB)
> [   33.229636] sd 2:0:6:0: [sdg] Write Protect is off
> [   33.229638] sd 2:0:6:0: [sdg] Mode Sense: 61 00 00 00
> [   33.229766] sd 2:0:6:0: [sdg] Cache data unavailable
> [   33.229768] sd 2:0:6:0: [sdg] Assuming drive cache: write through
> [   33.229771] sd 2:0:5:0: [sdf] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.229823] sd 2:0:9:0: Attached scsi generic sg9 type 0
> [   33.230166] sd 2:0:9:0: [sdi] 251658240 512-byte logical blocks: (128 =
GB/120 GiB)
> [   33.230171] sd 2:0:5:0: [sdf] Cache data unavailable
> [   33.230172] sd 2:0:5:0: [sdf] Assuming drive cache: write through
> [   33.230381]  sdd: unknown partition table
> [   33.230408] sd 2:0:6:0: [sdg] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.230432] sd 2:0:9:0: [sdi] Write Protect is off
> [   33.230436] sd 2:0:9:0: [sdi] Mode Sense: 61 00 00 00
> [   33.230618] sd 2:0:10:0: Attached scsi generic sg10 type 0
> [   33.230729] sd 2:0:9:0: [sdi] Cache data unavailable
> [   33.230731] sd 2:0:9:0: [sdi] Assuming drive cache: write through
> [   33.230793] sd 2:0:10:0: [sdj] 2778726400 512-byte logical blocks: (1.=
42 TB/1.29 TiB)
> [   33.230901]  sdc: unknown partition table
> [   33.230942] sd 2:0:6:0: [sdg] Cache data unavailable
> [   33.230945] sd 2:0:10:0: [sdj] Write Protect is off
> [   33.230948] sd 2:0:6:0: [sdg] Assuming drive cache: write through
> [   33.230952] sd 2:0:10:0: [sdj] Mode Sense: 61 00 00 00
> [   33.230975] sd 2:0:8:0: [sdh] 2361393152 512-byte logical blocks: (1.2=
0 TB/1.09 TiB)
> [   33.231119] sd 2:0:3:0: [sdd] Cache data unavailable
> [   33.231121] sd 2:0:3:0: [sdd] Assuming drive cache: write through
> [   33.231217] sd 2:0:11:0: Attached scsi generic sg11 type 0
> [   33.231311] sd 2:0:2:0: [sdc] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.231314] sd 2:0:3:0: [sdd] Attached SCSI disk
> [   33.231361] sd 2:0:10:0: [sdj] Cache data unavailable
> [   33.231364] sd 2:0:10:0: [sdj] Assuming drive cache: write through
> [   33.231663] sd 2:0:11:0: [sdk] Very big device. Trying to use READ CAP=
ACITY(16).
> [   33.231682] sd 2:0:12:0: Attached scsi generic sg12 type 0
> [   33.231831] sd 2:0:2:0: [sdc] Cache data unavailable
> [   33.231833] sd 2:0:2:0: [sdc] Assuming drive cache: write through
> [   33.231837] sd 2:0:11:0: [sdk] 4294967296 512-byte logical blocks: (2.=
19 TB/2.00 TiB)
> [   33.231842]  sde: unknown partition table
> [   33.231847] sd 2:0:12:0: [sdl] Very big device. Trying to use READ CAP=
ACITY(16).
> [   33.231870]  sdf: unknown partition table
> [   33.231888] sd 2:0:9:0: [sdi] Cache data unavailable
> [   33.231890] sd 2:0:9:0: [sdi] Assuming drive cache: write through
> [   33.232039] sd 2:0:2:0: [sdc] Attached SCSI disk
> [   33.232076] sd 2:0:11:0: [sdk] Write Protect is off
> [   33.232079] sd 2:0:11:0: [sdk] Mode Sense: 61 00 00 00
> [   33.232130] sd 2:0:13:0: Attached scsi generic sg13 type 0
> [   33.232164] sd 2:0:12:0: [sdl] 4294967296 512-byte logical blocks: (2.=
19 TB/2.00 TiB)
> [   33.232414] sd 2:0:11:0: [sdk] Cache data unavailable
> [   33.232416] sd 2:0:11:0: [sdk] Assuming drive cache: write through
> [   33.232424] sd 2:0:12:0: [sdl] Write Protect is off
> [   33.232427] sd 2:0:12:0: [sdl] Mode Sense: 61 00 00 00
> [   33.232454] sd 2:0:13:0: [sdm] 2090860544 512-byte logical blocks: (1.=
07 TB/997 GiB)
> [   33.232580] sd 2:0:14:0: Attached scsi generic sg14 type 0
> [   33.232608] sd 2:0:8:0: [sdh] Write Protect is off
> [   33.232611] sd 2:0:8:0: [sdh] Mode Sense: 61 00 00 00
> [   33.232646] sd 2:0:5:0: [sdf] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.232999] sd 2:0:10:0: [sdj] Cache data unavailable
> [   33.233001] sd 2:0:10:0: [sdj] Assuming drive cache: write through
> [   33.233021] sd 2:0:13:0: [sdm] Write Protect is off
> [   33.233024] sd 2:0:13:0: [sdm] Mode Sense: 61 00 00 00
> [   33.233035] sd 2:0:12:0: [sdl] Cache data unavailable
> [   33.233037] sd 2:0:8:0: [sdh] Cache data unavailable
> [   33.233039] sd 2:0:12:0: [sdl] Assuming drive cache: write through
> [   33.233040] sd 2:0:8:0: [sdh] Assuming drive cache: write through
> [   33.233228] sd 2:0:14:0: [sdn] 524288000 512-byte logical blocks: (268=
 GB/250 GiB)
> [   33.233233] sd 2:0:13:0: [sdm] Cache data unavailable
> [   33.233235] sd 2:0:13:0: [sdm] Assuming drive cache: write through
> [   33.233263] sd 2:0:15:0: Attached scsi generic sg15 type 0
> [   33.233368] sd 2:0:15:0: [sdo] 524288000 512-byte logical blocks: (268=
 GB/250 GiB)
> [   33.233397] sd 2:0:14:0: [sdn] Write Protect is off
> [   33.233400] sd 2:0:14:0: [sdn] Mode Sense: 61 00 00 00
> [   33.233477]  sdg: unknown partition table
> [   33.233498] sd 2:0:5:0: [sdf] Cache data unavailable
> [   33.233503] sd 2:0:5:0: [sdf] Assuming drive cache: write through
> [   33.233507] sd 2:0:11:0: [sdk] Very big device. Trying to use READ CAP=
ACITY(16).
> [   33.233533] sd 2:0:15:0: [sdo] Write Protect is off
> [   33.233537] sd 2:0:15:0: [sdo] Mode Sense: 61 00 00 00
> [   33.233554] sd 2:0:14:0: [sdn] Cache data unavailable
> [   33.233557] sd 2:0:14:0: [sdn] Assuming drive cache: write through
> [   33.233746] sd 2:0:5:0: [sdf] Attached SCSI disk
> [   33.233782] sd 2:0:15:0: [sdo] Cache data unavailable
> [   33.233785] sd 2:0:15:0: [sdo] Assuming drive cache: write through
> [   33.234094] sd 2:0:6:0: [sdg] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.234127] sd 2:0:11:0: [sdk] Cache data unavailable
> [   33.234129] sd 2:0:11:0: [sdk] Assuming drive cache: write through
> [   33.234300] sd 2:0:12:0: [sdl] Very big device. Trying to use READ CAP=
ACITY(16).
> [   33.234578] sd 2:0:13:0: [sdm] Cache data unavailable
> [   33.234580] sd 2:0:13:0: [sdm] Assuming drive cache: write through
> [   33.235018] sd 2:0:6:0: [sdg] Cache data unavailable
> [   33.235021] sd 2:0:6:0: [sdg] Assuming drive cache: write through
> [   33.235044]  sdi: unknown partition table
> [   33.235061] sd 2:0:8:0: [sdh] Cache data unavailable
> [   33.235064] sd 2:0:8:0: [sdh] Assuming drive cache: write through
> [   33.235114] sd 2:0:14:0: [sdn] Cache data unavailable
> [   33.235116] sd 2:0:14:0: [sdn] Assuming drive cache: write through
> [   33.235188] sd 2:0:12:0: [sdl] Cache data unavailable
> [   33.235190] sd 2:0:12:0: [sdl] Assuming drive cache: write through
> [   33.235270]  sdj: unknown partition table
> [   33.235277] sd 2:0:6:0: [sdg] Attached SCSI disk
> [   33.235291] sd 2:0:15:0: [sdo] Cache data unavailable
> [   33.235293] sd 2:0:15:0: [sdo] Assuming drive cache: write through
> [   33.235301] sd 2:0:4:0: [sde] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.235675] sd 2:0:9:0: [sdi] Cache data unavailable
> [   33.235677] sd 2:0:9:0: [sdi] Assuming drive cache: write through
> [   33.235780] sd 2:0:9:0: [sdi] Attached SCSI disk
> [   33.235832] sd 2:0:4:0: [sde] Cache data unavailable
> [   33.235833] sd 2:0:4:0: [sde] Assuming drive cache: write through
> [   33.235844] sd 2:0:10:0: [sdj] Cache data unavailable
> [   33.235846] sd 2:0:10:0: [sdj] Assuming drive cache: write through
> [   33.235917] sd 2:0:4:0: [sde] Attached SCSI disk
> [   33.235935] sd 2:0:10:0: [sdj] Attached SCSI disk
> [   33.236556]  sdh: unknown partition table
> [   33.236796] sd 2:0:8:0: [sdh] Cache data unavailable
> [   33.236798] sd 2:0:8:0: [sdh] Assuming drive cache: write through
> [   33.236825] sd 2:0:8:0: [sdh] Attached SCSI disk
> [   33.245257]  sdn: unknown partition table
> [   33.245571] sd 2:0:14:0: [sdn] Cache data unavailable
> [   33.245573] sd 2:0:14:0: [sdn] Assuming drive cache: write through
> [   33.246131] sd 2:0:14:0: [sdn] Attached SCSI disk
> [   33.247039]  sdm: unknown partition table
> [   33.247396] sd 2:0:13:0: [sdm] Cache data unavailable
> [   33.247398] sd 2:0:13:0: [sdm] Assuming drive cache: write through
> [   33.247425] sd 2:0:13:0: [sdm] Attached SCSI disk
> [   33.248779] sd 2:0:1:0: [sdb] Write Protect is off
> [   33.248911] sd 2:0:1:0: [sdb] Mode Sense: 61 00 00 00
> [   33.248962] sd 2:0:1:0: [sdb] Cache data unavailable
> [   33.249092] sd 2:0:1:0: [sdb] Assuming drive cache: write through
> [   33.250671]  sdk: unknown partition table
> [   33.250693] sd 2:0:1:0: [sdb] Cache data unavailable
> [   33.250695] sd 2:0:1:0: [sdb] Assuming drive cache: write through
> [   33.251498] sd 2:0:11:0: [sdk] Very big device. Trying to use READ CAP=
ACITY(16).
> [   33.251543] usbcore: registered new interface driver usbhid
> [   33.251544] usbhid: USB HID core driver
> [   33.252800]  sdb: unknown partition table
> [   33.253058] sd 2:0:11:0: [sdk] Cache data unavailable
> [   33.253200] sd 2:0:11:0: [sdk] Assuming drive cache: write through
> [   33.253427] sd 2:0:11:0: [sdk] Attached SCSI disk
> [   33.253494] sd 2:0:1:0: [sdb] Cache data unavailable
> [   33.253496] sd 2:0:1:0: [sdb] Assuming drive cache: write through
> [   33.253523] sd 2:0:1:0: [sdb] Attached SCSI disk
> [   33.255884]  sdo: unknown partition table
> [   33.256283] sd 2:0:15:0: [sdo] Cache data unavailable
> [   33.256415] sd 2:0:15:0: [sdo] Assuming drive cache: write through
> [   33.256599] sd 2:0:15:0: [sdo] Attached SCSI disk
> [   33.258689] input: VMware VMware Virtual USB Mouse as /devices/pci0000=
:00/0000:00:11.0/0000:02:02.0/usb2/2-1/2-1:1.0/input/input2
> [   33.259225] hid-generic 0003:0E0F:0003.0001: input,hidraw0: USB HID v1=
.10 Mouse [VMware VMware Virtual USB Mouse] on usb-0000:02:02.0-1/input0
> [   33.269014] ioc1: LSI53C1030 B0: Capabilities=3D{Initiator}
> [   33.270125]  sdl: unknown partition table
> [   33.270562] sd 2:0:12:0: [sdl] Very big device. Trying to use READ CAP=
ACITY(16).
> [   33.270935] sd 2:0:12:0: [sdl] Cache data unavailable
> [   33.271069] sd 2:0:12:0: [sdl] Assuming drive cache: write through
> [   33.271238] sd 2:0:12:0: [sdl] Attached SCSI disk
> [   33.433941] scsi3 : ioc1: LSI53C1030 B0, FwRev=3D01032920h, Ports=3D1,=
 MaxQ=3D128, IRQ=3D19
> [   33.545048] scsi 3:0:0:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.545263] scsi target3:0:0: Beginning Domain Validation
> [   33.545908] scsi target3:0:0: Domain Validation skipping write tests
> [   33.546056] scsi target3:0:0: Ending Domain Validation
> [   33.546227] scsi target3:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.546745] scsi 3:0:1:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.546950] scsi target3:0:1: Beginning Domain Validation
> [   33.547577] scsi target3:0:1: Domain Validation skipping write tests
> [   33.547716] scsi target3:0:1: Ending Domain Validation
> [   33.547886] scsi target3:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.548360] scsi 3:0:2:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.548565] scsi target3:0:2: Beginning Domain Validation
> [   33.549237] scsi target3:0:2: Domain Validation skipping write tests
> [   33.549378] scsi target3:0:2: Ending Domain Validation
> [   33.549577] scsi target3:0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.550058] scsi 3:0:3:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.550268] scsi target3:0:3: Beginning Domain Validation
> [   33.550899] scsi target3:0:3: Domain Validation skipping write tests
> [   33.551038] scsi target3:0:3: Ending Domain Validation
> [   33.551216] scsi target3:0:3: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.551681] scsi 3:0:4:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.551896] scsi target3:0:4: Beginning Domain Validation
> [   33.552533] scsi target3:0:4: Domain Validation skipping write tests
> [   33.552719] scsi target3:0:4: Ending Domain Validation
> [   33.552930] scsi target3:0:4: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.553493] scsi 3:0:5:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.553715] scsi target3:0:5: Beginning Domain Validation
> [   33.554354] scsi target3:0:5: Domain Validation skipping write tests
> [   33.554494] scsi target3:0:5: Ending Domain Validation
> [   33.554679] scsi target3:0:5: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.555183] scsi 3:0:6:0: Direct-Access     VMware   Virtual disk     =
1.0  PQ: 0 ANSI: 2
> [   33.555407] scsi target3:0:6: Beginning Domain Validation
> [   33.556170] scsi target3:0:6: Domain Validation skipping write tests
> [   33.556312] scsi target3:0:6: Ending Domain Validation
> [   33.556504] scsi target3:0:6: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, o=
ffset 127)
> [   33.559166] sd 3:0:0:0: [sdp] 629145600 512-byte logical blocks: (322 =
GB/300 GiB)
> [   33.559380] sd 3:0:0:0: [sdp] Write Protect is off
> [   33.559500] sd 3:0:0:0: [sdp] Mode Sense: 61 00 00 00
> [   33.559533] sd 3:0:0:0: [sdp] Cache data unavailable
> [   33.559655] sd 3:0:0:0: [sdp] Assuming drive cache: write through
> [   33.560150] sd 3:0:0:0: [sdp] Cache data unavailable
> [   33.560275] sd 3:0:0:0: [sdp] Assuming drive cache: write through
> [   33.560522] sd 3:0:0:0: Attached scsi generic sg16 type 0
> [   33.561233] sd 3:0:1:0: [sdq] 524288000 512-byte logical blocks: (268 =
GB/250 GiB)
> [   33.561254] sd 3:0:1:0: Attached scsi generic sg17 type 0
> [   33.561664] sd 3:0:1:0: [sdq] Write Protect is off
> [   33.561695] sd 3:0:2:0: Attached scsi generic sg18 type 0
> [   33.561922] sd 3:0:1:0: [sdq] Mode Sense: 61 00 00 00
> [   33.561928] sd 3:0:2:0: [sdr] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.562074] sd 3:0:3:0: Attached scsi generic sg19 type 0
> [   33.562351] sd 3:0:2:0: [sdr] 5368709120 512-byte logical blocks: (2.7=
4 TB/2.50 TiB)
> [   33.562517] sd 3:0:4:0: [sdt] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.562567] sd 3:0:4:0: [sdt] 6442450944 512-byte logical blocks: (3.2=
9 TB/3.00 TiB)
> [   33.562593] sd 3:0:4:0: [sdt] Write Protect is off
> [   33.562595] sd 3:0:4:0: [sdt] Mode Sense: 61 00 00 00
> [   33.562621] sd 3:0:4:0: [sdt] Cache data unavailable
> [   33.562622] sd 3:0:4:0: [sdt] Assuming drive cache: write through
> [   33.562857] sd 3:0:4:0: [sdt] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.562941] sd 3:0:4:0: [sdt] Cache data unavailable
> [   33.562943] sd 3:0:4:0: [sdt] Assuming drive cache: write through
> [   33.563171] sd 3:0:4:0: Attached scsi generic sg20 type 0
> [   33.563530] sd 3:0:5:0: Attached scsi generic sg21 type 0
> [   33.563569] sd 3:0:5:0: [sdu] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.563653] sd 3:0:5:0: [sdu] 21474836480 512-byte logical blocks: (10=
.9 TB/10.0 TiB)
> [   33.563705] sd 3:0:5:0: [sdu] Write Protect is off
> [   33.563708] sd 3:0:5:0: [sdu] Mode Sense: 61 00 00 00
> [   33.563770] sd 3:0:5:0: [sdu] Cache data unavailable
> [   33.563772] sd 3:0:5:0: [sdu] Assuming drive cache: write through
> [   33.564043] sd 3:0:6:0: [sdv] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.564120] sd 3:0:6:0: [sdv] 10307921510 512-byte logical blocks: (5.=
27 TB/4.79 TiB)
> [   33.564128] sd 3:0:6:0: Attached scsi generic sg22 type 0
> [   33.564162] sd 3:0:6:0: [sdv] Write Protect is off
> [   33.564164] sd 3:0:6:0: [sdv] Mode Sense: 61 00 00 00
> [   33.564248] sd 3:0:6:0: [sdv] Cache data unavailable
> [   33.564249] sd 3:0:6:0: [sdv] Assuming drive cache: write through
> [   33.564383] sd 3:0:5:0: [sdu] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.564604] sd 3:0:6:0: [sdv] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.564616] sd 3:0:5:0: [sdu] Cache data unavailable
> [   33.564618] sd 3:0:5:0: [sdu] Assuming drive cache: write through
> [   33.564748] sd 3:0:6:0: [sdv] Cache data unavailable
> [   33.564749] sd 3:0:6:0: [sdv] Assuming drive cache: write through
> [   33.565824]  sdt: unknown partition table
> [   33.566038] sd 3:0:4:0: [sdt] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.566137] sd 3:0:4:0: [sdt] Cache data unavailable
> [   33.566138] sd 3:0:4:0: [sdt] Assuming drive cache: write through
> [   33.566163] sd 3:0:4:0: [sdt] Attached SCSI disk
> [   33.567238] sd 3:0:1:0: [sdq] Cache data unavailable
> [   33.567492] sd 3:0:3:0: [sds] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.567502] sd 3:0:1:0: [sdq] Assuming drive cache: write through
> [   33.567993] sd 3:0:1:0: [sdq] Cache data unavailable
> [   33.567995] sd 3:0:1:0: [sdq] Assuming drive cache: write through
> [   33.568218]  sdu: unknown partition table
> [   33.568293]  sdv: unknown partition table
> [   33.568426] sd 3:0:5:0: [sdu] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.568602] sd 3:0:6:0: [sdv] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.568617] sd 3:0:5:0: [sdu] Cache data unavailable
> [   33.568619] sd 3:0:5:0: [sdu] Assuming drive cache: write through
> [   33.568692] sd 3:0:5:0: [sdu] Attached SCSI disk
> [   33.568744] sd 3:0:6:0: [sdv] Cache data unavailable
> [   33.568746] sd 3:0:6:0: [sdv] Assuming drive cache: write through
> [   33.568770] sd 3:0:6:0: [sdv] Attached SCSI disk
> [   33.569700] sd 3:0:2:0: [sdr] Write Protect is off
> [   33.569714] sd 3:0:3:0: [sds] 21474836480 512-byte logical blocks: (10=
.9 TB/10.0 TiB)
> [   33.570042] sd 3:0:2:0: [sdr] Mode Sense: 61 00 00 00
> [   33.570059] sd 3:0:3:0: [sds] Write Protect is off
> [   33.570086] sd 3:0:2:0: [sdr] Cache data unavailable
> [   33.570087] sd 3:0:2:0: [sdr] Assuming drive cache: write through
> [   33.570335] sd 3:0:2:0: [sdr] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.570421] sd 3:0:2:0: [sdr] Cache data unavailable
> [   33.570422] sd 3:0:2:0: [sdr] Assuming drive cache: write through
> [   33.571465] sd 3:0:3:0: [sds] Mode Sense: 61 00 00 00
> [   33.571547] sd 3:0:3:0: [sds] Cache data unavailable
> [   33.571675] sd 3:0:3:0: [sds] Assuming drive cache: write through
> [   33.572054] sd 3:0:3:0: [sds] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.572324] sd 3:0:3:0: [sds] Cache data unavailable
> [   33.572446] sd 3:0:3:0: [sds] Assuming drive cache: write through
> [   33.580562]  sdq: unknown partition table
> [   33.581036] sd 3:0:1:0: [sdq] Cache data unavailable
> [   33.581164] sd 3:0:1:0: [sdq] Assuming drive cache: write through
> [   33.581408] sd 3:0:1:0: [sdq] Attached SCSI disk
> [   33.581558]  sdp: unknown partition table
> [   33.581956] sd 3:0:0:0: [sdp] Cache data unavailable
> [   33.582079] sd 3:0:0:0: [sdp] Assuming drive cache: write through
> [   33.582244] sd 3:0:0:0: [sdp] Attached SCSI disk
> [   33.582900]  sds: unknown partition table
> [   33.583185] sd 3:0:3:0: [sds] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.583495] sd 3:0:3:0: [sds] Cache data unavailable
> [   33.583617] sd 3:0:3:0: [sds] Assuming drive cache: write through
> [   33.583775] sd 3:0:3:0: [sds] Attached SCSI disk
> [   33.585150]  sdr: unknown partition table
> [   33.585435] sd 3:0:2:0: [sdr] Very big device. Trying to use READ CAPA=
CITY(16).
> [   33.585703] sd 3:0:2:0: [sdr] Cache data unavailable
> [   33.585825] sd 3:0:2:0: [sdr] Assuming drive cache: write through
> [   33.585984] sd 3:0:2:0: [sdr] Attached SCSI disk
> [   33.838646] bio: create slab <bio-1> at 1
> [   36.281363] EXT4-fs (dm-11): mounted filesystem with ordered data mode=
. Opts: (null)
> [   37.026060] init: ureadahead main process (1382) terminated with statu=
s 5
> [   37.220943] Adding 1998844k swap on /dev/mapper/system-swap.  Priority=
:-1 extents:1 across:1998844k FS
> [   37.227324] EXT4-fs (dm-11): re-mounted. Opts: errors=3Dremount-ro
> [   37.296653] EXT4-fs (dm-14): mounted filesystem with ordered data mode=
. Opts: (null)
> [   37.304344] EXT4-fs (dm-12): mounted filesystem with ordered data mode=
. Opts: (null)
> [   37.312792] EXT4-fs (dm-13): mounted filesystem with ordered data mode=
. Opts: (null)
> [   37.322654] EXT4-fs (dm-16): mounted filesystem with ordered data mode=
. Opts: (null)
> [   37.401595] EXT4-fs (dm-15): mounted filesystem with ordered data mode=
. Opts: (null)
> [   37.416037] EXT4-fs (dm-10): mounted filesystem with ordered data mode=
. Opts: (null)
> [   37.424513] EXT4-fs (dm-9): mounted filesystem with ordered data mode.=
 Opts: (null)
> [   37.522841] kjournald starting.  Commit interval 5 seconds
> [   37.524134] EXT3-fs (sde): mounted filesystem with ordered data mode
> [   37.609197] kjournald starting.  Commit interval 5 seconds
> [   37.609776] EXT3-fs (sdf): mounted filesystem with ordered data mode
> [   37.725317] SGI XFS with ACLs, security attributes, realtime, large bl=
ock/inode numbers, no debug enabled
> [   37.730815] XFS (sdh): Mounting Filesystem
> [   37.877539] XFS (sdh): Ending clean mount
> [   37.885883] XFS (sdi): Mounting Filesystem
> [   38.037271] XFS (sdi): Ending clean mount
> [   38.044624] XFS (sdn): Mounting Filesystem
> [   38.185895] XFS (sdn): Starting recovery (logdev: internal)
> [   38.220130] XFS (sdn): Ending recovery (logdev: internal)
> [   38.228763] XFS (sdo): Mounting Filesystem
> [   38.385671] XFS (sdo): Ending clean mount
> [   38.410926] XFS (sdp): Mounting Filesystem
> [   38.419084] udevd[1582]: starting version 175
> [   38.424457] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   38.493726] lp: driver loaded but no devices found
> [   38.554485] XFS (sdp): Ending clean mount
> [   38.563173] XFS (dm-8): Mounting Filesystem
> [   38.600482] parport_pc 00:08: reported by Plug and Play ACPI
> [   38.600785] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> [   38.724915] lp0: using parport0 (interrupt-driven).
> [   38.725897] piix4_smbus 0000:00:07.3: Host SMBus controller not enable=
d!
> [   38.726589] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
.4
> [   38.727806] vmw_vmci 0000:00:07.7: Found VMCI PCI device at 0x11080, i=
rq 16
> [   38.727973] vmw_vmci 0000:00:07.7: Using capabilities 0xc
> [   38.728517] vmw_vmci 0000:00:07.7: irq 81 for MSI/MSI-X
> [   38.728673] vmw_vmci 0000:00:07.7: irq 82 for MSI/MSI-X
> [   38.729645] Guest personality initialized and is active
> [   38.729766] VMCI host device registered (name=3Dvmci, major=3D10, mino=
r=3D57)
> [   38.729770] Initialized host personality
> [   38.735106] XFS (dm-8): Ending clean mount
> [   38.743898] XFS (dm-5): Mounting Filesystem
> [   38.744508] [drm] Initialized drm 1.1.0 20060810
> [   38.830382] XFS (dm-5): Starting recovery (logdev: internal)
> [   38.830617] [drm] Capabilities:
> [   38.830622] [drm]   Rect copy.
> [   38.830624] [drm]   Cursor.
> [   38.830626] [drm]   Cursor bypass.
> [   38.830627] [drm]   Cursor bypass 2.
> [   38.830628] [drm]   8bit emulation.
> [   38.830630] [drm]   Alpha cursor.
> [   38.830631] [drm]   Extended Fifo.
> [   38.830632] [drm]   Multimon.
> [   38.830634] [drm]   Pitchlock.
> [   38.830635] [drm]   Irq mask.
> [   38.830636] [drm]   Display Topology.
> [   38.830637] [drm]   GMR.
> [   38.830639] [drm]   Traces.
> [   38.830640] [drm]   GMR2.
> [   38.830641] [drm]   Screen Object 2.
> [   38.830643] [drm] Max GMR ids is 64
> [   38.830645] [drm] Max GMR descriptors is 4096
> [   38.830647] [drm] Max number of GMR pages is 65536
> [   38.830649] [drm] Max dedicated hypervisor surface memory is 163840 kiB
> [   38.830652] [drm] VRAM at 0xec000000 size is 4096 kiB
> [   38.830654] [drm] MMIO at 0xfe000000 size is 256 kiB
> [   38.830657] [drm] global init.
> [   38.830849] [TTM] Zone  kernel: Available graphics memory: 12341824 kiB
> [   38.830852] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
> [   38.830854] [TTM] Initializing pool allocator
> [   38.830861] [TTM] Initializing DMA pool allocator
> [   38.831461] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [   38.831465] [drm] No driver support for vblank timestamp query.
> [   38.831569] [drm] Screen objects system initialized
> [   38.831577] [drm] Initialized vmwgfx 2.4.0 20120209 for 0000:00:0f.0 o=
n minor 0
> [   38.906606] XFS (dm-5): Ending recovery (logdev: internal)
> [   38.919089] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   38.936422] ppdev: user-space parallel port driver
> [   38.955546] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [   38.969046] type=3D1400 audit(1422542761.987:2): apparmor=3D"STATUS" o=
peration=3D"profile_load" parent=3D2626 profile=3D"unconfined" name=3D"/sbi=
n/dhclient" pid=3D2633 comm=3D"apparmor_parser"
> [   38.969054] type=3D1400 audit(1422542761.987:3): apparmor=3D"STATUS" o=
peration=3D"profile_load" parent=3D2626 profile=3D"unconfined" name=3D"/usr=
/lib/NetworkManager/nm-dhcp-client.action" pid=3D2633 comm=3D"apparmor_pars=
er"
> [   38.969060] type=3D1400 audit(1422542761.987:4): apparmor=3D"STATUS" o=
peration=3D"profile_load" parent=3D2626 profile=3D"unconfined" name=3D"/usr=
/lib/connman/scripts/dhclient-script" pid=3D2633 comm=3D"apparmor_parser"
> [   38.970162] type=3D1400 audit(1422542761.987:5): apparmor=3D"STATUS" o=
peration=3D"profile_replace" parent=3D2626 profile=3D"unconfined" name=3D"/=
usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D2633 comm=3D"apparmor_p=
arser"
> [   38.970170] type=3D1400 audit(1422542761.987:6): apparmor=3D"STATUS" o=
peration=3D"profile_replace" parent=3D2626 profile=3D"unconfined" name=3D"/=
usr/lib/connman/scripts/dhclient-script" pid=3D2633 comm=3D"apparmor_parser"
> [   38.970642] type=3D1400 audit(1422542761.987:7): apparmor=3D"STATUS" o=
peration=3D"profile_replace" parent=3D2626 profile=3D"unconfined" name=3D"/=
usr/lib/connman/scripts/dhclient-script" pid=3D2633 comm=3D"apparmor_parser"
> [   38.977921] type=3D1400 audit(1422542761.995:8): apparmor=3D"STATUS" o=
peration=3D"profile_replace" parent=3D2721 profile=3D"unconfined" name=3D"/=
sbin/dhclient" pid=3D2728 comm=3D"apparmor_parser"
> [   38.977930] type=3D1400 audit(1422542761.995:9): apparmor=3D"STATUS" o=
peration=3D"profile_replace" parent=3D2721 profile=3D"unconfined" name=3D"/=
usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D2728 comm=3D"apparmor_p=
arser"
> [   38.977936] type=3D1400 audit(1422542761.995:10): apparmor=3D"STATUS" =
operation=3D"profile_replace" parent=3D2721 profile=3D"unconfined" name=3D"=
/usr/lib/connman/scripts/dhclient-script" pid=3D2728 comm=3D"apparmor_parse=
r"
> [   38.978722] type=3D1400 audit(1422542761.995:11): apparmor=3D"STATUS" =
operation=3D"profile_replace" parent=3D2721 profile=3D"unconfined" name=3D"=
/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D2728 comm=3D"apparmor_=
parser"
> [   39.035980] kjournald starting.  Commit interval 5 seconds
> [   39.036971] EXT3-fs (dm-0): warning: maximal mount count reached, runn=
ing e2fsck is recommended
> [   39.074938] EXT3-fs (dm-0): using internal journal
> [   39.074943] EXT3-fs (dm-0): recovery complete
> [   39.074945] EXT3-fs (dm-0): mounted filesystem with ordered data mode
> [   39.078304] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   39.136699] kjournald starting.  Commit interval 5 seconds
> [   39.137369] EXT3-fs (dm-2): mounted filesystem with ordered data mode
> [   39.234445] EXT4-fs (dm-3): mounted filesystem with ordered data mode.=
 Opts: (null)
> [   39.281465] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i80=
42/serio1/input/input3
> [   39.292916] kjournald starting.  Commit interval 5 seconds
> [   39.293283] EXT3-fs (dm-1): mounted filesystem with ordered data mode
> [   39.300447] XFS (dm-4): Mounting Filesystem
> [   39.503001] XFS (dm-4): Starting recovery (logdev: internal)
> [   39.543025] XFS (dm-4): Ending recovery (logdev: internal)
> [   39.576811] vmxnet3 0000:03:00.0 eth0: intr type 3, mode 0, 9 vectors =
allocated
> [   39.578667] vmxnet3 0000:03:00.0 eth0: NIC Link is Up 10000 Mbps
> [   39.641213] [drm] width 640
> [   39.641232] [drm] height 480
> [   39.641247] [drm] bpp 32
> [   39.654571] [drm] Fifo max 0x00040000 min 0x00001000 cap 0x0000077f
> [   39.779577] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [   40.885658] [drm] width 640
> [   40.885677] [drm] height 480
> [   40.885692] [drm] bpp 32
> [   40.897965] [drm] Fifo max 0x00040000 min 0x00001000 cap 0x0000077f
> [   42.233323] [drm] width 640
> [   42.233343] [drm] height 480
> [   42.233358] [drm] bpp 32
> [   42.241586] [drm] Fifo max 0x00040000 min 0x00001000 cap 0x0000077f
> [   42.978835] EXT4-fs (dm-6): recovery complete
> [   42.978846] EXT4-fs (dm-6): mounted filesystem with ordered data mode.=
 Opts: (null)
> [   43.056777] EXT4-fs (dm-7): recovery complete
> [   43.056787] EXT4-fs (dm-7): mounted filesystem with ordered data mode.=
 Opts: (null)
> [   43.133681] init: failsafe main process (3023) killed by TERM signal
> [   43.167131] RPC: Registered named UNIX socket transport module.
> [   43.167137] RPC: Registered udp transport module.
> [   43.167139] RPC: Registered tcp transport module.
> [   43.167141] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   43.184154] FS-Cache: Loaded
> [   43.226717] FS-Cache: Netfs 'nfs' registered for caching
> [   43.304213] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [   43.655621] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state rec=
overy directory
> [   43.656328] NFSD: starting 90-second grace period (net ffffffff81cd238=
0)
> [   46.150181] dm-6: WRITE SAME failed. Manually zeroing.
> [   46.783418] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [   68.511716] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:50=
:56:b9:1f:61:08:00 SRC=3D192.168.128.15 DST=3D192.168.128.19 LEN=3D1500 TOS=
=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D44682 DF PROTO=3DTCP SPT=3D53920 DPT=3D39=
203 WINDOW=3D10069 RES=3D0x00 ACK URGP=3D0 =

> [  188.878603] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:50=
:56:b9:1f:61:08:00 SRC=3D192.168.128.15 DST=3D192.168.128.19 LEN=3D1500 TOS=
=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D44683 DF PROTO=3DTCP SPT=3D53920 DPT=3D39=
203 WINDOW=3D10069 RES=3D0x00 ACK URGP=3D0 =

> [ 6264.676983] list passed to list_sort() too long for efficiency
> [ 8228.777574] init: tty1 main process ended, respawning
> [15249.708067] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [15263.712072] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [18903.191011] nf_conntrack: automatic helper assignment is deprecated an=
d it will be removed soon. Use the iptables CT target to attach helpers ins=
tead.
> [22100.377762] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22108.380881] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22113.382893] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22120.384313] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22158.400443] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22163.400417] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22168.402342] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22185.410173] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22189.411150] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22201.417104] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22205.418717] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22209.864275] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22214.422190] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22218.423792] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22229.428090] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22236.430475] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> [22242.432504] [UFW BLOCK] IN=3Deth0 OUT=3D MAC=3D00:50:56:b9:14:92:00:00=
:00:00:00:00:08:00 SRC=3D10.0.0.0 DST=3D224.0.0.1 LEN=3D36 TOS=3D0x00 PREC=
=3D0x00 TTL=3D1 ID=3D0 PROTO=3D2 =

> =



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
