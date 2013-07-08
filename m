Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 022767F37
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 10:29:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75B5FAC071
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 08:29:53 -0700 (PDT)
Received: from mail-ee0-f43.google.com (mail-ee0-f43.google.com
	[74.125.83.43]) by cuda.sgi.com with ESMTP id uTDD8YbwmgenK1tG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Jul 2013 08:29:52 -0700 (PDT)
Received: by mail-ee0-f43.google.com with SMTP id l10so2915638eei.2
	for <xfs@oss.sgi.com>; Mon, 08 Jul 2013 08:29:51 -0700 (PDT)
Message-ID: <51DAD943.6050703@gmail.com>
Date: Mon, 08 Jul 2013 17:22:43 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
MIME-Version: 1.0
Subject: Re: Some baseline tests on new hardware (was Re: [PATCH] xfs: optimise
	CIL insertion during transaction commit [RFC])
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
	<20130708124453.GC3438@dastard>
	<20130708135953.GF5988@quack.suse.cz>
In-Reply-To: <20130708135953.GF5988@quack.suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Il 08/07/2013 15:59, Jan Kara ha scritto:
> On Mon 08-07-13 22:44:53, Dave Chinner wrote:
> <snipped some nice XFS results ;)>
>> So, lets look at ext4 vs btrfs vs XFS at 16-way (this is on the
>> 3.10-cil kernel I've been testing XFS on):
>>
>> 	    create		 walk		unlink
>> 	 time(s)   rate		time(s)		time(s)
>> xfs	  222	266k+-32k	  170		  295
>> ext4	  978	 54k+- 2k	  325		 2053
>> btrfs	 1223	 47k+- 8k	  366		12000(*)
>>
>> (*) Estimate based on a removal rate of 18.5 minutes for the first
>> 4.8 million inodes.
>>
>> Basically, neither btrfs or ext4 have any concurrency scaling to
>> demonstrate, and unlinks on btrfs a just plain woeful.
>    Thanks for posting the numbers. There isn't anyone seriously testing ext4
> SMP scalability AFAIK so it's not surprising it sucks.

Funny, if I well remember Google guys switched android from yaffs2 to 
ext4 due to its superiority on SMP :)

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
