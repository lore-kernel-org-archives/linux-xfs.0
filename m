Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6UK0Kbw085859 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 15:00:20 -0500
Message-ID: <5016E7D0.8060903@sgi.com>
Date: Mon, 30 Jul 2012 15:00:16 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 2/4]xfs: Introduce a new function to find the desired
	type of offset from page cache
References: <50110629.4090304@oracle.com> <5011631F.40005@oracle.com>
In-Reply-To: <5011631F.40005@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com

On 07/26/12 10:32, Jeff Liu wrote:
> This function is called by xfs_seek_data() and xfs_seek_hole() to find
> the desired offset from page cache.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>


Hopefully, I am not being a pain....

I just noticed that if trylock() failed you return found==0.
Wouldn't it be safer/more correct to assume a page that failed a 
try_lock to be data?


> +		if (nr_pages == 0) {
> +			if (type == HOLE_OFF) {
> +				if (coff == *offset)
> +					found = true;

is this necessary? wouldn't the next test also cover the above condition?

> +				if (coff<  endoff) {
> +					found = true;
> +					*offset = coff;
> +				}
> +			}


I like informative comments, but some are bit verbose. I will pick on 
this one:


+			/*
+			 * Page index is out of range, we need to deal with
+			 * hole search condition in paticular if that is the
+			 * desired type for the lookup.
+			 * stepping into the block buffer checkup, it probably
+			 * means that there is no page mapped at all in the
+			 * specified range to search, so we found a hole.
+			 * If we have already done some block buffer checking
+			 * and found one or more data buffers before, in this
+			 * case, the coff is already updated and it point to
+			 * the end of the last data buffer, so the left range
+			 * behind it might be a hole.  In either case, we will
+			 * return the coff to indicate a hole's location because
+			 * it must be greater than or equal to the search start.
+			 */

just a crude simplification - maybe it is too terse:
			/*
			 * coff is the current offset of the page being tested.
			 * If the next page index is beyond the extent of interest,
			 * then we are done searching with the data search is
			 * false and hole search is true at the last coff.
			 */

For holes you are looking for (page->index != coff) for every page, but 
in a indirect way. It had me a little confused, but eventually I figured 
it out. I am not sure if a doing that comparison directly would overly 
complicate the data search path.

Good work.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
