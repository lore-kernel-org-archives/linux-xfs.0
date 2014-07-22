Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E447029DF9
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 06:53:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF94930406A
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 04:53:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2PbvimvAhYIiD5UC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 22 Jul 2014 04:53:13 -0700 (PDT)
Date: Tue, 22 Jul 2014 07:53:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] repair: Set ftype for entries in lost+found
Message-ID: <20140722115311.GA64423@bfoster.bfoster>
References: <1405970485-19888-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1405970485-19888-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Mon, Jul 21, 2014 at 09:21:25PM +0200, Jan Kara wrote:
> So far all entries in lost+found had file type XFS_DIR3_FT_UNKNOWN which
> is somewhat annoying as the next xfs_repair pass will find these and
> report as an error. Set proper file type when creating these entries.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/phase6.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index f13069f4cd71..0ec4f07ca1c2 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1097,8 +1097,6 @@ mv_orphanage(
>  	xname.name = fname;
>  	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
>  				(unsigned long long)ino);
> -	/* XXX use xfs_mode_to_ftype[] when userspace gains it */
> -	xname.type = XFS_DIR3_FT_UNKNOWN;
>  
>  	err = libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip, 0);
>  	if (err)
> @@ -1117,6 +1115,8 @@ mv_orphanage(
>  	if ((err = libxfs_iget(mp, NULL, ino, 0, &ino_p, 0)))
>  		do_error(_("%d - couldn't iget disconnected inode\n"), err);
>  
> +	xname.type = xfs_mode_to_ftype[(ino_p->i_d.di_mode & S_IFMT)>>S_SHIFT];
> +
>  	if (isa_dir)  {
>  		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, orphanage_ino),
>  				XFS_INO_TO_AGINO(mp, orphanage_ino));
> -- 
> 1.8.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
