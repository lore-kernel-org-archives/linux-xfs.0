Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA825TMJ085357 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 20:05:29 -0600
Message-ID: <1320717928.3186.100.camel@doink>
Subject: Re: [PATCH] xfstests: ignore fsstress file count for 022
From: Alex Elder <aelder@sgi.com>
Date: Mon, 7 Nov 2011 20:05:28 -0600
In-Reply-To: <1320699832-12693-1-git-send-email-wkendall@sgi.com>
References: <1320699832-12693-1-git-send-email-wkendall@sgi.com>
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

On Mon, 2011-11-07 at 15:03 -0600, Bill Kendall wrote:
> The recently added fsstress operations result in a different
> number of directories and files being created for xfsdump test
> 022, which causes the test to fail since the expected xfsrestore
> output records these numbers. Filter out the numbers to prevent
> this from breaking in the future.
> 
> Also increase the number of fsstress operations used to populate
> the filesystem so that we get roughly the same number of
> directories and files as we used to for this test.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
