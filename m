Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6RHdbXV116966 for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 12:39:37 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9DEB1B5B610
	for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 10:40:21 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id uOCwANHIc9PHlgEy for <xfs@oss.sgi.com>;
	Mon, 27 Jul 2009 10:40:21 -0700 (PDT)
Message-ID: <4A6DE682.7080402@sandeen.net>
Date: Mon, 27 Jul 2009 12:40:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem shutting down on linux 2.6.28.9 (xfs_rename)
References: <000c01ca0ae0$e85420a0$b8fc61e0$@fr>
	<4A67E2F5.2030400@sandeen.net> <4A6D9221.5080603@oxeva.fr>
In-Reply-To: <4A6D9221.5080603@oxeva.fr>
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
To: Gabriel Barazer <gabriel@oxeva.fr>
Cc: xfs@oss.sgi.com

Gabriel Barazer wrote:
> Eric Sandeen wrote:
>> Gabriel Barazer wrote:
>>   
>>> Hi,
>>>
>>> I recently put a NFS file server into production, with mostly XFS volumes on LVM. The server was quite low on traffic until this morning and one of the filesystems crashed twice since this morning with the following backtrace:
>>>
>>> Filesystem "dm-24": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff811b09a7
>>> Pid: 2053, comm: nfsd Not tainted 2.6.28.9-filer #1
>>> Call Trace:
>>>  [<ffffffff811b09a7>] xfs_rename+0x4a1/0x4f6
>>>  [<ffffffff811b1806>] xfs_trans_cancel+0x56/0xed
>>>  [<ffffffff811b09a7>] xfs_rename+0x4a1/0x4f6
>>>     
>> ...
>>
>>   
>>> xfs_force_shutdown(dm-24,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff811b181f
>>> Filesystem "dm-24": Corruption of in-memory data detected.  Shutting down filesystem: dm-24
>>>
>>> The two crashed are related to the same function: xfs_rename.
>>>     
>> Can you do objdump -d xfs.ko | grep "xfs_rename\|xfs_trans_cancel" and
>> maybe we can see which call to xfs_trans_cancel in xfs_rename this was.
>>
>> The problem relates to canceling a dirty transaction on an error path.
>>   
> Hi,
> 
> sorry for the late reply
> 
> I don't have any xfs.ko as my kernel is compiled without CONFIG_MODULES. 
> However I objdump'd the vmlinux uncompressed kernel, and here are the 
> results:

Ok, that was an over eager grep command, my apologies to the mail
archives ;)

The relevant stuff:

ffffffff811b0506 <xfs_rename>:
ffffffff811b06c1:       e8 ea 10 00 00          callq  ffffffff811b17b0
<xfs_trans_cancel>
ffffffff811b09a2:       e8 09 0e 00 00          callq  ffffffff811b17b0
<xfs_trans_cancel>

hmm but there are only 2 obvious calls in the disassembly, and there are
4 calls in the function... and neither one seems to line up with your
stated offset in the oops.  :(  I was hoping to sort out which
xfs_trans_cancel call in xfs_rename it was.

Any chance you could add a couple printk's to xfs_rename in the cases
where it calls trans_cancel so we can see which one it was?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
