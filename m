Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C35FF7F53
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 18:12:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5DC2DAC002
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 16:12:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gpV6CXu2ajVTke7h for <xfs@oss.sgi.com>;
	Sun, 18 Oct 2015 16:12:20 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EC38E63CBCF9
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 18:12:19 -0500 (CDT)
Subject: Re: Problem with data recovery
References: <20151018144937.5406805.67472.2273@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56242753.7000807@sandeen.net>
Date: Sun, 18 Oct 2015 18:12:19 -0500
MIME-Version: 1.0
In-Reply-To: <20151018144937.5406805.67472.2273@gmail.com>
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
To: xfs@oss.sgi.com



On 10/18/15 9:49 AM, Matteo Sarti wrote:
> I have a buffalo terastation with both two failed drive on 4 drives of raid 5.
> Problem is very simple hardware is ok, but someone goes wrong during normal process of this dataserver.

I don't understand what that means - how can you have two failed drives, but hardware is ok?

If you lost 2 drives out of a 3+1 RAID5, then you have essentially lost your filesystem,
I'm sorry.

> I check both driver on other PC with ufs explorer and drive is full of data, but xfs file system is not recognized.

because the drives are part of a raid set, and they are not xfs filesystems
on their own.

https://en.wikipedia.org/wiki/Standard_RAID_levels#RAID_5

> How can I write manually on harddrive using raw data the beginning of xfs definition??

You can't.

> I hope someone can help me because buffalo is very good in selling, but not so much in Support :(.

If you lost 2 of your 4 drives, there's not much support to do, I'm afraid.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
