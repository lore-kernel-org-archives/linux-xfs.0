Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 692A57CA0
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 20:11:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2FBA98F81A5
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 18:10:58 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wp57BCb4TqTEJZiu for <xfs@oss.sgi.com>;
	Tue, 16 Aug 2016 18:10:55 -0700 (PDT)
Date: Wed, 17 Aug 2016 11:10:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: master branch updated to v4.8-rc2, for-next
	branch updated to d25ed4d
Message-ID: <20160817011053.GF19025@dastard>
References: <20160816233659.GE19025@dastard>
	<20160817003350.GA8268@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160817003350.GA8268@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 16, 2016 at 05:33:50PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 17, 2016 at 09:36:59AM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > I've just updated the master branch of hte XFS kernel repository to
> > v4.8-rc2. If you have outstanding patches, can you check they apply
> > to this updated branch, and if not rebase your patches and resend
> > them?
> 
> I think this is missing "xfs: remove OWN_AG rmap when allocating a block from
> the AGFL", a.k.a. the fix for the generic/299 crash you were seeing.

Oh, I might have merged one patch short. Thanks for the head's up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
