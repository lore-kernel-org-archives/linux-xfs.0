Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8O9qmCK175491 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 04:52:49 -0500
Received: from mailout.rz.uni-frankfurt.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4EEB997DB
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 02:53:28 -0700 (PDT)
Received: from mailout.rz.uni-frankfurt.de (mailout.rz.uni-frankfurt.de
	[141.2.22.233]) by cuda.sgi.com with ESMTP id TL5UHAZZGkFOZcH9
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 02:53:28 -0700 (PDT)
Date: Fri, 24 Sep 2010 11:53:17 +0200
From: Mario Bachmann <mbachman@stud.uni-frankfurt.de>
Subject: Re: [PATCH] Re: xfsdump-3.0.4 problems
Message-ID: <20100924115317.7026e721@x2.grafnetz>
In-Reply-To: <20100827114055.GI705@dastard>
References: <20100816182236.249a2a0f@x2.grafnetz>
	<20100816223021.GL10429@dastard>
	<20100817083227.06e23889@x2.grafnetz>
	<20100817071337.GN10429@dastard>
	<20100817095340.6b9ab8e2@x2.grafnetz>
	<20100817090534.GP10429@dastard> <20100817114550.GQ10429@dastard>
	<20100827111820.GA9837@teal.hq.k1024.org>
	<20100827114055.GI705@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi there, 

is the patch now in 2.6.35.5? 

The more exact question is: Does XFS (and xfsprogs) work perfectly now again?
My backup works with xfsdump, so it would be a disaster when this does not work.

Thanks for your information!

Greetings
Mario


Am Fri, 27 Aug 2010 21:40:55 +1000
schrieb Dave Chinner <david@fromorbit.com>:

> On Fri, Aug 27, 2010 at 01:18:20PM +0200, Iustin Pop wrote:
> > On Tue, Aug 17, 2010 at 09:45:50PM +1000, Dave Chinner wrote:
> > > My fault. I screwed up the btree lookup for the inode validation.
> > > Can you test the patch below?
> > 
> > I just see that 2.6.35.4 has been released, but it doesn't include this
> > fix (as far as I can see). Could it be send for inclusion into the next
> > stable please (yes, it fixes the issue for me too).
> 
> The commit is now upstream, it had a "cc: stable@kernel.org" in it,
> so it should get automatically queued for inclusion in the next
> stable kernel release. If I don't see it appear in Greg's stable
> queue once he starts processing the commits for the next stable
> release, I'll chase it up....
> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
