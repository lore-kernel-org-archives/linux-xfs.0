Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P4wQBN159477 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 23:58:27 -0500
Date: Thu, 25 Aug 2011 00:58:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] xfsprogs: xfs_quota: a few fixes
Message-ID: <20110825045823.GA23901@infradead.org>
References: <1314222823-24101-1-git-send-email-aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1314222823-24101-1-git-send-email-aelder@sgi.com>
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

On Wed, Aug 24, 2011 at 04:53:40PM -0500, Alex Elder wrote:
> The main problem solved in this series is that for project
> quotas, the numbers of blocks reported by the xfs_quota "df"
> subcommand is twice what it should be.  While looking at
> this I also noticed two other problems that I corrected.
> 
> Below is a script that demonstrates the problem.

This script should be turned into an xfsqa testcase.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
