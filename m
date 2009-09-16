Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8GCtoZ3054391 for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 07:56:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44BF1B63307
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 05:57:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QAgqVF3YqkNW2ihD for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2009 05:57:04 -0700 (PDT)
Date: Wed, 16 Sep 2009 08:57:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] _check_generic_filesistem support for fsck parameters
Message-ID: <20090916125703.GA12782@infradead.org>
References: <20090915124908.GA4070@infradead.org>
	<1253082245-5333-1-git-send-email-jbarton@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1253082245-5333-1-git-send-email-jbarton@redhat.com>
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
To: Jaroslav Barton <jbarton@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 16, 2009 at 08:24:05AM +0200, Jaroslav Barton wrote:
> _check_generic_filesystem now support fsck parameters. Fsck parameters
> can be passed by FSCK_OPTIONS environmental variable. Default values
> will be used if FSCK_OPTIONS is missing or empty (same mechanism as
> MOUNT_OPTIONS and MKFS_OPTIONS).
> 
> _check_extN_filesystem function is no longer needed, extN filesystem are
> properly handled by default values in _check_generic_filesystem.

Thanks, I've put this in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
