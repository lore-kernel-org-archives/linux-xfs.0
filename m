Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Nov 2008 07:39:59 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA6FdkXI018597
	for <xfs@oss.sgi.com>; Thu, 6 Nov 2008 07:39:47 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83EA21506B42
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2008 07:39:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id OL9nA0MjAr8QJg3I for <xfs@oss.sgi.com>; Thu, 06 Nov 2008 07:39:49 -0800 (PST)
Date: Thu, 6 Nov 2008 10:39:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] XFS: fix error inversion problems with data
	flushing
Message-ID: <20081106153949.GA1726@infradead.org>
References: <1225415729-26514-1-git-send-email-david@fromorbit.com> <1225415729-26514-2-git-send-email-david@fromorbit.com> <20081031201830.GA20309@infradead.org> <20081102225133.GI19509@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081102225133.GI19509@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 03, 2008 at 09:51:33AM +1100, Dave Chinner wrote:
> Yes, that's the point of the patch - we get it wrong in many
> places and this fixes them so that correctly signed error values
> are returned to the higher layers....

Well, you also introduce xfs_wait_on_pages, which should at least be
documented.  And I'd have to say I don't really like adding more of
these wrappers just for the sake of it.
