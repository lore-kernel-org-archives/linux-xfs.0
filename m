Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49Eot61228251 for <xfs@oss.sgi.com>; Sun, 9 May 2010 09:50:56 -0500
Received: from smtp.stepping-stone.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 189363233FB
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 07:53:06 -0700 (PDT)
Received: from smtp.stepping-stone.ch (smtp.stepping-stone.ch
	[194.176.109.228]) by cuda.sgi.com with ESMTP id
	2cH1zbSjBCB7Lo1e for <xfs@oss.sgi.com>;
	Sun, 09 May 2010 07:53:06 -0700 (PDT)
Received: from localhost (mail-scanner-01.int.stepping-stone.ch [10.17.98.47])
	by smtp.stepping-stone.ch (Postfix) with ESMTP id 281E6400389
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 16:53:05 +0200 (CEST)
Received: from smtp.stepping-stone.ch ([10.17.98.46])
	by localhost (mail-scanner-01.int.stepping-stone.ch [10.17.98.47])
	(amavisd-new, port 10024)
	with LMTP id Liq8XIXoy+du for <xfs@oss.sgi.com>;
	Sun,  9 May 2010 16:53:02 +0200 (CEST)
Received: from [192.168.1.4] (84-73-140-121.dclient.hispeed.ch [84.73.140.121])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client did not present a certificate)
	by smtp.stepping-stone.ch (Postfix) with ESMTPSA id 27FE340018C
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 16:53:01 +0200 (CEST)
Message-ID: <4BE6CC4C.3030501@purplehaze.ch>
Date: Sun, 09 May 2010 16:53:00 +0200
From: Christian Affolter <christian.affolter@purplehaze.ch>
MIME-Version: 1.0
Subject: Re: failed to read root inode
References: <4BE55A63.8070203@purplehaze.ch> <4BE57E0D.3020601@sandeen.net>
In-Reply-To: <4BE57E0D.3020601@sandeen.net>
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
To: xfs@oss.sgi.com

Hi Eric

Thanks for your answer.

>> After a disk crash within a hardware RAID-6 controller and kernel
>> freeze, I'm unable to mount an XFS filesystem on top of an EVMS volume:
> 
> Are you sure the volume is reassembled correctly?  It seems like the
> fs has a ton of damage ...
> 
> One trick I often recommend is to make a metadata image of the fs
> with xfs_metadump / xfs_mdrestore and run repair on that to see
> what repair -would- do, but I guess you've already run it on the
> real fs.

OK, I didn't know that. I actually cloned the faild volume using dd and
run xfs_repair on the clone.


> So if repair isn't making a mountable fs, first suggestion would
> be to re-try with the latest version of repair.

OK, I will try that. Unfortunately the latest upstream version isn't
included within the distribution package repository, so I will have to
compile it first.


>> Filesystem "dm-13": Disabling barriers, not supported by the underlying
>> device
> 
> Honestly, that could be part of the problem too, if a bunch of
> disks with write caches all lost them, in the array.
> 
>> XFS mounting filesystem dm-13
>> Starting XFS recovery on filesystem: dm-13 (logdev: internal)
>> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1599 of file
>> fs/xfs/xfs_alloc.c.  Caller 0xffffffff8035c58d
>> Pid: 13473, comm: mount Not tainted 2.6.26-gentoo #1
> ...
> 
>> XFS: log mount finish failed
> 
> So recovery is failing, you could try mount -o ro,norecovery at this
> point to see what's still left on the fs... but:

This didn't made any difference, I'm still getting the same error message.


>> I tried to repair the filesystem with the help of xfs_repair many times,
>> without any luck:
>> Filesystem "dm-13": Disabling barriers, not supported by the underlying
>> device
>> XFS mounting filesystem dm-13
>> XFS: failed to read root inode
> 
> ...
> 
>> xfs_check output:
>> cache_node_purge: refcount was 1, not zero (node=0x820010)
>> xfs_check: cannot read root inode (117)
> 
> That's a bit of an odd root inode number, I think, which
> makes me think maybe there are still serious problems.
> 
>> Are there any other ways to fix the unreadable root inode or to restore
>> the remaining data?
>>
>>
>> Environment informations:
>> Linux Kernel: 2.6.26-gentoo (x86_64)
>> xfsprogs:     3.0.3
> 
> Those are both pretty old at this point, I can't say there is anything
> specific in newer xfsprogs, but I'd probably give that a shot first.

Yes I'm going to try the latest version.


Thanks
Christian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
