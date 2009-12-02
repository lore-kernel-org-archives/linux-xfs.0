Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB218epK186612
	for <linux-xfs@oss.sgi.com>; Tue, 1 Dec 2009 19:08:41 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA75FC4015
	for <linux-xfs@oss.sgi.com>; Tue,  1 Dec 2009 17:09:09 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id TzucygnqsTZMiLA0 for
	<linux-xfs@oss.sgi.com>; Tue, 01 Dec 2009 17:09:09 -0800 (PST)
Message-ID: <4B15BE1C.2030209@sandeen.net>
Date: Tue, 01 Dec 2009 19:08:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can xfs_repair guarantee a complete clean filesystem?
References: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>	
	<4B14936F.7040401@sandeen.net>	
	<389deec70911302037v19764c2cr7686b353c5e933fa@mail.gmail.com>	
	<4B14B077.5090500@sandeen.net>	
	<389deec70911302234v2fc792ddt54bf88f5200500be@mail.gmail.com>	
	<4B152BAD.1000004@sandeen.net>	
	<389deec70912010732o72edd3c4q196088a1c01b801e@mail.gmail.com>	
	<4B1539C6.90000@sandeen.net>
	<389deec70912011646y682a2cc2rd5d4ea8cfe78d2f5@mail.gmail.com>
In-Reply-To: <389deec70912011646y682a2cc2rd5d4ea8cfe78d2f5@mail.gmail.com>
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

...

>>> kernel version is 2.6.23, xfsprogs is 2.9.7, CPU is MPC8548, powerpc arch.
>>> I am at home now, Maybe I can provide some detailed information tomorrow.
>> If there's any possibility to test newer kernel & userspace, that'd
>> be great.  Many bugs have been fixed since those versions.
>>
> We did have plan to upgrade kernel to latest 2.6.31.

Well, I'm just suggesting testing it for now, not necessarily
upgrading your product.  Would just be good to know if the bug you
are seeing persists upstream on ppc.

> BTW, Is there some place where I can check those fixed bug list across versions?

You can look at the changelogs on kernel.org, for instance:

http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.32

Or with git, git log --pretty-oneline fs/xfs

There isn't a great bug <-> commit <-> kernelversion mapping, I guess.

-Eric

>> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
