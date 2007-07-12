Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 19:31:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6C2V7bm020708
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 19:31:09 -0700
Date: Thu, 12 Jul 2007 12:31:00 +1000
From: David Chinner <dgc@sgi.com>
Subject: block_page_mkwrite? (Re: fault vs invalidate race (Re: -mm merge plans for 2.6.23))
Message-ID: <20070712023100.GX12413810@sgi.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <46957BE1.1010104@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46957BE1.1010104@yahoo.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Linux Memory Management <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 12, 2007 at 10:54:57AM +1000, Nick Piggin wrote:
> Andrew Morton wrote:
> > The fault-vs-invalidate race fix.  I have belatedly learned that these 
> > need
> > more work, so their state is uncertain.
> 
> The more work may turn out being too much for you (although it is nothing
> exactly tricky that would introduce subtle bugs, it is a fair amont of 
> churn).

OK, so does that mean we can finally get the block_page_mkwrite
patches merged?

i.e.:

http://marc.info/?l=linux-kernel&m=117426058311032&w=2
http://marc.info/?l=linux-kernel&m=117426070111136&w=2

I've got up-to-date versions of them ready to go and they've been
consistently tested thanks to the XFSQA test I wrote for the bug
that it fixes. I've been holding them out-of-tree for months now
because ->fault was supposed to supercede this interface.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
