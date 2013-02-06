Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 345207F3F
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 16:47:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1044C8F8035
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 14:47:12 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1bbaIkMnXEqsZykR for <xfs@oss.sgi.com>;
	Wed, 06 Feb 2013 14:47:11 -0800 (PST)
Date: Thu, 7 Feb 2013 09:47:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using
	git?archive
Message-ID: <20130206224707.GU2667@dastard>
References: <50F44B2E.9050408@sgi.com> <20130201190930.GX27055@sgi.com>
	<20130206011547.GT2667@dastard>
	<loom.20130206T072310-821@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <loom.20130206T072310-821@post.gmane.org>
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
To: Nathan Scott <nathans@debian.org>
Cc: xfs@oss.sgi.com

On Wed, Feb 06, 2013 at 06:28:10AM +0000, Nathan Scott wrote:
> Dave Chinner <david <at> fromorbit.com> writes:
> 
> > 
> > It breaks the 'make deb' command for all the trees.
> > 
> 
> (thanks for checking!)

I didn't - my CI system caught it immediately once I switched
everything back on after being away for a week at LCA. It builds
debs and ships them to VMs, installs them and then runs various
tests after every upstream repository check in that occurs.

It was when I checked the RSS feeds coming back from the CI system
that I noticed that it was busted and started looking into the
problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
