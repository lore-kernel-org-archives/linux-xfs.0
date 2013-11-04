Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 234867F4E
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 23:52:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ED3778F8040
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 21:52:14 -0800 (PST)
Received: from mail-gg0-f173.google.com (mail-gg0-f173.google.com
	[209.85.161.173]) by cuda.sgi.com with ESMTP id
	8QU7OsfEaWr43OJ5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Nov 2013 21:52:13 -0800 (PST)
Received: by mail-gg0-f173.google.com with SMTP id e5so2426615ggk.32
	for <xfs@oss.sgi.com>; Sun, 03 Nov 2013 21:52:12 -0800 (PST)
Message-ID: <52773607.30506@gmail.com>
Date: Mon, 04 Nov 2013 00:52:07 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: How to use increased number of ACL entries?
References: <20131103081704.GE9974@fit.vutbr.cz>	<20131104003915.GN6188@dastard>
	<5277086E.6030905@sandeen.net> <52771FFE.8030009@gmail.com>
	<527723FC.1070401@oracle.com>
In-Reply-To: <527723FC.1070401@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Kasparek Tomas <kasparek@fit.vutbr.cz>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 11/03/2013 11:35 PM, Jeff Liu wrote:
> On 11/04/2013 12:18 PM, Michael L. Semon wrote:
> 
>> On 11/03/2013 09:37 PM, Eric Sandeen wrote:
>>> On 11/3/13, 6:39 PM, Dave Chinner wrote:
>>>> On Sun, Nov 03, 2013 at 09:17:04AM +0100, Kasparek Tomas wrote:
>>>>> Hello,
>>>>>
>>>>> I'm trying to get more then 25 ACLs entries to work according to
>>>>> http://oss.sgi.com/pipermail/xfs/2013-May/026544.html . I'm running 3.10.x
>>>>> kernel which seems to contain these changes. I understand, that this is
>>>>> on-disk format change, so I expect to need new xfsprogs too. I tried the
>>>>> version from CentOS 6.4 (3.1.1) and one from git repo (
>>>>> git://oss.sgi.com/xfs/cmds/xfsprogs), but still it fails to create more then
>>>>> 25 ACL entries (21 user defined). Is there something I'm still missing?
>>>>
>>>> You haven't told mkfs to change the on disk format to enable more
>>>> than 25 ACLs. Only the version from git will do it, and your CentOS
>>>> kernel will not support it.
>>>
>>> but the 3.10.x kernel you're running will IIRC; use "-m crc=1" on the mkfs.xfs
>>> commandline from a git mkfs.xfs.
>>>
>>> -Eric
>>>  
>>>> Cheers,
>>>>
>>>> Dave.
>>
>> Y'know, Eric, your best suggestions are always made when I'm working on a 
>> non-test PC that I don't really want to touch ;-)  But anyway, (i686 Pentium 
>> 4, kernel 3.10.17)...
>>
>> git xfsprogs will make the filesystem in question:
>>
>> root@bpserver:/storage/devel/git-xfsprogs# mkfs/mkfs.xfs /dev/sdb3
>> mkfs.xfs: /dev/sdb3 appears to contain an existing filesystem (swap).
>> mkfs.xfs: Use the -f option to force overwrite.
>> root@bpserver:/storage/devel/git-xfsprogs# mkfs/mkfs.xfs -f -m crc=1 /dev/sdb3
>> meta-data=/dev/sdb3              isize=512    agcount=4, agsize=65536 blks
>>          =                       sectsz=512   attr=2, projid32bit=1
>>          =                       crc=1
>> data     =                       bsize=4096   blocks=262144, imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>> log      =internal log           bsize=4096   blocks=12800, version=2
>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> However, it should be dirent (ftype=1 in the above output) that keeps a 
>> vanilla 3.10.17 kernel from mounting the resulting filesystem:
>>
>> [438326.624667] XFS (sdb3): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
>> [438326.624667] Use of these features in this kernel is at your own risk!
>> [438326.624762] XFS (sdb3): Superblock has unknown incompatible features (0x1) enabled.
>> [438326.624762] Filesystem can not be safely mounted by this kernel.
>> [438326.624769] 8d76c000: 58 46 53 42 00 00 10 00 00 00 00 00 00 04 00 00  XFSB............
>> [438326.624833] 8d76c010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>> [438326.624897] 8d76c020: 60 b9 e2 ff 8f c5 41 f5 87 32 bc ea 7d 7b 8c 1b  `.....A..2..}{..
>> [438326.624961] 8d76c030: 00 00 00 00 00 02 00 04 00 00 00 00 00 00 00 40  ...............@
>> [438326.625026] XFS (sdb3): Internal error xfs_sb_read_verify at line 730 of file fs/xfs/xfs_mount.c.  Caller 0x81123144
>> [438326.625026] 
>> [438326.625108] CPU: 0 PID: 58 Comm: kworker/0:1H Not tainted 3.10.17 #2
>> [438326.625110] Hardware name: Dell Computer Corporation Dimension 3000               /0N6381, BIOS A02 11/08/2004
>> [438326.625119] Workqueue: xfslogd xfs_buf_iodone_work
>> [438326.625123]  a4b38400 a4b38400 bde73e90 813ab881 bde73eb4 81124b91 a4b38400 00000008
>> [438326.625130]  814593ac 813c5439 000002da 8145fee6 81123144 bde73ed4 81124bd6 8145fee6
>> [438326.625136]  000002da 81123144 954cf500 00000016 a4b38400 bde73f00 811693c4 8d76c000
>> [438326.625142] Call Trace:
>> [438326.625151]  [<813ab881>] dump_stack+0x16/0x18
>> [438326.625155]  [<81124b91>] xfs_error_report+0x45/0x47
>> [438326.625160]  [<81123144>] ? xfs_buf_iodone_work+0x52/0x67
>> [438326.625163]  [<81124bd6>] xfs_corruption_error+0x43/0x5d
>> [438326.625167]  [<81123144>] ? xfs_buf_iodone_work+0x52/0x67
>> [438326.625173]  [<811693c4>] xfs_sb_read_verify+0xd4/0xe5
>> [438326.625177]  [<81123144>] ? xfs_buf_iodone_work+0x52/0x67
>> [438326.625181]  [<81123144>] xfs_buf_iodone_work+0x52/0x67
>> [438326.625187]  [<81038920>] process_one_work+0xd5/0x2eb
>> [438326.625191]  [<8103923c>] worker_thread+0xea/0x2f8
>> [438326.625196]  [<81039152>] ? manage_workers.isra.37+0x21a/0x21a
>> [438326.625200]  [<8103d4c4>] kthread+0x8e/0x90
>> [438326.625207]  [<813af737>] ret_from_kernel_thread+0x1b/0x28
>> [438326.625211]  [<8103d436>] ? kthread_worker_fn+0xd3/0xd3
>> [438326.625214] XFS (sdb3): Corruption detected. Unmount and run xfs_repair
>> [438326.625271] XFS (sdb3): SB validate failed with error 22.
>>
> 
> looks this problem is irrelevant to CRC check is enabled or not, and
> Eric has fixed it:
> 
> commit 31625f28ad7be67701dc4cefcf52087addd88af4
>     xfs: don't emit corruption noise on fs probes
> 
> 
> Thanks,
> -Jeff

We shall see.  I was providing some output to give an expectation of how it 
would look.  The one line that showed the feature bits looked like this:

>> [438326.624762] XFS (sdb3): Superblock has unknown incompatible features (0x1) enabled.

>> I don't know if the CentOS kernel has any extra patches that would enable 
>> this filesystem to be mounted.
>>
>> There might be a way to bisect or revert the git xfsprogs back before dirent 
>> and giving that a try.  However, it seems best to start working with v5/CRC 
>> XFS starting with kernel 3.11.  If my luck with recent AIO commits was better, 
>> I'd recommend 3.12 instead because that's the real correct answer, problems 
>> aside.
>>
>> Thanks!
>>
>> Michael

That stated, I found some time to revert the git xfsprogs, and there was success 
in making more than 25 ACLs on vanilla kernel 3.10.17.  Again, this is not 
recommended--the later kernel and userspace patches are there for good reason--but 
the output is pasted after my closing.

Good luck!

Michael

Script started on Mon 04 Nov 2013 12:32:08 AM EST

root@bpserver:/storage/devel/git-xfsprogs# git branch early_branch 88cd79be1aa1f6947d20da102fbf5bb128d70ce1

root@bpserver:/storage/devel/git-xfsprogs# git checkout early_branch
Switched to branch 'early_branch'

root@bpserver:/storage/devel/git-xfsprogs# git log
commit 88cd79be1aa1f6947d20da102fbf5bb128d70ce1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Sep 4 22:05:50 2013 +0000

    xfs: Add xfs_log_rlimit.c
    
    Add source files for xfs_log_rlimit.c The new file is used for log
    size calculations and validation shared with userspace.

[rest of `git log` snipped]
    
root@bpserver:/storage/devel/git-xfsprogs# make distclean; make

[make OK, output snipped]

root@bpserver:/storage/devel/git-xfsprogs# cat /proc/swaps 
Filename				Type		Size	Used	Priority
/dev/sdb3                               partition	1048572	0	-1

root@bpserver:/storage/devel/git-xfsprogs# swapoff /dev/sdb3

root@bpserver:/storage/devel/git-xfsprogs# dd if=/dev/zero of=/dev/sdb3 bs=4k
dd: writing '/dev/sdb3': No space left on device
262145+0 records in
262144+0 records out
1073741824 bytes (1.1 GB) copied, 18.8771 s, 56.9 MB/s

root@bpserver:/storage/devel/git-xfsprogs# mkfs/mkfs.xfs -m crc=1 /dev/sdb3
meta-data=/dev/sdb3              isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!
Use of these features is at your own risk!

root@bpserver:/storage/devel/git-xfsprogs# mount -t xfs /dev/sdb3 /mnt/tmp

root@bpserver:/storage/devel/git-xfsprogs# mount | grep sdb3
/dev/sdb3 on /mnt/tmp type xfs (rw)

root@bpserver:/storage/devel/git-xfsprogs# cd /mnt/tmp

root@bpserver:/mnt/tmp# touch testfile

root@bpserver:/mnt/tmp# for a in `seq 1 28`; do setfacl -m u:$a:rw- testfile; done

root@bpserver:/mnt/tmp# getfacl testfile
# file: testfile
# owner: root
# group: root
user::rw-
user:bin:rw-
user:daemon:rw-
user:adm:rw-
user:lp:rw-
user:sync:rw-
user:shutdown:rw-
user:halt:rw-
user:mail:rw-
user:news:rw-
user:uucp:rw-
user:operator:rw-
user:games:rw-
user:13:rw-
user:ftp:rw-
user:15:rw-
user:16:rw-
user:17:rw-
user:18:rw-
user:19:rw-
user:20:rw-
user:21:rw-
user:22:rw-
user:23:rw-
user:24:rw-
user:smmsp:rw-
user:26:rw-
user:mysql:rw-
user:28:rw-
group::r--
mask::rw-
other::r--

root@bpserver:/mnt/tmp# cd -
/storage/devel/git-xfsprogs
root@bpserver:/storage/devel/git-xfsprogs# umount /mnt/tmp/
root@bpserver:/storage/devel/git-xfsprogs# dmesg
[ 4648.112001] XFS (sdb3): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
[ 4648.112001] Use of these features in this kernel is at your own risk!
[ 4648.112233] XFS (sdb3): Mounting Filesystem
[ 4648.227979] XFS (sdb3): Ending clean mount
root@bpserver:/storage/devel/git-xfsprogs# exit

Script done on Mon 04 Nov 2013 12:40:26 AM EST

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
