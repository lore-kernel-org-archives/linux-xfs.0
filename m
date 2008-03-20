Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 00:35:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K7Z0sR005563
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:35:03 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 319BC6C4E4F
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:35:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 3wFVzPcXGhERbIg7 for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:35:32 -0700 (PDT)
Date: Thu, 20 Mar 2008 03:35:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix xfsqa 049 when using whole scratch device
Message-ID: <20080320073501.GA19969@infradead.org>
References: <47E1CCF0.9070904@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E1CCF0.9070904@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 19, 2008 at 09:33:20PM -0500, Eric Sandeen wrote:
> if SCRATCH_DEV happens to be a whole device, mke2fs will wait
> for confirmation.
> 
> (mke2fs -F would work, too...)

Looks good.
