Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 21:56:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9A4uiaG024381
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 21:56:47 -0700
Date: Tue, 10 Oct 2006 14:55:33 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: xfs vs. lockdep
Message-ID: <B00614C05C5235594B24FDD6@boing.melbourne.sgi.com>
In-Reply-To: <452B0396.8060506@sandeen.net>
References: <452A8DE2.4000608@sandeen.net>
 <20061010004726.GO11034@melbourne.sgi.com>
 <C013892BDA68824F76A0474A@boing.melbourne.sgi.com>
 <452B0396.8060506@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

--On 9 October 2006 9:21:10 PM -0500 Eric Sandeen <sandeen@sandeen.net> 
wrote:
>> This one rings a bell. I seem to recall multiple places where we destroy
>> without releasing the lock first.
>> And I vaguely remember Nathan mentioning that this was causing grief
>> for lockdep:)
>
>
> Ok, cool.  Want a formal patch
Nope :)

> or you guys want to just free it up...
>
>          /*
>           * Free all memory associated with the inode.
>           */
> +       xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>          xfs_idestroy(ip);
>
> Thanks,
>
Thanks, I'll just check it in under Vlad's bug.

Cheers,
Tim.
