Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA9Mbdjn261316 for <xfs@oss.sgi.com>; Wed, 9 Nov 2011 16:37:39 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E376232737
	for <xfs@oss.sgi.com>; Wed,  9 Nov 2011 14:37:37 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Oih0DJtPdJU1zmDj for <xfs@oss.sgi.com>;
	Wed, 09 Nov 2011 14:37:37 -0800 (PST)
Date: Thu, 10 Nov 2011 09:37:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: add .ltdep to .gitignore
Message-ID: <20111109223735.GR5534@dastard>
References: <1320865438-27014-1-git-send-email-bpm@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320865438-27014-1-git-send-email-bpm@sgi.com>
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
Cc: aelder@sgi.com, arenaud@sgi.com, xfs@oss.sgi.com

On Wed, Nov 09, 2011 at 01:03:58PM -0600, Ben Myers wrote:
> Make git ignore all .ltdep files which are created as part of the build
> process.
> 
> ~/xfsprogs # find | grep ltdep
> ./libxcmd/.ltdep
> ./libxfs/.ltdep
> ./libhandle/.ltdep
> ./libdisk/.ltdep
> ./libxlog/.ltdep
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>

The same changes are needed for the xfstests and xfsdump packages,
right? Regardless, this change is good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
