Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7CKjucd086300 for <xfs@oss.sgi.com>; Fri, 12 Aug 2011 15:45:57 -0500
Date: Fri, 12 Aug 2011 16:45:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/7] xfsdump: convert to the POSIX signal API
Message-ID: <20110812204554.GA30615@infradead.org>
References: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
	<1312497011-24840-7-git-send-email-wkendall@sgi.com>
	<1313012883.2865.139.camel@doink> <4E457BEE.7060704@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E457BEE.7060704@sgi.com>
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
Cc: xfs@oss.sgi.com, aelder@sgi.com

On Fri, Aug 12, 2011 at 02:15:58PM -0500, Bill Kendall wrote:
> >Is there any requirement that the fields
> >other than sa_flags and sa_handler should
> >be zeroed before use?
> 
> The sa_sigaction field will only be used if sa_flags
> has SA_SIGINFO set, and the sa_restored field is obsolete
> and not specified by POSIX. Better to explicitly initialize
> everything though, so I'll change that.

sigaction actuall is a rare case where this is harmful.  To quote
the manpage:

	On some architectures a union is involved:  do not assign to both
	sa_handler and sa_sigaction.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
