Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NHBtEL016439 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 12:11:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF7991444997
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:14:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lPazr4kflVv3RKZT for
	<xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:14:45 -0700 (PDT)
Date: Thu, 23 Apr 2009 13:11:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: enforce lazy-count=0 in log tests 018, 081, 082
Message-ID: <20090423171151.GB11391@infradead.org>
References: <49EE28EA.4010409@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49EE28EA.4010409@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Tue, Apr 21, 2009 at 03:13:30PM -0500, Eric Sandeen wrote:
> I was experimenting w/ default lazy-count=1, and it broke a few tests.
> Seems simplest to enforce lazy-count=0 in the common.log routines
> for now, and fix up the output?  (vs. updating all the expected
> output for these tests...)

Didn't you just send a patch to make lazy-count=1 the default? :)

I'd rather see either a filter dealing with both variants or make
sure we always test the newer and more important case (lazy-count=1)
here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
