Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 20:22:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F3MnTg022190
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 20:22:51 -0700
Date: Tue, 14 Oct 2008 23:24:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: crash with latest code drop.
Message-ID: <20081015032431.GA7426@infradead.org>
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed> <20081015022948.GA20966@infradead.org> <20081015031645.GA25906@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015031645.GA25906@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com

On Wed, Oct 15, 2008 at 02:16:46PM +1100, Dave Chinner wrote:
> +		xfs_iunlock(ip, lock_flags);
> +		IRELE(ip);

Aka xfs_iput(ip, lock_flags);
