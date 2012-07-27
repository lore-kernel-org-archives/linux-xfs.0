Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6RLWPuS257088 for <xfs@oss.sgi.com>; Fri, 27 Jul 2012 16:32:26 -0500
Message-ID: <501308E6.3030207@sgi.com>
Date: Fri, 27 Jul 2012 16:32:22 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 3/4]xfs: xfs_seek_data() refinements with lookup data
	buffer offset from page cache.
References: <50110630.7020902@oracle.com> <50116322.2020005@oracle.com>
In-Reply-To: <50116322.2020005@oracle.com>
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
> Search data buffer offset for given range from page cache.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>


...

This is the same as version 4.

It looks good.

There are a couple places the comment precedes the test and is not yet 
valid:


>   		offset = max_t(loff_t, start,
> -			       XFS_FSB_TO_B(mp, map[1].br_startoff));
> +			       XFS_FSB_TO_B(mp, map[0].br_startoff));
> +		if (map[0].br_state == XFS_EXT_NORM&&
> +		    !isnullstartblock(map[0].br_startblock))
> +			break;
> +		else {
> +			/*
> +			 * Landed in an unwritten extent, try to lookup data
> +			 * buffer from the page cache before proceeding to
> +			 * check the next extent map.  It's a hole if nothing
> +			 * was found.
> +			 */

or it could be a hole
> +			if (map[0].br_startblock == DELAYSTARTBLOCK ||
> +			    map[0].br_state == XFS_EXT_UNWRITTEN) {

here is where it is unwritten extent
> +				/* Probing page cache start from offset */
> +				if (xfs_find_get_desired_pgoff(inode,&map[0],
> +							DATA_OFF,&offset))
> +					break;
> +			}
> +
> +			/*
> +			 * Found a hole in map[0] and nothing in map[1].
> +			 * Probably means that we are reading after EOF.
> +			 */

here we did find a hole
> +			if (nmap == 1) {
here is where there is nothing in map[1] and ...
> +				error = ENXIO;
> +				goto out_unlock;
> +			}
> +
> +			/*
> +			 * We have two mappings, proceed to check map[1].
> +			 */
> +			offset = max_t(loff_t, start,
> +				       XFS_FSB_TO_B(mp, map[1].br_startoff));
> +			if (map[1].br_state == XFS_EXT_NORM&&
> +			    !isnullstartblock(map[1].br_startblock))
> +				break;
> +			else {
> +				/*
> +				 * map[1] is also an unwritten extent, lookup
> +				 * data buffer from page cache now.
> +				 */

it could be unwritten or a hole
> +				if (map[1].br_startblock == DELAYSTARTBLOCK ||
> +				    map[1].br_state == XFS_EXT_UNWRITTEN) {

here is where we know it is unwritten.
> +					if (xfs_find_get_desired_pgoff(inode,
> +						&map[1], DATA_OFF,&offset))
> +						break;
> +				}
> +			}
> +		}

I am being really picky, but comments really help a quick read of the code.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
