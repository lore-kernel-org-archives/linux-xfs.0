Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Aug 2008 19:03:58 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7P23rUo017915
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 19:03:53 -0700
Received: from larry.melbourne.sgi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 494531A3F32B
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 19:05:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130]) by cuda.sgi.com with SMTP id qZNeEBS2hvgbUg7p for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 19:05:13 -0700 (PDT)
Message-ID: <48B21507.9050708@sgi.com>
Date: Mon, 25 Aug 2008 12:12:23 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com> <20080825010213.GO5706@disturbed>
In-Reply-To: <20080825010213.GO5706@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Daniel J Blueman <daniel.blueman@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, hch@lst.de

Dave Chinner wrote:
> On Fri, Aug 22, 2008 at 10:12:59PM +0100, Daniel J Blueman wrote:
>> On 2.6.27-rc4 with various debug options enabled, lockdep claims lock
>> ordering issues with XFS [1] - easiest reproducer is just running
>> xfs_fsr. Mount options I was using were
>> 'nobarrier,noatime,nodiratime'.
>>
>> Thanks,
>>   Daniel
>>
>> --- [1]
>>
>> =======================================================
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.27-rc4-224c #1
>> -------------------------------------------------------
>> xfs_fsr/5763 is trying to acquire lock:
>>  (&(&ip->i_lock)->mr_lock/2){--..}, at: [<ffffffff803ad8fc>] xfs_ilock+0x8c/0xb0
>>
>> but task is already holding lock:
>>  (&(&ip->i_iolock)->mr_lock/3){--..}, at: [<ffffffff803ad915>]
>> xfs_ilock+0xa5/0xb0
> 
> False positive. We do:
> 
> 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);

Why not just change the above line to two lines:
	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);


> 	.....
> 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 	xfs_iunlock(tip, XFS_ILOCK_EXCL);
> 	.....
> 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
> 
> Which is a perfectly valid thing to do.
> 
> The problem is that lockdep is complaining about the second call
> to xfs_lock_two_inodes(), which uses the subclasses 2 and 3.
> effectively it is seeing:
> 
> 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> 		iolock/2
> 		ilock/2
> 		iolock/3
> 		ilock/3
> 	.....
> 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
> 		ilock/2
> 		ilock/3
> 
> 
> But because the original lock order was ilock/2->iolock/3, the
> second call to xfs_lock_two_inodes is seeing iolock/3->ilock/2
> which it then complains about....
> 
> Christoph - I think we're going to need to pass a lockdep 'order'
> flag into xfs_lock_two_inodes() to avoid this so the second call
> can use different classes to the first call. Or perhaps a '_nested'
> variant of the call...
> 
> Cheers,
> 
> Dave.
