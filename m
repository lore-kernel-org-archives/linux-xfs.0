Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 02:44:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T9iI4K030051
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:44:18 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2B4C10F2EAC
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:44:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id ZVxLW0LGGzz2f5Ji for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:44:18 -0700 (PDT)
Date: Wed, 29 Oct 2008 05:44:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029094417.GA21824@infradead.org>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029091203.GA32545@infradead.org> <20081029092143.GA5953@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029092143.GA5953@wotan.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 10:21:43AM +0100, Nick Piggin wrote:
> Please do.

Well, there's one stumling block I haven't made progress on yet:

I've changed the prototype of ->fsync to lose the dentry as we should
always have a valid file struct.  Except that nfsd doesn't on
directories.  So I either need to fake up a file there, or bail out
and add a ->dir_sync export operation that needs just a dentry.
