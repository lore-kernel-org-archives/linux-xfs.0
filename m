Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39IAFMv127392 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 13:10:15 -0500
Received: from rcsinet12.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CB761D404EB
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 11:12:07 -0700 (PDT)
Received: from rcsinet12.oracle.com (rcsinet12.oracle.com [148.87.113.124]) by
	cuda.sgi.com with ESMTP id oeK5A9hs8ziW8oTd for
	<xfs@oss.sgi.com>; Fri, 09 Apr 2010 11:12:07 -0700 (PDT)
Date: Fri, 9 Apr 2010 14:11:08 -0400
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks,
	heavy write load, 8k stack, x86-64
Message-ID: <20100409181108.GG13327@think>
References: <4BBC6719.7080304@humyo.com> <20100407140523.GJ11036@dastard>
	<4BBCAB57.3000106@humyo.com> <20100407234341.GK11036@dastard>
	<20100408030347.GM11036@dastard> <4BBDC92D.8060503@humyo.com>
	<4BBDEC9A.9070903@humyo.com> <20100408233837.GP11036@dastard>
	<20100409113850.GE13327@think> <4BBF6C51.5030203@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BBF6C51.5030203@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: John Berthels <john@humyo.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Nick Gregory <nick@humyo.com>, linux-mm@kvack.org, Rob Sanderson <rob@humyo.com>

On Fri, Apr 09, 2010 at 01:05:05PM -0500, Eric Sandeen wrote:
> Chris Mason wrote:
> 
> > shrink_zone on my box isn't 500 bytes, but lets try the easy stuff
> > first.  This is against .34, if you have any trouble applying to .32,
> > just add the word noinline after the word static on the function
> > definitions.
> > 
> > This makes shrink_zone disappear from my check_stack.pl output.
> > Basically I think the compiler is inlining the shrink_active_zone and
> > shrink_inactive_zone code into shrink_zone.
> > 
> > -chris
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 79c8098..c70593e 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -620,7 +620,7 @@ static enum page_references page_check_references(struct page *page,
> >  /*
> >   * shrink_page_list() returns the number of reclaimed pages
> >   */
> > -static unsigned long shrink_page_list(struct list_head *page_list,
> > +static noinline unsigned long shrink_page_list(struct list_head *page_list,
> 
> FWIW akpm suggested that I add:
> 
> /*
>  * Rather then using noinline to prevent stack consumption, use
>  * noinline_for_stack instead.  For documentaiton reasons.
>  */
> #define noinline_for_stack noinline
> 
> so maybe for a formal submission that'd be good to use.

Oh yeah, I forgot about that one.  If the patch actually helps we can
switch it.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
