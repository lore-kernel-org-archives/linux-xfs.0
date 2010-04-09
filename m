Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39I3EtM127038 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 13:03:15 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C11482B12C7
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 11:05:06 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id NdQOFEGaGQBuT2H4 for
	<xfs@oss.sgi.com>; Fri, 09 Apr 2010 11:05:06 -0700 (PDT)
Message-ID: <4BBF6C51.5030203@sandeen.net>
Date: Fri, 09 Apr 2010 13:05:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks, heavy
	write load, 8k stack, x86-64
References: <4BBC6719.7080304@humyo.com>
	<20100407140523.GJ11036@dastard>	<4BBCAB57.3000106@humyo.com>
	<20100407234341.GK11036@dastard>	<20100408030347.GM11036@dastard>
	<4BBDC92D.8060503@humyo.com>	<4BBDEC9A.9070903@humyo.com>
	<20100408233837.GP11036@dastard> <20100409113850.GE13327@think>
In-Reply-To: <20100409113850.GE13327@think>
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
To: Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, John Berthels <john@humyo.com>, linux-kernel@vger.kernel.org, Nick Gregory <nick@humyo.com>, Rob Sanderson <rob@humyo.com>, xfs@oss.sgi.com, linux-mm@kvack.org

Chris Mason wrote:

> shrink_zone on my box isn't 500 bytes, but lets try the easy stuff
> first.  This is against .34, if you have any trouble applying to .32,
> just add the word noinline after the word static on the function
> definitions.
> 
> This makes shrink_zone disappear from my check_stack.pl output.
> Basically I think the compiler is inlining the shrink_active_zone and
> shrink_inactive_zone code into shrink_zone.
> 
> -chris
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 79c8098..c70593e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -620,7 +620,7 @@ static enum page_references page_check_references(struct page *page,
>  /*
>   * shrink_page_list() returns the number of reclaimed pages
>   */
> -static unsigned long shrink_page_list(struct list_head *page_list,
> +static noinline unsigned long shrink_page_list(struct list_head *page_list,

FWIW akpm suggested that I add:

/*
 * Rather then using noinline to prevent stack consumption, use
 * noinline_for_stack instead.  For documentaiton reasons.
 */
#define noinline_for_stack noinline

so maybe for a formal submission that'd be good to use.


>  					struct scan_control *sc,
>  					enum pageout_io sync_writeback)
>  {
> @@ -1121,7 +1121,7 @@ static int too_many_isolated(struct zone *zone, int file,
>   * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
>   * of reclaimed pages
>   */
> -static unsigned long shrink_inactive_list(unsigned long max_scan,
> +static noinline unsigned long shrink_inactive_list(unsigned long max_scan,
>  			struct zone *zone, struct scan_control *sc,
>  			int priority, int file)
>  {
> @@ -1341,7 +1341,7 @@ static void move_active_pages_to_lru(struct zone *zone,
>  		__count_vm_events(PGDEACTIVATE, pgmoved);
>  }
>  
> -static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
> +static noinline void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>  			struct scan_control *sc, int priority, int file)
>  {
>  	unsigned long nr_taken;
> @@ -1504,7 +1504,7 @@ static int inactive_list_is_low(struct zone *zone, struct scan_control *sc,
>  		return inactive_anon_is_low(zone, sc);
>  }
>  
> -static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
> +static noinline unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
>  	struct zone *zone, struct scan_control *sc, int priority)
>  {
>  	int file = is_file_lru(lru);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
