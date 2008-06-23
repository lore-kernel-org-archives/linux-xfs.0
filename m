Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 00:21:38 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5N7LWtG016054
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 00:21:34 -0700
Date: Mon, 23 Jun 2008 03:22:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6.26-rc7] shrink_icache from pagefault locking (nee: nfsd
	hangs for a few sec)...
Message-ID: <20080623072227.GB11986@infradead.org>
References: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com> <6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com> <20080622221930.GA11558@disturbed> <20080623002415.GB21597@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623002415.GB21597@csn.ul.ie>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mel Gorman <mel@csn.ul.ie>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, Christoph Lameter <clameter@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Beregalov <a.beregalov@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Jun 23, 2008 at 01:24:15AM +0100, Mel Gorman wrote:
> In that case, have you any theory as to why this circular dependency is
> being reported now but wasn't before 2.6.26-rc1? I'm beginning to wonder
> if the bisecting fingering the zonelist modifiation is just a
> co-incidence.

I've seen this traces since lockdep was added when running xfsqa.
