Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q227lji1010155 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 01:47:45 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wEsAvX496DHf9XhO (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 23:47:44 -0800 (PST)
Date: Fri, 2 Mar 2012 02:47:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] xfs: Fix open flag handling in open_by_handle code
Message-ID: <20120302074744.GD4117@infradead.org>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
	<1330661507-1121-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330661507-1121-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  	/* Put open permission in namei format. */

this coment is obsolete now.

>  	permflag = hreq->oflags;
> -	if ((permflag+1) & O_ACCMODE)
> -		permflag++;
> -	if (permflag & O_TRUNC)
> -		permflag |= 2;
> -
>  	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
> -	    (permflag & FMODE_WRITE) && IS_APPEND(inode)) {
> +	    (OPEN_FMODE(permflag) & FMODE_WRITE) && IS_APPEND(inode)) {

It would seem cleaner to still keep a loca fmode_t fmode variable
instead of using OPEN_FMODE multiple times.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
