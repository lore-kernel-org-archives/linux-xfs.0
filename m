Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 16:34:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NNY2sj022235
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 16:34:03 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B43901B1546F
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 16:35:47 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id BWxxuucl92hTtCOA for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 16:35:47 -0700 (PDT)
Date: Fri, 24 Oct 2008 10:35:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] convert xfs_getbmap to take formatter functions
Message-ID: <20081023233538.GG18495@disturbed>
References: <490103C9.9080900@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490103C9.9080900@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Thu, Oct 23, 2008 at 06:07:53PM -0500, Eric Sandeen wrote:
> Preliminary work to hook up fiemap, this allows us to pass in an
> arbitrary formatter to copy extent data back to userspace.

Is there a fiemap test program around anywhere?

If so, would it be appropriate to include it in xfstests and write
a quick regression test for it? We'd probably need to also check
xfs_bmap gives the same output as fiemap....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
