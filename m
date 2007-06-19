Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 02:24:32 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5J9OPdo005686
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 02:24:27 -0700
Message-ID: <4677A0C7.4000306@dgreaves.com>
Date: Tue, 19 Jun 2007 10:24:23 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com> <4676D97E.4000403@dgreaves.com>
In-Reply-To: <4676D97E.4000403@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>
Cc: David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>

David Greaves wrote:
> I'm going to have to do some more testing...
done


> David Chinner wrote:
>> On Mon, Jun 18, 2007 at 08:49:34AM +0100, David Greaves wrote:
>>> David Greaves wrote:
>>> So doing:
>>> xfs_freeze -f /scratch
>>> sync
>>> echo platform > /sys/power/disk
>>> echo disk > /sys/power/state
>>> # resume
>>> xfs_freeze -u /scratch
>>>
>>> Works (for now - more usage testing tonight)
>>
>> Verrry interesting.
> Good :)
Now, not so good :)


>> What you were seeing was an XFS shutdown occurring because the free space
>> btree was corrupted. IOWs, the process of suspend/resume has resulted
>> in either bad data being written to disk, the correct data not being
>> written to disk or the cached block being corrupted in memory.
> That's the kind of thing I was suspecting, yes.
> 
>> If you run xfs_check on the filesystem after it has shut down after a 
>> resume,
>> can you tell us if it reports on-disk corruption? Note: do not run 
>> xfs_repair
>> to check this - it does not check the free space btrees; instead it 
>> simply
>> rebuilds them from scratch. If xfs_check reports an error, then run 
>> xfs_repair
>> to fix it up.
> OK, I can try this tonight...


This is on 2.6.22-rc5

So I hibernated last night and resumed this morning.
Before hibernating I froze and sync'ed. After resume I thawed it. (Sorry Dave)

Here are some photos of the screen during resume. This is not 100% reproducable 
- it seems to occur only if the system is shutdown for 30mins or so.

Tejun, I wonder if error handling during resume is problematic? I got the same 
errors in 2.6.21. I have never seen these (or any other libata) errors other 
than during resume.

http://www.dgreaves.com/pub/2.6.22-rc5-resume-failure.jpg
(hard to read, here's one from 2.6.21
http://www.dgreaves.com/pub/2.6.21-resume-failure.jpg

I _think_ I've only seen the xfs problem when a resume shows these errors.


Ok, to try and cause a problem I ran a make and got this back at once:
make: stat: Makefile: Input/output error
make: stat: clean: Input/output error
make: *** No rule to make target `clean'.  Stop.
make: stat: GNUmakefile: Input/output error
make: stat: makefile: Input/output error


I caught the first dmesg this time:

Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b58e1
  [<c0104f6a>] show_trace_log_lvl+0x1a/0x30
  [<c0105c52>] show_trace+0x12/0x20
  [<c0105d15>] dump_stack+0x15/0x20
  [<c01daddf>] xfs_error_report+0x4f/0x60
  [<c01cd736>] xfs_btree_check_sblock+0x56/0xd0
  [<c01b58e1>] xfs_alloc_lookup+0x181/0x390
  [<c01b5b06>] xfs_alloc_lookup_le+0x16/0x20
  [<c01b30c1>] xfs_free_ag_extent+0x51/0x690
  [<c01b4ea4>] xfs_free_extent+0xa4/0xc0
  [<c01bf739>] xfs_bmap_finish+0x119/0x170
  [<c01e3f4a>] xfs_itruncate_finish+0x23a/0x3a0
  [<c02046a2>] xfs_inactive+0x482/0x500
  [<c0210ad4>] xfs_fs_clear_inode+0x34/0xa0
  [<c017d777>] clear_inode+0x57/0xe0
  [<c017d8e5>] generic_delete_inode+0xe5/0x110
  [<c017da77>] generic_drop_inode+0x167/0x1b0
  [<c017cedf>] iput+0x5f/0x70
  [<c01735cf>] do_unlinkat+0xdf/0x140
  [<c0173640>] sys_unlink+0x10/0x20
  [<c01040a4>] syscall_call+0x7/0xb
  =======================
xfs_force_shutdown(dm-0,0x8) called from line 4258 of file fs/xfs/xfs_bmap.c. 
Return address = 0xc021101e
Filesystem "dm-0": Corruption of in-memory data detected.  Shutting down 
filesystem: dm-0
Please umount the filesystem, and rectify the problem(s)

so I cd'ed out of /scratch and umounted.

I then tried the xfs_check.

haze:~# xfs_check /dev/video_vg/video_lv
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.
haze:~# mount /scratch/
haze:~# umount /scratch/
haze:~# xfs_check /dev/video_vg/video_lv

Message from syslogd@haze at Tue Jun 19 08:47:30 2007 ...
haze kernel: Bad page state in process 'xfs_db'

Message from syslogd@haze at Tue Jun 19 08:47:30 2007 ...
haze kernel: page:c1767bc0 flags:0x80010008 mapping:00000000 mapcount:-64 count:0

Message from syslogd@haze at Tue Jun 19 08:47:30 2007 ...
haze kernel: Trying to fix it up, but a reboot is needed

Message from syslogd@haze at Tue Jun 19 08:47:30 2007 ...
haze kernel: Backtrace:

Message from syslogd@haze at Tue Jun 19 08:47:30 2007 ...
haze kernel: Bad page state in process 'syslogd'

Message from syslogd@haze at Tue Jun 19 08:47:30 2007 ...
haze kernel: page:c1767cc0 flags:0x80010008 mapping:00000000 mapcount:-64 count:0

Message from syslogd@haze at Tue Jun 19 08:47:30 2007 ...
haze kernel: Trying to fix it up, but a reboot is needed

Message from syslogd@haze at Tue Jun 19 08:47:30 2007 ...
haze kernel: Backtrace:

ugh. Try again
haze:~# xfs_check /dev/video_vg/video_lv
haze:~#

whilst running a top reported this as roughly the peak memory usage:
  8759 root      18   0  479m 474m  876 R  2.0 46.9   0:02.49 xfs_db
so it looks like it didn't run out of memory (machine has 1Gb).

Dave, I ran xfs_check -v... but I got bored when it reached 122M of bz2 
compressed output with no sign of stopping... still got it if it's any use...

lots of:
setting block 0/0 to sb
setting block 0/1 to freelist
setting block 0/2 to freelist
setting block 0/3 to freelist
setting block 0/4 to freelist
setting block 0/75 to btbno
setting block 0/346901 to free1
setting block 0/346903 to free1
setting block 0/346904 to free1
setting block 0/346905 to free1
   and stuff like this
inode 128 mode 040777 fmt extents afmt extents nex 1 anex 0 nblk 1 sz 4096
inode 128 nlink 39 is dir
inode 128 extent [0,7,1,0]

I then rebooted and ran a repair which didn't show any damage.

David
