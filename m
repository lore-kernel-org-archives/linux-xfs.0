Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E44A7F3F
	for <xfs@oss.sgi.com>; Sat, 21 Dec 2013 11:03:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3FCFD8F8071
	for <xfs@oss.sgi.com>; Sat, 21 Dec 2013 09:03:52 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id vgbitqOFE53crlax
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 21 Dec 2013 09:03:49 -0800 (PST)
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:62731
	helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82) (envelope-from <lists@colorremedies.com>)
	id 1VuPxt-001CeF-A1
	for xfs@oss.sgi.com; Sat, 21 Dec 2013 10:03:49 -0700
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <31B8E1DCCA4F45918621D6461ED19B19@alyakaslap>
Date: Sat, 21 Dec 2013 10:03:47 -0700
Message-Id: <8AB55F90-13DA-498D-B5AF-FB1DF76B9010@colorremedies.com>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
	<31B8E1DCCA4F45918621D6461ED19B19@alyakaslap>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On Dec 19, 2013, at 12:24 PM, Alex Lyakas <alex@zadarastorage.com> wrote:

> Hi Dave,
> It makes sense. I agree it might break some guarantees. Although if the user deleted some blocks in the file or the whole file, maybe it's ok to not have a clear promise what he sees after the crash. 

User perspective: I disagree. Sounds like a possible zombie file invasion, with no clear way of reversion. The file either needs to be gone, as in not accessible in user space, or it needs to be present and intact.  There isn't a reasonable expectation for a file to be resurrected from the dead that's also corrupted.

If the file name isn't also corrupted, the problem is worse. It looks like a legitimate file, yet it's useless. The zombie files will be subject to backup and restore, just like their valid predecessors. All I need is to stumble upon a handful of these files, which I won't necessarily remember were deleted files, to start assuming I have some sort of weird file system corruption, at which point at best I'll become really confused not knowing what to do next. At worse, I may start throwing hammers that end up causing worse problems.


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
