Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0OFCQS8018884 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 09:12:26 -0600
Received: from mail.qboosh.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 009141BA9A26
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 07:11:41 -0800 (PST)
Received: from mail.qboosh.pl (mail.qboosh.pl [217.73.31.61]) by cuda.sgi.com
	with ESMTP id uNktoUnI5lvFzOwj for <xfs@oss.sgi.com>;
	Sat, 24 Jan 2009 07:11:41 -0800 (PST)
Date: Sat, 24 Jan 2009 16:08:33 +0100
From: Jakub Bogusz <qboosh@pld-linux.org>
Subject: Re: [PATCH] xfsprogs: add xfs_fsr to the gettext machinery
Message-ID: <20090124150833.GA9158@stranger.qboosh.pl>
References: <20090124141902.GA32331@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090124141902.GA32331@infradead.org>
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
Cc: xfs@oss.sgi.com

On Sat, Jan 24, 2009 at 09:19:02AM -0500, Christoph Hellwig wrote:
> When removing fsr from xfsdump I noticed it was tied up to gettext,
> so we should make sure it still is in xfsprogs.
> 
> Jakub, any chance you could submit an update of the Polish translations
> that takes the move into account?

Yes.
Could I get latest .pot (after this change) from somewhere?


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/po/Makefile
> ===================================================================
> --- xfsprogs-dev.orig/po/Makefile	2009-01-24 15:17:00.847134077 +0100
> +++ xfsprogs-dev/po/Makefile	2009-01-24 15:17:14.246285604 +0100
> @@ -14,6 +14,7 @@ LDIRT = $(POTHEAD)
>  XGETTEXTFILES =	\
>  		$(TOPDIR)/copy/xfs_copy.c \
>  		$(TOPDIR)/estimate/xfs_estimate.c \
> +		$(TOPDIR)/fsr/xfs_fsr.c \
>  		$(TOPDIR)/growfs/xfs_growfs.c \
>  		$(TOPDIR)/io/attr.c \
>  		$(TOPDIR)/io/bmap.c \

-- 
Jakub Bogusz    http://qboosh.pl/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
