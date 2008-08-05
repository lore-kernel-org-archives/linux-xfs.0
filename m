Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:38:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m757bGR6013656
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:37:16 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26DBF1246C5E
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 00:38:30 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id ttc85ZGPhUMG9Qeu for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 00:38:30 -0700 (PDT)
Date: Tue, 5 Aug 2008 17:38:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Don't release root inode until finished using it
Message-ID: <20080805073827.GB21635@disturbed>
References: <4897F434.2010309@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4897F434.2010309@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

On Tue, Aug 05, 2008 at 04:33:24PM +1000, Lachlan McIlroy wrote:
> During unmount we're releasing the last reference on the root inode
> before we've finished using it so move it after the XFS_SEND_UNMOUNT
> hook.

Looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
