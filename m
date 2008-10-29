Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 14:45:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9TLj5Qx025806
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 14:45:05 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C04E55B796
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 14:45:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id Ws7yB6UdabWHCZpN for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 14:45:05 -0700 (PDT)
Date: Wed, 29 Oct 2008 17:45:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029214503.GA8895@infradead.org>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029032601.GF4985@disturbed> <20081029091326.GB32545@infradead.org> <20081029214202.GH17077@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029214202.GH17077@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Thu, Oct 30, 2008 at 08:42:02AM +1100, Dave Chinner wrote:
> I'll do that as a separate patch - it's not really part of a "fix
> error value inversion" bug fix....

Well it is kindof.  Because we'd call Linux library functions directly
from the method we skip to places that need sign conversion and could
possibly go wrong.  But if you want a separate patch that's fine with
me too.
