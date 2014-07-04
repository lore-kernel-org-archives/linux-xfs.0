Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E1B427F3F
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 09:24:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 70016AC005
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 07:24:24 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id cJhdASHPUWy9WG4g (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Jul 2014 07:24:22 -0700 (PDT)
Date: Fri, 4 Jul 2014 07:24:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] repair: handle directory block corruption in phase 6
Message-ID: <20140704142422.GB4687@infradead.org>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
	<1404453435-1915-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1404453435-1915-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> @@ -2179,7 +2179,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  	freetab = malloc(FREETAB_SIZE(ip->i_d.di_size / mp->m_dirblksize));
>  	if (!freetab) {
>  		do_error(
> -		_("malloc failed in longform_dir2_entry_check (%" PRId64 " bytes)\n"),
> +_("malloc failed in longform_dir2_entry_check (%" PRId64 " bytes)\n"),

Use __func__ to make this both more readable and future proof (same for
the other error message).


Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
