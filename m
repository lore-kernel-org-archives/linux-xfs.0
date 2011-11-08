Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA82BW1c085481 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 20:11:32 -0600
Message-ID: <1320718291.3186.103.camel@doink>
Subject: Re: [PATCH v2] xfstests: add 059 and 060 for multi-stream xfsdump
From: Alex Elder <aelder@sgi.com>
Date: Mon, 7 Nov 2011 20:11:31 -0600
In-Reply-To: <1320686536-1399-1-git-send-email-wkendall@sgi.com>
References: <1320686536-1399-1-git-send-email-wkendall@sgi.com>
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

On Mon, 2011-11-07 at 11:22 -0600, Bill Kendall wrote:
> Implement the multi-stream placeholder tests 059 and 060. The comments
> imply that these tests existed on IRIX, but I was unable to find them.
> 
> Test 059 does a simple 4-way dump and restore. Test 060 does a 4-way
> dump, then restores each dump file individually (in a cumulative
> fashion).
> 
> The tests are skipped if the installed xfsdump does not support
> multi-stream output.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

I haven't run these yet, but this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
