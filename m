Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 May 2008 22:58:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m455vlZx021187
	for <xfs@oss.sgi.com>; Sun, 4 May 2008 22:57:50 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7BB6163450A
	for <xfs@oss.sgi.com>; Sun,  4 May 2008 22:58:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id cqPxF49C5b44FYgd for <xfs@oss.sgi.com>; Sun, 04 May 2008 22:58:29 -0700 (PDT)
Date: Mon, 5 May 2008 01:58:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Replace down_trylock() with down_try(), reverse
	return values.
Message-ID: <20080505055823.GA20970@infradead.org>
References: <200805051156.36437.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805051156.36437.rusty@rustcorp.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, kaos@sgi.com, Stephen Rothwell <sfr@au1.ibm.com>, rolandd@cisco.com, "Brian S. Julin" <bri@calyx.com>, Martin Diehl <info@mdiehl.de>, mokuno@sm.sony.co.jp, aacraid@adaptec.com, mfasheh@suse.com, wim@iguana.be, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Mon, May 05, 2008 at 01:56:35AM +0000, Rusty Russell wrote:
> 
> down_trylock() returns 1 on failure, 0 on success.  This differs from
> spin_trylock(), mutex_trylock() and common sense.  Or as ocfs2 put it
> "kernel 1, world 0".
> 
> Rename it to down_try() (which makes more sense anyway), and reverse
> it.  Fortunately there aren't a huge number of callers left.
> 
> I took the liberty of reversing the sense of usb_trylock_device()
> without renaming it: it's only used in one place anyway.

Given that people are actively trying to kill struct semaphore I don't
think doing a big search and rename is a good idea right now.

(And I also really hate the name down_try, but when it goes away that's
 rather void and we can spare the discussion)
