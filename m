Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E60DF7F52
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 07:51:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA8FD30406B
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 05:51:50 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id MFMok4DBEoAS2OB0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 05:51:50 -0800 (PST)
Date: Mon, 25 Nov 2013 05:51:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/4] xfs: allow linkat() on O_TMPFILE files
Message-ID: <20131125135149.GD30189@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-5-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385379154-3802-5-git-send-email-zwu.kernel@gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

> -	ASSERT(ip->i_d.di_nlink > 0);
> +	if ((VFS_I(ip)->i_nlink == 0) &&
> +	    !(VFS_I(ip)->i_state & I_LINKABLE))
> +		ASSERT(ip->i_d.di_nlink > 0);

	ASSERT(ip->i_d.di_nlink > 0 || (VFS_I(ip)->i_state & I_LINKABLE));

> @@ -1498,7 +1503,14 @@ xfs_link(
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_LINK);
>  	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
>  	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, resblks, 0);
> +
> +	if ((VFS_I(sip)->i_nlink == 0) &&
> +	    (VFS_I(sip)->i_state & I_LINKABLE))
> +		tres = &M_RES(mp)->tr_link_tmpfile;
> +	else
> +		tres = &M_RES(mp)->tr_link;

Just check i_nlink, and for consistency it might make sense to just use
the xfs_inode one.  The VFS already made sure we don't inodes with
I_LINKABLE and a zero link count.

> +	if ((VFS_I(sip)->i_nlink == 0) &&
> +	    (VFS_I(sip)->i_state & I_LINKABLE)) {

Same here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
