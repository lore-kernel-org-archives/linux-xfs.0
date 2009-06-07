Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n57IROSO183408
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 13:27:25 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61EDB2DA882
	for <linux-xfs@oss.sgi.com>; Sun,  7 Jun 2009 11:27:42 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id EcEcQS9Fdr2uInYX for
	<linux-xfs@oss.sgi.com>; Sun, 07 Jun 2009 11:27:42 -0700 (PDT)
Message-ID: <4A2C0698.9060800@sandeen.net>
Date: Sun, 07 Jun 2009 13:27:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
References: <20090520003745.GA27491@samad.com.au>	<20090604112657.GA10738@infradead.org>
	<h0gtcd$136u$1@osprey.mgras.de>
In-Reply-To: <h0gtcd$136u$1@osprey.mgras.de>
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
To: Martin Spott <Martin.Spott@mgras.net>
Cc: linux-xfs@oss.sgi.com

Martin Spott wrote:
> Hi Christoph,
> 
> Christoph Hellwig wrote:
> 
>> Sorry guys, still haven't been able to track it down.  Any chance one
>> of you could run with CONFIG_XFS_DEBUG enabled and see if it trips
>> over any of the asserts?
> 
>   "Say N unless you are an XFS developer, or you play one on TV."
> 
> Very nice  ;-)
> 
> I'm have to regret that I'm neither an XFS developer nor do I pretend
> to be one. Yet, as I understand, I should see at least _some_ debug
> info via 'dmesg', if there is any.

CONFIG_XFS_DEBUG is more of addded checks and asserts, not so much in
the way of extra messages - at least, until you actually hit a problem.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
