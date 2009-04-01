Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n31EZk2C087759 for <xfs@oss.sgi.com>; Wed, 1 Apr 2009 09:35:56 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 020321C890FB
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2009 07:35:22 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id 5YeIZyn3ggiCLpDt for
	<xfs@oss.sgi.com>; Wed, 01 Apr 2009 07:35:22 -0700 (PDT)
Date: Wed, 1 Apr 2009 10:35:22 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 1/2] xfstests: make the mode consistent for all the
	test scripts
Message-ID: <20090401143522.GO19690@josefsipek.net>
References: <1238536234-26969-1-git-send-email-jsipek@eecs.umich.edu>
	<1238536234-26969-2-git-send-email-jsipek@eecs.umich.edu>
	<20090401070823.GA3044@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090401070823.GA3044@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Josef 'Jeff' Sipek <jsipek@eecs.umich.edu>, xfs@oss.sgi.com

On Wed, Apr 01, 2009 at 03:08:23AM -0400, Christoph Hellwig wrote:
> A consistant mode sounds fine to me, but we'd have to pull this in as
> git-pull not as patch, right?

Depends on how you manage xfs-dev.git.  patch(1) won't work, but git-apply
will. Personally, I use guilt [1], which let's me push/pop patches much
like quilt, but since it uses git-apply, it works with all the fancy things
git diffs offer.

> Also for some reason some modes seem to change when actually running
> xfstests which makes git barf when pulling into such a tree again, not
> sure where that comes from.

Hrm, I haven't seen this yet.

Josef 'Jeff' Sipek.

[1] http://git.kernel.org/?p=linux/kernel/git/jsipek/guilt.git;a=summary

-- 
The obvious mathematical breakthrough would be development of an easy way to
factor large prime numbers.
		- Bill Gates, The Road Ahead, pg. 265

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
