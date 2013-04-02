Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 189C97F75
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 13:17:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC0EF304082
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 11:17:40 -0700 (PDT)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id GctpTGMIyvgXOLKn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 11:17:39 -0700 (PDT)
Message-ID: <515B20B5.10007@tlinx.org>
Date: Tue, 02 Apr 2013 11:17:25 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: FYI: better workaround for updating 'df' info after 'rm' on
	xfs-vols
References: <512C12B5.3070908@tlinx.org> <20130226045038.GN5551@dastard>
In-Reply-To: <20130226045038.GN5551@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> On Mon, Feb 25, 2013 at 05:41:09PM -0800, Linda Walsh wrote:
>> Some time ago I reported that after I deleted
>> some large amount of space from one of my xfs volumes,
>> 'df' still showed the original, pre-delete space, though
>> 'du' only showed the expected amount.
> 
> Sure, because unlinked files might not have their second phase of
> processing (which releases the disk space) done immediately.
> 
>> Mentioned that I had tried 'sync' to no avail, and had
>> only found umount/mount to cause the figures to synchronize.
> 
> sync doesn't cause unlinked inodes to be reclaimed and processed,
> unlike remount,ro, unmount or freeze.
> 
>> Someone suggested cat [1|3] >/proc/sys/vm/drop_caches.
> 
> echo, not cat. It does work every time, whether you see anything
> obvious or not. And if you want to reclaim inodes, then you want
> "echo 2 > ..."
> 
>>  xfs_mount -o remount,ro + rw
>> seemed to do the trick and cause the disk space to update without
>> me having to stop processes with FD's open on the vol.
> 
> freeze/thaw should do what you want without affecting anything
> running on the fs at all.
----
	It doesn't work at al.

.... I've deleted off 2.4T from an 11T volume in about 15 files.
du reflects the actions:

Ishtar:/backups> du -sxh /backups/
9.6T    /backups/
Ishtar:/backups> df .

df does not:

Filesystem                   Size  Used Avail Use% Mounted on
/dev/mapper/Backups-Backups   11T   11T   14G 100% /backups

Any stats you want to debug this?
Ishtar:/backups> xfs_info /backups
meta-data=/dev/mapper/Backups-Backups isize=256    agcount=11, agsize=268435440 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2929458176, imaxpct=5
         =                       sunit=16     swidth=96 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
----
   from      to extents  blocks    pct
      1       1     861     861   0.02
      2       3    1424    3587   0.10
      4       7     913    3785   0.10
     16      31       2      52   0.00
    512    1023       2    1164   0.03
   1024    2047       1    1833   0.05
   2048    4095       2    5972   0.17
   8192   16383       1    8688   0.24
  32768   65535       2   94647   2.62
  65536  131071       2  190992   5.29
 262144  524287       3 1230194  34.10
1048576 2097151       1 2066103  57.27
total free extents 3214
total free blocks 3607878      ### well at 4k/block, that's 1.4T which is about
right
average free extent size 1122.55
xfs_db> q
So why df
Ishtar:/backups> df .
Filesystem                   Size  Used Avail Use% Mounted on
/dev/mapper/Backups-Backups   11T   11T   14G 100% /backups
Ishtar:law/test> mount -l|grep backups
/dev/mapper/Backups-Backups on /backups type xfs
(rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=131072k,logbsize=256k,sunit=128,swidth=768,noquota)
[Backups]
--- reality check -- swidth DOES mean total width, right?  i.e. 768/128 = 6
disks wide which is a
correct number of data disks in the array.

BTW, I'm wondering if my alignment is important or correct on it:
parted -l on the volume shows:
Disk /dev/sdb: 12.0TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt_sync_mbr

Number  Start   End     Size    File system  Name    Flags
 1      17.4kB  12.0TB  12.0TB               backup  lvm
(i.e. it's not starting @ 0)
sudo pvs /dev/sdb1 -o +pe_start,pvseg_start
  PV         VG      Fmt  Attr PSize  PFree 1st PE  Start
  /dev/sdb1  Backups lvm2 a--  10.91t    0  512.00k     0
sudo vgs Backups -o +vg_mda_size,vg_mda_copies,vg_extent_size
  VG      #PV #LV #SN Attr   VSize  VFree VMdaSize  #VMdaCps  Ext
  Backups   1   1   0 wz--n- 10.91t    0    188.00k unmanaged 4.00m

my system's xfs settings:

Ishtar:/proc/sys/fs/xfs> for i in *
do
printf "%30s: %-10s\n" "$i" $(<"$i")
done
          age_buffer_centisecs: 1500
                   error_level: 3
          filestream_centisecs: 3000
               inherit_noatime: 1
              inherit_nodefrag: 1
                inherit_nodump: 1
            inherit_nosymlinks: 0
                  inherit_sync: 1
             irix_sgid_inherit: 0
             irix_symlink_mode: 0
                    panic_mask: 0
                     rotorstep: 1
 speculative_prealloc_lifetime: 300
                   stats_clear: 0
             xfsbufd_centisecs: 100
            xfssyncd_centisecs: 3000
---------------

Also I don't understand.  does irix_sgid_inherit mean something other than
directories created in a dir with the sgid bit set also get it set with the
same group ownership?

As I just tested it .. made a dir set the group & chmod g+s.. made a dir in
it, and it got created w/same group and w/sgid bit set.
But looking at the above, I'd think the sgid bit wasn't supposed to
be inherited...(I can go look it up, but just looked strange).

----
In the ~54 minutes it took to write this:
> df /backups
Filesystem                   Size  Used Avail Use% Mounted on
/dev/mapper/Backups-Backups   11T   11T   14G 100% /backups





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
