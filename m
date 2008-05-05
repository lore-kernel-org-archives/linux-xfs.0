Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 May 2008 23:09:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4568aml022817
	for <xfs@oss.sgi.com>; Sun, 4 May 2008 23:08:37 -0700
Received: from ozlabs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2618125080
	for <xfs@oss.sgi.com>; Sun,  4 May 2008 23:09:18 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [203.10.76.45]) by cuda.sgi.com with ESMTP id 0HupDjmTcz5h9U3D for <xfs@oss.sgi.com>; Sun, 04 May 2008 23:09:18 -0700 (PDT)
From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] Replace down_trylock() with down_try(), reverse return values.
Date: Mon, 5 May 2008 16:09:12 +1000
References: <200805051156.36437.rusty@rustcorp.com.au> <20080505055823.GA20970@infradead.org>
In-Reply-To: <20080505055823.GA20970@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051609.13731.rusty@rustcorp.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, kaos@sgi.com, Stephen Rothwell <sfr@au1.ibm.com>, rolandd@cisco.com, "Brian S. Julin" <bri@calyx.com>, Martin Diehl <info@mdiehl.de>, mokuno@sm.sony.co.jp, aacraid@adaptec.com, mfasheh@suse.com, wim@iguana.be, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Monday 05 May 2008 15:58:23 Christoph Hellwig wrote:
> On Mon, May 05, 2008 at 01:56:35AM +0000, Rusty Russell wrote:
> > down_trylock() returns 1 on failure, 0 on success.  This differs from
> > spin_trylock(), mutex_trylock() and common sense.  Or as ocfs2 put it
> > "kernel 1, world 0".
> >
> > Rename it to down_try() (which makes more sense anyway), and reverse
> > it.  Fortunately there aren't a huge number of callers left.
>
> Given that people are actively trying to kill struct semaphore I don't
> think doing a big search and rename is a good idea right now.

If it goes away before the 2.6.27 merge window, great.  But I don't see that 
happening, so let's clean up this horror.  I cc'd all the people effected in 
the hope that it will prod some of them towards mutexes anyway.

> (And I also really hate the name down_try, but when it goes away that's
>  rather void and we can spare the discussion)

Ideas?  down() is pretty bad, down_try() matches it.

Thanks,
Rusty.
