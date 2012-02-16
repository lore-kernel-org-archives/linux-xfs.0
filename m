Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1G0Mfcr214890 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 18:22:41 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	MLUWYwbTO1hbS0kI for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 16:22:39 -0800 (PST)
Date: Thu, 16 Feb 2012 11:22:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Transactional XFS?
Message-ID: <20120216002237.GW14132@dastard>
References: <CAFLt3phWcaQ4K3OPSVUkyN0BXqh+jQgQbeA59Oav23aOPLYMYw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFLt3phWcaQ4K3OPSVUkyN0BXqh+jQgQbeA59Oav23aOPLYMYw@mail.gmail.com>
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
To: Grozdan <neutrino8@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 15, 2012 at 08:15:46PM +0100, Grozdan wrote:
> Hi,
> 
> I just finished watching the excellent speech of Dave Chinner at
> linux.conf.au and I must say I'm impressed by the recent improvements
> to XFS. Towards the end of the talk, Dave talked about upcoming
> improvements on Metadata reliability and other features. What I'm
> wondering about is if there are any plans in making XFS transactional
> (fully atomic) like it is the case with recent NTFS versions on
> Windows Vista and higher?

What do you mean by "fully atomic"? NTFS is not fully atomic - it
doesn't journal data so can lose data on a crash - so I'm not sure
what you mean here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
