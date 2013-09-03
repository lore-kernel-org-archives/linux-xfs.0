Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F077B7F3F
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 14:02:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF2E730407A
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 12:02:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 5SvXn6d1K5tEOTJ1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 12:02:12 -0700 (PDT)
Date: Tue, 3 Sep 2013 12:02:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] xfs: more shutdown-related fixes
Message-ID: <20130903190210.GA23072@infradead.org>
References: <1378208858-20557-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378208858-20557-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 03, 2013 at 09:47:36PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> More fixes as a result of forced shutdown testing. The first is
> fixing yet another hole in the buf log item freein logic when a
> transaction is aborted, and the other removes the asserts from the
> inode buffer checking so that verifiers return errors rather than
> crashing the system.

Btw, I've been wondering for a while if we need a major change to how
the buf item refcounting works.  All these little special cases in there
are utterly non-intuitive.  I've not looked very deep yet, but a normal
scheme where every reference to it increments the refcount, and we
simply free it when that hits zero should work here as well.  We'd
still need flags for the abort and clean conditions, but it would still
be way simpler than what we have now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
