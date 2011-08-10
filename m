Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7ALlvNE210492 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 16:47:58 -0500
Subject: Re: [PATCH v2 5/7] xfsdump: rework dialog to use main signal handler
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1312497011-24840-6-git-send-email-wkendall@sgi.com>
References: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
	<1312497011-24840-6-git-send-email-wkendall@sgi.com>
Date: Wed, 10 Aug 2011 16:47:53 -0500
Message-ID: <1313012873.2865.138.camel@doink>
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
> xfsdump currently swaps in a different signal handler for the duration
> of a dialog. This patch changes the code to have a global signal
> handler which will first give the dialog a chance to process the
> signal. If a dialog is not active or if it is not interested in the
> signal, the signal will be processed as usual.

Yay!  I guess I wasn't alone in being confused by
the signal handlers...

> There is one side effect to this change. SIGQUIT is now caught in the
> miniroot/pipeline case as the handler needs to be setup in case a
> dialog needs it. The signal handler will exit in this case just as
> if SIGQUIT was not caught, the only real difference being that a
> core file will not be generated.

Sounds OK to me.

Your dialog signal handler is clever, and I like it.
Again you should make dlog_registered_sigs have a
"volatile" qualifier.

Otherwise this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Bill Kendall <wkendall@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
