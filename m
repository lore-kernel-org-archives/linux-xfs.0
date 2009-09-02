Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82BUERg260070 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 06:30:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 653801B8760F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 04:31:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oCrFkYvcgjDSTIfI for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 04:31:11 -0700 (PDT)
Date: Wed, 2 Sep 2009 07:31:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: minor bug in xfsprogs-3.0.3
Message-ID: <20090902113107.GA6908@infradead.org>
References: <200909011044.44938@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200909011044.44938@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, Sep 01, 2009 at 10:44:44AM +0200, Michael Monnerie wrote:
> # xfs_info -V
> Usage: xfs_info [-V] [-t mtab] mountpoint
> 
> It should print the version, right?

Yes, it should.  But from looking at git history it looks like it never
did.  Same for various other shell scripts (xfs_check/xfs_ncheck/xfs_admin).
I'll fix it up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
