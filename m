Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA823ZSx085309 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 20:03:35 -0600
Message-ID: <1320717814.3186.99.camel@doink>
Subject: Re: [PATCH v2 8/8] xfsdump: enable multiple streams
From: Alex Elder <aelder@sgi.com>
Date: Mon, 7 Nov 2011 20:03:34 -0600
In-Reply-To: <1320699511-12281-9-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
	<1320699511-12281-9-git-send-email-wkendall@sgi.com>
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

On Mon, 2011-11-07 at 14:58 -0600, Bill Kendall wrote:
> IRIX contained an environment referred to as "miniroot" where
> sproc threads were either not available, or at least not used
> in xfsdump. Throughout xfsdump there's a "miniroot" variable
> which indicates whether or not thread support is enabled. On
> Linux this variable has always been false in order to disable
> support for multiple streams.
> 
> Now that the threading infracstructure has been converted over
> to pthreads, this patch removes the "miniroot" variable and
> enables the option of using multiple streams.
> 
> Note that another feature in xfsdump, using a ring buffer for
> I/O to tapes, also depends on thread support. I'm leaving that
> disabled for now until more testing has been done.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Really, really nice work Bill.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
