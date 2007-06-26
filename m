Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 05:16:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5QCGTtL007849
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 05:16:31 -0700
Message-ID: <46810398.7040004@sgi.com>
Date: Tue, 26 Jun 2007 22:16:24 +1000
From: Tim Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: Multi-File Data Streams V2
References: <20070613041629.GI86004887@sgi.com> <467B8BFA.2050107@sgi.com> <20070625035315.GL86004887@sgi.com>
In-Reply-To: <20070625035315.GL86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
 > On Fri, Jun 22, 2007 at 06:44:42PM +1000, Timothy Shimmin wrote:

 >> *
 >> As we talked about before, this code seems to come up in a few places:
 >>
 >> 	need = XFS_MIN_FREELIST_PAG(pag, mp);
 >> 	delta = need > pag->pagf_flcount ?
 >> 		need - pag->pagf_flcount : 0;
 >> 	longest = (pag->pagf_longest > delta) ?
 >> 		(pag->pagf_longest - delta) :
 >> 		(pag->pagf_flcount > 0 ||
 >> 		pag->pagf_longest > 0);
 >>
 >> Perhaps we could macroize/inline-function it?
 >
 > Sure. I'll do that as a separate patch, though.

Cool.

 >
 >> It confused me in _xfs_filestream_pick_ag() when I was trying
 >> to understand it and so could do with a comment for it too.
 >> As I said then, I don't like the way it uses a boolean as
 >> the number of blocks, in the case when the longest extent is
 >> is smaller than the excess over the freelist which
 >> the fresspace-btree-splits-overhead needs.
 >
 > Actually, the logic statement is correct. If we have a delta greater
 > than the longest extent, we cannot find out what the next longest
 > extent is without searching the btree.  Hence we assume that the
 > longest extent is a single block, which means if the have free
 > extents in the tree (pag->pagf_longest > 0) or we have blocks in the
 > freelist (pag->pagf_flcount > 0) we are guaranteed to be able to
 > alocate a single block if there is space available. So the logic is:
 >
 > 	longest = 0;
 > 	if pag->pagf_longest > delta
 > 		longest = pag->pagf_longest - delta;
 > 	else if pag->pagf_flcount > 0
 > 		longest = 1;
 > 	else if pag->pagf_longest > 0
 > 		longest = 1;
 >
 > And the above is simply more compact.
 >
I didn't say it didn't give a reasonable answer - it's just
I don't like it using a boolean result for the number of blocks
being 1. It's a style thing. I think it is hacky.
i.e. prefer (pagf->pagf_flcount > 0 || pag->pagf_longest > 0) ? 1 : 0
but then that gets too long winded with the existing ternary,
and your above code is clearer
or grouping the last 2 conditions into one "or".
The existing code "hides" how we want 1 block in that case IMHO.

Hmmm....
though if all we have is freelist (pagf_flcount) space, then
I didn't know we could dip into it here. And I'm not really sure on
what happens if delta is too big for our longest and it actually needs
this space for splits - what happens then - we die further on?

--Tim
