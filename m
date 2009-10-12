Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9CK5DV9052881 for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 15:05:13 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26C1F176D5E7
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 13:06:42 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id qHJyevJytjtCV4mG for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2009 13:06:42 -0700 (PDT)
Message-ID: <4AD38C50.2060403@sandeen.net>
Date: Mon, 12 Oct 2009 15:06:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 04/14] repair: split up scanfunc_ino
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090902175840.403232401@bombadil.infradead.org>
In-Reply-To: <20090902175840.403232401@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:


> Split out a helper to scan a single inode chunk for suspect inodes from
> scanfunc_ino to make it more readable.
>
>
> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: xfsprogs-dev/repair/scan.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/scan.c	2009-08-21 19:00:15.000000000 +0000
> +++ xfsprogs-dev/repair/scan.c	2009-08-21 19:03:26.000000000 +0000
>
...

> +
> +	/*
> +	 * set state of each block containing inodes
> +	 */
> +	if (off == 0 && !suspect)  {
> +		for (j = 0;
> +		     j < XFS_INODES_PER_CHUNK;
> +		     j += mp->m_sb.sb_inopblock)  {
> +			agbno = XFS_AGINO_TO_AGBNO(mp, ino + j);
> +			state = get_agbno_state(mp, agno, agbno);
> +			if (state == XR_E_UNKNOWN)  {
> +				set_agbno_state(mp, agno, agbno, XR_E_INO);
> +			} else if (state == XR_E_INUSE_FS && agno == 0 &&
> +				   ino + j >= first_prealloc_ino &&
> +				   ino + j < last_prealloc_ino)  {
> +				set_agbno_state(mp, agno, agbno, XR_E_INO);
> +			} else  {
> +				do_warn(
> +_("inode chunk claims used block, inobt block - agno %d, bno %d, inopb %d\n"),
> +					agno, agbno,
> +				mp->m_sb.sb_inopblock);

pretty weird indentation here can't you just merge w/ previous line?


Also is the change from bno to agbno intentional in the message?
I guess it's fine.

...


> +		for (i = 0; i < numrecs; i++)
> +			suspect = scan_single_ino_chunk(agno, &rp[i], suspect);
>  
>  		if (suspect)
>  			bad_ino_btree = 1;
It seems like it might be nicer to just do:


+		for (i = 0; i < numrecs; i++)
+			suspect += scan_single_ino_chunk(agno, &rp[i]);

and let scan_single_ino_chunk return 0/1 instead of passing suspect in
and returning an incremented value?

Hm but I guess the sub-function tests it doesn't it:

+       /*
+        * set state of each block containing inodes
+        */
+       if (off == 0 && !suspect)  {

so, seems fine as-is, though I'd just fix that indentation.

Thanks,
-Eric


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
