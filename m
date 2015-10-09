Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C074A7F47
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 08:24:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 94CFE8F8035
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 06:24:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UUnvki9WdhOaJt6Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2015 06:24:36 -0700 (PDT)
Date: Fri, 9 Oct 2015 09:24:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs_repair: fix unaligned accesses
Message-ID: <20151009132433.GC27982@bfoster.bfoster>
References: <56170906.5090301@redhat.com>
 <56170974.5020604@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56170974.5020604@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Oct 08, 2015 at 07:25:24PM -0500, Eric Sandeen wrote:
> This fixes some unaligned accesses spotted by libubsan in repair.
> 

Could we add a couple sentences about why this is a problem? I take it
unaligned accesses are "bad" on certain arches..?

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  repair/dinode.c   |   19 +++++++++----------
>  repair/prefetch.c |    4 ++--
>  2 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index f78f907..44bbb8f 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -960,13 +960,13 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
>  		 * btree, we'd do it right here.  For now, if there's a
>  		 * problem, we'll bail out and presumably clear the inode.
>  		 */
> -		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
> +		if (!verify_dfsbno(mp, get_unaligned_be64(&pp[i])))  {
>  			do_warn(_("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
> -			       (unsigned long long) be64_to_cpu(pp[i]), lino);
> +			       get_unaligned_be64(&pp[i]), lino);
>  			return(1);
>  		}
>  
> -		if (scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt, type,
> +		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt, type,
>  				whichfork, lino, tot, nex, blkmapp, &cursor,
>  				1, check_dups, magic, &xfs_bmbt_buf_ops))
>  			return(1);
> @@ -977,25 +977,24 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
>  		 * blocks but the parent hasn't been updated
>  		 */
>  		if (!check_dups && cursor.level[level-1].first_key !=
> -					be64_to_cpu(pkey[i].br_startoff))  {
> +				   get_unaligned_be64(&pkey[i].br_startoff)) {
>  			if (!no_modify)  {
>  				do_warn(
>  	_("correcting key in bmbt root (was %llu, now %" PRIu64") in inode "
>  	  "%" PRIu64" %s fork\n"),
> -				       (unsigned long long)
> -					       be64_to_cpu(pkey[i].br_startoff),
> +					get_unaligned_be64(&pkey[i].br_startoff),
>  					cursor.level[level-1].first_key,
>  					XFS_AGINO_TO_INO(mp, agno, ino),
>  					forkname);
>  				*dirty = 1;
> -				pkey[i].br_startoff = cpu_to_be64(
> -					cursor.level[level-1].first_key);
> +				put_unaligned_be64(
> +					cpu_to_be64(cursor.level[level-1].first_key),
> +					&pkey[i].br_startoff);

I could be confused here... but if get_unaligned_be64() takes a be64 and
transforms to cpu order, shouldn't put_unaligned_be64() take a cpu order
parameter? Is this a double byte order swap?

Brian

>  			} else  {
>  				do_warn(
>  	_("bad key in bmbt root (is %llu, would reset to %" PRIu64 ") in inode "
>  	  "%" PRIu64 " %s fork\n"),
> -				       (unsigned long long)
> -					       be64_to_cpu(pkey[i].br_startoff),
> +					get_unaligned_be64(&pkey[i].br_startoff),
>  					cursor.level[level-1].first_key,
>  					XFS_AGINO_TO_INO(mp, agno, ino),
>  					forkname);
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 32ec55e..52238ca 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -330,7 +330,7 @@ pf_scanfunc_bmap(
>  	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
>  
>  	for (i = 0; i < numrecs; i++) {
> -		dbno = be64_to_cpu(pp[i]);
> +		dbno = get_unaligned_be64(&pp[i]);
>  		if (!verify_dfsbno(mp, dbno))
>  			return 0;
>  		if (!pf_scan_lbtree(dbno, level, isadir, args, pf_scanfunc_bmap))
> @@ -372,7 +372,7 @@ pf_read_btinode(
>  	pp = XFS_BMDR_PTR_ADDR(dib, 1, xfs_bmdr_maxrecs(dsize, 0));
>  
>  	for (i = 0; i < numrecs; i++) {
> -		dbno = be64_to_cpu(pp[i]);
> +		dbno = get_unaligned_be64(&pp[i]);
>  		if (!verify_dfsbno(mp, dbno))
>  			break;
>  		if (!pf_scan_lbtree(dbno, level, isadir, args, pf_scanfunc_bmap))
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
