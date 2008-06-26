Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 06:06:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QD5xpD023893
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 06:06:00 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC2FF182C03B
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 06:07:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id bXuo455AIIrDlTBA for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 06:07:00 -0700 (PDT)
Date: Thu, 26 Jun 2008 09:07:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626130700.GA24325@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626074636.GB7064@infradead.org> <20080626112133.GJ11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626112133.GJ11558@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 09:21:33PM +1000, Dave Chinner wrote:
> Ok, so that involves exactly what? A new header file, a new API name
> (ideas anyone?) and kerneldoc comments?

Yes, probably just a new header with properly documented functions.
Thew two non-trivial ones you added should probably not be inlines,
btw.

flush_lock_init/flush_lock/flush_trylock/flush_done/flush_is_locked?
