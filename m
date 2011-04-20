Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3KFdY9v102036 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 10:39:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EF4F50FBE4
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 08:43:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ezM79Rf8k5n0BJGd for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2011 08:43:02 -0700 (PDT)
Date: Wed, 20 Apr 2011 11:43:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 252: add test for fallocate with hole punching
Message-ID: <20110420154301.GA15220@infradead.org>
References: <1302895199-24618-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302895199-24618-1-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 15, 2011 at 03:19:59PM -0400, Josef Bacik wrote:
> As Dave Chinner requested I moved the major test meat of 242 into common.punch
> and made it take all the arguments for alloc/punch/zero/map and such.  This way
> 242 and 252 can use the same base test and just pass in their specific commands
> they are testing.  I ran both 242 and 252 on XFS and the both pass.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Thanks, applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
