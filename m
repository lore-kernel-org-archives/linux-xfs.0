Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73AxDoO148861 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 05:59:13 -0500
Date: Wed, 3 Aug 2011 06:59:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] xfsdump: convert to using the POSIX signal API
Message-ID: <20110803105911.GA7226@infradead.org>
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
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

Bill,

one thing I noticed looking over the code to understand your changes
is that there still is a lot of dead code in xfsdump.  One that
has a lot of implications and seems fairly useless for any non-IRIX
version is the miniroot mode.  Any chance we can rip that out?  There's
also a lot of code under #ifdef HIDDEN - it would be good to go through
these and see we can just be removed, and if anything is still useful
moved under more self-explaining ifdefs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
