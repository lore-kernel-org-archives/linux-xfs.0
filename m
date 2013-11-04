Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2265C7F4E
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 22:34:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9F458F804C
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 20:34:09 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 9qbfvk3wa1fOmN4B (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Nov 2013 20:34:08 -0800 (PST)
Message-ID: <527723FC.1070401@oracle.com>
Date: Mon, 04 Nov 2013 12:35:08 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: How to use increased number of ACL entries?
References: <20131103081704.GE9974@fit.vutbr.cz>	<20131104003915.GN6188@dastard>
	<5277086E.6030905@sandeen.net> <52771FFE.8030009@gmail.com>
In-Reply-To: <52771FFE.8030009@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: Kasparek Tomas <kasparek@fit.vutbr.cz>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 11/04/2013 12:18 PM, Michael L. Semon wrote:

> On 11/03/2013 09:37 PM, Eric Sandeen wrote:
>> On 11/3/13, 6:39 PM, Dave Chinner wrote:
>>> On Sun, Nov 03, 2013 at 09:17:04AM +0100, Kasparek Tomas wrote:
>>>> Hello,
>>>>
>>>> I'm trying to get more then 25 ACLs entries to work according to
>>>> http://oss.sgi.com/pipermail/xfs/2013-May/026544.html . I'm running 3.10.x
>>>> kernel which seems to contain these changes. I understand, that this is
>>>> on-disk format change, so I expect to need new xfsprogs too. I tried the
>>>> version from CentOS 6.4 (3.1.1) and one from git repo (
>>>> git://oss.sgi.com/xfs/cmds/xfsprogs), but still it fails to create more then
>>>> 25 ACL entries (21 user defined). Is there something I'm still missing?
>>>
>>> You haven't told mkfs to change the on disk format to enable more
>>> than 25 ACLs. Only the version from git will do it, and your CentOS
>>> kernel will not support it.
>>
>> but the 3.10.x kernel you're running will IIRC; use "-m crc=1" on the mkfs.xfs
>> commandline from a git mkfs.xfs.
>>
>> -Eric
>>  
>>> Cheers,
>>>
>>> Dave.
> 
> Y'know, Eric, your best suggestions are always made when I'm working on a 
> non-test PC that I don't really want to touch ;-)  But anyway, (i686 Pentium 
> 4, kernel 3.10.17)...
> 
> git xfsprogs will make the filesystem in question:
> 
> root@bpserver:/storage/devel/git-xfsprogs# mkfs/mkfs.xfs /dev/sdb3
> mkfs.xfs: /dev/sdb3 appears to contain an existing filesystem (swap).
> mkfs.xfs: Use the -f option to force overwrite.
> root@bpserver:/storage/devel/git-xfsprogs# mkfs/mkfs.xfs -f -m crc=1 /dev/sdb3
> meta-data=/dev/sdb3              isize=512    agcount=4, agsize=65536 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1
> data     =                       bsize=4096   blocks=262144, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> However, it should be dirent (ftype=1 in the above output) that keeps a 
> vanilla 3.10.17 kernel from mounting the resulting filesystem:
> 
> [438326.624667] XFS (sdb3): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
> [438326.624667] Use of these features in this kernel is at your own risk!
> [438326.624762] XFS (sdb3): Superblock has unknown incompatible features (0x1) enabled.
> [438326.624762] Filesystem can not be safely mounted by this kernel.
> [438326.624769] 8d76c000: 58 46 53 42 00 00 10 00 00 00 00 00 00 04 00 00  XFSB............
> [438326.624833] 8d76c010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [438326.624897] 8d76c020: 60 b9 e2 ff 8f c5 41 f5 87 32 bc ea 7d 7b 8c 1b  `.....A..2..}{..
> [438326.624961] 8d76c030: 00 00 00 00 00 02 00 04 00 00 00 00 00 00 00 40  ...............@
> [438326.625026] XFS (sdb3): Internal error xfs_sb_read_verify at line 730 of file fs/xfs/xfs_mount.c.  Caller 0x81123144
> [438326.625026] 
> [438326.625108] CPU: 0 PID: 58 Comm: kworker/0:1H Not tainted 3.10.17 #2
> [438326.625110] Hardware name: Dell Computer Corporation Dimension 3000               /0N6381, BIOS A02 11/08/2004
> [438326.625119] Workqueue: xfslogd xfs_buf_iodone_work
> [438326.625123]  a4b38400 a4b38400 bde73e90 813ab881 bde73eb4 81124b91 a4b38400 00000008
> [438326.625130]  814593ac 813c5439 000002da 8145fee6 81123144 bde73ed4 81124bd6 8145fee6
> [438326.625136]  000002da 81123144 954cf500 00000016 a4b38400 bde73f00 811693c4 8d76c000
> [438326.625142] Call Trace:
> [438326.625151]  [<813ab881>] dump_stack+0x16/0x18
> [438326.625155]  [<81124b91>] xfs_error_report+0x45/0x47
> [438326.625160]  [<81123144>] ? xfs_buf_iodone_work+0x52/0x67
> [438326.625163]  [<81124bd6>] xfs_corruption_error+0x43/0x5d
> [438326.625167]  [<81123144>] ? xfs_buf_iodone_work+0x52/0x67
> [438326.625173]  [<811693c4>] xfs_sb_read_verify+0xd4/0xe5
> [438326.625177]  [<81123144>] ? xfs_buf_iodone_work+0x52/0x67
> [438326.625181]  [<81123144>] xfs_buf_iodone_work+0x52/0x67
> [438326.625187]  [<81038920>] process_one_work+0xd5/0x2eb
> [438326.625191]  [<8103923c>] worker_thread+0xea/0x2f8
> [438326.625196]  [<81039152>] ? manage_workers.isra.37+0x21a/0x21a
> [438326.625200]  [<8103d4c4>] kthread+0x8e/0x90
> [438326.625207]  [<813af737>] ret_from_kernel_thread+0x1b/0x28
> [438326.625211]  [<8103d436>] ? kthread_worker_fn+0xd3/0xd3
> [438326.625214] XFS (sdb3): Corruption detected. Unmount and run xfs_repair
> [438326.625271] XFS (sdb3): SB validate failed with error 22.
> 

looks this problem is irrelevant to CRC check is enabled or not, and
Eric has fixed it:

commit 31625f28ad7be67701dc4cefcf52087addd88af4
    xfs: don't emit corruption noise on fs probes


Thanks,
-Jeff

> I don't know if the CentOS kernel has any extra patches that would enable 
> this filesystem to be mounted.
> 
> There might be a way to bisect or revert the git xfsprogs back before dirent 
> and giving that a try.  However, it seems best to start working with v5/CRC 
> XFS starting with kernel 3.11.  If my luck with recent AIO commits was better, 
> I'd recommend 3.12 instead because that's the real correct answer, problems 
> aside.
> 
> Thanks!
> 
> Michael
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
