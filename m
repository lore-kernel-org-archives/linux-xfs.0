Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E9227CA0
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 01:51:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D746E8F8040
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 23:51:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OlFkaDRLvdAVzJkv for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2016 23:51:55 -0700 (PDT)
Date: Wed, 15 Jun 2016 16:51:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Something badly broken with the latest XFS changeset in all
	stable kernels?
Message-ID: <20160615065121.GE26977@dastard>
References: <75808782-835f-4bc9-5243-b25cab00d6f3@whissi.de>
	<20160615000241.GC26977@dastard> <20160615013056.GA23074@kroah.com>
	<20160615052831.GA3452@1wt.eu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160615052831.GA3452@1wt.eu>
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
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <greg@kroah.com>, xfs@oss.sgi.com, spender@grsecurity.net, stable@vger.kernel.org, "Thomas D." <whissi@whissi.de>

On Wed, Jun 15, 2016 at 07:28:31AM +0200, Willy Tarreau wrote:
> On Tue, Jun 14, 2016 at 06:30:56PM -0700, Greg KH wrote:
> > As the patch was tagged with 3.10+, I assumed that it was safe to be
> > merged to those older kernels, otherwise I would never have done so.  We
> > do have ways to mark external things like this for stable patches, it's
> > a great help when doing backports.
> 
> I guess only 3.14.72 was affected in the end. 3.18.35 has the fix but my
> understanding is that after 3.17 it's OK.

Correct.

> Apparently it's not yet queued
> for 3.16.

The queue for 3.16 has a different bunch of XFS stuff that I've
previous said is pretty risky and not advisable to back port (the
mmaplock stuff). I'm waiting for that to get to users and a new
bunch of whacky problems to be reported...

> Jiri has queued it for 3.12 but not yet released it. For 3.10
> I only pick patches that are already in a 3.14 release so I didn't have
> the time to backport it to 3.10 yet as the preview started before the
> release.

Just lucky, eh?

> Overall the regression lived only 8 days in a single branch, I
> guess it shows that our process works rather well and limits the exposure
> to regressions.

That it got as far as release and it took so long to get to the
upstream maintainers shows the process could do with being improved.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
