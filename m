Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74CbDpX068960 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 07:37:13 -0500
Date: Thu, 4 Aug 2011 08:37:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfsdump: convert to the POSIX signal API
Message-ID: <20110804123712.GA1089@infradead.org>
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<1311972011-1446-5-git-send-email-wkendall@sgi.com>
	<20110803104813.GA3575@infradead.org> <4E393AE3.70505@sgi.com>
	<20110803123934.GA13447@infradead.org> <4E39A176.7000906@sgi.com>
	<20110804075331.GA8836@infradead.org> <4E3A91F8.3080606@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E3A91F8.3080606@sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Aug 04, 2011 at 07:35:04AM -0500, Bill Kendall wrote:
> Right, with some rework of that handler. It would have to do
> something like:
> 
>   case SIGINT:
>       if (is_dialog_active(SIGINT))
>           dlg_sigterm_received = BOOL_TRUE;
>       else
>           sigterm_received = BOOL_TRUE;
> 
> (The SIGINT param is needed because it's optional whether a
> dialog handles a particular signal.)
> 
> Otherwise we'd race between main's use of sigterm_received and
> the dialog's need to use it.
> 
> Do you prefer this over the signal handler swap?

This seems cleaner to me.  The upside is that we a) don't have
to mess with changing signal handlers all the time, and b)
that we don't really have to bother who is going to receive the
signal.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
