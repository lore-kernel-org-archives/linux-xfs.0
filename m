Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAB0KbD074665 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 05:00:22 -0600
Date: Thu, 10 Nov 2011 06:00:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/8] xfsdump: enable support for multiple streams
Message-ID: <20111110110017.GA26747@infradead.org>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
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

I've put these changes, and Mike's path.c fix in.  It seems like the
whole autoconf/aclocal foo needs to be regenerated to make the
libpthread substitution to work.

What is your schedule for turning on the tap ring buffer, and redoing
the stream split scan?  Should we wait for them or aim for a release
with the current improvements relatively quickly?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
