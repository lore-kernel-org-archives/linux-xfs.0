Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q82GD6Mp053191 for <xfs@oss.sgi.com>; Sun, 2 Sep 2012 11:13:06 -0500
Received: from bosmailout18.eigbox.net (bosmailout18.eigbox.net
	[66.96.185.18]) by cuda.sgi.com with ESMTP id c08VIV1unGxA3w6G
	for <xfs@oss.sgi.com>; Sun, 02 Sep 2012 09:13:59 -0700 (PDT)
Received: from bosmailscan07.eigbox.net ([10.20.15.7])
	by bosmailout18.eigbox.net with esmtp (Exim) id 1T8CoB-0003kN-68
	for xfs@oss.sgi.com; Sun, 02 Sep 2012 12:13:59 -0400
Message-ID: <0a1f3a3e331f28a9fb81973dc0893fb5.squirrel@emailmg.netfirms.com>
Date: Mon, 3 Sep 2012 00:13:05 +0800
Subject: Re: XFS Mount Recovery Failed on Root File System After Power     
	Outage
From: "Chin Gim Leong" <CHIN_Gim_Leong@performance-computing.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20120903001305_82642"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

------=_20120903001305_82642
Content-Type: multipart/alternative;
 boundary="8601fsu_trap_24628_50310030902102_=----"

--8601fsu_trap_24628_50310030902102_=----
Content-Type: text/plain
Content-Transfer-Encoding: 8bit





Hi Dave

I did the "xfs_repair -L" on the root file
system; xfs_repair is version 3.1.8.  The repair was successful.

> You misunderstood. I was asking for the messages when it
>
successfully mounts and the contents of /proc/mounts is when it is
mounted to see if barriers were disabled or not supported on your
hardware.
> 
The notebook is Acer Aspire 6530G, AMD Turion
X2 RM-74, chipset is AMD M780G, southbridge is AMD SB 700.  The hard drive
is Western Digital Scorpio Black SATA 320 GB, WDC WD3200BEKT-00F3T0,
/dev/sdb
chingl@rat:~> cat
/etc/fstab                                                                                                                                                                   

/dev/disk/by-path/pci-0000:00:11.0-scsi-1:0:0:0-part1
swap                 swap       defaults              0
0                                                                                

/dev/disk/by-path/pci-0000:00:11.0-scsi-1:0:0:0-part2
/                    xfs       
defaults,logbufs=8,logbsize=256k              1
1                                                         
/dev/disk/by-path/pci-0000:00:11.0-scsi-1:0:0:0-part3
/home                xfs       
defaults,logbufs=8,logbsize=256k              1 2
/dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part2
/windows/C           ntfs-3g   
users,gid=users,fmask=133,dmask=022,locale=en_US.UTF-8 0 0
/dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part3 /windows/D          
ntfs-3g    users,gid=users,fmask=133,dmask=022,locale=en_US.UTF-8 0 0
proc                 /proc                proc       defaults             
0 0
sysfs                /sys                 sysfs     
noauto                0 0
debugfs              /sys/kernel/debug   
debugfs    noauto                0 0
usbfs               
/proc/bus/usb        usbfs      noauto                0 0
devpts               /dev/pts             devpts    
mode=0620,gid=5       0 0
chingl@rat:~>
chingl@rat:~> cat
/proc/mounts 
rootfs / rootfs rw 0 0
devtmpfs /dev devtmpfs
rw,relatime,size=1761184k,nr_inodes=440296,mode=755 0 0
tmpfs
/dev/shm tmpfs rw,relatime 0 0
devpts /dev/pts devpts
rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
/dev/sdb2 / xfs
rw,relatime,attr2,logbufs=8,logbsize=256k,noquota 0 0 proc /proc proc
rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
debugfs
/sys/kernel/debug debugfs rw,relatime 0 0
/dev/sdb3 /home xfs
rw,relatime,attr2,logbufs=8,logbsize=256k,noquota 0 0
 fusectl
/sys/fs/fuse/connections fusectl rw,relatime 0 0
securityfs
/sys/kernel/security securityfs rw,relatime 0 0
none
/proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
none
/var/lib/ntp/proc proc ro,nosuid,nodev,relatime 0 0
gvfs-fuse-daemon
/home/chingl/.gvfs fuse.gvfs-fuse-daemon
rw,nosuid,nodev,relatime,user_id=1000,group_id=100 0 0
chingl@rat:~>
>From /var/log/boot.msg:

 
<6>[    1.084085] ata3: SATA link down (SStatus 0 SControl 300)
  <6>[    1.084172] ata4: SATA link down (SStatus 0 SControl
300)
  <3>[    1.256058] ata2: softreset failed (device not
ready)
  <4>[    1.256067] ata2: applying SB600 PMP SRST
workaround and retrying   <3>[    1.256084] ata1: softreset failed
(device not ready)
  <4>[    1.256095] ata1: applying SB600 PMP
SRST workaround and retrying   <6>[    1.428069] ata2: SATA link up
3.0 Gbps (SStatus 123 SControl 300)   <6>[    1.428097] ata1: SATA
link up 3.0 Gbps (SStatus 123 SControl 300)   <6>[    1.429454]
ata1.00: ATA-8: Hitachi HTS543232L9A300, FB4OC40C, max UDMA/133
 
<6>[    1.429458] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ
(depth 31/32), AA
  <6>[    1.430923] ata1.00: configured for
UDMA/133
  <5>[    1.431164] scsi 0:0:0:0: Direct-Access    
ATA      Hitachi HTS54323 FB4O PQ: 0 ANSI: 5
  <5>[   
1.431560] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298
GiB)
  <5>[    1.431672] sd 0:0:0:0: [sda] Write Protect is
off
  <7>[    1.431675] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00
00
  <5>[    1.431915] sd 0:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
  <6>[   
1.441064] ata2.00: ATA-8: WDC WD3200BEKT-00F3T0, 11.01A11, max UDMA/133
  <6>[    1.441067] ata2.00: 625142448 sectors, multi 16: LBA48
NCQ (depth 31/32), AA
  <6>[    1.442978] ata2.00: configured
for UDMA/133
  <5>[    1.443207] scsi 1:0:0:0:
Direct-Access     ATA      WDC
WD3200BEKT-0 11.0 PQ: 0 ANSI: 5
 
<5>[    1.443387] sd 1:0:0:0: [sdb] 625142448 512-byte logical
blocks: (320 GB/298 GiB)
  <5>[    1.443707] sd 1:0:0:0: [sdb]
Write Protect is off
  <7>[    1.443710] sd 1:0:0:0: [sdb] Mode
Sense: 00 3a 00 00
  <5>[    1.443756] sd 1:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
 
<6>[    1.459438]  sda: sda1 sda2 sda3 sda4
  <5>[   
1.460197] sd 0:0:0:0: [sda] Attached SCSI disk
  <6>[   
1.476394] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x12a0b1, caps:
0xa04711/0xa04000/0x0
  <6>[    1.481898]  sdb: sdb1 sdb2
sdb3
  <5>[    1.482254] sd 1:0:0:0: [sdb] Attached SCSI
disk



  <6>[    3.201111] SGI XFS with ACLs,
security attributes, realtime, large block/inode numbers, no debug
enabled
  <6>[    3.202279] SGI XFS Quota Management
subsystem
  <5>[    3.230174] XFS mounting filesystem sdb2
  <7>[    3.351323] Ending clean XFS mount for filesystem: sdb2

  <5>[   11.865393] XFS mounting filesystem sdb3
 
<7>[   12.008707] Ending clean XFS mount for filesystem: sdb3

I do not see anything that says barrier is not supported?


> Only by looking at them can you know. Regardless of what
filesystem you
are using, recovery of files and directories from
lost+found is the same process. e.g. do an rpm check to see if allteh
installed packages are intact. that will narrow down where all your
binaries came from. use of strings can also tell you what the binary is.
e.g:

> Define "really there" when important
metadata (i.e. the log) has been
corrupted and is not available any
more.  Indeed, if things like btree splits of merges occurred in the log,
and they are
> partially written to disk, it's entirely possible
that you could lose
directory references to inodes that haven't been
modified for some time....
> 
> Remember, like all fsck
programs, xfs_repair is a best effort
> attempt at correcting the
problems found  - there are no guarantees
given about what it can and
can't recover when it runs...
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 

Looking at the messages from xfs_repair, and inspection of /lost+found,
the files in it are from /tmp and
/etc/NetworkManager/system-connections/Auto eth0 (a session file). I
think one of the index.db in /var/cache/man was also affected.

I did a "rpm -V -a", thanks for the advice.  I manually
inspected every output, paying attention to the missing files and file
size or checksum mismatches.
There were 5 missing files from two
packages, as well as a number of installed files of zero file size.  I
have re-installed all of the affected packages.

May I know, if
it is possible that, due to the loss of the journal log, that some package
installed files either go missing, or show zero file size?

An
aside, the reason I use XFS is that when I was a student, I did my work in
a school centre with a cluster of 12 SGI Indigo2 R10000 and 3 SGI O2
R5000.  Due to buggy IRIX 6.2 and earlier releases of IRIX 6.5, 6.5.X, the
machines had kernel panics; faulty power supplies (the maintenance was
discontinued) also caused stoppages.  On restart, the recovery was always
instantaneous, no XFS file system repair was ever done
When I built
my first computer, it was only natural that I chose XFS, that was SUSE
Linux 10.0.  On various versions of SUSE, I have had freezes and power
outages, but I have never had to repair file system.  The only time I had
ever had to run xfs_repair was when Areca RAID spitted out the WD desktop
drives and I had to rescue the RAID, so I was very unprepared for this
latest incident.

Any way, a big thanks to all those who
contributed towards XFS over the years in IRIX and Linux, I could not
imagine back in the 90s that in the future I would have a piece of SGI
IRIX technology in my own personal computers.

GL




--8601fsu_trap_24628_50310030902102_=----
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

<p>
Hi Dave<br /><br />I did the &quot;xfs_repair -L&quot; on the root file
system; xfs_repair is version 3.1.8.  The repair was successful.<br /><br
/>&gt; You misunderstood. I was asking for the messages when it<br />&gt;
successfully mounts and the contents of /proc/mounts is when it is<br
/>mounted to see if barriers were disabled or not supported on your<br
/>hardware.<br />&gt; <br />The notebook is Acer Aspire 6530G, AMD Turion
X2 RM-74, chipset is AMD M780G, southbridge is AMD SB 700.  The hard drive
is Western Digital Scorpio Black SATA 320 GB, WDC WD3200BEKT-00F3T0,
/dev/sdb<br />chingl@rat:~&gt; cat<br
/>/etc/fstab                                                                                                                                                                   <br
/><br />/dev/disk/by-path/pci-0000:00:11.0-scsi-1:0:0:0-part1
swap                 swap       defaults              0<br
/>0                                                                                <br
/><br />/dev/disk/by-path/pci-0000:00:11.0-scsi-1:0:0:0-part2
/                    xfs       
defaults,logbufs=8,logbsize=256k              1<br
/>1                                                         <br
/>/dev/disk/by-path/pci-0000:00:11.0-scsi-1:0:0:0-part3
/home                xfs       
defaults,logbufs=8,logbsize=256k              1 2<br
/>/dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part2
/windows/C           ntfs-3g   
users,gid=users,fmask=133,dmask=022,locale=en_US.UTF-8 0 0
/dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part3 /windows/D          
ntfs-3g    users,gid=users,fmask=133,dmask=022,locale=en_US.UTF-8 0 0
proc                 /proc                proc       defaults             
0 0<br />sysfs                /sys                 sysfs     
noauto                0 0<br />debugfs              /sys/kernel/debug   
debugfs    noauto                0 0<br />usbfs               
/proc/bus/usb        usbfs      noauto                0 0<br
/>devpts               /dev/pts             devpts    
mode=0620,gid=5       0 0<br />chingl@rat:~&gt;<br />chingl@rat:~&gt; cat
/proc/mounts <br />rootfs / rootfs rw 0 0<br />devtmpfs /dev devtmpfs
rw,relatime,size=1761184k,nr_inodes=440296,mode=755 0 0<br />tmpfs
/dev/shm tmpfs rw,relatime 0 0<br />devpts /dev/pts devpts
rw,relatime,gid=5,mode=620,ptmxmode=000 0 0</p><p>/dev/sdb2 / xfs
rw,relatime,attr2,logbufs=8,logbsize=256k,noquota 0 0 proc /proc proc
rw,relatime 0 0<br />sysfs /sys sysfs rw,relatime 0 0<br />debugfs
/sys/kernel/debug debugfs rw,relatime 0 0<br />/dev/sdb3 /home xfs
rw,relatime,attr2,logbufs=8,logbsize=256k,noquota 0 0</p><p> fusectl
/sys/fs/fuse/connections fusectl rw,relatime 0 0<br />securityfs
/sys/kernel/security securityfs rw,relatime 0 0<br />none
/proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0<br />none
/var/lib/ntp/proc proc ro,nosuid,nodev,relatime 0 0<br />gvfs-fuse-daemon
/home/chingl/.gvfs fuse.gvfs-fuse-daemon<br
/>rw,nosuid,nodev,relatime,user_id=1000,group_id=100 0 0<br
/>chingl@rat:~&gt;</p><p>From /var/log/boot.msg:</p><p><br /> 
&lt;6&gt;[    1.084085] ata3: SATA link down (SStatus 0 SControl 300)<br
/>  &lt;6&gt;[    1.084172] ata4: SATA link down (SStatus 0 SControl
300)<br />  &lt;3&gt;[    1.256058] ata2: softreset failed (device not
ready)<br />  &lt;4&gt;[    1.256067] ata2: applying SB600 PMP SRST
workaround and retrying   &lt;3&gt;[    1.256084] ata1: softreset failed
(device not ready)<br />  &lt;4&gt;[    1.256095] ata1: applying SB600 PMP
SRST workaround and retrying   &lt;6&gt;[    1.428069] ata2: SATA link up
3.0 Gbps (SStatus 123 SControl 300)   &lt;6&gt;[    1.428097] ata1: SATA
link up 3.0 Gbps (SStatus 123 SControl 300)   &lt;6&gt;[    1.429454]
ata1.00: ATA-8: Hitachi HTS543232L9A300, FB4OC40C, max UDMA/133<br /> 
&lt;6&gt;[    1.429458] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ
(depth 31/32), AA<br />  &lt;6&gt;[    1.430923] ata1.00: configured for
UDMA/133<br />  &lt;5&gt;[    1.431164] scsi 0:0:0:0: Direct-Access    
ATA      Hitachi HTS54323 FB4O PQ: 0 ANSI: 5<br />  &lt;5&gt;[   
1.431560] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298
GiB)<br />  &lt;5&gt;[    1.431672] sd 0:0:0:0: [sda] Write Protect is
off<br />  &lt;7&gt;[    1.431675] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00
00<br />  &lt;5&gt;[    1.431915] sd 0:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA<br />  &lt;6&gt;[   
1.441064] ata2.00: ATA-8: WDC WD3200BEKT-00F3T0, 11.01A11, max UDMA/133<br
/>  &lt;6&gt;[    1.441067] ata2.00: 625142448 sectors, multi 16: LBA48
NCQ (depth 31/32), AA<br />  &lt;6&gt;[    1.442978] ata2.00: configured
for UDMA/133<br />  &lt;5&gt;[    1.443207] scsi 1:0:0:0:
Direct-Access     ATA      WDC<br />WD3200BEKT-0 11.0 PQ: 0 ANSI: 5<br /> 
&lt;5&gt;[    1.443387] sd 1:0:0:0: [sdb] 625142448 512-byte logical
blocks: (320 GB/298 GiB)<br />  &lt;5&gt;[    1.443707] sd 1:0:0:0: [sdb]
Write Protect is off<br />  &lt;7&gt;[    1.443710] sd 1:0:0:0: [sdb] Mode
Sense: 00 3a 00 00<br />  &lt;5&gt;[    1.443756] sd 1:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA<br /> 
&lt;6&gt;[    1.459438]  sda: sda1 sda2 sda3 sda4<br />  &lt;5&gt;[   
1.460197] sd 0:0:0:0: [sda] Attached SCSI disk<br />  &lt;6&gt;[   
1.476394] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x12a0b1, caps:
0xa04711/0xa04000/0x0<br />  &lt;6&gt;[    1.481898]  sdb: sdb1 sdb2
sdb3<br />  &lt;5&gt;[    1.482254] sd 1:0:0:0: [sdb] Attached SCSI
disk<br /><br /><br /><br />  &lt;6&gt;[    3.201111] SGI XFS with ACLs,
security attributes, realtime, large block/inode numbers, no debug
enabled<br />  &lt;6&gt;[    3.202279] SGI XFS Quota Management
subsystem<br />  &lt;5&gt;[    3.230174] XFS mounting filesystem sdb2<br
/>  &lt;7&gt;[    3.351323] Ending clean XFS mount for filesystem: sdb2<br
/><br />  &lt;5&gt;[   11.865393] XFS mounting filesystem sdb3<br /> 
&lt;7&gt;[   12.008707] Ending clean XFS mount for filesystem: sdb3<br
/><br />I do not see anything that says barrier is not supported?<br /><br
/><br />&gt; Only by looking at them can you know. Regardless of what
filesystem you<br />are using, recovery of files and directories from
lost+found is the same process. e.g. do an rpm check to see if allteh
installed packages are intact. that will narrow down where all your
binaries came from. use of strings can also tell you what the binary is.
e.g:<br /><br />&gt; Define &quot;really there&quot; when important
metadata (i.e. the log) has been<br />corrupted and is not available any
more.  Indeed, if things like btree splits of merges occurred in the log,
and they are<br />&gt; partially written to disk, it's entirely possible
that you could lose<br />directory references to inodes that haven't been
modified for some time....<br />&gt; <br />&gt; Remember, like all fsck
programs, xfs_repair is a best effort<br />&gt; attempt at correcting the
problems found  - there are no guarantees<br />given about what it can and
can't recover when it runs...<br />&gt; <br />&gt; Dave.<br />&gt; --<br
/>&gt; Dave Chinner<br />&gt; david@fromorbit.com<br />&gt; <br /><br
/>Looking at the messages from xfs_repair, and inspection of /lost+found,
the files in it are from /tmp and<br
/>/etc/NetworkManager/system-connections/Auto eth0 (a session file). I
think one of the index.db in /var/cache/man was also affected.</p><p><br
/>I did a &quot;rpm -V -a&quot;, thanks for the advice.  I manually
inspected every output, paying attention to the missing files and file
size or checksum mismatches.<br />There were 5 missing files from two
packages, as well as a number of installed files of zero file size.  I
have re-installed all of the affected packages.</p><p><br />May I know, if
it is possible that, due to the loss of the journal log, that some package
installed files either go missing, or show zero file size?<br /><br />An
aside, the reason I use XFS is that when I was a student, I did my work in
a school centre with a cluster of 12 SGI Indigo2 R10000 and 3 SGI O2
R5000.  Due to buggy IRIX 6.2 and earlier releases of IRIX 6.5, 6.5.X, the
machines had kernel panics; faulty power supplies (the maintenance was
discontinued) also caused stoppages.  On restart, the recovery was always
instantaneous, no XFS file system repair was ever done<br />When I built
my first computer, it was only natural that I chose XFS, that was SUSE
Linux 10.0.  On various versions of SUSE, I have had freezes and power
outages, but I have never had to repair file system.  The only time I had
ever had to run xfs_repair was when Areca RAID spitted out the WD desktop
drives and I had to rescue the RAID, so I was very unprepared for this
latest incident.<br /></p><p>Any way, a big thanks to all those who
contributed towards XFS over the years in IRIX and Linux, I could not
imagine back in the 90s that in the future I would have a piece of SGI
IRIX technology in my own personal computers.<br /><br />GL<br /><br />
</p>
--8601fsu_trap_24628_50310030902102_=------

------=_20120903001305_82642
Content-Type: text/html; name="untitled-[1.2]"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="untitled-[1.2]"

PHA+CkhpIERhdmU8YnIgLz48YnIgLz5JIGRpZCB0aGUgJnF1b3Q7eGZzX3JlcGFpciAtTCZxdW90
OyBvbiB0aGUgcm9vdCBmaWxlIHN5c3RlbTsgeGZzX3JlcGFpciBpcyB2ZXJzaW9uIDMuMS44LqAg
VGhlIHJlcGFpciB3YXMgc3VjY2Vzc2Z1bC48YnIgLz48YnIgLz4mZ3Q7IFlvdSBtaXN1bmRlcnN0
b29kLiBJIHdhcyBhc2tpbmcgZm9yIHRoZSBtZXNzYWdlcyB3aGVuIGl0PGJyIC8+Jmd0OyBzdWNj
ZXNzZnVsbHkgbW91bnRzIGFuZCB0aGUgY29udGVudHMgb2YgL3Byb2MvbW91bnRzIGlzIHdoZW4g
aXQgaXM8YnIgLz5tb3VudGVkIHRvIHNlZSBpZiBiYXJyaWVycyB3ZXJlIGRpc2FibGVkIG9yIG5v
dCBzdXBwb3J0ZWQgb24geW91cjxiciAvPmhhcmR3YXJlLjxiciAvPiZndDsgPGJyIC8+VGhlIG5v
dGVib29rIGlzIEFjZXIgQXNwaXJlIDY1MzBHLCBBTUQgVHVyaW9uIFgyIFJNLTc0LCBjaGlwc2V0
IGlzIEFNRCBNNzgwRywgc291dGhicmlkZ2UgaXMgQU1EIFNCIDcwMC6gIFRoZSBoYXJkIGRyaXZl
IGlzIFdlc3Rlcm4gRGlnaXRhbCBTY29ycGlvIEJsYWNrIFNBVEEgMzIwIEdCLCBXREMgV0QzMjAw
QkVLVC0wMEYzVDAsIC9kZXYvc2RiPGJyIC8+Y2hpbmdsQHJhdDp+Jmd0OyBjYXQ8YnIgLz4vZXRj
L2ZzdGFioKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoDxi
ciAvPjxiciAvPi9kZXYvZGlzay9ieS1wYXRoL3BjaS0wMDAwOjAwOjExLjAtc2NzaS0xOjA6MDow
LXBhcnQxIHN3YXCgoKCgoKCgoKCgoKCgoKCgIHN3YXCgoKCgoKAgZGVmYXVsdHOgoKCgoKCgoKCg
oKCgIDA8YnIgLz4woKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKA8YnIgLz48YnIgLz4vZGV2L2Rpc2sv
YnktcGF0aC9wY2ktMDAwMDowMDoxMS4wLXNjc2ktMTowOjA6MC1wYXJ0MiAvoKCgoKCgoKCgoKCg
oKCgoKCgoCB4ZnOgoKCgoKCgIGRlZmF1bHRzLGxvZ2J1ZnM9OCxsb2dic2l6ZT0yNTZroKCgoKCg
oKCgoKCgoCAxPGJyIC8+MaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgIDxiciAvPi9kZXYvZGlzay9ieS1wYXRoL3BjaS0wMDAwOjAwOjExLjAt
c2NzaS0xOjA6MDowLXBhcnQzIC9ob21loKCgoKCgoKCgoKCgoKCgIHhmc6CgoKCgoKAgZGVmYXVs
dHMsbG9nYnVmcz04LGxvZ2JzaXplPTI1NmugoKCgoKCgoKCgoKCgIDEgMjxiciAvPi9kZXYvZGlz
ay9ieS1wYXRoL3BjaS0wMDAwOjAwOjExLjAtc2NzaS0wOjA6MDowLXBhcnQyIC93aW5kb3dzL0Og
oKCgoKCgoKCgIG50ZnMtM2egoKAgdXNlcnMsZ2lkPXVzZXJzLGZtYXNrPTEzMyxkbWFzaz0wMjIs
bG9jYWxlPWVuX1VTLlVURi04IDAgMCAvZGV2L2Rpc2svYnktcGF0aC9wY2ktMDAwMDowMDoxMS4w
LXNjc2ktMDowOjA6MC1wYXJ0MyAvd2luZG93cy9EoKCgoKCgoKCgoCBudGZzLTNnoKCgIHVzZXJz
LGdpZD11c2VycyxmbWFzaz0xMzMsZG1hc2s9MDIyLGxvY2FsZT1lbl9VUy5VVEYtOCAwIDAgcHJv
Y6CgoKCgoKCgoKCgoKCgoKAgL3Byb2OgoKCgoKCgoKCgoKCgoKAgcHJvY6CgoKCgoCBkZWZhdWx0
c6CgoKCgoKCgoKCgoKAgMCAwPGJyIC8+c3lzZnOgoKCgoKCgoKCgoKCgoKAgL3N5c6CgoKCgoKCg
oKCgoKCgoKAgc3lzZnOgoKCgoCBub2F1dG+goKCgoKCgoKCgoKCgoKAgMCAwPGJyIC8+ZGVidWdm
c6CgoKCgoKCgoKCgoKAgL3N5cy9rZXJuZWwvZGVidWegoKAgZGVidWdmc6CgoCBub2F1dG+goKCg
oKCgoKCgoKCgoKAgMCAwPGJyIC8+dXNiZnOgoKCgoKCgoKCgoKCgoKAgL3Byb2MvYnVzL3VzYqCg
oKCgoKAgdXNiZnOgoKCgoCBub2F1dG+goKCgoKCgoKCgoKCgoKAgMCAwPGJyIC8+ZGV2cHRzoKCg
oKCgoKCgoKCgoKAgL2Rldi9wdHOgoKCgoKCgoKCgoKAgZGV2cHRzoKCgoCBtb2RlPTA2MjAsZ2lk
PTWgoKCgoKAgMCAwPGJyIC8+Y2hpbmdsQHJhdDp+Jmd0OzxiciAvPmNoaW5nbEByYXQ6fiZndDsg
Y2F0IC9wcm9jL21vdW50cyA8YnIgLz5yb290ZnMgLyByb290ZnMgcncgMCAwPGJyIC8+ZGV2dG1w
ZnMgL2RldiBkZXZ0bXBmcyBydyxyZWxhdGltZSxzaXplPTE3NjExODRrLG5yX2lub2Rlcz00NDAy
OTYsbW9kZT03NTUgMCAwPGJyIC8+dG1wZnMgL2Rldi9zaG0gdG1wZnMgcncscmVsYXRpbWUgMCAw
PGJyIC8+ZGV2cHRzIC9kZXYvcHRzIGRldnB0cyBydyxyZWxhdGltZSxnaWQ9NSxtb2RlPTYyMCxw
dG14bW9kZT0wMDAgMCAwIC9kZXYvc2RiMiAvIHhmcyBydyxyZWxhdGltZSxhdHRyMixsb2didWZz
PTgsbG9nYnNpemU9MjU2ayxub3F1b3RhIDAgMCBwcm9jIC9wcm9jIHByb2MgcncscmVsYXRpbWUg
MCAwPGJyIC8+c3lzZnMgL3N5cyBzeXNmcyBydyxyZWxhdGltZSAwIDA8YnIgLz5kZWJ1Z2ZzIC9z
eXMva2VybmVsL2RlYnVnIGRlYnVnZnMgcncscmVsYXRpbWUgMCAwPGJyIC8+L2Rldi9zZGIzIC9o
b21lIHhmcyBydyxyZWxhdGltZSxhdHRyMixsb2didWZzPTgsbG9nYnNpemU9MjU2ayxub3F1b3Rh
IDAgMCBmdXNlY3RsIC9zeXMvZnMvZnVzZS9jb25uZWN0aW9ucyBmdXNlY3RsIHJ3LHJlbGF0aW1l
IDAgMDxiciAvPnNlY3VyaXR5ZnMgL3N5cy9rZXJuZWwvc2VjdXJpdHkgc2VjdXJpdHlmcyBydyxy
ZWxhdGltZSAwIDA8YnIgLz5ub25lIC9wcm9jL3N5cy9mcy9iaW5mbXRfbWlzYyBiaW5mbXRfbWlz
YyBydyxyZWxhdGltZSAwIDA8YnIgLz5ub25lIC92YXIvbGliL250cC9wcm9jIHByb2Mgcm8sbm9z
dWlkLG5vZGV2LHJlbGF0aW1lIDAgMDxiciAvPmd2ZnMtZnVzZS1kYWVtb24gL2hvbWUvY2hpbmds
Ly5ndmZzIGZ1c2UuZ3Zmcy1mdXNlLWRhZW1vbjxiciAvPnJ3LG5vc3VpZCxub2RldixyZWxhdGlt
ZSx1c2VyX2lkPTEwMDAsZ3JvdXBfaWQ9MTAwIDAgMDxiciAvPmNoaW5nbEByYXQ6fiZndDs8YnIg
Lz48YnIgLz6gICZsdDs2Jmd0O1ugoKAgMS4wODQwODVdIGF0YTM6IFNBVEEgbGluayBkb3duIChT
U3RhdHVzIDAgU0NvbnRyb2wgMzAwKTxiciAvPqAgJmx0OzYmZ3Q7W6CgoCAxLjA4NDE3Ml0gYXRh
NDogU0FUQSBsaW5rIGRvd24gKFNTdGF0dXMgMCBTQ29udHJvbCAzMDApPGJyIC8+oCAmbHQ7MyZn
dDtboKCgIDEuMjU2MDU4XSBhdGEyOiBzb2Z0cmVzZXQgZmFpbGVkIChkZXZpY2Ugbm90IHJlYWR5
KTxiciAvPqAgJmx0OzQmZ3Q7W6CgoCAxLjI1NjA2N10gYXRhMjogYXBwbHlpbmcgU0I2MDAgUE1Q
IFNSU1Qgd29ya2Fyb3VuZCBhbmQgcmV0cnlpbmcgoCAmbHQ7MyZndDtboKCgIDEuMjU2MDg0XSBh
dGExOiBzb2Z0cmVzZXQgZmFpbGVkIChkZXZpY2Ugbm90IHJlYWR5KTxiciAvPqAgJmx0OzQmZ3Q7
W6CgoCAxLjI1NjA5NV0gYXRhMTogYXBwbHlpbmcgU0I2MDAgUE1QIFNSU1Qgd29ya2Fyb3VuZCBh
bmQgcmV0cnlpbmcgoCAmbHQ7NiZndDtboKCgIDEuNDI4MDY5XSBhdGEyOiBTQVRBIGxpbmsgdXAg
My4wIEdicHMgKFNTdGF0dXMgMTIzIFNDb250cm9sIDMwMCkgoCAmbHQ7NiZndDtboKCgIDEuNDI4
MDk3XSBhdGExOiBTQVRBIGxpbmsgdXAgMy4wIEdicHMgKFNTdGF0dXMgMTIzIFNDb250cm9sIDMw
MCkgoCAmbHQ7NiZndDtboKCgIDEuNDI5NDU0XSBhdGExLjAwOiBBVEEtODogSGl0YWNoaSBIVFM1
NDMyMzJMOUEzMDAsIEZCNE9DNDBDLCBtYXggVURNQS8xMzM8YnIgLz6gICZsdDs2Jmd0O1ugoKAg
MS40Mjk0NThdIGF0YTEuMDA6IDYyNTE0MjQ0OCBzZWN0b3JzLCBtdWx0aSAxNjogTEJBNDggTkNR
IChkZXB0aCAzMS8zMiksIEFBPGJyIC8+oCAmbHQ7NiZndDtboKCgIDEuNDMwOTIzXSBhdGExLjAw
OiBjb25maWd1cmVkIGZvciBVRE1BLzEzMzxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQzMTE2NF0g
c2NzaSAwOjA6MDowOiBEaXJlY3QtQWNjZXNzoKCgoCBBVEGgoKCgoCBIaXRhY2hpIEhUUzU0MzIz
IEZCNE8gUFE6IDAgQU5TSTogNTxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQzMTU2MF0gc2QgMDow
OjA6MDogW3NkYV0gNjI1MTQyNDQ4IDUxMi1ieXRlIGxvZ2ljYWwgYmxvY2tzOiAoMzIwIEdCLzI5
OCBHaUIpPGJyIC8+oCAmbHQ7NSZndDtboKCgIDEuNDMxNjcyXSBzZCAwOjA6MDowOiBbc2RhXSBX
cml0ZSBQcm90ZWN0IGlzIG9mZjxiciAvPqAgJmx0OzcmZ3Q7W6CgoCAxLjQzMTY3NV0gc2QgMDow
OjA6MDogW3NkYV0gTW9kZSBTZW5zZTogMDAgM2EgMDAgMDA8YnIgLz6gICZsdDs1Jmd0O1ugoKAg
MS40MzE5MTVdIHNkIDA6MDowOjA6IFtzZGFdIFdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNh
Y2hlOiBlbmFibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQTxiciAvPqAgJmx0OzYmZ3Q7
W6CgoCAxLjQ0MTA2NF0gYXRhMi4wMDogQVRBLTg6IFdEQyBXRDMyMDBCRUtULTAwRjNUMCwgMTEu
MDFBMTEsIG1heCBVRE1BLzEzMzxiciAvPqAgJmx0OzYmZ3Q7W6CgoCAxLjQ0MTA2N10gYXRhMi4w
MDogNjI1MTQyNDQ4IHNlY3RvcnMsIG11bHRpIDE2OiBMQkE0OCBOQ1EgKGRlcHRoIDMxLzMyKSwg
QUE8YnIgLz6gICZsdDs2Jmd0O1ugoKAgMS40NDI5NzhdIGF0YTIuMDA6IGNvbmZpZ3VyZWQgZm9y
IFVETUEvMTMzPGJyIC8+oCAmbHQ7NSZndDtboKCgIDEuNDQzMjA3XSBzY3NpIDE6MDowOjA6IERp
cmVjdC1BY2Nlc3OgoKCgIEFUQaCgoKCgIFdEQzxiciAvPldEMzIwMEJFS1QtMCAxMS4wIFBROiAw
IEFOU0k6IDU8YnIgLz6gICZsdDs1Jmd0O1ugoKAgMS40NDMzODddIHNkIDE6MDowOjA6IFtzZGJd
IDYyNTE0MjQ0OCA1MTItYnl0ZSBsb2dpY2FsIGJsb2NrczogKDMyMCBHQi8yOTggR2lCKTxiciAv
PqAgJmx0OzUmZ3Q7W6CgoCAxLjQ0MzcwN10gc2QgMTowOjA6MDogW3NkYl0gV3JpdGUgUHJvdGVj
dCBpcyBvZmY8YnIgLz6gICZsdDs3Jmd0O1ugoKAgMS40NDM3MTBdIHNkIDE6MDowOjA6IFtzZGJd
IE1vZGUgU2Vuc2U6IDAwIDNhIDAwIDAwPGJyIC8+oCAmbHQ7NSZndDtboKCgIDEuNDQzNzU2XSBz
ZCAxOjA6MDowOiBbc2RiXSBXcml0ZSBjYWNoZTogZW5hYmxlZCwgcmVhZCBjYWNoZTogZW5hYmxl
ZCwgZG9lc24ndCBzdXBwb3J0IERQTyBvciBGVUE8YnIgLz6gICZsdDs2Jmd0O1ugoKAgMS40NTk0
MzhdoCBzZGE6IHNkYTEgc2RhMiBzZGEzIHNkYTQ8YnIgLz6gICZsdDs1Jmd0O1ugoKAgMS40NjAx
OTddIHNkIDA6MDowOjA6IFtzZGFdIEF0dGFjaGVkIFNDU0kgZGlzazxiciAvPqAgJmx0OzYmZ3Q7
W6CgoCAxLjQ3NjM5NF0gU3luYXB0aWNzIFRvdWNocGFkLCBtb2RlbDogMSwgZnc6IDYuMywgaWQ6
IDB4MTJhMGIxLCBjYXBzOiAweGEwNDcxMS8weGEwNDAwMC8weDA8YnIgLz6gICZsdDs2Jmd0O1ug
oKAgMS40ODE4OThdoCBzZGI6IHNkYjEgc2RiMiBzZGIzPGJyIC8+oCAmbHQ7NSZndDtboKCgIDEu
NDgyMjU0XSBzZCAxOjA6MDowOiBbc2RiXSBBdHRhY2hlZCBTQ1NJIGRpc2s8YnIgLz48YnIgLz48
YnIgLz48YnIgLz6gICZsdDs2Jmd0O1ugoKAgMy4yMDExMTFdIFNHSSBYRlMgd2l0aCBBQ0xzLCBz
ZWN1cml0eSBhdHRyaWJ1dGVzLCByZWFsdGltZSwgbGFyZ2UgYmxvY2svaW5vZGUgbnVtYmVycywg
bm8gZGVidWcgZW5hYmxlZDxiciAvPqAgJmx0OzYmZ3Q7W6CgoCAzLjIwMjI3OV0gU0dJIFhGUyBR
dW90YSBNYW5hZ2VtZW50IHN1YnN5c3RlbTxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAzLjIzMDE3NF0g
WEZTIG1vdW50aW5nIGZpbGVzeXN0ZW0gc2RiMjxiciAvPqAgJmx0OzcmZ3Q7W6CgoCAzLjM1MTMy
M10gRW5kaW5nIGNsZWFuIFhGUyBtb3VudCBmb3IgZmlsZXN5c3RlbTogc2RiMjxiciAvPjxiciAv
PqAgJmx0OzUmZ3Q7W6CgIDExLjg2NTM5M10gWEZTIG1vdW50aW5nIGZpbGVzeXN0ZW0gc2RiMzxi
ciAvPqAgJmx0OzcmZ3Q7W6CgIDEyLjAwODcwN10gRW5kaW5nIGNsZWFuIFhGUyBtb3VudCBmb3Ig
ZmlsZXN5c3RlbTogc2RiMzxiciAvPjxiciAvPkkgZG8gbm90IHNlZSBhbnl0aGluZyB0aGF0IHNh
eXMgYmFycmllciBpcyBub3Qgc3VwcG9ydGVkLqAgSW4gZmFjdCwgSSBoYXZlIG5ldmVyIHBlcnNv
bmFsbHkgc2VlbiBhIHN5c3RlbSB3aXRoIGEgbWVzc2FnZSB0aGF0IGJhcnJpZXIgaXMgbm90PGJy
IC8+c3VwcG9ydGVkLjxiciAvPjxiciAvPiZndDsgT25seSBieSBsb29raW5nIGF0IHRoZW0gY2Fu
IHlvdSBrbm93LiBSZWdhcmRsZXNzIG9mIHdoYXQgZmlsZXN5c3RlbSB5b3U8YnIgLz5hcmUgdXNp
bmcsIHJlY292ZXJ5IG9mIGZpbGVzIGFuZCBkaXJlY3RvcmllcyBmcm9tIGxvc3QrZm91bmQgaXMg
dGhlIHNhbWUgcHJvY2Vzcy4gZS5nLiBkbyBhbiBycG0gY2hlY2sgdG8gc2VlIGlmIGFsbHRlaCBp
bnN0YWxsZWQgcGFja2FnZXMgYXJlIGludGFjdC4gdGhhdCB3aWxsIG5hcnJvdyBkb3duIHdoZXJl
IGFsbCB5b3VyIGJpbmFyaWVzIGNhbWUgZnJvbS4gdXNlIG9mIHN0cmluZ3MgY2FuIGFsc28gdGVs
bCB5b3Ugd2hhdCB0aGUgYmluYXJ5IGlzLiBlLmc6PGJyIC8+PGJyIC8+Jmd0OyBEZWZpbmUgJnF1
b3Q7cmVhbGx5IHRoZXJlJnF1b3Q7IHdoZW4gaW1wb3J0YW50IG1ldGFkYXRhIChpLmUuIHRoZSBs
b2cpIGhhcyBiZWVuPGJyIC8+Y29ycnVwdGVkIGFuZCBpcyBub3QgYXZhaWxhYmxlIGFueSBtb3Jl
LiAgSW5kZWVkLCBpZiB0aGluZ3MgbGlrZSBidHJlZSBzcGxpdHMgb2YgbWVyZ2VzIG9jY3VycmVk
IGluIHRoZSBsb2csIGFuZCB0aGV5IGFyZTxiciAvPiZndDsgcGFydGlhbGx5IHdyaXR0ZW4gdG8g
ZGlzaywgaXQncyBlbnRpcmVseSBwb3NzaWJsZSB0aGF0IHlvdSBjb3VsZCBsb3NlPGJyIC8+ZGly
ZWN0b3J5IHJlZmVyZW5jZXMgdG8gaW5vZGVzIHRoYXQgaGF2ZW4ndCBiZWVuIG1vZGlmaWVkIGZv
ciBzb21lIHRpbWUuLi4uPGJyIC8+Jmd0OyA8YnIgLz4mZ3Q7IFJlbWVtYmVyLCBsaWtlIGFsbCBm
c2NrIHByb2dyYW1zLCB4ZnNfcmVwYWlyIGlzIGEgYmVzdCBlZmZvcnQ8YnIgLz4mZ3Q7IGF0dGVt
cHQgYXQgY29ycmVjdGluZyB0aGUgcHJvYmxlbXMgZm91bmQgIC0gdGhlcmUgYXJlIG5vIGd1YXJh
bnRlZXM8YnIgLz5naXZlbiBhYm91dCB3aGF0IGl0IGNhbiBhbmQgY2FuJ3QgcmVjb3ZlciB3aGVu
IGl0IHJ1bnMuLi48YnIgLz4mZ3Q7IDxiciAvPiZndDsgRGF2ZS48YnIgLz4mZ3Q7IC0tPGJyIC8+
Jmd0OyBEYXZlIENoaW5uZXI8YnIgLz4mZ3Q7IGRhdmlkQGZyb21vcmJpdC5jb208YnIgLz4mZ3Q7
IDxiciAvPjxiciAvPkxvb2tpbmcgYXQgdGhlIG1lc3NhZ2VzIGZyb20geGZzX3JlcGFpciwgYW5k
IGluc3BlY3Rpb24gb2YgL2xvc3QrZm91bmQsIHRoZSBmaWxlcyBpbiBpdCBhcmUgZnJvbSAvdG1w
IGFuZDxiciAvPi9ldGMvTmV0d29ya01hbmFnZXIvc3lzdGVtLWNvbm5lY3Rpb25zL0F1dG8gZXRo
MCAoYSBzZXNzaW9uIGZpbGUpLjwvcD48cD5JIHRoaW5rIG9uZSBvZiB0aGUgbWFuIGluZGV4LmRi
IGluIGZpbGVzIHdhcyBhbHNvIGFmZmVjdGVkLjwvcD48cD5JIGRpZCBhICZxdW90O3JwbSAtViAt
YSZxdW90OywgdGhhbmtzIGZvciB0aGUgYWR2aWNlLqAgSSBtYW51YWxseSBpbnNwZWN0ZWQgZXZl
cnkgb3V0cHV0LCBwYXlpbmcgYXR0ZW50aW9uIHRvIHRoZSBtaXNzaW5nIGZpbGVzIGFuZCBmaWxl
IHNpemUgb3IgY2hlY2tzdW0gbWlzbWF0Y2hlcy48L3A+PHA+VGhlcmUgd2VyZSA1IG1pc3Npbmcg
ZmlsZXMgZnJvbSB0d28gcGFja2FnZXMsIGFzIHdlbGwgYXMgYSBudW1iZXIgb2YgaW5zdGFsbGVk
IGZpbGVzIG9mIHplcm8gZmlsZSBzaXplLqAgSSBoYXZlIHJlLWluc3RhbGxlZCBhbGwgb2YgdGhl
IGFmZmVjdGVkIHBhY2thZ2VzLjwvcD48cD5NYXkgSSBrbm93LCBpZiBpdCBpcyBwb3NzaWJsZSB0
aGF0LCBkdWUgdG8gdGhlIGxvc3Mgb2YgdGhlIGpvdXJuYWwgbG9nLCB0aGF0IHNvbWUgcGFja2Fn
ZWQgaW5zdGFsbGVkIGZpbGVzIGVpdGhlciBnbyBtaXNzaW5nLCBvciBzaG93IHplcm8gZmlsZSBz
aXplPzwvcD48cD48L3A+PHA+QW4gYXNpZGUsIHRoZSByZWFzb24gSSB1c2UgWEZTIGlzIHRoYXQg
d2hlbiBJIHdhcyBhIHN0dWRlbnQsIEkgZGlkIG15IHdvcmsgaW4gYSBzY2hvb2wgY2VudHJlIHdp
dGggYSBjbHVzdGVyIG9mIDEyIFNHSSBJbmRpZ28yIFIxMDAwMCBhbmQgMyBTR0kgTzIgUjUwMDAu
oCBEdWUgdG8gYnVnZ3kgSVJJWCA2LjIgYW5kIGVhcmxpZXIgcmVsZWFzZXMgb2YgSVJJWCA2LjUs
IDYuNS5YLCB0aGUgbWFjaGluZXMgaGFkIGtlcm5lbCBwYW5pY3M7IGZhdWx0eSBwb3dlciBzdXBw
bGllcyAodGhlIG1haW50ZW5hbmNlIHdhcyBkaXNjb250aW51ZWQpIGFsc28gY2F1c2VkIHN0b3Bw
YWdlcy6gIE9uIHJlc3RhcnQsIHRoZSByZWNvdmVyeSB3YXMgYWx3YXlzIGluc3RhbnRhbmVvdXMs
IG5vIFhGUyBmaWxlIHN5c3RlbSByZXBhaXIgd2FzIGV2ZXIgZG9uZTwvcD48cD5XaGVuIEkgYnVp
bHQgbXkgb3duIGNvbXB1dGVyLCBpdCB3YXMgb25seSBuYXR1cmFsIHRoYXQgSSBjaG9zZSBYRlMs
IHRoYXQgd2FzIFNVU0UgTGludXggMTAuMC6gIE9uIHZhcmlvdXMgdmVyc2lvbnMgb2YgU1VTRSwg
SSBoYXZlIGhhZCBmcmVlemVzIGFuZCBwb3dlciBvdXRhZ2VzLCBidXQgSSBoYXZlIG5ldmVyIGhh
ZCB0byByZXBhaXIgZmlsZSBzeXN0ZW0uoCBUaGUgb25seSB0aW1lIEkgaGFkIGV2ZXIgaGFkIHRv
IHJ1biB4ZnNfcmVwYWlyIHdhcyB3aGVuIEFyZWNhIFJBSUQgc3BpdHRlZCBvdXQgdGhlIFdEIGRl
c2t0b3AgZHJpdmVzIGFuZCBJIGhhZCB0byByZXNjdWUgdGhlIFJBSUQsIHNvIEkgd2FzIHZlcnkg
dW5wcmVwYXJlZCBmb3IgdGhpcyBsYXRlc3QgaW5jaWRlbnQuPC9wPjxwPkFueSB3YXksIGEgYmln
IHRoYW5rcyB0byBhbGwgdGhvc2Ugd2hvIGNvbnRyaWJ1dGVkIHRvd2FyZHMgWEZTIG92ZXIgdGhl
IHllYXJzIGluIElSSVggYW5kIExpbnV4LCBJIGNvdWxkIG5vdCBpbWFnaW5lIGJhY2sgaW4gdGhl
IDkwcyB0aGF0IGluIHRoZSBmdXR1cmUgSSB3b3VsZCBoYXZlIGEgcGllY2Ugb2YgU0dJIElSSVgg
dGVjaG5vbG9neSBpbiBteSBvd24gcGVyc29uYWwgY29tcHV0ZXJzLjwvcD48cD48L3A+PHA+R0w8
L3A+
------=_20120903001305_82642
Content-Type: text/html; name="untitled-[1.2]"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="untitled-[1.2]"

PHA+PC9wPjxwPjwvcD48cD48L3A+PHA+PC9wPjxwPjwvcD48cD48L3A+CkhpIERhdmU8YnIgLz48
YnIgLz5JIGRpZCB0aGUgeGZzX3JlcGFpciAtTCBvbiB0aGUgcm9vdCBmaWxlIHN5c3RlbTsgeGZz
X3JlcGFpciBpcyB2ZXJzaW9uIDMuMS44LqAgVGhlIHJlcGFpciB3YXMgc3VjY2Vzc2Z1bC48YnIg
Lz48YnIgLz4mZ3Q7IFlvdSBtaXN1bmRlcnN0b29kLiBJIHdhcyBhc2tpbmcgZm9yIHRoZSBtZXNz
YWdlcyB3aGVuIGl0PGJyIC8+Jmd0OyBzdWNjZXNzZnVsbHkgbW91bnRzIGFuZCB0aGUgY29udGVu
dHMgb2YgL3Byb2MvbW91bnRzIGlzIHdoZW4gaXQgaXM8YnIgLz5tb3VudGVkIHRvIHNlZSBpZiBi
YXJyaWVycyB3ZXJlIGRpc2FibGVkIG9yIG5vdCBzdXBwb3J0ZWQgb24geW91cjxiciAvPmhhcmR3
YXJlLjxiciAvPiZndDsgPGJyIC8+VGhlIG5vdGVib29rIGlzIEFjZXIgQXNwaXJlIDY1MzBHLCBB
TUQgVHVyaW9uIFgyIFJNLTc0LCBjaGlwc2V0IGlzIEFNRCBNNzgwRywgc291dGhicmlkZ2UgaXMg
QU1EIFNCIDcwMC6gIFRoZSBoYXJkIGRyaXZlIGlzIFdlc3Rlcm4gRGlnaXRhbCBTY29ycGlvIEJs
YWNrIFNBVEEgMzIwIEdCLCBXREMgV0QzMjAwQkVLVC0wMEYzVDAsIC9kZXYvc2RiPGJyIC8+Y2hp
bmdsQHJhdDp+Jmd0OyBjYXQgL2V0Yy9mc3RhYqCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKA8YnIgLz48YnIgLz4vZGV2L2Rpc2svYnktcGF0aC9wY2ktMDAw
MDowMDoxMS4wLXNjc2ktMTowOjA6MC1wYXJ0MSBzd2FwoKCgoKCgoKCgoKCgoKCgoCBzd2FwoKCg
oKCgIGRlZmF1bHRzoKCgoKCgoKCgoKCgoCAwPGJyIC8+MKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
PGJyIC8+PGJyIC8+L2Rldi9kaXNrL2J5LXBhdGgvcGNpLTAwMDA6MDA6MTEuMC1zY3NpLTE6MDow
OjAtcGFydDIgL6CgoKCgoKCgoKCgoKCgoKCgoKAgeGZzoKCgoKCgoCBkZWZhdWx0cyxsb2didWZz
PTgsbG9nYnNpemU9MjU2a6CgoKCgoKCgoKCgoKAgMTxiciAvPjGgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCA8YnIgLz4vZGV2L2Rpc2svYnkt
cGF0aC9wY2ktMDAwMDowMDoxMS4wLXNjc2ktMTowOjA6MC1wYXJ0MyAvaG9tZaCgoKCgoKCgoKCg
oKCgoCB4ZnOgoKCgoKCgIGRlZmF1bHRzLGxvZ2J1ZnM9OCxsb2dic2l6ZT0yNTZroKCgoKCgoKCg
oKCgoCAxIDI8YnIgLz4vZGV2L2Rpc2svYnktcGF0aC9wY2ktMDAwMDowMDoxMS4wLXNjc2ktMDow
OjA6MC1wYXJ0MiAvd2luZG93cy9DoKCgoKCgoKCgoCBudGZzLTNnoKCgIHVzZXJzLGdpZD11c2Vy
cyxmbWFzaz0xMzMsZG1hc2s9MDIyLGxvY2FsZT1lbl9VUy5VVEYtOCAwIDAgL2Rldi9kaXNrL2J5
LXBhdGgvcGNpLTAwMDA6MDA6MTEuMC1zY3NpLTA6MDowOjAtcGFydDMgL3dpbmRvd3MvRKCgoKCg
oKCgoKAgbnRmcy0zZ6CgoCB1c2VycyxnaWQ9dXNlcnMsZm1hc2s9MTMzLGRtYXNrPTAyMixsb2Nh
bGU9ZW5fVVMuVVRGLTggMCAwIHByb2OgoKCgoKCgoKCgoKCgoKCgIC9wcm9joKCgoKCgoKCgoKCg
oKCgIHByb2OgoKCgoKAgZGVmYXVsdHOgoKCgoKCgoKCgoKCgIDAgMDxiciAvPnN5c2ZzoKCgoKCg
oKCgoKCgoKCgIC9zeXOgoKCgoKCgoKCgoKCgoKCgIHN5c2ZzoKCgoKAgbm9hdXRvoKCgoKCgoKCg
oKCgoKCgIDAgMDxiciAvPmRlYnVnZnOgoKCgoKCgoKCgoKCgIC9zeXMva2VybmVsL2RlYnVnoKCg
IGRlYnVnZnOgoKAgbm9hdXRvoKCgoKCgoKCgoKCgoKCgIDAgMDxiciAvPnVzYmZzoKCgoKCgoKCg
oKCgoKCgIC9wcm9jL2J1cy91c2KgoKCgoKCgIHVzYmZzoKCgoKAgbm9hdXRvoKCgoKCgoKCgoKCg
oKCgIDAgMDxiciAvPmRldnB0c6CgoKCgoKCgoKCgoKCgIC9kZXYvcHRzoKCgoKCgoKCgoKCgIGRl
dnB0c6CgoKAgbW9kZT0wNjIwLGdpZD01oKCgoKCgIDAgMDxiciAvPmNoaW5nbEByYXQ6fiZndDs8
YnIgLz5jaGluZ2xAcmF0On4mZ3Q7IGNhdCAvcHJvYy9tb3VudHMgPGJyIC8+cm9vdGZzIC8gcm9v
dGZzIHJ3IDAgMDxiciAvPmRldnRtcGZzIC9kZXYgZGV2dG1wZnMgcncscmVsYXRpbWUsc2l6ZT0x
NzYxMTg0ayxucl9pbm9kZXM9NDQwMjk2LG1vZGU9NzU1IDAgMDxiciAvPnRtcGZzIC9kZXYvc2ht
IHRtcGZzIHJ3LHJlbGF0aW1lIDAgMDxiciAvPmRldnB0cyAvZGV2L3B0cyBkZXZwdHMgcncscmVs
YXRpbWUsZ2lkPTUsbW9kZT02MjAscHRteG1vZGU9MDAwIDAgMCAvZGV2L3NkYjIgLyB4ZnMgcncs
cmVsYXRpbWUsYXR0cjIsbG9nYnVmcz04LGxvZ2JzaXplPTI1Nmssbm9xdW90YSAwIDAgcHJvYyAv
cHJvYyBwcm9jIHJ3LHJlbGF0aW1lIDAgMDxiciAvPnN5c2ZzIC9zeXMgc3lzZnMgcncscmVsYXRp
bWUgMCAwPGJyIC8+ZGVidWdmcyAvc3lzL2tlcm5lbC9kZWJ1ZyBkZWJ1Z2ZzIHJ3LHJlbGF0aW1l
IDAgMDxiciAvPi9kZXYvc2RiMyAvaG9tZSB4ZnMgcncscmVsYXRpbWUsYXR0cjIsbG9nYnVmcz04
LGxvZ2JzaXplPTI1Nmssbm9xdW90YSAwIDAgZnVzZWN0bCAvc3lzL2ZzL2Z1c2UvY29ubmVjdGlv
bnMgZnVzZWN0bCBydyxyZWxhdGltZSAwIDA8YnIgLz5zZWN1cml0eWZzIC9zeXMva2VybmVsL3Nl
Y3VyaXR5IHNlY3VyaXR5ZnMgcncscmVsYXRpbWUgMCAwPGJyIC8+bm9uZSAvcHJvYy9zeXMvZnMv
YmluZm10X21pc2MgYmluZm10X21pc2MgcncscmVsYXRpbWUgMCAwPGJyIC8+bm9uZSAvdmFyL2xp
Yi9udHAvcHJvYyBwcm9jIHJvLG5vc3VpZCxub2RldixyZWxhdGltZSAwIDA8YnIgLz5ndmZzLWZ1
c2UtZGFlbW9uIC9ob21lL2NoaW5nbC8uZ3ZmcyBmdXNlLmd2ZnMtZnVzZS1kYWVtb248YnIgLz5y
dyxub3N1aWQsbm9kZXYscmVsYXRpbWUsdXNlcl9pZD0xMDAwLGdyb3VwX2lkPTEwMCAwIDA8YnIg
Lz5jaGluZ2xAcmF0On4mZ3Q7PGJyIC8+PGJyIC8+oCAmbHQ7NiZndDtboKCgIDEuMDg0MDg1XSBh
dGEzOiBTQVRBIGxpbmsgZG93biAoU1N0YXR1cyAwIFNDb250cm9sIDMwMCk8YnIgLz6gICZsdDs2
Jmd0O1ugoKAgMS4wODQxNzJdIGF0YTQ6IFNBVEEgbGluayBkb3duIChTU3RhdHVzIDAgU0NvbnRy
b2wgMzAwKTxiciAvPqAgJmx0OzMmZ3Q7W6CgoCAxLjI1NjA1OF0gYXRhMjogc29mdHJlc2V0IGZh
aWxlZCAoZGV2aWNlIG5vdCByZWFkeSk8YnIgLz6gICZsdDs0Jmd0O1ugoKAgMS4yNTYwNjddIGF0
YTI6IGFwcGx5aW5nIFNCNjAwIFBNUCBTUlNUIHdvcmthcm91bmQgYW5kIHJldHJ5aW5nIKAgJmx0
OzMmZ3Q7W6CgoCAxLjI1NjA4NF0gYXRhMTogc29mdHJlc2V0IGZhaWxlZCAoZGV2aWNlIG5vdCBy
ZWFkeSk8YnIgLz6gICZsdDs0Jmd0O1ugoKAgMS4yNTYwOTVdIGF0YTE6IGFwcGx5aW5nIFNCNjAw
IFBNUCBTUlNUIHdvcmthcm91bmQgYW5kIHJldHJ5aW5nIKAgJmx0OzYmZ3Q7W6CgoCAxLjQyODA2
OV0gYXRhMjogU0FUQSBsaW5rIHVwIDMuMCBHYnBzIChTU3RhdHVzIDEyMyBTQ29udHJvbCAzMDAp
IKAgJmx0OzYmZ3Q7W6CgoCAxLjQyODA5N10gYXRhMTogU0FUQSBsaW5rIHVwIDMuMCBHYnBzIChT
U3RhdHVzIDEyMyBTQ29udHJvbCAzMDApIKAgJmx0OzYmZ3Q7W6CgoCAxLjQyOTQ1NF0gYXRhMS4w
MDogQVRBLTg6IEhpdGFjaGkgSFRTNTQzMjMyTDlBMzAwLCBGQjRPQzQwQywgbWF4IFVETUEvMTMz
PGJyIC8+oCAmbHQ7NiZndDtboKCgIDEuNDI5NDU4XSBhdGExLjAwOiA2MjUxNDI0NDggc2VjdG9y
cywgbXVsdGkgMTY6IExCQTQ4IE5DUSAoZGVwdGggMzEvMzIpLCBBQTxiciAvPqAgJmx0OzYmZ3Q7
W6CgoCAxLjQzMDkyM10gYXRhMS4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMzM8YnIgLz6gICZs
dDs1Jmd0O1ugoKAgMS40MzExNjRdIHNjc2kgMDowOjA6MDogRGlyZWN0LUFjY2Vzc6CgoKAgQVRB
oKCgoKAgSGl0YWNoaSBIVFM1NDMyMyBGQjRPIFBROiAwIEFOU0k6IDU8YnIgLz6gICZsdDs1Jmd0
O1ugoKAgMS40MzE1NjBdIHNkIDA6MDowOjA6IFtzZGFdIDYyNTE0MjQ0OCA1MTItYnl0ZSBsb2dp
Y2FsIGJsb2NrczogKDMyMCBHQi8yOTggR2lCKTxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQzMTY3
Ml0gc2QgMDowOjA6MDogW3NkYV0gV3JpdGUgUHJvdGVjdCBpcyBvZmY8YnIgLz6gICZsdDs3Jmd0
O1ugoKAgMS40MzE2NzVdIHNkIDA6MDowOjA6IFtzZGFdIE1vZGUgU2Vuc2U6IDAwIDNhIDAwIDAw
PGJyIC8+oCAmbHQ7NSZndDtboKCgIDEuNDMxOTE1XSBzZCAwOjA6MDowOiBbc2RhXSBXcml0ZSBj
YWNoZTogZW5hYmxlZCwgcmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0IERQTyBv
ciBGVUE8YnIgLz6gICZsdDs2Jmd0O1ugoKAgMS40NDEwNjRdIGF0YTIuMDA6IEFUQS04OiBXREMg
V0QzMjAwQkVLVC0wMEYzVDAsIDExLjAxQTExLCBtYXggVURNQS8xMzM8YnIgLz6gICZsdDs2Jmd0
O1ugoKAgMS40NDEwNjddIGF0YTIuMDA6IDYyNTE0MjQ0OCBzZWN0b3JzLCBtdWx0aSAxNjogTEJB
NDggTkNRIChkZXB0aCAzMS8zMiksIEFBPGJyIC8+oCAmbHQ7NiZndDtboKCgIDEuNDQyOTc4XSBh
dGEyLjAwOiBjb25maWd1cmVkIGZvciBVRE1BLzEzMzxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQ0
MzIwN10gc2NzaSAxOjA6MDowOiBEaXJlY3QtQWNjZXNzoKCgoCBBVEGgoKCgoCBXREM8YnIgLz5X
RDMyMDBCRUtULTAgMTEuMCBQUTogMCBBTlNJOiA1PGJyIC8+oCAmbHQ7NSZndDtboKCgIDEuNDQz
Mzg3XSBzZCAxOjA6MDowOiBbc2RiXSA2MjUxNDI0NDggNTEyLWJ5dGUgbG9naWNhbCBibG9ja3M6
ICgzMjAgR0IvMjk4IEdpQik8YnIgLz6gICZsdDs1Jmd0O1ugoKAgMS40NDM3MDddIHNkIDE6MDow
OjA6IFtzZGJdIFdyaXRlIFByb3RlY3QgaXMgb2ZmPGJyIC8+oCAmbHQ7NyZndDtboKCgIDEuNDQz
NzEwXSBzZCAxOjA6MDowOiBbc2RiXSBNb2RlIFNlbnNlOiAwMCAzYSAwMCAwMDxiciAvPqAgJmx0
OzUmZ3Q7W6CgoCAxLjQ0Mzc1Nl0gc2QgMTowOjA6MDogW3NkYl0gV3JpdGUgY2FjaGU6IGVuYWJs
ZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3IgRlVBPGJyIC8+
oCAmbHQ7NiZndDtboKCgIDEuNDU5NDM4XaAgc2RhOiBzZGExIHNkYTIgc2RhMyBzZGE0PGJyIC8+
oCAmbHQ7NSZndDtboKCgIDEuNDYwMTk3XSBzZCAwOjA6MDowOiBbc2RhXSBBdHRhY2hlZCBTQ1NJ
IGRpc2s8YnIgLz6gICZsdDs2Jmd0O1ugoKAgMS40NzYzOTRdIFN5bmFwdGljcyBUb3VjaHBhZCwg
bW9kZWw6IDEsIGZ3OiA2LjMsIGlkOiAweDEyYTBiMSwgY2FwczogMHhhMDQ3MTEvMHhhMDQwMDAv
MHgwPGJyIC8+oCAmbHQ7NiZndDtboKCgIDEuNDgxODk4XaAgc2RiOiBzZGIxIHNkYjIgc2RiMzxi
ciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQ4MjI1NF0gc2QgMTowOjA6MDogW3NkYl0gQXR0YWNoZWQg
U0NTSSBkaXNrPGJyIC8+PGJyIC8+PGJyIC8+PGJyIC8+oCAmbHQ7NiZndDtboKCgIDMuMjAxMTEx
XSBTR0kgWEZTIHdpdGggQUNMcywgc2VjdXJpdHkgYXR0cmlidXRlcywgcmVhbHRpbWUsIGxhcmdl
IGJsb2NrL2lub2RlIG51bWJlcnMsIG5vIGRlYnVnIGVuYWJsZWQ8YnIgLz6gICZsdDs2Jmd0O1ug
oKAgMy4yMDIyNzldIFNHSSBYRlMgUXVvdGEgTWFuYWdlbWVudCBzdWJzeXN0ZW08YnIgLz6gICZs
dDs1Jmd0O1ugoKAgMy4yMzAxNzRdIFhGUyBtb3VudGluZyBmaWxlc3lzdGVtIHNkYjI8YnIgLz6g
ICZsdDs3Jmd0O1ugoKAgMy4zNTEzMjNdIEVuZGluZyBjbGVhbiBYRlMgbW91bnQgZm9yIGZpbGVz
eXN0ZW06IHNkYjI8YnIgLz48YnIgLz6gICZsdDs1Jmd0O1ugoCAxMS44NjUzOTNdIFhGUyBtb3Vu
dGluZyBmaWxlc3lzdGVtIHNkYjM8YnIgLz6gICZsdDs3Jmd0O1ugoCAxMi4wMDg3MDddIEVuZGlu
ZyBjbGVhbiBYRlMgbW91bnQgZm9yIGZpbGVzeXN0ZW06IHNkYjM8YnIgLz48YnIgLz5JIGRvIG5v
dCBzZWUgYW55dGhpbmcgdGhhdCBzYXlzIGJhcnJpZXIgaXMgbm90IHN1cHBvcnRlZC6gIEluIGZh
Y3QsIEkgaGF2ZSBuZXZlciBwZXJzb25hbGx5IHNlZW4gYSBzeXN0ZW0gd2l0aCBhIG1lc3NhZ2Ug
dGhhdCBiYXJyaWVyIGlzIG5vdCBzdXBwb3J0ZWQuPGJyIC8+PGJyIC8+Jmd0OyBPbmx5IGJ5IGxv
b2tpbmcgYXQgdGhlbSBjYW4geW91IGtub3cuIFJlZ2FyZGxlc3Mgb2Ygd2hhdCBmaWxlc3lzdGVt
IHlvdTxiciAvPmFyZSB1c2luZywgcmVjb3Zlcnkgb2YgZmlsZXMgYW5kIGRpcmVjdG9yaWVzIGZy
b20gbG9zdCtmb3VuZCBpcyB0aGUgc2FtZSBwcm9jZXNzLiBlLmcuIGRvIGFuIHJwbSBjaGVjayB0
byBzZWUgaWYgYWxsdGVoIGluc3RhbGxlZCBwYWNrYWdlcyBhcmUgaW50YWN0LiB0aGF0IHdpbGwg
bmFycm93IGRvd24gd2hlcmUgYWxsIHlvdXIgYmluYXJpZXMgY2FtZSBmcm9tLiB1c2Ugb2Ygc3Ry
aW5ncyBjYW4gYWxzbyB0ZWxsIHlvdSB3aGF0IHRoZSBiaW5hcnkgaXMuIGUuZzo8YnIgLz48YnIg
Lz4mZ3Q7Jmd0OyBJbnR1aXRpdmVseSwgdGhlIG9ubHkgZmlsZXMgaW4gcm9vdCBmaWxlIHN5c3Rl
bSAoYnkgdGhlIHdheSwgcm9vdCBhbHNvPGJyIC8+Y29udGFpbnMgL2Jvb3QpIHRoYXQgYXJlIG9w
ZW4gZm9yIHdyaXRpbmcgYXJlIHRob3NlIGluIGxvZ3MgYW5kIC90bXAgYW5kPGJyIC8+Jmd0OyZn
dDsgL3Zhci90bXAsIEkgaG9wZSB0aGF0IGlzIHRoZSBjYXNlIGFuZCBJIGNhbiBzYWZlbHkgZGlz
Y2FyZCB0aG9zZSBpbjxiciAvPmxvc3QrZm91bmQuPGJyIC8+Jmd0OyZndDsgSSBhbHNvIGhvcGUg
dGhhdCB0aGUgaW5vZGUgbGluayBjbGVhbi11cHMgZG9uZSBieSB4ZnNfcmVwYWlyIGRvIG5vdDxi
ciAvPmFjdHVhbGx5IHJlbW92ZSBhbnkgZmlsZXMgdGhhdCBhcmUgcmVhbGx5IHRoZXJlLjxiciAv
PiZndDsgPGJyIC8+Jmd0OyBEZWZpbmUgJnF1b3Q7cmVhbGx5IHRoZXJlJnF1b3Q7IHdoZW4gaW1w
b3J0YW50IG1ldGFkYXRhIChpLmUuIHRoZSBsb2cpIGhhcyBiZWVuPGJyIC8+Y29ycnVwdGVkIGFu
ZCBpcyBub3QgYXZhaWxhYmxlIGFueSBtb3JlLiAgSW5kZWVkLCBpZiB0aGluZ3MgbGlrZSBidHJl
ZSBzcGxpdHMgb2YgbWVyZ2VzIG9jY3VycmVkIGluIHRoZSBsb2csIGFuZCB0aGV5IGFyZTxiciAv
PiZndDsgcGFydGlhbGx5IHdyaXR0ZW4gdG8gZGlzaywgaXQncyBlbnRpcmVseSBwb3NzaWJsZSB0
aGF0IHlvdSBjb3VsZCBsb3NlPGJyIC8+ZGlyZWN0b3J5IHJlZmVyZW5jZXMgdG8gaW5vZGVzIHRo
YXQgaGF2ZW4ndCBiZWVuIG1vZGlmaWVkIGZvciBzb21lIHRpbWUuLi4uPGJyIC8+Jmd0OyA8YnIg
Lz4mZ3Q7IFJlbWVtYmVyLCBsaWtlIGFsbCBmc2NrIHByb2dyYW1zLCB4ZnNfcmVwYWlyIGlzIGEg
YmVzdCBlZmZvcnQ8YnIgLz4mZ3Q7IGF0dGVtcHQgYXQgY29ycmVjdGluZyB0aGUgcHJvYmxlbXMg
Zm91bmQgIC0gdGhlcmUgYXJlIG5vIGd1YXJhbnRlZXM8YnIgLz5naXZlbiBhYm91dCB3aGF0IGl0
IGNhbiBhbmQgY2FuJ3QgcmVjb3ZlciB3aGVuIGl0IHJ1bnMuLi48YnIgLz4mZ3Q7IDxiciAvPiZn
dDsgRGF2ZS48YnIgLz4mZ3Q7IC0tPGJyIC8+Jmd0OyBEYXZlIENoaW5uZXI8YnIgLz4mZ3Q7IGRh
dmlkQGZyb21vcmJpdC5jb208YnIgLz4mZ3Q7IDxiciAvPjxiciAvPkxvb2tpbmcgYXQgdGhlIG1l
c3NhZ2VzIGZyb20geGZzX3JlcGFpciwgYW5kIGluc3BlY3Rpb24gb2YgL2xvc3QrZm91bmQsIHRo
ZSBmaWxlcyBpbiBpdCBhcmUgZnJvbSAvdG1wIGFuZCAvZXRjL05ldHdvcmtNYW5hZ2VyL3N5c3Rl
bS1jb25uZWN0aW9ucy9BdXRvIGV0aDAuoCBJIGRpZCBycG0gLVYgLWEuoCBBbGwgdGhlIGZpbGVz
IGluIGxvc3QgPGJyIC8+PGJyIC8+PGJyIC8+PGJyIC8+PGJyIC8+
------=_20120903001305_82642
Content-Type: text/html; name="untitled-[1.2]"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="untitled-[1.2]"

PHA+PC9wPjxwPjwvcD48cD48L3A+PHA+PC9wPjxwPjwvcD48cD48L3A+PHA+PC9wPgo8YnIgLz48
YnIgLz5IaSBEYXZlPGJyIC8+PGJyIC8+SSBkaWQgdGhlIHhmc19yZXBhaXIgLUwgb24gdGhlIHJv
b3QgZmlsZSBzeXN0ZW07IHhmc19yZXBhaXIgaXMgdmVyc2lvbiAzLjEuOC6gIFRoZSByZXBhaXIg
d2FzIHN1Y2Nlc3NmdWwuPGJyIC8+PGJyIC8+Jmd0OyBZb3UgbWlzdW5kZXJzdG9vZC4gSSB3YXMg
YXNraW5nIGZvciB0aGUgbWVzc2FnZXMgd2hlbiBpdDxiciAvPiZndDsgc3VjY2Vzc2Z1bGx5IG1v
dW50cyBhbmQgdGhlIGNvbnRlbnRzIG9mIC9wcm9jL21vdW50cyBpcyB3aGVuIGl0IGlzIG1vdW50
ZWQgdG8gc2VlIGlmIGJhcnJpZXJzIHdlcmUgZGlzYWJsZWQgb3Igbm90IHN1cHBvcnRlZCBvbiB5
b3VyIGhhcmR3YXJlLjxiciAvPiZndDsgPGJyIC8+VGhlIG5vdGVib29rIGlzIEFjZXIgQXNwaXJl
IDY1MzBHLCBBTUQgVHVyaW9uIFgyIFJNLTc0LCBjaGlwc2V0IGlzIEFNRCBNNzgwRywgc291dGhi
cmlkZ2UgaXMgQU1EIFNCIDcwMC6gIFRoZSBoYXJkIGRyaXZlIGlzIFdlc3Rlcm4gRGlnaXRhbCBT
Y29ycGlvIEJsYWNrIFNBVEEgMzIwIEdCLCBXREMgV0QzMjAwQkVLVC0wMEYzVDAsIC9kZXYvc2Ri
PGJyIC8+Y2hpbmdsQHJhdDp+Jmd0OyBjYXQ8YnIgLz4vZXRjL2ZzdGFioKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoDxiciAvPjxiciAvPi9kZXYvZGlzay9i
eS1wYXRoL3BjaS0wMDAwOjAwOjExLjAtc2NzaS0xOjA6MDowLXBhcnQxIHN3YXCgoKCgoKCgoKCg
oKCgoKCgIHN3YXCgoKCgoKAgZGVmYXVsdHOgoKCgoKCgoKCgoKCgIDA8YnIgLz4woKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKA8YnIgLz48YnIgLz4vZGV2L2Rpc2svYnktcGF0aC9wY2ktMDAwMDowMDox
MS4wLXNjc2ktMTowOjA6MC1wYXJ0MiAvoKCgoKCgoKCgoKCgoKCgoKCgoCB4ZnOgoKCgoKCgIGRl
ZmF1bHRzLGxvZ2J1ZnM9OCxsb2dic2l6ZT0yNTZroKCgoKCgoKCgoKCgoCAxPGJyIC8+MaCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxiciAv
Pi9kZXYvZGlzay9ieS1wYXRoL3BjaS0wMDAwOjAwOjExLjAtc2NzaS0xOjA6MDowLXBhcnQzIC9o
b21loKCgoKCgoKCgoKCgoKCgIHhmc6CgoKCgoKAgZGVmYXVsdHMsbG9nYnVmcz04LGxvZ2JzaXpl
PTI1NmugoKCgoKCgoKCgoKCgIDEgMjxiciAvPi9kZXYvZGlzay9ieS1wYXRoL3BjaS0wMDAwOjAw
OjExLjAtc2NzaS0wOjA6MDowLXBhcnQyIC93aW5kb3dzL0OgoKCgoKCgoKCgIG50ZnMtM2egoKAg
dXNlcnMsZ2lkPXVzZXJzLGZtYXNrPTEzMyxkbWFzaz0wMjIsbG9jYWxlPWVuX1VTLlVURi04IDAg
MCAvZGV2L2Rpc2svYnktcGF0aC9wY2ktMDAwMDowMDoxMS4wLXNjc2ktMDowOjA6MC1wYXJ0MyAv
d2luZG93cy9EoKCgoKCgoKCgoCBudGZzLTNnoKCgIHVzZXJzLGdpZD11c2VycyxmbWFzaz0xMzMs
ZG1hc2s9MDIyLGxvY2FsZT1lbl9VUy5VVEYtOCAwIDAgcHJvY6CgoKCgoKCgoKCgoKCgoKAgL3By
b2OgoKCgoKCgoKCgoKCgoKAgcHJvY6CgoKCgoCBkZWZhdWx0c6CgoKCgoKCgoKCgoKAgMCAwPGJy
IC8+c3lzZnOgoKCgoKCgoKCgoKCgoKAgL3N5c6CgoKCgoKCgoKCgoKCgoKAgc3lzZnOgoKCgoCBu
b2F1dG+goKCgoKCgoKCgoKCgoKAgMCAwPGJyIC8+ZGVidWdmc6CgoKCgoKCgoKCgoKAgL3N5cy9r
ZXJuZWwvZGVidWegoKAgZGVidWdmc6CgoCBub2F1dG+goKCgoKCgoKCgoKCgoKAgMCAwPGJyIC8+
dXNiZnOgoKCgoKCgoKCgoKCgoKAgL3Byb2MvYnVzL3VzYqCgoKCgoKAgdXNiZnOgoKCgoCBub2F1
dG+goKCgoKCgoKCgoKCgoKAgMCAwPGJyIC8+ZGV2cHRzoKCgoKCgoKCgoKCgoKAgL2Rldi9wdHOg
oKCgoKCgoKCgoKAgZGV2cHRzoKCgoCBtb2RlPTA2MjAsZ2lkPTWgoKCgoKAgMCAwPGJyIC8+Y2hp
bmdsQHJhdDp+Jmd0OzxiciAvPmNoaW5nbEByYXQ6fiZndDsgY2F0IC9wcm9jL21vdW50cyA8YnIg
Lz5yb290ZnMgLyByb290ZnMgcncgMCAwPGJyIC8+ZGV2dG1wZnMgL2RldiBkZXZ0bXBmcyBydyxy
ZWxhdGltZSxzaXplPTE3NjExODRrLG5yX2lub2Rlcz00NDAyOTYsbW9kZT03NTUgMCAwPGJyIC8+
dG1wZnMgL2Rldi9zaG0gdG1wZnMgcncscmVsYXRpbWUgMCAwPGJyIC8+ZGV2cHRzIC9kZXYvcHRz
IGRldnB0cyBydyxyZWxhdGltZSxnaWQ9NSxtb2RlPTYyMCxwdG14bW9kZT0wMDAgMCAwIC9kZXYv
c2RiMiAvIHhmcyBydyxyZWxhdGltZSxhdHRyMixsb2didWZzPTgsbG9nYnNpemU9MjU2ayxub3F1
b3RhIDAgMCBwcm9jIC9wcm9jIHByb2MgcncscmVsYXRpbWUgMCAwPGJyIC8+c3lzZnMgL3N5cyBz
eXNmcyBydyxyZWxhdGltZSAwIDA8YnIgLz5kZWJ1Z2ZzIC9zeXMva2VybmVsL2RlYnVnIGRlYnVn
ZnMgcncscmVsYXRpbWUgMCAwPGJyIC8+L2Rldi9zZGIzIC9ob21lIHhmcyBydyxyZWxhdGltZSxh
dHRyMixsb2didWZzPTgsbG9nYnNpemU9MjU2ayxub3F1b3RhIDAgMCBmdXNlY3RsIC9zeXMvZnMv
ZnVzZS9jb25uZWN0aW9ucyBmdXNlY3RsIHJ3LHJlbGF0aW1lIDAgMDxiciAvPnNlY3VyaXR5ZnMg
L3N5cy9rZXJuZWwvc2VjdXJpdHkgc2VjdXJpdHlmcyBydyxyZWxhdGltZSAwIDA8YnIgLz5ub25l
IC9wcm9jL3N5cy9mcy9iaW5mbXRfbWlzYyBiaW5mbXRfbWlzYyBydyxyZWxhdGltZSAwIDA8YnIg
Lz5ub25lIC92YXIvbGliL250cC9wcm9jIHByb2Mgcm8sbm9zdWlkLG5vZGV2LHJlbGF0aW1lIDAg
MDxiciAvPmd2ZnMtZnVzZS1kYWVtb24gL2hvbWUvY2hpbmdsLy5ndmZzIGZ1c2UuZ3Zmcy1mdXNl
LWRhZW1vbjxiciAvPnJ3LG5vc3VpZCxub2RldixyZWxhdGltZSx1c2VyX2lkPTEwMDAsZ3JvdXBf
aWQ9MTAwIDAgMDxiciAvPmNoaW5nbEByYXQ6fiZndDs8YnIgLz48YnIgLz6gICZsdDs2Jmd0O1ug
oKAgMS4wODQwODVdIGF0YTM6IFNBVEEgbGluayBkb3duIChTU3RhdHVzIDAgU0NvbnRyb2wgMzAw
KTxiciAvPqAgJmx0OzYmZ3Q7W6CgoCAxLjA4NDE3Ml0gYXRhNDogU0FUQSBsaW5rIGRvd24gKFNT
dGF0dXMgMCBTQ29udHJvbCAzMDApPGJyIC8+oCAmbHQ7MyZndDtboKCgIDEuMjU2MDU4XSBhdGEy
OiBzb2Z0cmVzZXQgZmFpbGVkIChkZXZpY2Ugbm90IHJlYWR5KTxiciAvPqAgJmx0OzQmZ3Q7W6Cg
oCAxLjI1NjA2N10gYXRhMjogYXBwbHlpbmcgU0I2MDAgUE1QIFNSU1Qgd29ya2Fyb3VuZCBhbmQg
cmV0cnlpbmcgoCAmbHQ7MyZndDtboKCgIDEuMjU2MDg0XSBhdGExOiBzb2Z0cmVzZXQgZmFpbGVk
IChkZXZpY2Ugbm90IHJlYWR5KTxiciAvPqAgJmx0OzQmZ3Q7W6CgoCAxLjI1NjA5NV0gYXRhMTog
YXBwbHlpbmcgU0I2MDAgUE1QIFNSU1Qgd29ya2Fyb3VuZCBhbmQgcmV0cnlpbmcgoCAmbHQ7NiZn
dDtboKCgIDEuNDI4MDY5XSBhdGEyOiBTQVRBIGxpbmsgdXAgMy4wIEdicHMgKFNTdGF0dXMgMTIz
IFNDb250cm9sIDMwMCkgoCAmbHQ7NiZndDtboKCgIDEuNDI4MDk3XSBhdGExOiBTQVRBIGxpbmsg
dXAgMy4wIEdicHMgKFNTdGF0dXMgMTIzIFNDb250cm9sIDMwMCkgoCAmbHQ7NiZndDtboKCgIDEu
NDI5NDU0XSBhdGExLjAwOiBBVEEtODogSGl0YWNoaSBIVFM1NDMyMzJMOUEzMDAsIEZCNE9DNDBD
LCBtYXggVURNQS8xMzM8YnIgLz6gICZsdDs2Jmd0O1ugoKAgMS40Mjk0NThdIGF0YTEuMDA6IDYy
NTE0MjQ0OCBzZWN0b3JzLCBtdWx0aSAxNjogTEJBNDggTkNRIChkZXB0aCAzMS8zMiksIEFBPGJy
IC8+oCAmbHQ7NiZndDtboKCgIDEuNDMwOTIzXSBhdGExLjAwOiBjb25maWd1cmVkIGZvciBVRE1B
LzEzMzxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQzMTE2NF0gc2NzaSAwOjA6MDowOiBEaXJlY3Qt
QWNjZXNzoKCgoCBBVEGgoKCgoCBIaXRhY2hpIEhUUzU0MzIzIEZCNE8gUFE6IDAgQU5TSTogNTxi
ciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQzMTU2MF0gc2QgMDowOjA6MDogW3NkYV0gNjI1MTQyNDQ4
IDUxMi1ieXRlIGxvZ2ljYWwgYmxvY2tzOiAoMzIwIEdCLzI5OCBHaUIpPGJyIC8+oCAmbHQ7NSZn
dDtboKCgIDEuNDMxNjcyXSBzZCAwOjA6MDowOiBbc2RhXSBXcml0ZSBQcm90ZWN0IGlzIG9mZjxi
ciAvPqAgJmx0OzcmZ3Q7W6CgoCAxLjQzMTY3NV0gc2QgMDowOjA6MDogW3NkYV0gTW9kZSBTZW5z
ZTogMDAgM2EgMDAgMDA8YnIgLz6gICZsdDs1Jmd0O1ugoKAgMS40MzE5MTVdIHNkIDA6MDowOjA6
IFtzZGFdIFdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVkLCBkb2Vzbid0
IHN1cHBvcnQgRFBPIG9yIEZVQTxiciAvPqAgJmx0OzYmZ3Q7W6CgoCAxLjQ0MTA2NF0gYXRhMi4w
MDogQVRBLTg6IFdEQyBXRDMyMDBCRUtULTAwRjNUMCwgMTEuMDFBMTEsIG1heCBVRE1BLzEzMzxi
ciAvPqAgJmx0OzYmZ3Q7W6CgoCAxLjQ0MTA2N10gYXRhMi4wMDogNjI1MTQyNDQ4IHNlY3RvcnMs
IG11bHRpIDE2OiBMQkE0OCBOQ1EgKGRlcHRoIDMxLzMyKSwgQUE8YnIgLz6gICZsdDs2Jmd0O1ug
oKAgMS40NDI5NzhdIGF0YTIuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTMzPGJyIC8+oCAmbHQ7
NSZndDtboKCgIDEuNDQzMjA3XSBzY3NpIDE6MDowOjA6IERpcmVjdC1BY2Nlc3OgoKCgIEFUQaCg
oKCgIFdEQzxiciAvPldEMzIwMEJFS1QtMCAxMS4wIFBROiAwIEFOU0k6IDU8YnIgLz6gICZsdDs1
Jmd0O1ugoKAgMS40NDMzODddIHNkIDE6MDowOjA6IFtzZGJdIDYyNTE0MjQ0OCA1MTItYnl0ZSBs
b2dpY2FsIGJsb2NrczogKDMyMCBHQi8yOTggR2lCKTxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQ0
MzcwN10gc2QgMTowOjA6MDogW3NkYl0gV3JpdGUgUHJvdGVjdCBpcyBvZmY8YnIgLz6gICZsdDs3
Jmd0O1ugoKAgMS40NDM3MTBdIHNkIDE6MDowOjA6IFtzZGJdIE1vZGUgU2Vuc2U6IDAwIDNhIDAw
IDAwPGJyIC8+oCAmbHQ7NSZndDtboKCgIDEuNDQzNzU2XSBzZCAxOjA6MDowOiBbc2RiXSBXcml0
ZSBjYWNoZTogZW5hYmxlZCwgcmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0IERQ
TyBvciBGVUE8YnIgLz6gICZsdDs2Jmd0O1ugoKAgMS40NTk0MzhdoCBzZGE6IHNkYTEgc2RhMiBz
ZGEzIHNkYTQ8YnIgLz6gICZsdDs1Jmd0O1ugoKAgMS40NjAxOTddIHNkIDA6MDowOjA6IFtzZGFd
IEF0dGFjaGVkIFNDU0kgZGlzazxiciAvPqAgJmx0OzYmZ3Q7W6CgoCAxLjQ3NjM5NF0gU3luYXB0
aWNzIFRvdWNocGFkLCBtb2RlbDogMSwgZnc6IDYuMywgaWQ6IDB4MTJhMGIxLCBjYXBzOiAweGEw
NDcxMS8weGEwNDAwMC8weDA8YnIgLz6gICZsdDs2Jmd0O1ugoKAgMS40ODE4OThdoCBzZGI6IHNk
YjEgc2RiMiBzZGIzPGJyIC8+oCAmbHQ7NSZndDtboKCgIDEuNDgyMjU0XSBzZCAxOjA6MDowOiBb
c2RiXSBBdHRhY2hlZCBTQ1NJIGRpc2s8YnIgLz48YnIgLz48YnIgLz48YnIgLz6gICZsdDs2Jmd0
O1ugoKAgMy4yMDExMTFdIFNHSSBYRlMgd2l0aCBBQ0xzLCBzZWN1cml0eSBhdHRyaWJ1dGVzLCBy
ZWFsdGltZSwgbGFyZ2UgYmxvY2svaW5vZGUgbnVtYmVycywgbm8gZGVidWcgZW5hYmxlZDxiciAv
PqAgJmx0OzYmZ3Q7W6CgoCAzLjIwMjI3OV0gU0dJIFhGUyBRdW90YSBNYW5hZ2VtZW50IHN1YnN5
c3RlbTxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAzLjIzMDE3NF0gWEZTIG1vdW50aW5nIGZpbGVzeXN0
ZW0gc2RiMjxiciAvPqAgJmx0OzcmZ3Q7W6CgoCAzLjM1MTMyM10gRW5kaW5nIGNsZWFuIFhGUyBt
b3VudCBmb3IgZmlsZXN5c3RlbTogc2RiMjxiciAvPjxiciAvPqAgJmx0OzUmZ3Q7W6CgIDExLjg2
NTM5M10gWEZTIG1vdW50aW5nIGZpbGVzeXN0ZW0gc2RiMzxiciAvPqAgJmx0OzcmZ3Q7W6CgIDEy
LjAwODcwN10gRW5kaW5nIGNsZWFuIFhGUyBtb3VudCBmb3IgZmlsZXN5c3RlbTogc2RiMzxiciAv
PjxiciAvPjxiciAvPiZndDsgSXQncyBub3QgY2hhcmdpbmcgTGktaW9uIGJhdHRlcmllcyB0aGF0
IHNob3J0ZW5zIHRoZWlyIGxpZmUgLSBpdCdzIGhpZ2ggdGVtcGVyYXR1cmVzIHRoYXQgc2hvcnRl
biBpdC4gSU9XcywgdGhlIHJlYXNvbiBmb3IgcmVtb3ZpbmcgdGhlIGJhdHRlcnkgd2hlbiBvbiBB
QyBpcyB0byBwcmV2ZW50IGhlYXQgc29hayBhbmQgdGhlIGJhdHRlcnk8YnIgLz4mZ3Q7IHN1c3Rh
aW5pbmcgZWxldmF0ZWQgdGVtcGVyYXR1cmVzIG92ZXIgbG9uZyBwZXJpb2RzIG9mIHRpbWUuPGJy
IC8+Jmd0OyA8YnIgLz4mZ3Q7IEV2ZW4gc28sIHByb3Blcmx5IGRlc2lnbmVkIGxhcHRvcHMgZG9u
J3Qgc3VmZmVyIGZyb20gaGVhdCBzb2FrIG9yIGNoYXJnZSBjeWNsZSByZWxhdGVkIGJhdHRlcnkg
bGlmZSBwcm9ibGVtcywgYW5kIGVudmlyb25tZW50YWw8YnIgLz4mZ3Q7IGNvbmRpdGlvbnMgcGxh
eSBtb3JlIG9mIGEgcGFydCBpbiBkZXRlcm1pbmluZyBiYXR0ZXJ5IGxpZmUgdGhhbjxiciAvPiZn
dDsgdXNhZ2UvY2hhcmdlIHBhdHRlcm5zLi4uPGJyIC8+Jmd0OyA8YnIgLz4mZ3Q7Jmd0OyAmZ3Q7
IFRoZSBmaWxlcyBpbiBsb3N0K2ZvdW5kIGFyZSBudW1iZXJlZCBieSB0aGVpciBpbm9kZSBudW1i
ZXIuIFlvdSBuZWVkIHRvIGxvb2sgYXQgdGhlIGNvbnRlbnRzIG9mIHRoZW0gdG8gZGV0ZXJtaW5l
IHdoZXJlIHRoZXkgY2FtZSBmcm9tLjxiciAvPiZndDsmZ3Q7IElub2RlIG51bWJlcnMgYXJlIG5v
dCBpbmZvcm1hdGl2ZSwgcmlnaHQ/PGJyIC8+Jmd0OyA8YnIgLz4mZ3Q7IFN1cmUsIGJ1dCB3aGVu
IHlvdSd2ZSBoYWQgYSBkaXJlY3RvcnkgY29ycnVwdGlvbiBhbmQgdGhlIG5hbWVzIGhhdmUgYmVl
biBsb3N0LCB3aGF0IGRvIHlvdSBuYW1lIHRoZSBmaWxlcyBhbmQgZGlyZWN0b3JpZXMgdGhhdCBh
cmU8YnIgLz4mZ3Q7IGZvdW5kPyBBbGwgd2UgY2FuIGRvIGlzIG5hbWUgdGhlbSBzb21ldGhpbmcg
dW5pcXVlLCBoZW5jZSB0aGUgdXNlIG9mIHRoZSBpbm9kZSBudW1iZXIuPGJyIC8+Jmd0OyA8YnIg
Lz4mZ3Q7Jmd0OyBUZXh0IGZpbGVzIGFyZSByZWFkYWJsZSwgYnV0IGJpbmFyaWVzLi4uLi4uLCBJ
IHdpbGwgaGF2ZSBubyBjbHVlLCBhbmQ8YnIgLz5pZjxiciAvPiZndDsmZ3Q7IEk8YnIgLz4mZ3Q7
Jmd0OyBkZWxldGUgdGhlbSwgd2hvIGtub3dzIGlmIEkgYW0gZGVsZXRpbmcgc29tZSB0aGluZyBy
ZWFsbHkgaW1wb3J0YW50PzxiciAvPiZndDsgPGJyIC8+Jmd0OyBPbmx5IGJ5IGxvb2tpbmcgYXQg
dGhlbSBjYW4geW91IGtub3cuIFJlZ2FyZGxlc3Mgb2Ygd2hhdCBmaWxlc3lzdGVtIHlvdSBhcmUg
dXNpbmcsIHJlY292ZXJ5IG9mIGZpbGVzIGFuZCBkaXJlY3RvcmllcyBmcm9tIGxvc3QrZm91bmQg
aXMgdGhlIHNhbWUgcHJvY2Vzcy4gZS5nLiBkbyBhbiBycG0gY2hlY2sgdG8gc2VlIGlmIGFsbHRl
aCBpbnN0YWxsZWQgcGFja2FnZXMgYXJlIGludGFjdC4gdGhhdCB3aWxsIG5hcnJvdyBkb3duIHdo
ZXJlIGFsbCB5b3VyIGJpbmFyaWVzIGNhbWUgZnJvbS4gdXNlIG9mIHN0cmluZ3MgY2FuIGFsc28g
dGVsbCB5b3Ugd2hhdCB0aGUgYmluYXJ5IGlzLiBlLmc6PGJyIC8+Jmd0OyA8YnIgLz4mZ3Q7ICQg
c3RyaW5ncyAvc2Jpbi94ZnNfcmVwYWlyIHxncmVwIHhmc19yZXBhaXI8YnIgLz4mZ3Q7IHJlLXJ1
bm5pbmcgeGZzX3JlcGFpci4gIElmIHlvdSBhcmUgdW5hYmxlIHRvIG1vdW50IHRoZSBmaWxlc3lz
dGVtLCB0aGVuIHVzZTxiciAvPiZndDsgUGxlYXNlIHJ1biBhIG1vcmUgcmVjZW50IHZlcnNpb24g
b2YgeGZzX3JlcGFpci48YnIgLz4mZ3Q7ICQ8YnIgLz4mZ3Q7IDxiciAvPiZndDsmZ3Q7IEludHVp
dGl2ZWx5LCB0aGUgb25seSBmaWxlcyBpbiByb290IGZpbGUgc3lzdGVtIChieSB0aGUgd2F5LCBy
b290IGFsc28gY29udGFpbnMgL2Jvb3QpIHRoYXQgYXJlIG9wZW4gZm9yIHdyaXRpbmcgYXJlIHRo
b3NlIGluIGxvZ3MgYW5kIC90bXA8YnIgLz5hbmQ8YnIgLz4mZ3Q7Jmd0OyAvdmFyL3RtcCwgSSBo
b3BlIHRoYXQgaXMgdGhlIGNhc2UgYW5kIEkgY2FuIHNhZmVseSBkaXNjYXJkIHRob3NlIGluIGxv
c3QrZm91bmQuPGJyIC8+Jmd0OyZndDsgSSBhbHNvIGhvcGUgdGhhdCB0aGUgaW5vZGUgbGluayBj
bGVhbi11cHMgZG9uZSBieSB4ZnNfcmVwYWlyIGRvIG5vdCBhY3R1YWxseSByZW1vdmUgYW55IGZp
bGVzIHRoYXQgYXJlIHJlYWxseSB0aGVyZS48YnIgLz4mZ3Q7IDxiciAvPiZndDsgRGVmaW5lICZx
dW90O3JlYWxseSB0aGVyZSZxdW90OyB3aGVuIGltcG9ydGFudCBtZXRhZGF0YSAoaS5lLiB0aGUg
bG9nKSBoYXMgYmVlbiBjb3JydXB0ZWQgYW5kIGlzIG5vdCBhdmFpbGFibGUgYW55IG1vcmUuICBJ
bmRlZWQsIGlmIHRoaW5ncyBsaWtlIGJ0cmVlIHNwbGl0cyBvZiBtZXJnZXMgb2NjdXJyZWQgaW4g
dGhlIGxvZywgYW5kIHRoZXkgYXJlPGJyIC8+Jmd0OyBwYXJ0aWFsbHkgd3JpdHRlbiB0byBkaXNr
LCBpdCdzIGVudGlyZWx5IHBvc3NpYmxlIHRoYXQgeW91IGNvdWxkIGxvc2UgZGlyZWN0b3J5IHJl
ZmVyZW5jZXMgdG8gaW5vZGVzIHRoYXQgaGF2ZW4ndCBiZWVuIG1vZGlmaWVkIGZvciBzb21lIHRp
bWUuLi4uPGJyIC8+Jmd0OyA8YnIgLz4mZ3Q7IFJlbWVtYmVyLCBsaWtlIGFsbCBmc2NrIHByb2dy
YW1zLCB4ZnNfcmVwYWlyIGlzIGEgYmVzdCBlZmZvcnQ8YnIgLz4mZ3Q7IGF0dGVtcHQgYXQgY29y
cmVjdGluZyB0aGUgcHJvYmxlbXMgZm91bmQgIC0gdGhlcmUgYXJlIG5vIGd1YXJhbnRlZXMgZ2l2
ZW4gYWJvdXQgd2hhdCBpdCBjYW4gYW5kIGNhbid0IHJlY292ZXIgd2hlbiBpdCBydW5zLi4uPGJy
IC8+Jmd0OyA8YnIgLz4mZ3Q7IENoZWVycyw8YnIgLz4mZ3Q7IDxiciAvPiZndDsgRGF2ZS48YnIg
Lz4mZ3Q7IC0tPGJyIC8+Jmd0OyBEYXZlIENoaW5uZXI8YnIgLz4mZ3Q7IGRhdmlkQGZyb21vcmJp
dC5jb208YnIgLz4mZ3Q7IDxiciAvPjxiciAvPjxiciAvPkNoaW4gR2ltIExlb25nPGJyIC8+UGVy
Zm9ybWFuY2UgQ29tcHV0aW5nIEVuZ2luZWVyPGJyIC8+UGVyZm9ybWFuY2UgQ29tcHV0aW5nIExM
UDxiciAvPjxiciAvPmh0dHA6Ly9wZXJmb3JtYW5jZS1jb21wdXRpbmcubmV0PGJyIC8+Q0hJTl9H
aW1fTGVvbmdAcGVyZm9ybWFuY2UtY29tcHV0aW5nLm5ldDxiciAvPlRlbDogKzY1LTk3NDY5NDgy
PGJyIC8+PGJyIC8+PGJyIC8+
------=_20120903001305_82642
Content-Type: text/html; name="untitled-[2]"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="untitled-[2]"

PHA+SGkgRGF2ZTwvcD48cD48L3A+PHA+SSBkaWQgdGhlIHhmc19yZXBhaXIgLUwgb24gdGhlIHJv
b3QgZmlsZSBzeXN0ZW07IHhmc19yZXBhaXIgaXMgdmVyc2lvbiAzLjEuOC6gIFRoZSByZXBhaXIg
d2FzIHN1Y2Nlc3NmdWwuPGJyIC8+PGJyIC8+Jmd0OyBZb3UgbWlzdW5kZXJzdG9vZC4gSSB3YXMg
YXNraW5nIGZvciB0aGUgbWVzc2FnZXMgd2hlbiBpdDxiciAvPiZndDsgc3VjY2Vzc2Z1bGx5IG1v
dW50cyBhbmQgdGhlIGNvbnRlbnRzIG9mIC9wcm9jL21vdW50cyBpcyB3aGVuIGl0IGlzPGJyIC8+
Jmd0OyBtb3VudGVkIHRvIHNlZSBpZiBiYXJyaWVycyB3ZXJlIGRpc2FibGVkIG9yIG5vdCBzdXBw
b3J0ZWQgb24geW91cjxiciAvPiZndDsgaGFyZHdhcmUuPGJyIC8+Jmd0OyA8L3A+PHA+VGhlIG5v
dGVib29rIGlzIEFjZXIgQXNwaXJlIDY1MzBHLCBBTUQgVHVyaW9uIFgyIFJNLTc0LCBjaGlwc2V0
IGlzIEFNRCBNNzgwRywgc291dGhicmlkZ2UgaXMgQU1EIFNCIDcwMC6gIFRoZSBoYXJkIGRyaXZl
IGlzIFdlc3Rlcm4gRGlnaXRhbCBTY29ycGlvIEJsYWNrIFNBVEEgMzIwIEdCLCBXREMgV0QzMjAw
QkVLVC0wMEYzVDAsIC9kZXYvc2RiPC9wPjxwPmNoaW5nbEByYXQ6fiZndDsgY2F0IC9ldGMvZnN0
YWKgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxiciAv
Pi9kZXYvZGlzay9ieS1wYXRoL3BjaS0wMDAwOjAwOjExLjAtc2NzaS0xOjA6MDowLXBhcnQxIHN3
YXCgoKCgoKCgoKCgoKCgoKCgIHN3YXCgoKCgoKAgZGVmYXVsdHOgoKCgoKCgoKCgoKCgIDAgMKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxiciAvPi9kZXYvZGlzay9ieS1wYXRoL3BjaS0wMDAwOjAw
OjExLjAtc2NzaS0xOjA6MDowLXBhcnQyIC+goKCgoKCgoKCgoKCgoKCgoKCgIHhmc6CgoKCgoKAg
ZGVmYXVsdHMsbG9nYnVmcz04LGxvZ2JzaXplPTI1NmugoKCgoKCgoKCgoKCgIDEgMaCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxiciAvPi9k
ZXYvZGlzay9ieS1wYXRoL3BjaS0wMDAwOjAwOjExLjAtc2NzaS0xOjA6MDowLXBhcnQzIC9ob21l
oKCgoKCgoKCgoKCgoKCgIHhmc6CgoKCgoKAgZGVmYXVsdHMsbG9nYnVmcz04LGxvZ2JzaXplPTI1
NmugoKCgoKCgoKCgoKCgIDEgMjxiciAvPi9kZXYvZGlzay9ieS1wYXRoL3BjaS0wMDAwOjAwOjEx
LjAtc2NzaS0wOjA6MDowLXBhcnQyIC93aW5kb3dzL0OgoKCgoKCgoKCgIG50ZnMtM2egoKAgdXNl
cnMsZ2lkPXVzZXJzLGZtYXNrPTEzMyxkbWFzaz0wMjIsbG9jYWxlPWVuX1VTLlVURi04IDAgMDxi
ciAvPi9kZXYvZGlzay9ieS1wYXRoL3BjaS0wMDAwOjAwOjExLjAtc2NzaS0wOjA6MDowLXBhcnQz
IC93aW5kb3dzL0SgoKCgoKCgoKCgIG50ZnMtM2egoKAgdXNlcnMsZ2lkPXVzZXJzLGZtYXNrPTEz
MyxkbWFzaz0wMjIsbG9jYWxlPWVuX1VTLlVURi04IDAgMDxiciAvPnByb2OgoKCgoKCgoKCgoKCg
oKCgIC9wcm9joKCgoKCgoKCgoKCgoKCgIHByb2OgoKCgoKAgZGVmYXVsdHOgoKCgoKCgoKCgoKCg
IDAgMDxiciAvPnN5c2ZzoKCgoKCgoKCgoKCgoKCgIC9zeXOgoKCgoKCgoKCgoKCgoKCgIHN5c2Zz
oKCgoKAgbm9hdXRvoKCgoKCgoKCgoKCgoKCgIDAgMDxiciAvPmRlYnVnZnOgoKCgoKCgoKCgoKCg
IC9zeXMva2VybmVsL2RlYnVnoKCgIGRlYnVnZnOgoKAgbm9hdXRvoKCgoKCgoKCgoKCgoKCgIDAg
MDxiciAvPnVzYmZzoKCgoKCgoKCgoKCgoKCgIC9wcm9jL2J1cy91c2KgoKCgoKCgIHVzYmZzoKCg
oKAgbm9hdXRvoKCgoKCgoKCgoKCgoKCgIDAgMDxiciAvPmRldnB0c6CgoKCgoKCgoKCgoKCgIC9k
ZXYvcHRzoKCgoKCgoKCgoKCgIGRldnB0c6CgoKAgbW9kZT0wNjIwLGdpZD01oKCgoKCgIDAgMDxi
ciAvPmNoaW5nbEByYXQ6fiZndDs8L3A+PHA+Y2hpbmdsQHJhdDp+Jmd0OyBjYXQgL3Byb2MvbW91
bnRzIDxiciAvPnJvb3RmcyAvIHJvb3RmcyBydyAwIDA8YnIgLz5kZXZ0bXBmcyAvZGV2IGRldnRt
cGZzIHJ3LHJlbGF0aW1lLHNpemU9MTc2MTE4NGssbnJfaW5vZGVzPTQ0MDI5Nixtb2RlPTc1NSAw
IDA8YnIgLz50bXBmcyAvZGV2L3NobSB0bXBmcyBydyxyZWxhdGltZSAwIDA8YnIgLz5kZXZwdHMg
L2Rldi9wdHMgZGV2cHRzIHJ3LHJlbGF0aW1lLGdpZD01LG1vZGU9NjIwLHB0bXhtb2RlPTAwMCAw
IDA8YnIgLz4vZGV2L3NkYjIgLyB4ZnMgcncscmVsYXRpbWUsYXR0cjIsbG9nYnVmcz04LGxvZ2Jz
aXplPTI1Nmssbm9xdW90YSAwIDA8YnIgLz5wcm9jIC9wcm9jIHByb2MgcncscmVsYXRpbWUgMCAw
PGJyIC8+c3lzZnMgL3N5cyBzeXNmcyBydyxyZWxhdGltZSAwIDA8YnIgLz5kZWJ1Z2ZzIC9zeXMv
a2VybmVsL2RlYnVnIGRlYnVnZnMgcncscmVsYXRpbWUgMCAwPGJyIC8+L2Rldi9zZGIzIC9ob21l
IHhmcyBydyxyZWxhdGltZSxhdHRyMixsb2didWZzPTgsbG9nYnNpemU9MjU2ayxub3F1b3RhIDAg
MDxiciAvPmZ1c2VjdGwgL3N5cy9mcy9mdXNlL2Nvbm5lY3Rpb25zIGZ1c2VjdGwgcncscmVsYXRp
bWUgMCAwPGJyIC8+c2VjdXJpdHlmcyAvc3lzL2tlcm5lbC9zZWN1cml0eSBzZWN1cml0eWZzIHJ3
LHJlbGF0aW1lIDAgMDxiciAvPm5vbmUgL3Byb2Mvc3lzL2ZzL2JpbmZtdF9taXNjIGJpbmZtdF9t
aXNjIHJ3LHJlbGF0aW1lIDAgMDxiciAvPm5vbmUgL3Zhci9saWIvbnRwL3Byb2MgcHJvYyBybyxu
b3N1aWQsbm9kZXYscmVsYXRpbWUgMCAwPGJyIC8+Z3Zmcy1mdXNlLWRhZW1vbiAvaG9tZS9jaGlu
Z2wvLmd2ZnMgZnVzZS5ndmZzLWZ1c2UtZGFlbW9uIHJ3LG5vc3VpZCxub2RldixyZWxhdGltZSx1
c2VyX2lkPTEwMDAsZ3JvdXBfaWQ9MTAwIDAgMDxiciAvPmNoaW5nbEByYXQ6fiZndDs8L3A+PHA+
PC9wPjxwPqAgJmx0OzYmZ3Q7W6CgoCAxLjA4NDA4NV0gYXRhMzogU0FUQSBsaW5rIGRvd24gKFNT
dGF0dXMgMCBTQ29udHJvbCAzMDApPGJyIC8+oCAmbHQ7NiZndDtboKCgIDEuMDg0MTcyXSBhdGE0
OiBTQVRBIGxpbmsgZG93biAoU1N0YXR1cyAwIFNDb250cm9sIDMwMCk8YnIgLz6gICZsdDszJmd0
O1ugoKAgMS4yNTYwNThdIGF0YTI6IHNvZnRyZXNldCBmYWlsZWQgKGRldmljZSBub3QgcmVhZHkp
PGJyIC8+oCAmbHQ7NCZndDtboKCgIDEuMjU2MDY3XSBhdGEyOiBhcHBseWluZyBTQjYwMCBQTVAg
U1JTVCB3b3JrYXJvdW5kIGFuZCByZXRyeWluZzxiciAvPqAgJmx0OzMmZ3Q7W6CgoCAxLjI1NjA4
NF0gYXRhMTogc29mdHJlc2V0IGZhaWxlZCAoZGV2aWNlIG5vdCByZWFkeSk8YnIgLz6gICZsdDs0
Jmd0O1ugoKAgMS4yNTYwOTVdIGF0YTE6IGFwcGx5aW5nIFNCNjAwIFBNUCBTUlNUIHdvcmthcm91
bmQgYW5kIHJldHJ5aW5nPGJyIC8+oCAmbHQ7NiZndDtboKCgIDEuNDI4MDY5XSBhdGEyOiBTQVRB
IGxpbmsgdXAgMy4wIEdicHMgKFNTdGF0dXMgMTIzIFNDb250cm9sIDMwMCk8YnIgLz6gICZsdDs2
Jmd0O1ugoKAgMS40MjgwOTddIGF0YTE6IFNBVEEgbGluayB1cCAzLjAgR2JwcyAoU1N0YXR1cyAx
MjMgU0NvbnRyb2wgMzAwKTxiciAvPqAgJmx0OzYmZ3Q7W6CgoCAxLjQyOTQ1NF0gYXRhMS4wMDog
QVRBLTg6IEhpdGFjaGkgSFRTNTQzMjMyTDlBMzAwLCBGQjRPQzQwQywgbWF4IFVETUEvMTMzPGJy
IC8+oCAmbHQ7NiZndDtboKCgIDEuNDI5NDU4XSBhdGExLjAwOiA2MjUxNDI0NDggc2VjdG9ycywg
bXVsdGkgMTY6IExCQTQ4IE5DUSAoZGVwdGggMzEvMzIpLCBBQTxiciAvPqAgJmx0OzYmZ3Q7W6Cg
oCAxLjQzMDkyM10gYXRhMS4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMzM8YnIgLz6gICZsdDs1
Jmd0O1ugoKAgMS40MzExNjRdIHNjc2kgMDowOjA6MDogRGlyZWN0LUFjY2Vzc6CgoKAgQVRBoKCg
oKAgSGl0YWNoaSBIVFM1NDMyMyBGQjRPIFBROiAwIEFOU0k6IDU8YnIgLz6gICZsdDs1Jmd0O1ug
oKAgMS40MzE1NjBdIHNkIDA6MDowOjA6IFtzZGFdIDYyNTE0MjQ0OCA1MTItYnl0ZSBsb2dpY2Fs
IGJsb2NrczogKDMyMCBHQi8yOTggR2lCKTxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQzMTY3Ml0g
c2QgMDowOjA6MDogW3NkYV0gV3JpdGUgUHJvdGVjdCBpcyBvZmY8YnIgLz6gICZsdDs3Jmd0O1ug
oKAgMS40MzE2NzVdIHNkIDA6MDowOjA6IFtzZGFdIE1vZGUgU2Vuc2U6IDAwIDNhIDAwIDAwPGJy
IC8+oCAmbHQ7NSZndDtboKCgIDEuNDMxOTE1XSBzZCAwOjA6MDowOiBbc2RhXSBXcml0ZSBjYWNo
ZTogZW5hYmxlZCwgcmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0IERQTyBvciBG
VUE8YnIgLz6gICZsdDs2Jmd0O1ugoKAgMS40NDEwNjRdIGF0YTIuMDA6IEFUQS04OiBXREMgV0Qz
MjAwQkVLVC0wMEYzVDAsIDExLjAxQTExLCBtYXggVURNQS8xMzM8YnIgLz6gICZsdDs2Jmd0O1ug
oKAgMS40NDEwNjddIGF0YTIuMDA6IDYyNTE0MjQ0OCBzZWN0b3JzLCBtdWx0aSAxNjogTEJBNDgg
TkNRIChkZXB0aCAzMS8zMiksIEFBPGJyIC8+oCAmbHQ7NiZndDtboKCgIDEuNDQyOTc4XSBhdGEy
LjAwOiBjb25maWd1cmVkIGZvciBVRE1BLzEzMzxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQ0MzIw
N10gc2NzaSAxOjA6MDowOiBEaXJlY3QtQWNjZXNzoKCgoCBBVEGgoKCgoCBXREMgV0QzMjAwQkVL
VC0wIDExLjAgUFE6IDAgQU5TSTogNTxiciAvPqAgJmx0OzUmZ3Q7W6CgoCAxLjQ0MzM4N10gc2Qg
MTowOjA6MDogW3NkYl0gNjI1MTQyNDQ4IDUxMi1ieXRlIGxvZ2ljYWwgYmxvY2tzOiAoMzIwIEdC
LzI5OCBHaUIpPGJyIC8+oCAmbHQ7NSZndDtboKCgIDEuNDQzNzA3XSBzZCAxOjA6MDowOiBbc2Ri
XSBXcml0ZSBQcm90ZWN0IGlzIG9mZjxiciAvPqAgJmx0OzcmZ3Q7W6CgoCAxLjQ0MzcxMF0gc2Qg
MTowOjA6MDogW3NkYl0gTW9kZSBTZW5zZTogMDAgM2EgMDAgMDA8YnIgLz6gICZsdDs1Jmd0O1ug
oKAgMS40NDM3NTZdIHNkIDE6MDowOjA6IFtzZGJdIFdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFk
IGNhY2hlOiBlbmFibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQTxiciAvPqAgJmx0OzYm
Z3Q7W6CgoCAxLjQ1OTQzOF2gIHNkYTogc2RhMSBzZGEyIHNkYTMgc2RhNDxiciAvPqAgJmx0OzUm
Z3Q7W6CgoCAxLjQ2MDE5N10gc2QgMDowOjA6MDogW3NkYV0gQXR0YWNoZWQgU0NTSSBkaXNrPGJy
IC8+oCAmbHQ7NiZndDtboKCgIDEuNDc2Mzk0XSBTeW5hcHRpY3MgVG91Y2hwYWQsIG1vZGVsOiAx
LCBmdzogNi4zLCBpZDogMHgxMmEwYjEsIGNhcHM6IDB4YTA0NzExLzB4YTA0MDAwLzB4MDxiciAv
PqAgJmx0OzYmZ3Q7W6CgoCAxLjQ4MTg5OF2gIHNkYjogc2RiMSBzZGIyIHNkYjM8YnIgLz6gICZs
dDs1Jmd0O1ugoKAgMS40ODIyNTRdIHNkIDE6MDowOjA6IFtzZGJdIEF0dGFjaGVkIFNDU0kgZGlz
azwvcD48cD48L3A+PHA+PC9wPjxwPjwvcD48cD48L3A+PHA+PC9wPjxwPjwvcD48cD48YnIgLz4m
Z3Q7Jmd0OyAmZ3Q7PGJyIC8+Jmd0OyZndDsgJmd0OyZndDsgSSB3b3VsZCBsaWtlIHRvIGtub3cg
dGhlIGNhdXNlIG9mIHRoaXMgbG9nIHJlY292ZXJ5IGZhaWx1cmUgYW5kIGlmPGJyIC8+Jmd0OyZn
dDsgdGhlcmU8YnIgLz4mZ3Q7Jmd0OyAmZ3Q7PGJyIC8+Jmd0OyZndDsgJmd0OyBZb3UndmUgZ290
IGFuIG9sZCwgdW5zdXBwb3J0ZWQga2VybmVsIHRoYXQgd2FzIGdvaW5nIHRocm91Z2g8YnIgLz4m
Z3Q7Jmd0OyAmZ3Q7IHNpZ25pZmljYW50IGNoYW5nZXMgdG8gdGhlIGxvZyBjb2RlIGF0IHRoZSB0
aW1lLCBzbyBpdCBtYXkgbm90IGJlPGJyIC8+Jmd0OyZndDsgJmd0OyBwb3NzaWJsZSB0byB3b3Jr
IG91dCB3aGF0IHRoZSBwcm9ibGVtIHdhcy4gSXQgc2VlbXMgbGlrZWx5IHRoYXQgdGhlPGJyIC8+
Jmd0OyZndDsgJmd0OyBwb3dlciBsb3NzIGNhdXNlZCB0aGUgZGlzayBub3QgdG8gd3JpdGUgZXZl
cnl0aGluZyBpdCBzaG91bGQgaGF2ZSB0bzxiciAvPiZndDsmZ3Q7ICZndDsgdGhlIGxvZyAtIGxh
cHRvcHMgYXJlIG5vdCBzdXBwb3NlZCB0byBqdXN0IGxvc2UgcG93ZXIgYmVjYXVzZTxiciAvPiZn
dDsmZ3Q7ICZndDsgdGhleSBoYXZlIGEgYnVpbHQgaW4gVVBTIChpLmUuIGJhdHRlcnkpLi4uLjxi
ciAvPiZndDsmZ3Q7PGJyIC8+Jmd0OyZndDsgTXkgbm90ZSBib29rIGlzIGNvbm5lY3RlZCB0byB0
aGUgbWFpbnMsIGFuZCB0aGVyZSBpcyBubyBiYXR0ZXJ5LiAgVGhlPGJyIC8+Jmd0OyZndDsgQWNl
cjxiciAvPiZndDsmZ3Q7IHVzZXIgbWFudWFsIGFkdmlzZXMgcmVtb3ZpbmcgdGhlIGJhdHRlcnkg
d2hlbiBvbmUgaXMgY29ubmVjdGVkIHRvIHRoZTxiciAvPiZndDsmZ3Q7IG1haW5zLCBzaW5jZSBy
ZXBlYXRlZCBjaGFyZ2luZyBvZiBiYXR0ZXJ5IHdpbGwgc2hvcnRlbiBpdHMgbGlmZSBzcGFuLjxi
ciAvPiZndDsgPGJyIC8+Jmd0OyBJdCdzIG5vdCBjaGFyZ2luZyBMaS1pb24gYmF0dGVyaWVzIHRo
YXQgc2hvcnRlbnMgdGhlaXIgbGlmZSAtIGl0J3M8YnIgLz4mZ3Q7IGhpZ2ggdGVtcGVyYXR1cmVz
IHRoYXQgc2hvcnRlbiBpdC4gSU9XcywgdGhlIHJlYXNvbiBmb3IgcmVtb3ZpbmcgdGhlPGJyIC8+
Jmd0OyBiYXR0ZXJ5IHdoZW4gb24gQUMgaXMgdG8gcHJldmVudCBoZWF0IHNvYWsgYW5kIHRoZSBi
YXR0ZXJ5PGJyIC8+Jmd0OyBzdXN0YWluaW5nIGVsZXZhdGVkIHRlbXBlcmF0dXJlcyBvdmVyIGxv
bmcgcGVyaW9kcyBvZiB0aW1lLjxiciAvPiZndDsgPGJyIC8+Jmd0OyBFdmVuIHNvLCBwcm9wZXJs
eSBkZXNpZ25lZCBsYXB0b3BzIGRvbid0IHN1ZmZlciBmcm9tIGhlYXQgc29hayBvcjxiciAvPiZn
dDsgY2hhcmdlIGN5Y2xlIHJlbGF0ZWQgYmF0dGVyeSBsaWZlIHByb2JsZW1zLCBhbmQgZW52aXJv
bm1lbnRhbDxiciAvPiZndDsgY29uZGl0aW9ucyBwbGF5IG1vcmUgb2YgYSBwYXJ0IGluIGRldGVy
bWluaW5nIGJhdHRlcnkgbGlmZSB0aGFuPGJyIC8+Jmd0OyB1c2FnZS9jaGFyZ2UgcGF0dGVybnMu
Li48YnIgLz4mZ3Q7IDxiciAvPiZndDsmZ3Q7ICZndDsgVGhlIGZpbGVzIGluIGxvc3QrZm91bmQg
YXJlIG51bWJlcmVkIGJ5IHRoZWlyIGlub2RlIG51bWJlci4gWW91IG5lZWQ8YnIgLz4mZ3Q7Jmd0
OyAmZ3Q7IHRvIGxvb2sgYXQgdGhlIGNvbnRlbnRzIG9mIHRoZW0gdG8gZGV0ZXJtaW5lIHdoZXJl
IHRoZXkgY2FtZSBmcm9tLjxiciAvPiZndDsmZ3Q7PGJyIC8+Jmd0OyZndDsgSW5vZGUgbnVtYmVy
cyBhcmUgbm90IGluZm9ybWF0aXZlLCByaWdodD88YnIgLz4mZ3Q7IDxiciAvPiZndDsgU3VyZSwg
YnV0IHdoZW4geW91J3ZlIGhhZCBhIGRpcmVjdG9yeSBjb3JydXB0aW9uIGFuZCB0aGUgbmFtZXMg
aGF2ZTxiciAvPiZndDsgYmVlbiBsb3N0LCB3aGF0IGRvIHlvdSBuYW1lIHRoZSBmaWxlcyBhbmQg
ZGlyZWN0b3JpZXMgdGhhdCBhcmU8YnIgLz4mZ3Q7IGZvdW5kPyBBbGwgd2UgY2FuIGRvIGlzIG5h
bWUgdGhlbSBzb21ldGhpbmcgdW5pcXVlLCBoZW5jZSB0aGUgdXNlIG9mPGJyIC8+Jmd0OyB0aGUg
aW5vZGUgbnVtYmVyLjxiciAvPiZndDsgPGJyIC8+Jmd0OyZndDsgVGV4dCBmaWxlcyBhcmUgcmVh
ZGFibGUsIGJ1dCBiaW5hcmllcy4uLi4uLiwgSSB3aWxsIGhhdmUgbm8gY2x1ZSwgYW5kIGlmPGJy
IC8+Jmd0OyZndDsgSTxiciAvPiZndDsmZ3Q7IGRlbGV0ZSB0aGVtLCB3aG8ga25vd3MgaWYgSSBh
bSBkZWxldGluZyBzb21lIHRoaW5nIHJlYWxseSBpbXBvcnRhbnQ/PGJyIC8+Jmd0OyA8YnIgLz4m
Z3Q7IE9ubHkgYnkgbG9va2luZyBhdCB0aGVtIGNhbiB5b3Uga25vdy4gUmVnYXJkbGVzcyBvZiB3
aGF0IGZpbGVzeXN0ZW08YnIgLz4mZ3Q7IHlvdSBhcmUgdXNpbmcsIHJlY292ZXJ5IG9mIGZpbGVz
IGFuZCBkaXJlY3RvcmllcyBmcm9tIGxvc3QrZm91bmQgaXM8YnIgLz4mZ3Q7IHRoZSBzYW1lIHBy
b2Nlc3MuIGUuZy4gZG8gYW4gcnBtIGNoZWNrIHRvIHNlZSBpZiBhbGx0ZWggaW5zdGFsbGVkPGJy
IC8+Jmd0OyBwYWNrYWdlcyBhcmUgaW50YWN0LiB0aGF0IHdpbGwgbmFycm93IGRvd24gd2hlcmUg
YWxsIHlvdXIgYmluYXJpZXM8YnIgLz4mZ3Q7IGNhbWUgZnJvbS4gdXNlIG9mIHN0cmluZ3MgY2Fu
IGFsc28gdGVsbCB5b3Ugd2hhdCB0aGUgYmluYXJ5IGlzLiBlLmc6PGJyIC8+Jmd0OyA8YnIgLz4m
Z3Q7ICQgc3RyaW5ncyAvc2Jpbi94ZnNfcmVwYWlyIHxncmVwIHhmc19yZXBhaXI8YnIgLz4mZ3Q7
IHJlLXJ1bm5pbmcgeGZzX3JlcGFpci4gIElmIHlvdSBhcmUgdW5hYmxlIHRvIG1vdW50IHRoZSBm
aWxlc3lzdGVtLCB0aGVuPGJyIC8+Jmd0OyB1c2U8YnIgLz4mZ3Q7IFBsZWFzZSBydW4gYSBtb3Jl
IHJlY2VudCB2ZXJzaW9uIG9mIHhmc19yZXBhaXIuPGJyIC8+Jmd0OyAkPGJyIC8+Jmd0OyA8YnIg
Lz4mZ3Q7Jmd0OyBJbnR1aXRpdmVseSwgdGhlIG9ubHkgZmlsZXMgaW4gcm9vdCBmaWxlIHN5c3Rl
bSAoYnkgdGhlIHdheSwgcm9vdCBhbHNvPGJyIC8+Jmd0OyZndDsgY29udGFpbnMgL2Jvb3QpIHRo
YXQgYXJlIG9wZW4gZm9yIHdyaXRpbmcgYXJlIHRob3NlIGluIGxvZ3MgYW5kIC90bXAgYW5kPGJy
IC8+Jmd0OyZndDsgL3Zhci90bXAsIEkgaG9wZSB0aGF0IGlzIHRoZSBjYXNlIGFuZCBJIGNhbiBz
YWZlbHkgZGlzY2FyZCB0aG9zZSBpbjxiciAvPiZndDsmZ3Q7IGxvc3QrZm91bmQuPGJyIC8+Jmd0
OyZndDs8YnIgLz4mZ3Q7Jmd0OyBJIGFsc28gaG9wZSB0aGF0IHRoZSBpbm9kZSBsaW5rIGNsZWFu
LXVwcyBkb25lIGJ5IHhmc19yZXBhaXIgZG8gbm90PGJyIC8+Jmd0OyZndDsgYWN0dWFsbHkgcmVt
b3ZlIGFueSBmaWxlcyB0aGF0IGFyZSByZWFsbHkgdGhlcmUuPGJyIC8+Jmd0OyA8YnIgLz4mZ3Q7
IERlZmluZSAmcXVvdDtyZWFsbHkgdGhlcmUmcXVvdDsgd2hlbiBpbXBvcnRhbnQgbWV0YWRhdGEg
KGkuZS4gdGhlIGxvZykgaGFzPGJyIC8+Jmd0OyBiZWVuIGNvcnJ1cHRlZCBhbmQgaXMgbm90IGF2
YWlsYWJsZSBhbnkgbW9yZS4gIEluZGVlZCwgaWYgdGhpbmdzPGJyIC8+Jmd0OyBsaWtlIGJ0cmVl
IHNwbGl0cyBvZiBtZXJnZXMgb2NjdXJyZWQgaW4gdGhlIGxvZywgYW5kIHRoZXkgYXJlPGJyIC8+
Jmd0OyBwYXJ0aWFsbHkgd3JpdHRlbiB0byBkaXNrLCBpdCdzIGVudGlyZWx5IHBvc3NpYmxlIHRo
YXQgeW91IGNvdWxkPGJyIC8+Jmd0OyBsb3NlIGRpcmVjdG9yeSByZWZlcmVuY2VzIHRvIGlub2Rl
cyB0aGF0IGhhdmVuJ3QgYmVlbiBtb2RpZmllZCBmb3I8YnIgLz4mZ3Q7IHNvbWUgdGltZS4uLi48
YnIgLz4mZ3Q7IDxiciAvPiZndDsgUmVtZW1iZXIsIGxpa2UgYWxsIGZzY2sgcHJvZ3JhbXMsIHhm
c19yZXBhaXIgaXMgYSBiZXN0IGVmZm9ydDxiciAvPiZndDsgYXR0ZW1wdCBhdCBjb3JyZWN0aW5n
IHRoZSBwcm9ibGVtcyBmb3VuZCAgLSB0aGVyZSBhcmUgbm8gZ3VhcmFudGVlczxiciAvPiZndDsg
Z2l2ZW4gYWJvdXQgd2hhdCBpdCBjYW4gYW5kIGNhbid0IHJlY292ZXIgd2hlbiBpdCBydW5zLi4u
PGJyIC8+Jmd0OyA8YnIgLz4mZ3Q7IENoZWVycyw8YnIgLz4mZ3Q7IDxiciAvPiZndDsgRGF2ZS48
YnIgLz4mZ3Q7IC0tPGJyIC8+Jmd0OyBEYXZlIENoaW5uZXI8YnIgLz4mZ3Q7IGRhdmlkQGZyb21v
cmJpdC5jb208YnIgLz4mZ3Q7IDxiciAvPjxiciAvPjxiciAvPkNoaW4gR2ltIExlb25nPGJyIC8+
UGVyZm9ybWFuY2UgQ29tcHV0aW5nIEVuZ2luZWVyPGJyIC8+UGVyZm9ybWFuY2UgQ29tcHV0aW5n
IExMUDxiciAvPjxiciAvPmh0dHA6Ly9wZXJmb3JtYW5jZS1jb21wdXRpbmcubmV0PGJyIC8+Q0hJ
Tl9HaW1fTGVvbmdAcGVyZm9ybWFuY2UtY29tcHV0aW5nLm5ldDxiciAvPlRlbDogKzY1LTk3NDY5
NDgyCjwvcD4=
------=_20120903001305_82642
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_20120903001305_82642--
