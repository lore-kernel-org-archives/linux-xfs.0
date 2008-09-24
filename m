Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 23:06:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O66EQY016015
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 23:06:14 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83E76963B65
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 23:07:48 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id pUNfnnTqcLahoN74 for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 23:07:48 -0700 (PDT)
Date: Wed, 24 Sep 2008 16:07:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] don't use signed int to store xfs_dqid_t
Message-ID: <20080924060739.GI5448@disturbed>
References: <48D9C653.1030908@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D9C653.1030908@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

On Wed, Sep 24, 2008 at 02:47:15PM +1000, Peter Leckie wrote:
> When running xfsqa test 144 with quota's enabled it's possible to
> trip the following ASSERT(curid >= 0); from xfs_qm_init_dquot_blk().
> The reason this assert was tripped is the signed int currid was assigned
> an id from the unsigned xfs_dqid_t this works as long as the MSB in  
> xfs_dqid_t
> is not set. However if it is this translates to a negative number causing
> the assert to trip.
>
> The fix for this is simply replacing the signed int with type xfs_dqid_t
> and since xfs_dqid_t is unsigned there is no point checking if it's negative
> so remove the assert.

Looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
