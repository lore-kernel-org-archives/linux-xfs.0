Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6277J88231873 for <xfs@oss.sgi.com>; Fri, 2 Jul 2010 02:07:19 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BAE74230E2
	for <xfs@oss.sgi.com>; Fri,  2 Jul 2010 00:10:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dzo6Xwcd3KMc5zN1 for
	<xfs@oss.sgi.com>; Fri, 02 Jul 2010 00:10:06 -0700 (PDT)
Date: Fri, 2 Jul 2010 03:10:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfstests] _qmount: mount w/o selinux xattrs
Message-ID: <20100702071006.GB30776@infradead.org>
References: <4C2CF34F.7070008@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C2CF34F.7070008@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Thu, Jul 01, 2010 at 02:58:07PM -0500, Eric Sandeen wrote:
> when selinux is on it can change quota usage due to extra
> xattr blocks.
> 
> Mounting with a context prevents this.  We already do so
> for xfs in general because so many things look at detailed
> on-disk format, and extra xattrs confuses those tests.
> 
> For other filesystems, we've left selinux alone so far, 
> as that seemed the best way to test.
> 
> However, it throws quota accounting off, so add a fixup
> in _qmount()

What about just disabling selinux for all filesystems instead of just
XFS for the general case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
