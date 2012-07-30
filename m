Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6ULuhiX095293 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 16:56:43 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sBOETCZ3pmdOBSyP for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 14:56:42 -0700 (PDT)
Date: Tue, 31 Jul 2012 07:56:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Don't require to set $TEST_DEV and $TEST_DIR
	when creating new script
Message-ID: <20120730215630.GH2877@dastard>
References: <1343649811-13944-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343649811-13944-1-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Mon, Jul 30, 2012 at 02:03:31PM +0200, Tomas Racek wrote:
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>  common.config |   26 ++++++++++++++------------
>  1 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/common.config b/common.config
> index 7bed1c5..b92c025 100644
> --- a/common.config
> +++ b/common.config
> @@ -201,9 +201,9 @@ known_hosts()
> 
>    #  Mandatory Config values.
>    MC=""
> -  [ -z "$EMAIL" ]          && MC="$MC EMAIL"
> -  [ -z "$TEST_DIR" ]       && MC="$MC TEST_DIR"
> -  [ -z "$TEST_DEV" ]       && MC="$MC TEST_DEV"
> +  [ -z "$EMAIL" ]                           && MC="$MC EMAIL"
> +  [ -z "$TEST_DIR" ] && [ "$iam" != "new" ] && MC="$MC TEST_DIR"
> +  [ -z "$TEST_DEV" ] && [ "$iam" != "new" ] && MC="$MC TEST_DEV"

Given that I'm currently in the process of killing $iam as I
rework the structure of xfstests, I really don't like the idea of
introducing new dependencies on it.

Also, I prefer to know that someone writing a new test is developing
it in a configured, working test environment. After all, you have to
test your new test as you write it... :p

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
