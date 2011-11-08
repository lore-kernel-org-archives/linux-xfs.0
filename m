Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA82BcFj085498 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 20:11:38 -0600
Message-ID: <1320718297.3186.104.camel@doink>
Subject: Re: [PATCH] xfstests: fix permissions on non-executable tests
From: Alex Elder <aelder@sgi.com>
Date: Mon, 7 Nov 2011 20:11:37 -0600
In-Reply-To: <1320688253-2432-1-git-send-email-wkendall@sgi.com>
References: <1320688253-2432-1-git-send-email-wkendall@sgi.com>
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

On Mon, 2011-11-07 at 11:50 -0600, Bill Kendall wrote:
> Tests that are not executable are made executable when they are
> run, causing git to report them as modified. Fix this by
> changing non-executable tests to have permissions of 0755.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good.  I update these occasionally so they're
all executable again.  I guess I should do something
so this is more automatic in the future...  Thanks.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
