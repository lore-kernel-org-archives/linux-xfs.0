Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 19:21:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9A2LraG006398
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 19:21:54 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0826648DCA4
	for <xfs@oss.sgi.com>; Mon,  9 Oct 2006 19:21:12 -0700 (PDT)
Message-ID: <452B0396.8060506@sandeen.net>
Date: Mon, 09 Oct 2006 21:21:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs vs. lockdep
References: <452A8DE2.4000608@sandeen.net> <20061010004726.GO11034@melbourne.sgi.com> <C013892BDA68824F76A0474A@boing.melbourne.sgi.com>
In-Reply-To: <C013892BDA68824F76A0474A@boing.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Timothy Shimmin wrote:
>> Hence by the time we have the lock here in xfs_ireclaim we have 
>> guaranteed
>> that there are no other outstanding references and no new references
>> can occur. Therefore it should be safe to drop the lock before destroying
>> it.
>>
> Yeah, there really seems like something would be wrong if you can't
> unlock it before destroying it.

I thought so too; if anybody else might catch it post-unlock pre-free, they're 
in for a big surprise anyway :)

> I would have thought you'd need to guarantee that you are the only
> one with access to it before destroying it otherwise there'd be problems :)
> (Which as you say we do)

right.

> This one rings a bell. I seem to recall multiple places where we destroy
> without releasing the lock first.
> And I vaguely remember Nathan mentioning that this was causing grief
> for lockdep:)


Ok, cool.  Want a formal patch or you guys want to just free it up...

         /*
          * Free all memory associated with the inode.
          */
+       xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
         xfs_idestroy(ip);

Thanks,

-Eric
