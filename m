Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:44:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7iY2Z001249
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:44:34 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC862475DF8
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:46:08 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id TTtSKWzdEX2Ud7ju for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:46:08 -0700 (PDT)
Date: Wed, 24 Sep 2008 17:46:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080924074604.GK5448@disturbed>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D9EF6E.8010505@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Wed, Sep 24, 2008 at 05:42:38PM +1000, Lachlan McIlroy wrote:
> Looks good Pete.

No, it is not yet good. Pete cannot explain the underlying problem
and we need to understand if this is fixing the problem or just
changing the timing so it doesn't show up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
