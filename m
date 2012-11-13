Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADI0BJn110570 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 12:00:11 -0600
Message-ID: <50A28B23.4000703@sgi.com>
Date: Tue, 13 Nov 2012 12:02:11 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs_quota: fix report command parsing
References: <1352444578-14600-1-git-send-email-david@fromorbit.com>
	<1352444578-14600-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1352444578-14600-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/09/12 01:02, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The report command line needs to be parsed as a whole not as
> individual elements - report_f() is set up to do this correctly.
> When treated as non-global command line, the report function is
> called once for each command line arg, resulting in reports being
> issued multiple times.
>
> Set the command to be a global command so that it is only called
> once.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Solves the duplicate listings.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
