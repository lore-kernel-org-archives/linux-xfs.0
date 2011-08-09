Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p79A8G93086438 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 05:08:16 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1BDDC77AA
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2011 03:08:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SUCA8czOQAxa3Zer for <xfs@oss.sgi.com>;
	Tue, 09 Aug 2011 03:08:15 -0700 (PDT)
Date: Tue, 9 Aug 2011 20:08:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fsx: fix the hole punching test
Message-ID: <20110809100812.GR3162@dastard>
References: <1312819080-10083-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312819080-10083-1-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 08, 2011 at 11:58:00AM -0400, Josef Bacik wrote:
> The test to make sure we support hole punching is just wrong.  First it passes
> the mode options into the len argument, and secondly it uses 0 for what I assume
> was meant for the length, which doesn't work right.  Also it uses warn instead
> of just normal prt, which will cause xfstests to blow up for no reason.  So fix
> the arguments and the error message so that we can actually run xfstests with
> fsx on fs's that don't support hole punching yet.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Already fixed:

http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=commit;h=c18bf42de9d5d5fa05025754df1ff63f2147bd12

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
