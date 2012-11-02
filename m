Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA24Y3sO083850 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 23:34:03 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MAro8vlU59H9d2Hx for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 21:35:55 -0700 (PDT)
Message-ID: <50934DAA.8070207@sandeen.net>
Date: Thu, 01 Nov 2012 23:35:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump:fill in bs_forkoff
References: <5080D0BD.3000304@redhat.com> <20121030194718.GD405@sgi.com>
	<50903075.6060600@redhat.com> <20121031194654.GB9783@sgi.com>
In-Reply-To: <20121031194654.GB9783@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Dave Chinner <dchinner@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/31/12 2:46 PM, Ben Myers wrote:
> Hi Eric,

...

> It seemed like it could be an important bugfix but I wasn't really sure so I
> asked.  Since it sounds like it's not a big deal, lets just hold off till after
> the release...

Well, I was wrong - at least at one point, I thought it was getting zeroed. (?!)

But Dave was running into trouble tonight ...

And as the git tree stands today, I'm getting checksum errors w/o this patch
too, and xfstests dump group is passing only with it added back in.

So I think you'd better pull it in, maybe change the commit message a bit
though - it downplays the importance too much I guess.

Sorry about that,

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
