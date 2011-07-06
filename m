Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663iXOp064072 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:44:33 -0500
Subject: Re: [PATCH 20/27] xfs: cleanup the defintion of struct
	xfs_dir2_data_entry
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094606.386730624@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.386730624@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 22:44:32 -0500
Message-ID: <1309923872.3381.41.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> Remove the tag member which is at a variable offset after the actual
> name, and make name a real variable sized C99 array instead of the incorrect
> one-sized array which confuses (not only) gcc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

One comment, but looks good.

Oh, and also, fix spelling of "definition" in the subject
line here and in other patches in this series.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/xfs_dir2_data.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_data.h	2011-06-29 13:42:35.521563513 +0200
> +++ xfs/fs/xfs/xfs_dir2_data.h	2011-06-29 13:43:03.284746440 +0200
> @@ -98,14 +98,14 @@ typedef struct xfs_dir2_data_hdr {
>  
>  /*
>   * Active entry in a data block.  Aligned to 8 bytes.
> - * Tag appears as the last 2 bytes.
> + *
> + * After the variable length name field there is a 2 byte tag field, which
> + * can be accessed using xfs_dir2_data_entry_tag_p.
>   */
>  typedef struct xfs_dir2_data_entry {
>  	__be64			inumber;	/* inode number */
>  	__u8			namelen;	/* name length */
> -	__u8			name[1];	/* name bytes, no null */
> -						/* variable offset */
> -	__be16			tag;		/* starting offset of us */
> +	__u8			name[];		/* name bytes, no null */

Maybe put the comment about the tag field here, as
was done elsewhere.  (But the pictures are even
better...)

>  } xfs_dir2_data_entry_t;
>  
>  /*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
