Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2202oen226001 for <xfs@oss.sgi.com>; Tue, 1 Mar 2011 18:02:51 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 153E0A5BA71
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2011 16:05:39 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vBJoQsr3tFvvG1OA for <xfs@oss.sgi.com>;
	Tue, 01 Mar 2011 16:05:39 -0800 (PST)
Date: Wed, 2 Mar 2011 11:05:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: drop "Mount point match" from 028 and 047
	golden output
Message-ID: <20110302000524.GC4905@dastard>
References: <201103012253.p21MrHwt014849@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201103012253.p21MrHwt014849@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 01, 2011 at 04:53:17PM -0600, Alex Elder wrote:
> Bill's latest update to xfsdump dropped a line of output that served
> no real purpose.  This change updates the golden output for the two
> tests that included that line of output.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Hmmm - That means older versions of xfsdump will now fail the test
(e.g. running latest xfstests on RHEL/SLES installs).  Can you
filter the output of xfsdump so that even older versions still pass
the test?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
