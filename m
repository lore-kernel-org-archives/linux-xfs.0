Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 23:38:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m386cKKe022988
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 23:38:23 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 279C69669CA
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2008 23:38:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id apA9M5DO2dSQN4VG for <xfs@oss.sgi.com>; Mon, 07 Apr 2008 23:38:57 -0700 (PDT)
Date: Tue, 8 Apr 2008 02:38:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] cleanup - remove bhv_vname_t
Message-ID: <20080408063822.GA21876@infradead.org>
References: <op.t89zp3j63jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t89zp3j63jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Apr 08, 2008 at 02:50:17PM +1000, Barry Naujok wrote:
> -
> +

What's this?  both lines look empty.

>  	return -dm_send_namesp_event(event, mp ? mp->m_super : NULL,
>  				    ip1->i_vnode, vp1_right,
>  				    ip2 ? ip2->i_vnode : NULL, vp2_right,
> -				    name1, name2,
> +				    (char *)name1, (char *)name2,

please change dm_send_namesp_event to take a const char aswell.

> +static inline struct xfs_name *
> +xfs_dentry_name(
> +	struct xfs_name	*namep,
> +	struct dentry	*dentry)
> +{
> +	namep->name = dentry->d_name.name;
> +	namep->len = dentry->d_name.len;
> +	return namep;
> +}

As mentioned in my comment to the CI series:  shouldn't you just use
a struct qstr instead of adding a new struct xfs_name?

Also please don't add inline for this.
> +xfs_name_t xfs_name_dotdot = {"..", 2};

const?

> +	args.name = name->name;
> +	args.namelen = name->len;
> +	args.hashval = xfs_da_hashname(name->name, name->len);

What about just putting a pointer to the xfs_name/qstr into args?

>  /*
> + * Counted string for file names.
> + */
> +typedef struct xfs_name {
> +	const uchar_t	*name;
> +	int		len;
> +} xfs_name_t;

Please try to avoid the typedef for newly added types.
