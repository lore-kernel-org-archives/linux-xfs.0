Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753827AbeBVPJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 10:09:24 -0500
Date: Thu, 22 Feb 2018 07:09:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] misc: enable retpolines across all xfsprogs utilities
Message-ID: <20180222150922.GA26282@infradead.org>
References: <20180222021625.GA9827@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180222021625.GA9827@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Wed, Feb 21, 2018 at 06:16:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Detect and enable retpolines for all code, to mitigate Spectre v2
> (branch target injection) on x86.

The mechanics look ok, but why do we really care for xfsprogs?
fs utilities seem like a lesser target and should just be covered
by hopefully sane compiler defaults, shouldn't they?
