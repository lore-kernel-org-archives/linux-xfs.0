Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p79Me5A8130843 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 17:40:05 -0500
Subject: Re: [PATCH v2 1/7] xfsdump: remove conditional OPENMASKED code
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1312497011-24840-2-git-send-email-wkendall@sgi.com>
References: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
	<1312497011-24840-2-git-send-email-wkendall@sgi.com>
Date: Tue, 9 Aug 2011 17:40:01 -0500
Message-ID: <1312929601.9482.19.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-08-04 at 17:30 -0500, Bill Kendall wrote:
> xfsdump contains a couple wrapper functions which block signals
> during an open(2) call. This code is conditionally compiled and has
> not been enabled for a long time. Remove the wrappers rather than
> converting them to use the POSIX signal API.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
