Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T23neL027573 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 21:03:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BACC48EBB1B
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 19:05:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	9JB8kdZAz40SERmM for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 19:05:52 -0700 (PDT)
Date: Thu, 29 Apr 2010 12:05:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enabling lazy counters damages filesystem
Message-ID: <20100429020549.GC2512@dastard>
References: <4BD84771.4030804@mejor.pl> <20100428230447.GJ9783@dastard>
	<20100429014312.GA2512@dastard> <4BD8E622.80100@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BD8E622.80100@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>, xfs@oss.sgi.com

On Wed, Apr 28, 2010 at 08:51:30PM -0500, Eric Sandeen wrote:
> Dave Chinner wrote:
> 
> ...
> 
> > Actually, 3.1.0 was the first release with the fix to xfs_db that
> > prevents this problem.
> > 
> > Cheers,
> > 
> > Dave.
> 
> not so sure:

Yeah, you are right. I was thinking that xfs_db did the feature bit
modifications, then repair just fixed up the accounting. but repair
does both in this case. I should remember code that I wrote years
ago, but for some reason it all seems to be a little bit hazy...

Let me go look at your repair patch again ;)

Cheers,

dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
