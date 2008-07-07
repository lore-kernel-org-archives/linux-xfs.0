Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 17:06:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6706kLj002298
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 17:06:46 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3873B2BEF58
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 17:07:49 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id mAfCr5HXUf2BAMQG for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 17:07:49 -0700 (PDT)
Date: Mon, 7 Jul 2008 10:07:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Recovery
Message-ID: <20080707000745.GI29319@disturbed>
References: <48715CEF.8010008@sauce.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48715CEF.8010008@sauce.co.nz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Scobie <richard@sauce.co.nz>
Cc: xfs@oss.sgi.com

On Mon, Jul 07, 2008 at 12:01:51PM +1200, Richard Scobie wrote:
> If the following log entry appears after mounting an XFS fs, is it safe  
> to assume that whatever issue initiated the recovery has been repaired,  
> or is further checking/repair required?

No.

> XFS mounting filesystem md5
> Starting XFS recovery on filesystem: md5 (logdev: /dev/md0)
> Ending XFS recovery on filesystem: md5 (logdev: /dev/md0)

That's normal output when mounting an XFS filesystem - if
you see more than this then there might be problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
