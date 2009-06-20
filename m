Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KDTAp3117722
	for <linux-xfs@oss.sgi.com>; Sat, 20 Jun 2009 08:29:10 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B5E41AE0BCB
	for <linux-xfs@oss.sgi.com>; Sat, 20 Jun 2009 06:29:35 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id eeHElGPFHPNdfNrC for
	<linux-xfs@oss.sgi.com>; Sat, 20 Jun 2009 06:29:35 -0700 (PDT)
References: <4A392213.4020200@news-service.com> <4A3960A0.8090707@sandeen.net>
	<4A39F2E6.5020205@news-service.com>
	<4A3CB765.8040600@news-service.com>
Message-Id: <7028E3E6-033A-416D-B046-286520CA457A@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <4A3CB765.8040600@news-service.com>
Mime-Version: 1.0 (iPod Mail 7A341)
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
Date: Sat, 20 Jun 2009 08:29:06 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Patrick Schreurs <patrick@news-service.com>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>, Tommy van Leeuwen <tommy@news-service.com>

Others aren't hitting this, what sort of workload are you running when  
you hit it?

I have not had time to look at it yet but some sort of testcase may  
greatly help.

-Eric

On Jun 20, 2009, at 5:18 AM, Patrick Schreurs <patrick@news- 
service.com> wrote:

> Unfortunately another panic. See attachment.
>
> Would love to receive some advice on this issue.
>
> Thanks in advance.
>
> -Patrick
>
> Patrick Schreurs wrote:
>> Eric Sandeen wrote:
>>> Patrick Schreurs wrote:
>>>> Hi all,
>>>>
>>>> We are experiencing kernel panics on servers running 2.6.29(.1)  
>>>> and 2.6.30. I've included two attachments to demonstrate.
>>>>
>>>> The error is:
>>>> Kernel panic - not syncing: xfs_fs_destroy_inode: cannot  
>>>> reclaim ...
>>>>
>>>> OS is 64bit Debian lenny.
>>>>
>>>> Is this a known issue? Any comments on this?
>>>
>>> It's not known to me, was this a recent upgrade?  (IOW, did it start
>>> with .29(.1)?
>> We've seen this on 2 separate servers. It probably happened more  
>> often, but we didn't captured the panic message. One server was  
>> running 2.6.29.1, the other server was running 2.6.30. Currently  
>> we've updated all similar servers to 2.6.30.
>> If we can provide you with more details to help fix this issue,  
>> please let us know.
>> -Patrick
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> <sb06-20090619.png>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
