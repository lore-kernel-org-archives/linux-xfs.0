Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S7ffPL195460 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 02:41:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E2FC34979
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:41:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zbjdMmlXaBwtMJgw for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2011 00:41:39 -0700 (PDT)
Date: Tue, 28 Jun 2011 03:41:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: don't hard code the shell binary
Message-ID: <20110628074137.GA6123@infradead.org>
References: <1309245348-12638-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309245348-12638-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 28, 2011 at 05:15:48PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Recent changes to debian unstable user space have caused the
> xfsprogs build to break as certain shell functionality is being
> assumed by libtool and friends.  The configure scripts test and
> select the correct shell, but the input files ignore this and hard
> code the shell to use and hence now break.
> 
> Fix this by using the shell that the configure scripts decide is the
> right one to use.

Looks good.  The same fix should also be applied to xfsdump, xfstests
and dmapi.

Signed-off-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
