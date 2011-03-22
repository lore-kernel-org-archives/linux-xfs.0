Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2M9w3vo011517 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 04:58:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48E7313F678A
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 03:01:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id obik49uVo4smuBSK for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2011 03:01:03 -0700 (PDT)
Date: Tue, 22 Mar 2011 06:01:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: ensure selinux xattrs don't interfere with
	quota tests
Message-ID: <20110322100102.GB3532@infradead.org>
References: <4D83B2D0.1030607@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D83B2D0.1030607@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Mar 18, 2011 at 02:30:24PM -0500, Eric Sandeen wrote:
> 219 and 235 were failing on ext3 with selinux, because the extra
> xattrs upped the quota usage.
> 
> Do the same trick we've used in the past to mount with an selinux
> global context when doing quota tests.
> 
> Note the gross hack for remount,ro, though.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
