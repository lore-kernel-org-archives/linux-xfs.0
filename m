Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53JZa6q191503 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 14:35:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D47452CCF99
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 12:35:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id OKg4N2vj6ueqZBEx for
	<xfs@oss.sgi.com>; Wed, 03 Jun 2009 12:35:54 -0700 (PDT)
Date: Wed, 3 Jun 2009 15:35:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: don't run 122 if required headers aren't found
Message-ID: <20090603193554.GA4516@infradead.org>
References: <4A26B016.2080108@redhat.com> <20090603175103.GA4538@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090603175103.GA4538@infradead.org>
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

On Wed, Jun 03, 2009 at 01:51:03PM -0400, Christoph Hellwig wrote:
> On Wed, Jun 03, 2009 at 12:17:10PM -0500, Eric Sandeen wrote:
> > Now that libxfs etc is optional, 122 (which compiles on the fly)
> > is failing if those extra headers are missing.
> 
> Oh, the great 122 tests.  Indeed without all the headers defining
> the structures we can't actually check their size.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Umm, should be:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
