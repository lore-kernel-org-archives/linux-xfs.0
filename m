Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 12:55:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3OJtHE9023974
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 12:55:23 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C496F15D364A
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 12:55:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id v8CjjBDAlZeNeQBZ for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 12:55:59 -0700 (PDT)
Date: Thu, 24 Apr 2008 15:55:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix non-smp xfs build
Message-ID: <20080424195559.GA28280@infradead.org>
References: <480EB291.5030205@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480EB291.5030205@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 22, 2008 at 10:52:49PM -0500, Eric Sandeen wrote:
> xfs_reserve_blocks() calls xfs_icsb_sync_counters_locked(),
> which is not defined if !CONFIG_SMP/!HAVE_PERCPU_SB

Looks good.  Thanks for fixing this up!
