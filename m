Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6D9WPBA038570 for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 04:32:26 -0500
Subject: Re: [PATCH, RFC] xfs_repair - clear inodes in incorrect btree format
References: <4A582070.9040907@sandeen.net>
From: Olaf Weber <olaf@sgi.com>
Date: Mon, 13 Jul 2009 11:33:02 +0200
In-Reply-To: <4A582070.9040907@sandeen.net> (Eric Sandeen's message of "Sat,
	11 Jul 2009 00:17:36 -0500")
Message-ID: <bzytz1hq65t.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen writes:

[...]

> But questions remain...

> 1) How'd it get into this state? ... but maybe more importantly...
> 2) Should these really get cleared?  It's possibly a sane extent list,
> it's just that it -could- be in extents rather than btree format...
> 3) By the same token, should the kernel really be choking on it?

It is not clear to me yet how you could get into this state, but this
is clearly an invariant the kernel actively maintains.

If the kernel "just" missed the underflow and kept the extents in
btree format, then I don't see an apriori reason why the extent list
as such would be invalid (as opposed to inefficiently stored).  If
that's the primary model for getting into this state, then the file
contents can be rescued and kernel-side the event should be
survivable.

But if the kernel tried to convert, failed, and didn't properly detect
failure...  Without having a good answer for (1) I find it hard to
convince myself that to be more forgiving wrt to (2) and (3) is safe.

Olaf


> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Acked-By: Olaf Weber <olaf@sgi.com>

> ---

> diff --git a/repair/dinode.c b/repair/dinode.c
> index 84e1d05..3fc6cac 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1280,6 +1280,14 @@ process_btinode(
>  			last_key = cursor.level[level-1].first_key;
>  		}
>  	}
> +	if (*nex <= XFS_DFORK_SIZE(dip, mp, whichfork) / sizeof(xfs_bmbt_rec_t)) {
> +		do_warn(_("extent count for ino %lld %s fork too low "
> +			  "(%d) for file format\n"),
> +				lino,
> +				whichfork == XFS_DATA_FORK ? _("data") : _("attr"),
> +				*nex);
> +		return(1);
> +	}
>  	/*
>  	 * Check that the last child block's forward sibling pointer
>  	 * is NULL.


-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
