Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA25E0C7089847 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 00:14:00 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ve0LLfoYG90BDOHX for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 22:15:52 -0700 (PDT)
Date: Fri, 2 Nov 2012 16:15:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsdump:fill in bs_forkoff
Message-ID: <20121102051544.GX29378@dastard>
References: <5080D0BD.3000304@redhat.com> <20121030194718.GD405@sgi.com>
	<50903075.6060600@redhat.com> <20121031194654.GB9783@sgi.com>
	<50934DAA.8070207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50934DAA.8070207@sandeen.net>
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
Cc: Ben Myers <bpm@sgi.com>, xfs-oss <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>

On Thu, Nov 01, 2012 at 11:35:54PM -0500, Eric Sandeen wrote:
> On 10/31/12 2:46 PM, Ben Myers wrote:
> > Hi Eric,
> 
> ...
> 
> > It seemed like it could be an important bugfix but I wasn't really sure so I
> > asked.  Since it sounds like it's not a big deal, lets just hold off till after
> > the release...
> 
> Well, I was wrong - at least at one point, I thought it was getting zeroed. (?!)
> 
> But Dave was running into trouble tonight ...
> 
> And as the git tree stands today, I'm getting checksum errors w/o this patch
> too, and xfstests dump group is passing only with it added back in.
> 
> So I think you'd better pull it in, maybe change the commit message a bit
> though - it downplays the importance too much I guess.

Yes, this patch fixes the failures I see under normal conditions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
