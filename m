Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5F2E8004
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 07:52:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF828304051
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 05:52:53 -0800 (PST)
Received: from mail-out2.booking.com (mail-out2.booking.com [62.190.24.21]) by
	cuda.sgi.com with ESMTP id q29HheejmQQeoOkS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Mar 2013 05:52:49 -0800 (PST)
Received: from corpds-202.lhr4.corp.booking.com ([10.186.68.14]:46159)
	by mtx-06.prod.lhr1.booking.com with esmtps
	(TLSv1:DHE-RSA-AES256-SHA:256) (Exim 4.80.1)
	(envelope-from <dennis.kaarsemaker@booking.com>) id 1UDEly-0006WE-TF
	for xfs@oss.sgi.com; Wed, 06 Mar 2013 14:52:46 +0100
Received: from [10.155.73.64] (port=51823)
	by corpds-202.lhr4.corp.booking.com with esmtpsa
	(TLSv1:DHE-RSA-CAMELLIA256-SHA:256) (Exim 4.80.1)
	(envelope-from <dennis.kaarsemaker@booking.com>) id 1UDEly-0005xU-N0
	for xfs@oss.sgi.com; Wed, 06 Mar 2013 14:52:46 +0100
Message-ID: <1362577992.1247.84.camel@seahawk>
Subject: Re: XFS IO multiplication problem on centos/rhel 6 using hp p420i
	raid controllers
From: Dennis Kaarsemaker <dennis.kaarsemaker@booking.com>
Date: Wed, 06 Mar 2013 14:53:12 +0100
In-Reply-To: <20130228194023.GQ5551@dastard>
References: <1362060736.1247.30.camel@seahawk> <20130228194023.GQ5551@dastard>
Content-Type: multipart/mixed; boundary="=-2o1faoBEooenegpWZfdA"
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--=-2o1faoBEooenegpWZfdA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2013-03-01 at 06:40 +1100, Dave Chinner wrote:
> On Thu, Feb 28, 2013 at 03:12:16PM +0100, Dennis Kaarsemaker wrote:
> > Hello XFS developers,
> > 
> > I have a problem as described in the subject. If I read the xfs website
> > correctly, this would be a place to ask for support with that problem.
> > Before I spam you all with details, please confirm if this is true or
> > direct me to a better place. Thanks!
> 
> CentOS/RHEL problems can be triaged up to a point here. i.e. we will
> make an effort to pinpoint the problem, but we give no guarantees
> and we definitely can't fix it. If you want a btter triage guarantee
> and to talk to someone who is able to fix the problem, you need to
> work through the problem with your RHEL support contact.

Hi Dave,

Thanks for responding. We have filed support tickets with HP and Red Hat
as well, I was trying to parallelize the search for an answer as the
problem is really getting in the way here. So much so that I've offered
a bottle of $favourite_drink on a serverfault question to the one who
solves it, that offer applies here too :)

> Either way:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

A summary of the problem is this:

[root@bc290bprdb-01 ~]# collectl
#<----CPU[HYPER]-----><----------Disks-----------><----------Network---------->
#cpu sys inter  ctxsw KBRead  Reads KBWrit Writes   KBIn  PktIn  KBOut  PktOut 
   1   0  1636   4219     16      1   2336    313    184    195     12     133 
   1   0  1654   2804     64      3   2919    432    391    352     20     208 

[root@bc291bprdb-01 ~]# collectl
#<----CPU[HYPER]-----><----------Disks-----------><----------Network---------->
#cpu sys inter  ctxsw KBRead  Reads KBWrit Writes   KBIn  PktIn  KBOut  PktOut 
   1   0  2220   3691    332     13  39992    331    112    122      6      92 
   0   0  1354   2708      0      0  39836    335    103    125      9      99 
   0   0  1563   3023    120      6  44036    369    399    317     13     188 

Notice the KBWrit difference. These are two identical hp gen 8 machines,
doing the same thing (replicating the same mysql schema). The one
writing ten times as many bytes in the same amount of transactions is
running centos 6 (and was running rhel 6).

Changing to gen7 hardware (hp p410 controller instead of p420), or to
centos 5 on newer hardware (older xfs version obviously) or using ext3
instead of xfs on either makes the writes "normal sized" again. We're
most likely doing something wrong with XFS but can't figure out what.

Any hint to get us moving in the right direction would be most helpful.

Now all the info asked for in that wikipage:

uname -a: Linux bc291bprdb-01.lhr4.prod.booking.com 2.6.32-279.1.1.el6.x86_64 #1 SMP Tue Jul 10 13:47:21 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

xfsprogs version: xfs_repair version 3.1.1

number of CPU's: 2 x 8-core hyperthreaded Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz

meminfo:

MemTotal:       99026008 kB
MemFree:          502692 kB
Buffers:          176964 kB
Cached:         44630620 kB
SwapCached:            0 kB
Active:         71178012 kB
Inactive:       24698980 kB
Active(anon):   48478524 kB
Inactive(anon):  2591228 kB
Active(file):   22699488 kB
Inactive(file): 22107752 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       1048312 kB
SwapFree:        1048312 kB
Dirty:              4740 kB
Writeback:             0 kB
AnonPages:      51069600 kB
Mapped:            32992 kB
Shmem:               184 kB
Slab:            1517096 kB
SReclaimable:    1444392 kB
SUnreclaim:        72704 kB
KernelStack:        6152 kB
PageTables:       105940 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    50561316 kB
Committed_AS:   87014212 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      483464 kB
VmallocChunk:   34308527752 kB
HardwareCorrupted:     0 kB
AnonHugePages:  49096704 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        8120 kB
DirectMap2M:     3102720 kB
DirectMap1G:    97517568 kB

mounts:

rootfs / rootfs rw 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
devtmpfs /dev devtmpfs rw,relatime,size=49503776k,nr_inodes=12375944,mode=755 0 0
devpts /dev/pts devpts rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /dev/shm tmpfs rw,relatime 0 0
/dev/mapper/sysvm-root / ext4 rw,relatime,barrier=1,stripe=192,data=ordered 0 0
/proc/bus/usb /proc/bus/usb usbfs rw,relatime 0 0
/dev/sda1 /boot ext4 rw,relatime,barrier=1,stripe=768,data=ordered 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
/dev/mapper/sysvm-mysqlVol /mysql/bp xfs rw,relatime,attr2,delaylog,allocsize=1024k,logbsize=256k,sunit=512,swidth=1536,noquota 0 0

raid layout:

hp p420i raid controller
7 x 600 GB SAS disk (HP EG0600FBLSH)
raid 1+0 with one hot spare

LVM: default red hat config (lvm.conf attached)
The raid array is partitioned into /boot swap and a PV for LVM
One volume group containing that PV
2 LV's: root and mysql. Root is ext4, mysql xfs

[root@bc291bprdb-01 ~]# lvdisplay 
  --- Logical volume ---
  LV Path                /dev/sysvm/root
  LV Name                root
  VG Name                sysvm
  LV UUID                2xXk8Q-gor3-Ql0S-EKI3-dA20-E9el-FH8eDX
  LV Write Access        read/write
  LV Creation host, time bc291bprdb-01.lhr4.prod.booking.com, 2013-02-28 09:36:01 +0100
  LV Status              available
  # open                 1
  LV Size                39.06 GiB
  Current LE             1250
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
   
  --- Logical volume ---
  LV Path                /dev/sysvm/mysqlVol
  LV Name                mysqlVol
  VG Name                sysvm
  LV UUID                v2yezw-Ry8i-wy2d-PjZD-QHeJ-refb-96oAH8
  LV Write Access        read/write
  LV Creation host, time bc291bprdb-01.lhr4.prod.booking.com, 2013-02-28 09:49:58 +0100
  LV Status              available
  # open                 1
  LV Size                300.00 GiB
  Current LE             9600
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

type of disks: see raid config

write cache status: no disk write cache but raid controller cache

size of bbwc and mode:
   Cache Board Present: True
   Cache Status: OK
   Accelerator Ratio: 10% Read / 90% Write
   Cache Backup Power Source: Capacitors
   Battery/Capacitor Count: 1
   Battery/Capacitor Status: OK

xfs_info:

[root@bc291bprdb-01 ~]# xfs_info /mysql/bp/
meta-data=/dev/mapper/sysvm-mysqlVol isize=256    agcount=16, agsize=4915136 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=78642176, imaxpct=25
         =                       sunit=64     swidth=192 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=38400, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


And for reference, xfs_info on centos 5:

[root@bc290bprdb-01 ~]# xfs_info /mysql/bp/
meta-data=/dev/sysvm/mysqlVol    isize=256    agcount=22, agsize=4915200 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=104857600, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

dmesg output: there are no errors on the filesystem or in dmesg

iostat/vmstat output: attached
-- 
Dennis Kaarsemaker, Systems Architect
Booking.com
Herengracht 597, 1017 CE Amsterdam
Tel external +31 (0) 20 715 3409
Tel internal (7207) 3409

--=-2o1faoBEooenegpWZfdA
Content-Disposition: attachment; filename="lvm.conf"
Content-Type: text/plain; name="lvm.conf"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

# This is an example configuration file for the LVM2 system.
# It contains the default settings that would be used if there was no
# /etc/lvm/lvm.conf file.
#
# Refer to 'man lvm.conf' for further information including the file layout.
#
# To put this file in a different directory and override /etc/lvm set
# the environment variable LVM_SYSTEM_DIR before running the tools.
#
# N.B. Take care that each setting only appears once if uncommenting
# example settings in this file.


# This section allows you to configure which block devices should
# be used by the LVM system.
devices {

    # Where do you want your volume groups to appear ?
    dir = "/dev"

    # An array of directories that contain the device nodes you wish
    # to use with LVM2.
    scan = [ "/dev" ]

    # If set, the cache of block device nodes with all associated symlinks
    # will be constructed out of the existing udev database content.
    # This avoids using and opening any inapplicable non-block devices or
    # subdirectories found in the device directory. This setting is applied
    # to udev-managed device directory only, other directories will be scanned
    # fully. LVM2 needs to be compiled with udev support for this setting to
    # take effect. N.B. Any device node or symlink not managed by udev in
    # udev directory will be ignored with this setting on.
    obtain_device_list_from_udev = 1

    # If several entries in the scanned directories correspond to the
    # same block device and the tools need to display a name for device,
    # all the pathnames are matched against each item in the following
    # list of regular expressions in turn and the first match is used.
    # preferred_names = [ ]

    # Try to avoid using undescriptive /dev/dm-N names, if present.
    preferred_names = [ "^/dev/mpath/", "^/dev/mapper/mpath", "^/dev/[hs]d" ]

    # A filter that tells LVM2 to only use a restricted set of devices.
    # The filter consists of an array of regular expressions.  These
    # expressions can be delimited by a character of your choice, and
    # prefixed with either an 'a' (for accept) or 'r' (for reject).
    # The first expression found to match a device name determines if
    # the device will be accepted or rejected (ignored).  Devices that
    # don't match any patterns are accepted.

    # Be careful if there there are symbolic links or multiple filesystem 
    # entries for the same device as each name is checked separately against
    # the list of patterns.  The effect is that if the first pattern in the 
    # list to match a name is an 'a' pattern for any of the names, the device
    # is accepted; otherwise if the first pattern in the list to match a name
    # is an 'r' pattern for any of the names it is rejected; otherwise it is
    # accepted.

    # Don't have more than one filter line active at once: only one gets used.

    # Run vgscan after you change this parameter to ensure that
    # the cache file gets regenerated (see below).
    # If it doesn't do what you expect, check the output of 'vgscan -vvvv'.


    # By default we accept every block device:
    filter = [ "a/.*/" ]

    # Exclude the cdrom drive
    # filter = [ "r|/dev/cdrom|" ]

    # When testing I like to work with just loopback devices:
    # filter = [ "a/loop/", "r/.*/" ]

    # Or maybe all loops and ide drives except hdc:
    # filter =[ "a|loop|", "r|/dev/hdc|", "a|/dev/ide|", "r|.*|" ]

    # Use anchors if you want to be really specific
    # filter = [ "a|^/dev/hda8$|", "r/.*/" ]

    # The results of the filtering are cached on disk to avoid
    # rescanning dud devices (which can take a very long time).
    # By default this cache is stored in the /etc/lvm/cache directory
    # in a file called '.cache'.
    # It is safe to delete the contents: the tools regenerate it.
    # (The old setting 'cache' is still respected if neither of
    # these new ones is present.)
    cache_dir = "/etc/lvm/cache"
    cache_file_prefix = ""

    # You can turn off writing this cache file by setting this to 0.
    write_cache_state = 1

    # Advanced settings.

    # List of pairs of additional acceptable block device types found 
    # in /proc/devices with maximum (non-zero) number of partitions.
    # types = [ "fd", 16 ]

    # If sysfs is mounted (2.6 kernels) restrict device scanning to 
    # the block devices it believes are valid.
    # 1 enables; 0 disables.
    sysfs_scan = 1

    # By default, LVM2 will ignore devices used as component paths
    # of device-mapper multipath devices.
    # 1 enables; 0 disables.
    multipath_component_detection = 1

    # By default, LVM2 will ignore devices used as components of
    # software RAID (md) devices by looking for md superblocks.
    # 1 enables; 0 disables.
    md_component_detection = 1

    # By default, if a PV is placed directly upon an md device, LVM2
    # will align its data blocks with the md device's stripe-width.
    # 1 enables; 0 disables.
    md_chunk_alignment = 1

    # Default alignment of the start of a data area in MB.  If set to 0,
    # a value of 64KB will be used.  Set to 1 for 1MiB, 2 for 2MiB, etc.
    # default_data_alignment = 1

    # By default, the start of a PV's data area will be a multiple of
    # the 'minimum_io_size' or 'optimal_io_size' exposed in sysfs.
    # - minimum_io_size - the smallest request the device can perform
    #   w/o incurring a read-modify-write penalty (e.g. MD's chunk size)
    # - optimal_io_size - the device's preferred unit of receiving I/O
    #   (e.g. MD's stripe width)
    # minimum_io_size is used if optimal_io_size is undefined (0).
    # If md_chunk_alignment is enabled, that detects the optimal_io_size.
    # This setting takes precedence over md_chunk_alignment.
    # 1 enables; 0 disables.
    data_alignment_detection = 1

    # Alignment (in KB) of start of data area when creating a new PV.
    # md_chunk_alignment and data_alignment_detection are disabled if set.
    # Set to 0 for the default alignment (see: data_alignment_default)
    # or page size, if larger.
    data_alignment = 0

    # By default, the start of the PV's aligned data area will be shifted by
    # the 'alignment_offset' exposed in sysfs.  This offset is often 0 but
    # may be non-zero; e.g.: certain 4KB sector drives that compensate for
    # windows partitioning will have an alignment_offset of 3584 bytes
    # (sector 7 is the lowest aligned logical block, the 4KB sectors start
    # at LBA -1, and consequently sector 63 is aligned on a 4KB boundary).
    # But note that pvcreate --dataalignmentoffset will skip this detection.
    # 1 enables; 0 disables.
    data_alignment_offset_detection = 1

    # If, while scanning the system for PVs, LVM2 encounters a device-mapper
    # device that has its I/O suspended, it waits for it to become accessible.
    # Set this to 1 to skip such devices.  This should only be needed
    # in recovery situations.
    ignore_suspended_devices = 0

    # During each LVM operation errors received from each device are counted.
    # If the counter of a particular device exceeds the limit set here, no
    # further I/O is sent to that device for the remainder of the respective
    # operation. Setting the parameter to 0 disables the counters altogether.
    disable_after_error_count = 0

    # Allow use of pvcreate --uuid without requiring --restorefile.
    require_restorefile_with_uuid = 1

    # Minimum size (in KB) of block devices which can be used as PVs.
    # In a clustered environment all nodes must use the same value.
    # Any value smaller than 512KB is ignored.

    # Ignore devices smaller than 2MB such as floppy drives.
    pv_min_size = 2048

    # The original built-in setting was 512 up to and including version 2.02.84.
    # pv_min_size = 512

    # Issue discards to a logical volumes's underlying physical volume(s) when
    # the logical volume is no longer using the physical volumes' space (e.g.
    # lvremove, lvreduce, etc).  Discards inform the storage that a region is
    # no longer in use.  Storage that supports discards advertise the protocol
    # specific way discards should be issued by the kernel (TRIM, UNMAP, or
    # WRITE SAME with UNMAP bit set).  Not all storage will support or benefit
    # from discards but SSDs and thinly provisioned LUNs generally do.  If set
    # to 1, discards will only be issued if both the storage and kernel provide
    # support.
    # 1 enables; 0 disables.
    issue_discards = 0
}

# This section allows you to configure the way in which LVM selects
# free space for its Logical Volumes.
#allocation {
#    When searching for free space to extend an LV, the "cling"
#    allocation policy will choose space on the same PVs as the last
#    segment of the existing LV.  If there is insufficient space and a
#    list of tags is defined here, it will check whether any of them are
#    attached to the PVs concerned and then seek to match those PV tags
#    between existing extents and new extents.
#    Use the special tag "@*" as a wildcard to match any PV tag.
#    
#    Example: LVs are mirrored between two sites within a single VG.
#    PVs are tagged with either @site1 or @site2 to indicate where
#    they are situated.
#
#    cling_tag_list = [ "@site1", "@site2" ]
#    cling_tag_list = [ "@*" ]
#
#    Changes made in version 2.02.85 extended the reach of the 'cling'
#    policies to detect more situations where data can be grouped
#    onto the same disks.  Set this to 0 to revert to the previous
#    algorithm.
#
#    maximise_cling = 1
#
#    Set to 1 to guarantee that mirror logs will always be placed on 
#    different PVs from the mirror images.  This was the default
#    until version 2.02.85.
#
#    mirror_logs_require_separate_pvs = 0
#
#    Set to 1 to guarantee that thin pool metadata will always
#    be placed on different PVs from the pool data.
#
#    thin_pool_metadata_require_separate_pvs = 0
#}

# This section that allows you to configure the nature of the
# information that LVM2 reports.
log {

    # Controls the messages sent to stdout or stderr.
    # There are three levels of verbosity, 3 being the most verbose.
    verbose = 0

    # Should we send log messages through syslog?
    # 1 is yes; 0 is no.
    syslog = 1

    # Should we log error and debug messages to a file?
    # By default there is no log file.
    #file = "/var/log/lvm2.log"

    # Should we overwrite the log file each time the program is run?
    # By default we append.
    overwrite = 0

    # What level of log messages should we send to the log file and/or syslog?
    # There are 6 syslog-like log levels currently in use - 2 to 7 inclusive.
    # 7 is the most verbose (LOG_DEBUG).
    level = 0

    # Format of output messages
    # Whether or not (1 or 0) to indent messages according to their severity
    indent = 1

    # Whether or not (1 or 0) to display the command name on each line output
    command_names = 0

    # A prefix to use before the message text (but after the command name,
    # if selected).  Default is two spaces, so you can see/grep the severity
    # of each message.
    prefix = "  "

    # To make the messages look similar to the original LVM tools use:
    #   indent = 0
    #   command_names = 1
    #   prefix = " -- "

    # Set this if you want log messages during activation.
    # Don't use this in low memory situations (can deadlock).
    # activation = 0
}

# Configuration of metadata backups and archiving.  In LVM2 when we
# talk about a 'backup' we mean making a copy of the metadata for the
# *current* system.  The 'archive' contains old metadata configurations.
# Backups are stored in a human readeable text format.
backup {

    # Should we maintain a backup of the current metadata configuration ?
    # Use 1 for Yes; 0 for No.
    # Think very hard before turning this off!
    backup = 1

    # Where shall we keep it ?
    # Remember to back up this directory regularly!
    backup_dir = "/etc/lvm/backup"

    # Should we maintain an archive of old metadata configurations.
    # Use 1 for Yes; 0 for No.
    # On by default.  Think very hard before turning this off.
    archive = 1

    # Where should archived files go ?
    # Remember to back up this directory regularly!
    archive_dir = "/etc/lvm/archive"

    # What is the minimum number of archive files you wish to keep ?
    retain_min = 10

    # What is the minimum time you wish to keep an archive file for ?
    retain_days = 30
}

# Settings for the running LVM2 in shell (readline) mode.
shell {

    # Number of lines of history to store in ~/.lvm_history
    history_size = 100
}


# Miscellaneous global LVM2 settings
global {

    # The file creation mask for any files and directories created.
    # Interpreted as octal if the first digit is zero.
    umask = 077

    # Allow other users to read the files
    #umask = 022

    # Enabling test mode means that no changes to the on disk metadata
    # will be made.  Equivalent to having the -t option on every
    # command.  Defaults to off.
    test = 0

    # Default value for --units argument
    units = "h"

    # Since version 2.02.54, the tools distinguish between powers of
    # 1024 bytes (e.g. KiB, MiB, GiB) and powers of 1000 bytes (e.g.
    # KB, MB, GB).
    # If you have scripts that depend on the old behaviour, set this to 0
    # temporarily until you update them.
    si_unit_consistency = 1

    # Whether or not to communicate with the kernel device-mapper.
    # Set to 0 if you want to use the tools to manipulate LVM metadata 
    # without activating any logical volumes.
    # If the device-mapper kernel driver is not present in your kernel
    # setting this to 0 should suppress the error messages.
    activation = 1

    # If we can't communicate with device-mapper, should we try running 
    # the LVM1 tools?
    # This option only applies to 2.4 kernels and is provided to help you
    # switch between device-mapper kernels and LVM1 kernels.
    # The LVM1 tools need to be installed with .lvm1 suffices
    # e.g. vgscan.lvm1 and they will stop working after you start using
    # the new lvm2 on-disk metadata format.
    # The default value is set when the tools are built.
    # fallback_to_lvm1 = 0

    # The default metadata format that commands should use - "lvm1" or "lvm2".
    # The command line override is -M1 or -M2.
    # Defaults to "lvm2".
    # format = "lvm2"

    # Location of proc filesystem
    proc = "/proc"

    # Type of locking to use. Defaults to local file-based locking (1).
    # Turn locking off by setting to 0 (dangerous: risks metadata corruption
    # if LVM2 commands get run concurrently).
    # Type 2 uses the external shared library locking_library.
    # Type 3 uses built-in clustered locking.
    # Type 4 uses read-only locking which forbids any operations that might 
    # change metadata.
    locking_type = 1

    # Set to 0 to fail when a lock request cannot be satisfied immediately.
    wait_for_locks = 1

    # If using external locking (type 2) and initialisation fails,
    # with this set to 1 an attempt will be made to use the built-in
    # clustered locking.
    # If you are using a customised locking_library you should set this to 0.
    fallback_to_clustered_locking = 1

    # If an attempt to initialise type 2 or type 3 locking failed, perhaps
    # because cluster components such as clvmd are not running, with this set
    # to 1 an attempt will be made to use local file-based locking (type 1).
    # If this succeeds, only commands against local volume groups will proceed.
    # Volume Groups marked as clustered will be ignored.
    fallback_to_local_locking = 1

    # Local non-LV directory that holds file-based locks while commands are
    # in progress.  A directory like /tmp that may get wiped on reboot is OK.
    locking_dir = "/var/lock/lvm"

    # Whenever there are competing read-only and read-write access requests for
    # a volume group's metadata, instead of always granting the read-only
    # requests immediately, delay them to allow the read-write requests to be
    # serviced.  Without this setting, write access may be stalled by a high
    # volume of read-only requests.
    # NB. This option only affects locking_type = 1 viz. local file-based
    # locking.
    prioritise_write_locks = 1

    # Other entries can go here to allow you to load shared libraries
    # e.g. if support for LVM1 metadata was compiled as a shared library use
    #   format_libraries = "liblvm2format1.so" 
    # Full pathnames can be given.

    # Search this directory first for shared libraries.
    #   library_dir = "/lib"

    # The external locking library to load if locking_type is set to 2.
    #   locking_library = "liblvm2clusterlock.so"

    # Treat any internal errors as fatal errors, aborting the process that
    # encountered the internal error. Please only enable for debugging.
    abort_on_internal_errors = 0

    # Check whether CRC is matching when parsed VG is used multiple times.
    # This is useful to catch unexpected internal cached volume group
    # structure modification. Please only enable for debugging.
    detect_internal_vg_cache_corruption = 0

    # If set to 1, no operations that change on-disk metadata will be permitted.
    # Additionally, read-only commands that encounter metadata in need of repair
    # will still be allowed to proceed exactly as if the repair had been 
    # performed (except for the unchanged vg_seqno).
    # Inappropriate use could mess up your system, so seek advice first!
    metadata_read_only = 0

    # 'mirror_segtype_default' defines which segtype will be used when the
    # shorthand '-m' option is used for mirroring.  The possible options are:
    #
    # "mirror" - The original RAID1 implementation provided by LVM2/DM.  It is
    # 	         characterized by a flexible log solution (core, disk, mirrored)
    #		 and by the necessity to block I/O while reconfiguring in the
    #		 event of a failure.
    #
    #		 There is an inherent race in the dmeventd failure handling
    #		 logic with snapshots of devices using this type of RAID1 that
    #		 in the worst case could cause a deadlock.
    #		   Ref: https://bugzilla.redhat.com/show_bug.cgi?id=817130#c10
    #
    # "raid1"  - This implementation leverages MD's RAID1 personality through
    # 	       	 device-mapper.  It is characterized by a lack of log options.
    #		 (A log is always allocated for every device and they are placed
    #		 on the same device as the image - no separate devices are
    #		 required.)  This mirror implementation does not require I/O
    #		 to be blocked in the kernel in the event of a failure.
    #		 This mirror implementation is not cluster-aware and cannot be
    #		 used in a shared (active/active) fashion in a cluster.
    #
    # Specify the '--type <mirror|raid1>' option to override this default
    # setting.
    mirror_segtype_default = "mirror"

    # The default format for displaying LV names in lvdisplay was changed 
    # in version 2.02.89 to show the LV name and path separately.
    # Previously this was always shown as /dev/vgname/lvname even when that
    # was never a valid path in the /dev filesystem.
    # Set to 1 to reinstate the previous format.
    #
    # lvdisplay_shows_full_device_path = 0

    # Whether to use (trust) a running instance of lvmetad. If this is set to
    # 0, all commands fall back to the usual scanning mechanisms. When set to 1
    # *and* when lvmetad is running (it is not auto-started), the volume group
    # metadata and PV state flags are obtained from the lvmetad instance and no
    # scanning is done by the individual commands. In a setup with lvmetad,
    # lvmetad udev rules *must* be set up for LVM to work correctly. Without
    # proper udev rules, all changes in block device configuration will be
    # *ignored* until a manual 'vgscan' is performed.
    use_lvmetad = 0
}

activation {
    # Set to 1 to perform internal checks on the operations issued to
    # libdevmapper.  Useful for debugging problems with activation.
    # Some of the checks may be expensive, so it's best to use this
    # only when there seems to be a problem.
    checks = 0

    # Set to 0 to disable udev synchronisation (if compiled into the binaries).
    # Processes will not wait for notification from udev.
    # They will continue irrespective of any possible udev processing
    # in the background.  You should only use this if udev is not running
    # or has rules that ignore the devices LVM2 creates.
    # The command line argument --nodevsync takes precedence over this setting.
    # If set to 1 when udev is not running, and there are LVM2 processes
    # waiting for udev, run 'dmsetup udevcomplete_all' manually to wake them up.
    udev_sync = 1

    # Set to 0 to disable the udev rules installed by LVM2 (if built with
    # --enable-udev_rules). LVM2 will then manage the /dev nodes and symlinks
    # for active logical volumes directly itself.
    # N.B. Manual intervention may be required if this setting is changed
    # while any logical volumes are active.
    udev_rules = 1

    # Set to 1 for LVM2 to verify operations performed by udev. This turns on
    # additional checks (and if necessary, repairs) on entries in the device
    # directory after udev has completed processing its events. 
    # Useful for diagnosing problems with LVM2/udev interactions.
    verify_udev_operations = 0

    # If set to 1 and if deactivation of an LV fails, perhaps because
    # a process run from a quick udev rule temporarily opened the device,
    # retry the operation for a few seconds before failing.
    retry_deactivation = 1

    # How to fill in missing stripes if activating an incomplete volume.
    # Using "error" will make inaccessible parts of the device return
    # I/O errors on access.  You can instead use a device path, in which 
    # case, that device will be used to in place of missing stripes.
    # But note that using anything other than "error" with mirrored 
    # or snapshotted volumes is likely to result in data corruption.
    missing_stripe_filler = "error"

    # The linear target is an optimised version of the striped target
    # that only handles a single stripe.  Set this to 0 to disable this
    # optimisation and always use the striped target.
    use_linear_target = 1

    # How much stack (in KB) to reserve for use while devices suspended
    # Prior to version 2.02.89 this used to be set to 256KB
    reserved_stack = 64

    # How much memory (in KB) to reserve for use while devices suspended
    reserved_memory = 8192

    # Nice value used while devices suspended
    process_priority = -18

    # If volume_list is defined, each LV is only activated if there is a
    # match against the list.
    #   "vgname" and "vgname/lvname" are matched exactly.
    #   "@tag" matches any tag set in the LV or VG.
    #   "@*" matches if any tag defined on the host is also set in the LV or VG
    #
    # volume_list = [ "vg1", "vg2/lvol1", "@tag1", "@*" ]

    # If read_only_volume_list is defined, each LV that is to be activated 
    # is checked against the list, and if it matches, it as activated
    # in read-only mode.  (This overrides '--permission rw' stored in the
    # metadata.)
    #   "vgname" and "vgname/lvname" are matched exactly.
    #   "@tag" matches any tag set in the LV or VG.
    #   "@*" matches if any tag defined on the host is also set in the LV or VG
    #
    # read_only_volume_list = [ "vg1", "vg2/lvol1", "@tag1", "@*" ]

    # Size (in KB) of each copy operation when mirroring
    mirror_region_size = 512

    # Setting to use when there is no readahead value stored in the metadata.
    #
    # "none" - Disable readahead.
    # "auto" - Use default value chosen by kernel.
    readahead = "auto"

    # 'raid_fault_policy' defines how a device failure in a RAID logical
    # volume is handled.  This includes logical volumes that have the following
    # segment types: raid1, raid4, raid5*, and raid6*.
    #
    # In the event of a failure, the following policies will determine what
    # actions are performed during the automated response to failures (when
    # dmeventd is monitoring the RAID logical volume) and when 'lvconvert' is
    # called manually with the options '--repair' and '--use-policies'.
    #
    # "warn"	- Use the system log to warn the user that a device in the RAID
    # 		  logical volume has failed.  It is left to the user to run
    #		  'lvconvert --repair' manually to remove or replace the failed
    #		  device.  As long as the number of failed devices does not
    #		  exceed the redundancy of the logical volume (1 device for
    #		  raid4/5, 2 for raid6, etc) the logical volume will remain
    #		  usable.
    #
    # "allocate" - Attempt to use any extra physical volumes in the volume
    # 		  group as spares and replace faulty devices.
    #
    raid_fault_policy = "warn"

    # 'mirror_image_fault_policy' and 'mirror_log_fault_policy' define
    # how a device failure affecting a mirror (of "mirror" segment type) is
    # handled.  A mirror is composed of mirror images (copies) and a log.
    # A disk log ensures that a mirror does not need to be re-synced
    # (all copies made the same) every time a machine reboots or crashes.
    #
    # In the event of a failure, the specified policy will be used to determine
    # what happens. This applies to automatic repairs (when the mirror is being
    # monitored by dmeventd) and to manual lvconvert --repair when
    # --use-policies is given.
    #
    # "remove" - Simply remove the faulty device and run without it.  If
    #            the log device fails, the mirror would convert to using
    #            an in-memory log.  This means the mirror will not
    #            remember its sync status across crashes/reboots and
    #            the entire mirror will be re-synced.  If a
    #            mirror image fails, the mirror will convert to a
    #            non-mirrored device if there is only one remaining good
    #            copy.
    #
    # "allocate" - Remove the faulty device and try to allocate space on
    #            a new device to be a replacement for the failed device.
    #            Using this policy for the log is fast and maintains the
    #            ability to remember sync state through crashes/reboots.
    #            Using this policy for a mirror device is slow, as it
    #            requires the mirror to resynchronize the devices, but it
    #            will preserve the mirror characteristic of the device.
    #            This policy acts like "remove" if no suitable device and
    #            space can be allocated for the replacement.
    #
    # "allocate_anywhere" - Not yet implemented. Useful to place the log device
    #            temporarily on same physical volume as one of the mirror
    #            images. This policy is not recommended for mirror devices
    #            since it would break the redundant nature of the mirror. This
    #            policy acts like "remove" if no suitable device and space can
    #            be allocated for the replacement.

    mirror_log_fault_policy = "allocate"
    mirror_image_fault_policy = "remove"

    # 'snapshot_autoextend_threshold' and 'snapshot_autoextend_percent' define
    # how to handle automatic snapshot extension. The former defines when the
    # snapshot should be extended: when its space usage exceeds this many
    # percent. The latter defines how much extra space should be allocated for
    # the snapshot, in percent of its current size.
    #
    # For example, if you set snapshot_autoextend_threshold to 70 and
    # snapshot_autoextend_percent to 20, whenever a snapshot exceeds 70% usage,
    # it will be extended by another 20%. For a 1G snapshot, using up 700M will
    # trigger a resize to 1.2G. When the usage exceeds 840M, the snapshot will
    # be extended to 1.44G, and so on.
    #
    # Setting snapshot_autoextend_threshold to 100 disables automatic
    # extensions. The minimum value is 50 (A setting below 50 will be treated
    # as 50).

    snapshot_autoextend_threshold = 100
    snapshot_autoextend_percent = 20

    # 'thin_pool_autoextend_threshold' and 'thin_pool_autoextend_percent' define
    # how to handle automatic pool extension. The former defines when the
    # pool should be extended: when its space usage exceeds this many
    # percent. The latter defines how much extra space should be allocated for
    # the pool, in percent of its current size.
    #
    # For example, if you set thin_pool_autoextend_threshold to 70 and
    # thin_pool_autoextend_percent to 20, whenever a pool exceeds 70% usage,
    # it will be extended by another 20%. For a 1G pool, using up 700M will
    # trigger a resize to 1.2G. When the usage exceeds 840M, the pool will
    # be extended to 1.44G, and so on.
    #
    # Setting thin_pool_autoextend_threshold to 100 disables automatic
    # extensions. The minimum value is 50 (A setting below 50 will be treated
    # as 50).

    thin_pool_autoextend_threshold = 100
    thin_pool_autoextend_percent = 20

    # Full path of the utility called to check that a thin metadata device
    # is in a state that allows it to be used.
    # Each time a thin pool needs to be activated, this utility is executed.
    # The activation will only proceed if the utility has an exit status of 0.
    # Set to "" to skip this check.  (Not recommended.)
    # The thin tools are available as part of the device-mapper-persistent-data
    # package from https://github.com/jthornber/thin-provisioning-tools.
    #
    thin_check_executable = "/usr/sbin/thin_check"

    # String with options passed with thin_check command. By default,
    # option '-q' is for quiet output.
    thin_check_options = [ "-q" ]

    # While activating devices, I/O to devices being (re)configured is
    # suspended, and as a precaution against deadlocks, LVM2 needs to pin
    # any memory it is using so it is not paged out.  Groups of pages that
    # are known not to be accessed during activation need not be pinned
    # into memory.  Each string listed in this setting is compared against
    # each line in /proc/self/maps, and the pages corresponding to any
    # lines that match are not pinned.  On some systems locale-archive was
    # found to make up over 80% of the memory used by the process.
    # mlock_filter = [ "locale/locale-archive", "gconv/gconv-modules.cache" ]

    # Set to 1 to revert to the default behaviour prior to version 2.02.62
    # which used mlockall() to pin the whole process's memory while activating
    # devices.
    use_mlockall = 0

    # Monitoring is enabled by default when activating logical volumes.
    # Set to 0 to disable monitoring or use the --ignoremonitoring option.
    monitoring = 1

    # When pvmove or lvconvert must wait for the kernel to finish
    # synchronising or merging data, they check and report progress
    # at intervals of this number of seconds.  The default is 15 seconds.
    # If this is set to 0 and there is only one thing to wait for, there
    # are no progress reports, but the process is awoken immediately the
    # operation is complete.
    polling_interval = 15
}


####################
# Advanced section #
####################

# Metadata settings
#
# metadata {
    # Default number of copies of metadata to hold on each PV.  0, 1 or 2.
    # You might want to override it from the command line with 0 
    # when running pvcreate on new PVs which are to be added to large VGs.

    # pvmetadatacopies = 1

    # Default number of copies of metadata to maintain for each VG.
    # If set to a non-zero value, LVM automatically chooses which of
    # the available metadata areas to use to achieve the requested
    # number of copies of the VG metadata.  If you set a value larger
    # than the the total number of metadata areas available then
    # metadata is stored in them all.
    # The default value of 0 ("unmanaged") disables this automatic
    # management and allows you to control which metadata areas
    # are used at the individual PV level using 'pvchange
    # --metadataignore y/n'.

    # vgmetadatacopies = 0

    # Approximate default size of on-disk metadata areas in sectors.
    # You should increase this if you have large volume groups or
    # you want to retain a large on-disk history of your metadata changes.

    # pvmetadatasize = 255

    # List of directories holding live copies of text format metadata.
    # These directories must not be on logical volumes!
    # It's possible to use LVM2 with a couple of directories here,
    # preferably on different (non-LV) filesystems, and with no other 
    # on-disk metadata (pvmetadatacopies = 0). Or this can be in
    # addition to on-disk metadata areas.
    # The feature was originally added to simplify testing and is not
    # supported under low memory situations - the machine could lock up.
    #
    # Never edit any files in these directories by hand unless you
    # you are absolutely sure you know what you are doing! Use
    # the supplied toolset to make changes (e.g. vgcfgrestore).

    # dirs = [ "/etc/lvm/metadata", "/mnt/disk2/lvm/metadata2" ]
#}

# Event daemon
#
dmeventd {
    # mirror_library is the library used when monitoring a mirror device.
    #
    # "libdevmapper-event-lvm2mirror.so" attempts to recover from
    # failures.  It removes failed devices from a volume group and
    # reconfigures a mirror as necessary. If no mirror library is
    # provided, mirrors are not monitored through dmeventd.

    mirror_library = "libdevmapper-event-lvm2mirror.so"

    # snapshot_library is the library used when monitoring a snapshot device.
    #
    # "libdevmapper-event-lvm2snapshot.so" monitors the filling of
    # snapshots and emits a warning through syslog when the use of
    # the snapshot exceeds 80%. The warning is repeated when 85%, 90% and
    # 95% of the snapshot is filled.

    snapshot_library = "libdevmapper-event-lvm2snapshot.so"

    # thin_library is the library used when monitoring a thin device.
    #
    # "libdevmapper-event-lvm2thin.so" monitors the filling of
    # pool and emits a warning through syslog when the use of
    # the pool exceeds 80%. The warning is repeated when 85%, 90% and
    # 95% of the pool is filled.

    thin_library = "libdevmapper-event-lvm2thin.so"

    # Full path of the dmeventd binary.
    #
    # executable = "/sbin/dmeventd"
}

--=-2o1faoBEooenegpWZfdA
Content-Disposition: attachment; filename="vmstat.rh5.txt"
Content-Type: text/plain; name="vmstat.rh5.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0     12 260348  44008 10917540    0    0     8   124    0    0  8  1 90  0  0
 0  0     12 259000  44020 10920880    0    0    22  4308 1747 4974  1  1 98  0  0
 0  0     12 258808  44024 10922932    0    0     3  3419 1687 4453  1  0 99  0  0
 0  0     12 254744  44036 10925876    0    0    37  3237 1545 2962  1  0 99  0  0
 0  0     12 253172  44044 10927272    0    0     3  2401 1686 4460  1  0 99  0  0
 0  0     12 251724  44052 10929436    0    0    48  3643 1545 3113  0  0 99  0  0
 0  0     12 251680  44060 10930668    0    0    19  2130 1673 4354  1  0 99  0  0
 1  0     12 248208  44076 10932328    0    0    18  2879 1544 3201  1  1 98  0  0
 1  0     12 245156  44088 10935136    0    0    19 12653 1794 4943  5  0 95  0  0
 0  0     12 243324  44092 10938956    0    0    38  3929 1575 2785  1  0 98  1  0
 0  0     12 250824  44076 10930140    0    0    22  3346 1670 4509  1  0 99  0  0
 0  0     12 250964  44092 10932452    0    0    85  4113 1591 2816  0  0 99  0  0

--=-2o1faoBEooenegpWZfdA
Content-Disposition: attachment; filename="iostat.rh5.txt"
Content-Type: text/plain; name="iostat.rh5.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Linux 2.6.18-308.el5 (bc290bprdb-01.lhr4.prod.booking.com) 	03/06/2013

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        6.95    27.09  7.72 270.96     0.19     2.90    22.71     0.07    0.25   0.22   6.00
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00    47.62     0.00    1.69   1.61   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00    14.40     0.00    4.07   4.06   0.00
cciss/c0d0p3      6.94    27.09  7.72 270.96     0.19     2.90    22.71     0.07    0.25   0.22   6.00
dm-0              0.00     0.00  0.45 32.85     0.01     0.13     8.34     0.02    0.49   0.07   0.24
dm-1              0.00     0.00  6.97 264.13     0.15     2.77    22.10     0.07    0.24   0.22   5.93

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    22.40  0.80 334.40     0.01     2.75    16.89     0.02    0.06   0.06   2.02
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    22.40  0.80 334.40     0.01     2.75    16.89     0.02    0.06   0.06   2.02
dm-0              0.00     0.00  0.00 27.20     0.00     0.11     8.00     0.00    0.03   0.01   0.04
dm-1              0.00     0.00  0.80 329.60     0.01     2.65    16.47     0.02    0.06   0.06   1.96

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    25.80  0.60 275.60     0.01     2.13    15.89     0.02    0.06   0.05   1.44
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    25.80  0.60 275.60     0.01     2.13    15.89     0.02    0.06   0.05   1.44
dm-0              0.00     0.00  0.00 28.80     0.00     0.11     8.00     0.00    0.10   0.03   0.08
dm-1              0.00     0.00  0.60 272.60     0.01     2.02    15.23     0.01    0.05   0.05   1.36

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    89.22 13.37 389.82     0.21     3.26    17.60     0.10    0.25   0.24   9.72
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    89.22 13.37 389.82     0.21     3.26    17.60     0.10    0.25   0.24   9.72
dm-0              0.00     0.00  0.00 122.95     0.00     0.48     8.00     0.03    0.25   0.02   0.22
dm-1              0.00     0.00 13.37 356.09     0.21     2.78    16.54     0.10    0.26   0.26   9.68

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    14.80  1.20 303.60     0.02     2.88    19.48     0.02    0.07   0.06   1.76
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    14.80  1.20 303.60     0.02     2.88    19.48     0.02    0.07   0.06   1.76
dm-0              0.00     0.00  0.00 18.40     0.00     0.07     8.00     0.00    0.21   0.05   0.10
dm-1              0.00     0.00  1.20 300.00     0.02     2.81    19.22     0.02    0.07   0.06   1.74

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    38.20  1.00 339.80     0.02     2.91    17.55     0.02    0.05   0.05   1.82
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    38.20  1.00 339.80     0.02     2.91    17.55     0.02    0.05   0.05   1.82
dm-0              0.00     0.00  0.00 43.00     0.00     0.17     8.00     0.01    0.33   0.02   0.08
dm-1              0.00     0.00  1.00 335.00     0.02     2.74    16.78     0.02    0.05   0.05   1.80

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    17.20  0.20 296.40     0.00     2.16    14.96     0.01    0.05   0.04   1.22
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    17.20  0.20 296.40     0.00     2.16    14.96     0.01    0.05   0.04   1.22
dm-0              0.00     0.00  0.00 20.80     0.00     0.08     8.00     0.02    0.92   0.06   0.12
dm-1              0.00     0.00  0.20 292.80     0.00     2.08    14.58     0.01    0.04   0.04   1.18

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    16.80  1.60 309.20     0.02     2.62    17.42     0.02    0.07   0.06   1.90
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    16.80  1.60 309.20     0.02     2.62    17.42     0.02    0.07   0.06   1.90
dm-0              0.00     0.00  0.00 21.00     0.00     0.08     8.00     0.00    0.14   0.03   0.06
dm-1              0.00     0.00  1.60 305.00     0.02     2.54    17.11     0.02    0.06   0.06   1.78

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    35.20  3.00 309.20     0.05     2.27    15.20     0.03    0.11   0.10   3.20
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    35.20  3.00 309.20     0.05     2.27    15.20     0.03    0.11   0.10   3.20
dm-0              0.00     0.00  0.00 40.20     0.00     0.16     8.00     0.02    0.48   0.02   0.10
dm-1              0.00     0.00  3.00 304.20     0.05     2.11    14.40     0.03    0.10   0.10   3.16

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    29.80  0.80 325.60     0.01     2.76    17.37     0.01    0.04   0.04   1.44
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    29.80  0.80 325.60     0.01     2.76    17.37     0.01    0.04   0.04   1.44
dm-0              0.00     0.00  0.00 35.60     0.00     0.14     8.00     0.00    0.02   0.01   0.04
dm-1              0.00     0.00  0.80 319.80     0.01     2.62    16.79     0.01    0.05   0.05   1.48

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    81.00  1.40 311.40     0.02     2.53    16.73     0.03    0.10   0.10   3.00
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    81.00  1.40 311.40     0.02     2.53    16.73     0.03    0.10   0.10   3.00
dm-0              0.00     0.00  0.00 114.00     0.00     0.45     8.00     0.04    0.34   0.01   0.16
dm-1              0.00     0.00  1.40 278.40     0.02     2.09    15.45     0.03    0.11   0.11   2.94

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
cciss/c0d0        0.00    39.00 15.40 334.80     0.24     3.38    21.17     0.11    0.31   0.28   9.72
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
cciss/c0d0p3      0.00    39.00 15.40 334.80     0.24     3.38    21.17     0.11    0.31   0.28   9.72
dm-0              0.00     0.00  0.00 43.80     0.00     0.17     8.00     0.02    0.41   0.04   0.16
dm-1              0.00     0.00 15.40 330.00     0.24     3.21    20.45     0.11    0.31   0.28   9.56


--=-2o1faoBEooenegpWZfdA
Content-Disposition: attachment; filename="vmstat.rh6.txt"
Content-Type: text/plain; name="vmstat.rh6.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  0      0 502436 176348 44540116    0    0    10  1223    5    1  1  0 99  0  0	
 1  0      0 497348 176352 44541280    0    0   142 58031 2661 4424  3  0 97  0  0	
 1  0      0 486996 176360 44543584    0    0   105 43446 2563 3963  1  0 98  0  0	
 0  0      0 487388 176364 44545004    0    0   144 47756 1235 2889  0  0 99  0  0	
 0  0      0 481700 176372 44546044    0    0    87 40935 1719 3091  0  0 99  0  0	
 0  0      0 483400 176376 44546948    0    0    95 44988 1366 3021  0  0 99  0  0	
 0  0      0 484440 176376 44547944    0    0    16 33223  929 2255  0  0 100  0  0	
 0  0      0 483852 176380 44549140    0    0   186 40805 1288 2661  0  0 99  0  0	
 0  0      0 487676 176380 44544424    0    0   134 36696 2530 3300  0  1 99  0  0	
 2  0      0 487456 176380 44545240    0    0    40 35708 1589 3353  2  0 98  0  0	
 1  0      0 486604 176380 44546864    0    0   106 56364 1855 3779  2  0 98  0  0	
 0  0      0 485236 176380 44547916    0    0    63 41737 1310 2801  0  0 99  0  0	

--=-2o1faoBEooenegpWZfdA
Content-Disposition: attachment; filename="iostat.rh6.txt"
Content-Type: text/plain; name="iostat.rh6.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Linux 2.6.32-279.1.1.el6.x86_64 (bc291bprdb-01.lhr4.prod.booking.com) 	03/06/2013 	_x86_64_	(32 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.06   355.36   14.52  337.78     0.32    38.17   223.75     0.28    0.81   0.28   9.79
dm-0              0.00     0.00    0.39   17.27     0.01     0.07     8.86     0.03    1.50   0.07   0.13
dm-1              0.00     0.00   14.14  675.89     0.31    38.11   114.01     1.41    2.04   0.14   9.76

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     3.60    6.00  374.40     0.06    44.18   238.17     0.11    0.28   0.16   6.08
dm-0              0.00     0.00    0.00    4.40     0.00     0.02     8.00     0.00    0.27   0.18   0.08
dm-1              0.00     0.00    6.00  373.20     0.06    44.11   238.56     0.11    0.28   0.16   6.04

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     1.80    8.40  307.00     0.07    35.49   230.89     0.11    0.33   0.18   5.58
dm-0              0.00     0.00    0.00    5.20     0.00     0.02     8.00     0.00    0.04   0.04   0.02
dm-1              0.00     0.00    8.40  304.00     0.07    35.52   233.31     0.11    0.34   0.18   5.64

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00    36.60    1.80  339.60     0.02    39.29   235.83     0.08    0.23   0.16   5.54
dm-0              0.00     0.00    0.00   40.60     0.00     0.16     8.00     0.25    6.11   0.03   0.14
dm-1              0.00     0.00    1.80  335.20     0.02    39.08   237.64     0.06    0.18   0.16   5.44

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00    11.20    7.20  297.20     0.07    34.37   231.68     0.08    0.25   0.15   4.66
dm-0              0.00     0.00    0.00   13.60     0.00     0.05     8.00     0.01    0.51   0.03   0.04
dm-1              0.00     0.00    7.20  294.80     0.07    34.31   233.16     0.08    0.25   0.16   4.70

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00    21.80   72.20  401.20     0.90    46.25   203.97     0.64    1.35   0.34  15.86
dm-0              0.00     0.00    0.00   24.60     0.00     0.10     8.00     0.01    0.27   0.02   0.04
dm-1              0.00     0.00   72.20  398.40     0.90    46.15   204.77     0.64    1.36   0.34  15.96

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     8.60    0.80  314.60     0.01    36.05   234.19     0.05    0.17   0.15   4.80
dm-0              0.00     0.00    0.00   13.80     0.00     0.05     8.00     0.00    0.23   0.01   0.02
dm-1              0.00     0.00    0.80  309.40     0.01    36.00   237.76     0.05    0.16   0.16   4.82

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     8.40   11.60  326.20     0.08    38.22   232.19     0.19    0.56   0.23   7.62
dm-0              0.00     0.00    0.00   16.80     0.00     0.07     8.00     0.00    0.01   0.01   0.02
dm-1              0.00     0.00   11.60  318.40     0.08    38.21   237.62     0.19    0.58   0.23   7.70

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     3.20    1.80  304.00     0.03    34.85   233.55     0.05    0.18   0.15   4.54
dm-0              0.00     0.00    0.00    6.20     0.00     0.02     8.00     0.00    0.26   0.16   0.10
dm-1              0.00     0.00    1.80  300.40     0.03    34.77   235.79     0.05    0.18   0.15   4.56

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     5.60   15.00  354.60     0.18    41.34   230.08     0.17    0.47   0.26   9.64
dm-0              0.00     0.00    0.00    7.00     0.00     0.03     8.00     0.00    0.23   0.17   0.12
dm-1              0.00     0.00   15.00  353.20     0.18    41.31   230.81     0.18    0.48   0.26   9.62

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00    47.00    4.20  315.40     0.02    36.54   234.33     0.09    0.29   0.19   6.08
dm-0              0.00     0.00    0.00   52.60     0.00     0.21     8.00     0.01    0.26   0.01   0.06
dm-1              0.00     0.00    4.20  309.80     0.02    36.34   237.17     0.09    0.29   0.19   6.08

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     6.00    7.40  337.60     0.15    38.87   231.63     0.11    0.31   0.23   7.96
dm-0              0.00     0.00    0.00    8.40     0.00     0.03     8.00     0.00    0.02   0.02   0.02
dm-1              0.00     0.00    7.40  335.20     0.15    38.84   233.06     0.11    0.31   0.23   8.00


--=-2o1faoBEooenegpWZfdA
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-2o1faoBEooenegpWZfdA--
