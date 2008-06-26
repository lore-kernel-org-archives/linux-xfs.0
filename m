Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 20:02:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q32MdX026879
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 20:02:22 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4EF2D55DF4
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 20:03:22 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id BZbVimdZvxwQWhkk for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 20:03:22 -0700 (PDT)
Date: Thu, 26 Jun 2008 13:03:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Don't assert if trying to mount with blocksize >
	pagesize
Message-ID: <20080626030315.GG11558@disturbed>
References: <4863056D.3080209@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4863056D.3080209@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 26, 2008 at 12:56:45PM +1000, Lachlan McIlroy wrote:
> If we don't do the blocksize/PAGESIZE check before
> calling xfs_sb_validate_fsb_count() we can assert
> if we try to mount with a blocksize > pagesize.
> The assert is valid so leave it and just move the
> blocksize/pagesize check earlier.

Yes, looks like a problem. The fix looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
