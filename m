Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q357XFof011245 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 02:33:15 -0500
Message-ID: <4F7D4A41.5010201@oracle.com>
Date: Thu, 05 Apr 2012 15:31:13 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't fill statvfs with project quota for a directory
	if it was not enabled.
References: <4F77DFDB.1040802@oracle.com>		<20120402163903.GA6425@infradead.org>	<1333558102.21996.117.camel@chandra-lucid.austin.ibm.com>
	<4F7D2AC3.50204@oracle.com>
In-Reply-To: <4F7D2AC3.50204@oracle.com>
Reply-To: jeff.liu@oracle.com
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com


On 04/05/2012 01:16 PM, Jeff Liu wrote:

> Hi Chandra, 
> On 04/05/2012 12:48 AM, Chandra Seetharaman wrote:
> 
>> I tried the steps in latest xfs tree and on mainline 3.3.0. Unable to
>> reproduce the problem.
>>
>> Jeff, how big was the FS and how full was it ?


It is irrelevant to the FS space status, looks this is an old issue since I can reproduce it on kernel-2.6.39 too:

Apr  5 13:50:36 pibroch kernel: [  144.667978] XFS: Assertion failed: XFS_IS_QUOTA_RUNNING(mp), file: fs/xfs/quota/xfs_dquot.c, line: 819
Apr  5 13:50:36 pibroch kernel: [  144.668119] ------------[ cut here ]------------
Apr  5 13:50:36 pibroch kernel: [  144.668208] kernel BUG at fs/xfs/linux-2.6/xfs_message.c:119!
Apr  5 13:50:37 pibroch kernel: [  144.668298] invalid opcode: 0000 [#1] SMP
Apr  5 13:50:37 pibroch kernel: [  144.668383] last sysfs file: /sys/devices/virtual/block/loop0/queue/rotational
Apr  5 13:50:37 pibroch kernel: [  144.668492] Modules linked in: xfs cryptd ...
Apr  5 13:50:37 pibroch kernel: [  144.670132]
Apr  5 13:50:37 pibroch kernel: [  144.670164] Pid: 2711, comm: du Not tainted 2.6.39 #1 LENOVO 7661D43/7661D43
Apr  5 13:50:37 pibroch kernel: [  144.670293] EIP: 0060:[<fa8b9b57>] EFLAGS: 00010246 CPU: 0
Apr  5 13:50:37 pibroch kernel: [  144.670444] EIP is at assfail+0x47/0x60 [xfs]
Apr  5 13:50:37 pibroch kernel: [  144.670512] EAX: 00000070 EBX: f29a6800 ECX: f1a65960 EDX: 00000000
Apr  5 13:50:37 pibroch kernel: [  144.670605] ESI: 00000000 EDI: ffffffff EBP: f233de80 ESP: f233de6c
Apr  5 13:50:37 pibroch kernel: [  144.670701]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Apr  5 13:50:37 pibroch kernel: [  144.670787] Process du (pid: 2711, ti=f233c000 task=f1a65960 task.ti=f233c000)
Apr  5 13:50:37 pibroch kernel: [  144.670894] Stack:
Apr  5 13:50:37 pibroch kernel: [  144.670929]  00000000 fa8da474 fa8dcc2e fa8dcad4 00000333 f233dec8 fa7d677f f233df58
Apr  5 13:50:37 pibroch kernel: [  144.671100]  f233dec8 c1431e4b 00000246 00000000 00000002 00000000 00000000 fa8b9d81
Apr  5 13:50:37 pibroch kernel: [  144.671271]  00000001 00000246 00000000 00000246 f233df58 f233df58 ffffffff f233dee4
Apr  5 13:50:37 pibroch kernel: [  144.671443] Call Trace:
Apr  5 13:50:37 pibroch kernel: [  144.671542]  [<fa7d677f>] xfs_qm_dqget+0x4f/0xa20 [xfs]
Apr  5 13:50:37 pibroch kernel: [  144.671632]  [<c1431e4b>] ? do_raw_spin_lock+0x5b/0x230
Apr  5 13:50:37 pibroch kernel: [  144.671777]  [<fa8b9d81>] ? xfs_fs_statfs+0x91/0x2d0 [xfs]
Apr  5 13:50:37 pibroch kernel: [  144.671915]  [<fa7de68e>] xfs_qm_statvfs+0x4e/0xb0 [xfs]
Apr  5 13:50:37 pibroch kernel: [  144.672003]  [<c196f66c>] ? _raw_spin_unlock+0x4c/0x60
Apr  5 13:50:37 pibroch kernel: [  144.672020]  [<fa8b9f5a>] xfs_fs_statfs+0x26a/0x2d0 [xfs]
Apr  5 13:50:37 pibroch kernel: [  144.672020]  [<c12b6a1b>] statfs_by_dentry+0x8b/0xf0
Apr  5 13:50:37 pibroch kernel: [  144.672020]  [<c12b6aa4>] vfs_statfs+0x24/0x140
Apr  5 13:50:37 pibroch kernel: [  144.672020]  [<c12b6cbc>] fd_statfs+0x5c/0xa0
Apr  5 13:50:37 pibroch kernel: [  144.672020]  [<c12b6e9a>] sys_fstatfs64+0x2a/0x90
Apr  5 13:50:37 pibroch kernel: [  144.672020]  [<c19703a4>] syscall_call+0x7/0xb
Apr  5 13:50:37 pibroch kernel: [  144.672020] Code: 10 89 54 24 0c 89 44 24 08 c7 44 24 04 74 a4 8d fa c7 04 24 00 00 00 00 ...
Apr  5 13:50:37 pibroch kernel: [  144.672020] EIP: [<fa8b9b57>] assfail+0x47/0x60 [xfs] SS:ESP 0068:f233de6c
Apr  5 13:50:37 pibroch kernel: [  144.801094] ---[ end trace ae19ce1ca9446f05 ]---

At xfs_ioctl_setattr(), xfs_set_diflags() enabled the XFS_DIFLAG_PROJINHERIT flag of an inode if the given mask has FSX_XFLAGS no matter "PQUOTA is RUNNING or ON".
if (mask & FSX_XFLAGS) {
        xfs_set_diflags(ip, fa->fsx_xflags);
        xfs_diflags_to_linux(ip);
}

In this case, the following condition became always true at xfs_fs_statfs():
if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
     ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
                       (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
     xfs_qm_statvfs(ip, statp);

Hence xfs_qm_statvfs()->xfs_qm_dqget()->ASSERT(XFS_IS_QUOTA_RUNNING(mp)) will failed, that's why I proposed to check
if XFS_IS_QUOTA_RUNNING(mp) or not before doing it.

Thanks,
-Jeff

> 
> Sorry, I have missed one major step to reproduce this issue previously.
> Could you try to create a file under the project directory before setting it up?
> 
> Steps:
> 1. echo "1:/xfs" > /etc/projects; echo "project1:1" > /etc/projid
> 2. echo "test" > /xfs/testme
> 3. xfs_quota -x -c 'project -s project1' /xfs
> 4. du -sh /xfs
> 
> I have posted a test to xfstest at below link, it can help reproducing this issue.
> http://www.spinics.net/lists/xfs/msg10744.html
> 
> Thanks,
> -Jeff
> 
>>
>> Christoph, BTW, 3.3.0 does not have my changes. Ben pushed it for
>> 3.4-rc1
>>
>> Here is my results with 3.3.0
>> -------------------
>> -bash-4.1$ uname -r
>> 3.3.0 
>> bash-4.1$  mount | grep xfs
>> /dev/sdb1 on /xfs type xfs (rw)
>> bash-4.1$ cat /etc/projects
>> 1:/xfs
>> bash-4.1$ cat /etc/projid
>> project1:1
>> bash-4.1$ sudo xfs_quota -x -c 'project -s project1' /xfs
>> [sudo] password for chandra: 
>> Setting up project project1 (path /xfs)...
>> Processed 1 (/etc/projects and cmdline) paths for project project1 with
>> recursion depth infinite (-1).
>> bash-4.1$ du -sh /xfs
>> 0       /xfs
>> bash-4.1$ exit
>> ------------------
>>
>> Chandra
>>
>> On Mon, 2012-04-02 at 12:39 -0400, Christoph Hellwig wrote:
>>> On Sun, Apr 01, 2012 at 12:55:55PM +0800, Jeff Liu wrote:
>>>> Hello,
>>>>
>>>> I can trigger a BUG() at fs/xfs/xfs_dquot.c on vanilla kernel 3.3.0 by the following steps:
>>>>
>>>> 1. mount a XFS partition without 'pquota' option.
>>>>    /dev/sda7 on /xfs type xfs (rw)
>>>>
>>>> 2. setup project1 on it.
>>>>    $ cat /etc/projects 
>>>>    1:/xfs
>>>>    $ cat /etc/projid
>>>>    project1:1
>>>>    $ sudo xfs_quota -x -c 'project -s project1' /xfs
>>>>
>>>> 3. du -sh /xfs
>>>
>>> Can you wire this up as a test case for xfstests?
>>>
>>>> +		    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
>>>> +		     (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD)) {
>>>
>>> This check is supposed to return false.  I guess Chandras separate
>>> project quota inode preparations somehow broke it.
>>>
>>> Chandra, can you look into this issue?
>>>
>>
>>
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
