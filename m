Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB15vmW2101269
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 23:57:48 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E6D5C20ED
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 21:58:17 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id RGFtFCGTYqUyHcAe for
	<linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 21:58:17 -0800 (PST)
Message-ID: <4B14B077.5090500@sandeen.net>
Date: Mon, 30 Nov 2009 23:58:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can xfs_repair guarantee a complete clean filesystem?
References: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>	
	<4B14936F.7040401@sandeen.net>
	<389deec70911302037v19764c2cr7686b353c5e933fa@mail.gmail.com>
In-Reply-To: <389deec70911302037v19764c2cr7686b353c5e933fa@mail.gmail.com>
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
> 2009/12/1 Eric Sandeen <sandeen@sandeen.net>:
>> hank peng wrote:
>>> When using xfs_repair, I want my XFS filesystem complete clean and
>>> continue to work even if some files lost. Becase we use XFS in low-end
>>> NAS box, customers want a tool to repair the filesystem when it has
>>> problem and they allow some files be lost and don't want the whole
>>> system to stop.
>>> So, I wonder if xfs_repair or some other tools can satisfy this funciton?
>>>
>> Yes, that is exactly its purpose (any potential bugs notwithstanding...)
>>
> Thanks for your reply.
> Is there some points I should notice about when using xfs_repair? I
> used to encounter some cases in which xfs_repair complete successfully
> but some errors like "Corrupt in memory detected" occured when the
> filesytem is put into online for short time.

It's possible that you encountered a bug (in xfs or elsewhere), or
bad hardware...

> Should I reboot the machine and use xfs_repair before the damaged
> filesystem is used, or some other options I should use?

Just unmount the filesystem, run repair, and remount.

> In addition, I googled some information and found that some people say
> xfs_check should be used before xfs_repair, is it right?

There's no need; xfs_check doesn't scale very well, and xfs_repair -n will do
a check-only run if that's what you want.

xfs_check checks a little more than xfs_repair, but xfs_repair simply
rebuilds those things it doesn't check in any case.

-Eric

>> -Eric
>>
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
