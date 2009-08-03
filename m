Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n73ItB7q105143
	for <linux-xfs@oss.sgi.com>; Mon, 3 Aug 2009 13:55:12 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C73F1445D1D
	for <linux-xfs@oss.sgi.com>; Mon,  3 Aug 2009 11:56:00 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id EgexB8UxWxUjrwWq for
	<linux-xfs@oss.sgi.com>; Mon, 03 Aug 2009 11:56:00 -0700 (PDT)
Message-ID: <4A7732BF.6020207@sandeen.net>
Date: Mon, 03 Aug 2009 13:55:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to solve "No space left" problem on my 32bit machine?
References: <389deec70907252030s3524b2ecj9b35da9ea376020f@mail.gmail.com>	<4A6D075B.9060601@sandeen.net>	<389deec70907262347g1ca3637fn469596ec1e05148@mail.gmail.com>	<4A6DAE5D.6060704@sandeen.net>
	<389deec70908030732n29d35220mc9acdb912ab10899@mail.gmail.com>
In-Reply-To: <389deec70908030732n29d35220mc9acdb912ab10899@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

hank peng wrote:
> 2009/7/27 Eric Sandeen <sandeen@sandeen.net>:
>> hank peng wrote:
>>> 2009/7/27 Eric Sandeen <sandeen@sandeen.net>:
>>>> hank peng wrote:
>>>>> Hi, folks:
>>>>> I have a 2.5T file system formatted with XFS, df tells me it still
>>>>> have about 10G space available, but I can't create new files or
>>>>> directory any more. Return message is "No space left on this device".
>>>>> I searched solution for this problem through google, and found this:
>>>>> http://oss.sgi.com/archives/xfs/2005-06/msg00347.html. I think it is a
>>>>> known "No space left" problem. I wonder whether it can only
>>>>> be solved on 64-bit machine? If on my 32-bit machine, what should I do?
>>>> On very recent kernels you can use 64-bit inodes on 32-bit machines; you
>>>> can try mounting with -o inode64 t allow this.
>>>>
>>> I tried -o inode64 option, but kernel gives me error message:
>>> XFS: inode64 option not allowed on this system
>>> I doubt this option can't be used on 32-bit machine.
>> That's why I said you need a very recent kernel, it was added relatively
>> recently:
>>
>> commit 6c31b93a14a453c8756ffd228e24910ffdf30c5d
>> Author: Christoph Hellwig <hch@infradead.org>
>> Date:   Fri Nov 28 14:23:32 2008 +1100
>>
>>    [XFS] allow inode64 mount option on 32 bit systems
>>
>> I believe this went into 2.6.29.
>>
> I tried 2.6.30 and test it
> 1. create an exact 2T LVM
> 2. create XFS on it
> 3. mont it with inode64 option
> 4. write files on it to full extent
> 5. use xfs_grow to expand it to 2.5T
> 6. touch a file and no error message returned
> 7. 'ls -l' can not show the file I created above.
> 
> So I think I should do something on userspace tools, but how?

Doesn't sound like a userspace problem.  So touch succeeds (maybe echo
$? after to be sure) but ls shows no file?  Anything in dmesg after that?

I'd have to find a 32-bit box w/ > 2T to test this I guess.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
