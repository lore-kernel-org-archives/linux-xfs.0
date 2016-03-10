Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 140867CA0
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 07:52:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8A8C304053
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 05:51:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id OKtJmt03uyxGPSyX for <xfs@oss.sgi.com>;
	Thu, 10 Mar 2016 05:51:54 -0800 (PST)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 661D83251
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 07:51:43 -0600 (CST)
Subject: Re: xfs: eliminate committed arg from xfs_bmap_finish
References: <20160310130349.GA15596@mwanda>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56E17BFA.7010000@sandeen.net>
Date: Thu, 10 Mar 2016 07:51:54 -0600
MIME-Version: 1.0
In-Reply-To: <20160310130349.GA15596@mwanda>
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
To: xfs@oss.sgi.com



On 3/10/16 7:03 AM, Dan Carpenter wrote:
> Hello Eric Sandeen,
> 
> The patch f6106efae5f4: "xfs: eliminate committed arg from
> xfs_bmap_finish" from Jan 11, 2016, leads to the following static
> checker warning:
> 
> 	fs/xfs/xfs_bmap_util.c:132 xfs_bmap_finish()
> 	error: XXX potentially using uninitialized 'committed'.

You're right; thankfully it's "only" on an error path, but I'll
get a patch sent out to fix this up.

-Eric

> fs/xfs/xfs_bmap_util.c
>     98  int                                             /* error */
>     99  xfs_bmap_finish(
>    100          struct xfs_trans                **tp,   /* transaction pointer addr */
>    101          struct xfs_bmap_free            *flist, /* i/o: list extents to free */
>    102          struct xfs_inode                *ip)
>    103  {
>    104          struct xfs_efd_log_item         *efd;   /* extent free data */
>    105          struct xfs_efi_log_item         *efi;   /* extent free intention */
>    106          int                             error;  /* error return value */
>    107          int                             committed;/* xact committed or not */
>    108          struct xfs_bmap_free_item       *free;  /* free extent item */
>    109          struct xfs_bmap_free_item       *next;  /* next item on free list */
>    110  
>    111          ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
>    112          if (flist->xbf_count == 0)
>    113                  return 0;
>    114  
>    115          efi = xfs_trans_get_efi(*tp, flist->xbf_count);
>    116          for (free = flist->xbf_first; free; free = free->xbfi_next)
>    117                  xfs_trans_log_efi_extent(*tp, efi, free->xbfi_startblock,
>    118                          free->xbfi_blockcount);
>    119  
>    120          error = __xfs_trans_roll(tp, ip, &committed);
>    121          if (error) {
>    122                  /*
>    123                   * If the transaction was committed, drop the EFD reference
>    124                   * since we're bailing out of here. The other reference is
>    125                   * dropped when the EFI hits the AIL.
>    126                   *
>    127                   * If the transaction was not committed, the EFI is freed by the
>    128                   * EFI item unlock handler on abort. Also, we have a new
>    129                   * transaction so we should return committed=1 even though we're
>    130                   * returning an error.
>    131                   */
>    132                  if (committed) {
> 
> "committed" is never initialized to zero.  It's either 1 or
> uninitialized.
> 
>    133                          xfs_efi_release(efi);
>    134                          xfs_force_shutdown((*tp)->t_mountp,
>    135                                  (error == -EFSCORRUPTED) ?
>    136                                          SHUTDOWN_CORRUPT_INCORE :
>    137                                          SHUTDOWN_META_IO_ERROR);
>    138                  }
> 
> regards,
> dan carpenter
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
