Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Apr 2008 01:58:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3P8wNkx019766
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 01:58:29 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C772C15D73B3
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 01:59:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id EeuPTuwCK5ZaeCOc for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 01:59:04 -0700 (PDT)
Date: Fri, 25 Apr 2008 04:59:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] convert xfs to use ERR_CAST
Message-ID: <20080425085904.GB6395@infradead.org>
References: <480FA737.5030001@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480FA737.5030001@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>, David Howells <dhowells@redhat.com>

On Wed, Apr 23, 2008 at 04:16:39PM -0500, Eric Sandeen wrote:
> Looks like somehow xfs got missed in the conversion that
> took place in e231c2ee64eb1c5cd3c63c31da9dac7d888dcf7f,
> "Convert ERR_PTR(PTR_ERR(p)) instances to ERR_CAST(p) <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e231c2ee64eb1c5cd3c63c31da9dac7d888dcf7f>"

Looks good.
