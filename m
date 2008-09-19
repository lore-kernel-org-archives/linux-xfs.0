Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 02:26:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J9QlHg010673
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:26:47 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C13EB91E03A
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:28:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id wao3BbTWVtQG43FF for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:28:20 -0700 (PDT)
Date: Fri, 19 Sep 2008 05:28:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] XFS: Add ail pointer into log items
Message-ID: <20080919092820.GG11443@infradead.org>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221317877-8333-8-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:57:56AM +1000, Dave Chinner wrote:
> Add an xfs_ail pointer to log items so that the log items can
> reference the AIL directly during callbacks without needed a
> struct xfs_mount.

Does it matter? I'd be a nice cleanup if you managed to get rid of
li_mountp, but without that I don't quite see the point.
