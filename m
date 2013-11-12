Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8F1C97F6D
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 16:11:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3A8F0AC013
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 14:11:23 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	a1P1VPsdmdDggcuT for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 14:11:21 -0800 (PST)
Date: Wed, 13 Nov 2013 09:11:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests generic/320: heavy rm workload test
Message-ID: <20131112221119.GC6188@dastard>
References: <1384243184-19406-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1384243184-19406-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 12, 2013 at 03:59:44PM +0800, Eryu Guan wrote:
> This test is based on generic/273, a regression test for commit
> 
> 9a3a5da xfs: check for stale inode before acquiring iflock on push
> 
> On unpatched kernel, rm processes would hang.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks ok now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
