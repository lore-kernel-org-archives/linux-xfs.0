Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN7XU0u041525 for <xfs@oss.sgi.com>; Fri, 23 Nov 2012 01:33:30 -0600
Received: from mailout-de.gmx.net (mailout-de.gmx.net [213.165.64.22]) by
	cuda.sgi.com with SMTP id LY6x2MQ2xDr1ubM3 for
	<xfs@oss.sgi.com>; Thu, 22 Nov 2012 23:35:41 -0800 (PST)
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
Subject: Re: [PATCH] xfs: fix broken error handling in xfs_vm_writepage
Date: Fri, 23 Nov 2012 08:44:22 +0100
References: <1353625410-1413-1-git-send-email-peterhuewe@gmx.de>
	<20121123010123.GD18889@devil.redhat.com>
In-Reply-To: <20121123010123.GD18889@devil.redhat.com>
MIME-Version: 1.0
Message-Id: <201211230844.22438.PeterHuewe@gmx.de>
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
To: Dave Chinner <dchinner@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, stable@vger.kernel.org, xfs@oss.sgi.com

Hi Dave,

Am Freitag, 23. November 2012, 02:01:23 schrieb Dave Chinner:
> Any particular reason you picked this patch for a backport and not
> many of the other fixes that went into the 3.7 series?

Mainly two reasons:
time and before spending many hours trying to 'backport' all this stuff, I first 
wanted to see what the response would be like in general.
I'm still new to the stable kernel business, so I already expected that there 
will be some learning curve ;)

Maybe I should add a "Learners Sticker" to my first xx stable related messages 
:P

So I really appreciate your feedback.


> 
> As it is, this problem is not that easy to hit, and I'm wary of
> backporting changes to the io completion/Io submission error
> handling paths to stable kernels without wider testing of the fix
> (i.e. release of 3.7 and then a couple of weeks of people using it).
> That's the reason why I didn't put a cc to the stable kernel on the
> commit in the first place.
> 
> Sometimes there's good reason for being cautious about
> backporting fixes to stable kernels - if the problem is not being
> reported by users then letting the fixes get out into the real world
> for a while before backporting them to the stable kernels is the
> right approach. Stable kernels are supposed to be stable, and as
> such we want to be certain that changes are not going to have
> unintneded consequences and then have to rush more fixes back to the
> stable kernels because we broke them....

As stated in the other mail, I was a bit too eager here as well ;)
We should probably wait with the inclusion - so sorry for the noise.

Thanks,
PeterH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
