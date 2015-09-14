Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E42DA7F50
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 14:18:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D767A304053
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:18:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sQQKt9L7po78ZtUX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:18:06 -0700 (PDT)
Date: Mon, 14 Sep 2015 15:18:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/13] xfs_repair: remove type from da & dir2 cursors
Message-ID: <20150914191803.GB34083@bfoster.bfoster>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
	<1441827251-13128-3-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441827251-13128-3-git-send-email-sandeen@sandeen.net>
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

On Wed, Sep 09, 2015 at 02:34:00PM -0500, Eric Sandeen wrote:
> The type field in these cursors is only set (and only
> in the attr code), and it's never read; just remove
> it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/attr_repair.c |    2 --
>  repair/dir2.h        |    1 -
>  2 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index d63bc87..f29a5bd 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -67,7 +67,6 @@ typedef struct da_level_state  {
>  
>  typedef struct da_bt_cursor  {
>  	int			active;	/* highest level in tree (# levels-1) */
> -	int			type;	/* 0 if dir, 1 if attr */
>  	xfs_ino_t		ino;
>  	xfs_dablk_t		greatest_bno;
>  	xfs_dinode_t		*dip;
> @@ -1477,7 +1476,6 @@ process_node_attr(
>  	 */
>  	memset(&da_cursor, 0, sizeof(da_bt_cursor_t));
>  	da_cursor.active = 0;
> -	da_cursor.type = 0;
>  	da_cursor.ino = ino;
>  	da_cursor.dip = dip;
>  	da_cursor.greatest_bno = 0;
> diff --git a/repair/dir2.h b/repair/dir2.h
> index df68d5c..3cc1941 100644
> --- a/repair/dir2.h
> +++ b/repair/dir2.h
> @@ -51,7 +51,6 @@ typedef struct dir2_level_state  {
>  
>  typedef struct dir2_bt_cursor  {
>  	int			active;	/* highest level in tree (# levels-1) */
> -	int			type;	/* 0 if dir, 1 if attr */
>  	xfs_ino_t		ino;
>  	xfs_dablk_t		greatest_bno;
>  	xfs_dinode_t		*dip;
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
