Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08IF4CF017148 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 12:15:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A76C17BFB50
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 10:15:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id k7vvDJttOt0zTP4X for
	<xfs@oss.sgi.com>; Thu, 08 Jan 2009 10:15:04 -0800 (PST)
Date: Thu, 8 Jan 2009 13:15:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: fix include/ symlink creation (again)
Message-ID: <20090108181502.GA8102@infradead.org>
References: <49664144.3@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49664144.3@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Thu, Jan 08, 2009 at 12:09:08PM -0600, Eric Sandeen wrote:
> We need the "default" target first, otherwise a simple "make -C include"
> only ran the xfs target, missing disk, and failures ensued.

Yeah, looks good to me.  Having a target called "default" make is
confusing as the default target is implicit..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
