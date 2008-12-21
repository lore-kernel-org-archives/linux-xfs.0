Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLMKt0Q026374 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 16:20:55 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E62E93C9E8
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 14:20:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id YSNPxNuxIrzAdkrp for <xfs@oss.sgi.com>;
	Sun, 21 Dec 2008 14:20:53 -0800 (PST)
Message-ID: <494EC13E.2060303@sandeen.net>
Date: Sun, 21 Dec 2008 16:20:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair problem.
References: <7bcfcfff0812210703r4bd889cave8e2d60c56587e3e@mail.gmail.com>	
	<494E66D9.5030704@sandeen.net>	
	<7bcfcfff0812210852v6c1cd522i334de914e1e9a112@mail.gmail.com>	
	<494E766B.5080102@sandeen.net>
	<7bcfcfff0812211408u6e08bf81r1c19ab5ba938b0e2@mail.gmail.com>
In-Reply-To: <7bcfcfff0812211408u6e08bf81r1c19ab5ba938b0e2@mail.gmail.com>
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
To: David Bernick <dbernick@gmail.com>
Cc: xfs@oss.sgi.com

David Bernick wrote:
> So I ran an xfs_repair -v on my filesystem. While the FS was originally
> 12T and 95% full. I ran xfs_repair and it throw many "out of space
> errors" when it was running. That makes some sense.
>  
> I expanded it with a new device with xfs_grow. It seems to work, because
> the disk is now bigger when I mount it.

I should have pointed out; growing less than 2T at a time is safe, even
with that bug ...

> When I ran xfs_repair on that (latest version), it reverts back to the
> original size. Is there anything I need to do to make the xfs_growfs
> permanent?

No, it should just work.  But 2T at a time on that older code w/ teh bug.

> If I can make the XFS partition bigger, I can likely make it work
> because then it won't run out of space! But the partition, despite
> saying its "bigger" here, doesn't seem to "take" after the xfs_repair.
> Any ideas?

Add a terabyte at a time :)

(or backport that patch...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
