Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJG1BW6022560 for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 10:01:12 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50E1615A19F1
	for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 07:50:18 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id UB4z5qHFkga80wci for <xfs@oss.sgi.com>;
	Wed, 19 Nov 2008 07:50:18 -0800 (PST)
Message-ID: <49242FAC.2060208@sandeen.net>
Date: Wed, 19 Nov 2008 09:24:28 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch 01/11] Move compat ioctl structs & numbers
	into	xfs_ioctl32.h
References: <20081119044401.573365619@sandeen.net>
	<20081119044907.776640320@sandeen.net>
	<20081119145941.GA13050@infradead.org>
In-Reply-To: <20081119145941.GA13050@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Nov 18, 2008 at 10:44:02PM -0600, sandeen@sandeen.net wrote:
>> +#ifdef BROKEN_X86_ALIGNMENT
>>  STATIC unsigned long
>> -xfs_ioctl32_flock(
>> -	unsigned long		arg)
>> +xfs_ioctl32_flock_copyin(unsigned long arg)
> 
> Any reason this deflect from the standard xfs formatting?

eh, not really.  I can change it back.

> Also when you touch these helpers it would be a lot nice to already
> pass a void __user * pointer to them with just a single case in the main
> handler ala
> 
> 	void__user *	argp = (void __user *)arg;
> 
> And then use that directly in the places where it works, e.g.
> copy_{from,to,in}_user.

ok, sounds good.

> I must also say that I don't really like these _copying helpers at all,
> just adding an explicit call to the underlying ioctl from them seems
> much clener than dispatching control back to the main routine with a
> changed argument and ioc number.

Ok, either way is fine by me, was just following what was there already.

>> -#define XFS_IOC32_GETXFLAGS	FS_IOC32_GETFLAGS
>> -#define XFS_IOC32_SETXFLAGS	FS_IOC32_SETFLAGS
>> -#define XFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
>> +#define XFS_IOC_GETXFLAGS_32	FS_IOC32_GETFLAGS
>> +#define XFS_IOC_SETXFLAGS_32	FS_IOC32_SETFLAGS
>> +#define XFS_IOC_GETVERSION_32	FS_IOC32_GETVERSION
> 
> I think these should go into xfs_ioctl32.h, too.
> 

ah, good point.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
