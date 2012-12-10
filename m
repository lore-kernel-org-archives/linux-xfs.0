Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA1JFCm150693 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 19:19:15 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JDukT3rrljSTCufz for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 17:21:43 -0800 (PST)
Date: Mon, 10 Dec 2012 12:21:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] XFS: remove a unused sysctl related enum definition.
Message-ID: <20121210012141.GJ15784@dastard>
References: <50C521B2.1030001@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50C521B2.1030001@jp.fujitsu.com>
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
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs ML <xfs@oss.sgi.com>

On Mon, Dec 10, 2012 at 08:41:38AM +0900, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> There is a unused sysctl related enum definition
> in fs/xfs/xfs_sysctl.h. This patch removes it.

Is it?

AFAICT, kernel/sysctl_binary.c uses it when CONFIG_SYSCTL_SYSCALL=y.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
