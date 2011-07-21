Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LMvk3Q048431 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:57:46 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55D5BEED6E7
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 15:57:44 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id g1OrIutiTglSJ8hy for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 15:57:44 -0700 (PDT)
Date: Thu, 21 Jul 2011 18:57:38 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Problems building xfsprogs
Message-ID: <20110721225738.GA25092@thunk.org>
References: <20110720175918.GB17971@thunk.org>
	<20110721090619.GA26263@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110721090619.GA26263@infradead.org>
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
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 21, 2011 at 05:06:19AM -0400, Christoph Hellwig wrote:
> 
> I works fine for me on various releases of Debian, Fedsora, RHEL and
> SLES.  But all he machines I've quickly checked seem to have an autoconf
> that can handle -I, so could you please send this pach with a proper
> signoff and description?

I figured what the core problem is.  There's a subtle and hidden
dependency in xfsprogs for an autoconf version which is 2.50 or above.
In Debian and Ubuntu, if autoconf 2.13 is installed, autoconf will try
to automatically figure out whether the configure.in requires 2.13 or
2.50 (since the autoconf maintainers didn't understand the concept of
"backwards compatibility").  Unfortunately, it got this wrong.

Using an explicit AC_PREREQ(2.50) fixes this.  I'll be sending patches
shortly....

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
