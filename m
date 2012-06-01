Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q51KJg23175569 for <xfs@oss.sgi.com>; Fri, 1 Jun 2012 15:19:42 -0500
Date: Fri, 1 Jun 2012 15:25:42 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/3] xfs_repair: handle fragmented multiblock dir2 in
	process_leaf_node_dir2()
Message-ID: <20120601202542.GL4721@sgi.com>
References: <4FBABCAB.20300@redhat.com>
 <4FBABDA1.1030205@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FBABDA1.1030205@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, May 21, 2012 at 05:11:45PM -0500, Eric Sandeen wrote:
> process_leaf_node_dir2() had the following loop:
> 
> 	while ((dbno = blkmap_next_off(blkmap, ndbno, &t)) < mp->m_dirleafblk) {
> 		...
> 		ndbno = dbno + mp->m_dirblkfsbs - 1;
> 		...
> 	}
> 
> which does not account for fragmented multiblock dir2.
> 
> ndbno was blindly being advanced by m_dirblkfsbs, but then
> blkmap_next_off() would return the logical block of the next
> mapped extent in blkmap, which may be within the current
> (fragmented) dir2 multi-block, not the next multi-block,
> because the extent index t hadn't been advanced.
> 
> Fix this by calling blkmap_next_off() until ndbno has advanced
> into the next multiblock dir2 block, thereby keeping
> the extent index t straight while properly advancing
> ndbno.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index f9562d7..7a614a8 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -2003,7 +2003,11 @@ process_leaf_node_dir2(
>  	ndbno = NULLDFILOFF;
>  	while ((dbno = blkmap_next_off(blkmap, ndbno, &t)) < mp->m_dirleafblk) {
>  		nex = blkmap_getn(blkmap, dbno, mp->m_dirblkfsbs, &bmp, &lbmp);
> -		ndbno = dbno + mp->m_dirblkfsbs - 1;
> +		/* Advance through map to last dfs block in this dir block */
> +		ndbno = dbno;
> +		while (ndbno < dbno + mp->m_dirblkfsbs - 1) {
> +			ndbno = blkmap_next_off(blkmap, ndbno, &t);
> +		}

Yep, looks good to me.  An important thing to notice is that blkmap_getn
handles all extents in a dir2 multiblock... 

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
