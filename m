Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E6777F5E
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 16:27:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE300304032
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 14:27:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LagW9bZC7fyzqf7D for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 14:27:20 -0700 (PDT)
Date: Wed, 25 Mar 2015 08:27:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: factor out xfs_rename_finish()
Message-ID: <20150324212718.GW28621@dastard>
References: <1427194771-3105-1-git-send-email-david@fromorbit.com>
	<1427194771-3105-4-git-send-email-david@fromorbit.com>
	<5511D166.7050201@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5511D166.7050201@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Mar 24, 2015 at 04:04:38PM -0500, Eric Sandeen wrote:
> On 3/24/15 5:59 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Rather than use a jump label for the final transaction commit in
> > the rename, factor it into a simple helper function and call it
> > appropriately. This slightly reduces the spaghetti nature of
> > xfs_rename.
> 
> Nit, subject should be "xfs_finish_rename" not "xfs_rename_finish"

Will fix.

-Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
