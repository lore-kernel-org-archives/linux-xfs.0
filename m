Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3MJCT9M219461 for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 14:12:30 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4FAA1CDD35A
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 12:12:26 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id 7gUpCHKxm4EbYmZY for
	<xfs@oss.sgi.com>; Wed, 22 Apr 2009 12:12:26 -0700 (PDT)
Date: Wed, 22 Apr 2009 15:12:26 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] xfstests: enforce lazy-count=0 in log tests 018, 081, 082
Message-ID: <20090422191226.GB3709@josefsipek.net>
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
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Hrm...are there any tests that explicitly check lazy-count=1?

Josef 'Jeff' Sipek.

-- 
Mankind invented the atomic bomb, but no mouse would ever construct a
mousetrap.
		- Albert Einstein

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
