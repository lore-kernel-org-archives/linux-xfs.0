Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6S0VVGm135281 for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 19:31:31 -0500
Received: from mail.reagi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF712140BB88
	for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 17:32:14 -0700 (PDT)
Received: from mail.reagi.com (mail.reagi.com [195.60.188.80]) by cuda.sgi.com
	with ESMTP id NAAbD8fedagjn89t for <xfs@oss.sgi.com>;
	Mon, 27 Jul 2009 17:32:14 -0700 (PDT)
Message-ID: <4A6E46D5.1090901@oxeva.fr>
Date: Tue, 28 Jul 2009 02:31:17 +0200
From: Gabriel Barazer <gabriel@oxeva.fr>
MIME-Version: 1.0
Subject: Re: XFS filesystem shutting down on linux 2.6.28.9 (xfs_rename)
References: <000c01ca0ae0$e85420a0$b8fc61e0$@fr>	<4A67E2F5.2030400@sandeen.net>
	<4A6D9221.5080603@oxeva.fr> <4A6DE682.7080402@sandeen.net>
In-Reply-To: <4A6DE682.7080402@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



Eric Sandeen wrote:
> Gabriel Barazer wrote:
>   
>> Eric Sandeen wrote:
>>     
>>> Gabriel Barazer wrote:
>>>   
>>>       
>>>> Hi,
>>>>
>>>> I recently put a NFS file server into production, with mostly XFS volumes on LVM. The server was quite low on traffic until this morning and one of the filesystems crashed twice since this morning with the following backtrace:
>>>>
>>>> Filesystem "dm-24": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff811b09a7
>>>> Pid: 2053, comm: nfsd Not tainted 2.6.28.9-filer #1
>>>> Call Trace:
>>>>  [<ffffffff811b09a7>] xfs_rename+0x4a1/0x4f6
>>>>  [<ffffffff811b1806>] xfs_trans_cancel+0x56/0xed
>>>>  [<ffffffff811b09a7>] xfs_rename+0x4a1/0x4f6
>>>>     
>>>>         
>>> ...
>>>
>>>   
>>>       
>>>> xfs_force_shutdown(dm-24,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff811b181f
>>>> Filesystem "dm-24": Corruption of in-memory data detected.  Shutting down filesystem: dm-24
>>>>
>>>> The two crashed are related to the same function: xfs_rename.
>>>>     
>>>>         
>>> Can you do objdump -d xfs.ko | grep "xfs_rename\|xfs_trans_cancel" and
>>> maybe we can see which call to xfs_trans_cancel in xfs_rename this was.
>>>
>>> The problem relates to canceling a dirty transaction on an error path.
>>>   
>>>       
>> Hi,
>>
>> sorry for the late reply
>>
>> I don't have any xfs.ko as my kernel is compiled without CONFIG_MODULES. 
>> However I objdump'd the vmlinux uncompressed kernel, and here are the 
>> results:
>>     
>
> Ok, that was an over eager grep command, my apologies to the mail
> archives ;)
>
> The relevant stuff:
>
> ffffffff811b0506 <xfs_rename>:
> ffffffff811b06c1:       e8 ea 10 00 00          callq  ffffffff811b17b0
> <xfs_trans_cancel>
> ffffffff811b09a2:       e8 09 0e 00 00          callq  ffffffff811b17b0
> <xfs_trans_cancel>
>
> hmm but there are only 2 obvious calls in the disassembly, and there are
> 4 calls in the function... and neither one seems to line up with your
> stated offset in the oops.  :(  I was hoping to sort out which
> xfs_trans_cancel call in xfs_rename it was.
>   
I disassembled the uncompressed version of the linux kernel, generated 
at compile time in the build directory. I don't know if compressing the 
kernel to a bzImage file can change offsets compared to the uncompressed 
vmlinux kernel. I still have all the compiled sources for that kernel, 
including the .o files. Does any of these files could contain the offset 
you are looking for ?

> Any chance you could add a couple printk's to xfs_rename in the cases
> where it calls trans_cancel so we can see which one it was?
>   
This kernel and these bugs occured on a live production file server, and 
I really cannot mess with it. Good news though, I did not get any other 
shutdown since my last e-mail.

One detail that might be useful in case that bug is a race between 2 
functions somewhere: The disks containing the filesystem is a SSD RAID 
plugged to a 3ware adapter with write cache enabled; that is as those 
SSD are very irregular in write speeds, the writes are occuring in short 
bursts, then any I/O to the disks are blocked for a few seconds until 
the next burst (see the purple line :  
http://pub.grosboulet.com/benchmark-seqwrite.jpg ). (BTW, I _really_ 
don't recommend using Intel X25-M SSDs in server systems, thoses are 
only good for desktop/laptop systems and are worse than SAS15K drives in 
multiuser writes). This very odd behaviour could lead the kernel to 
block/wait at unusual places in the code like where that bug is occuring.

Gabriel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
