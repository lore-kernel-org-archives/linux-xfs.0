Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B2BA97F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 13:43:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CF09AC001
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 11:43:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fWwpCdZSNA0RqdXI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 11:43:39 -0700 (PDT)
Date: Mon, 9 Mar 2015 15:43:26 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/4] xfs_repair: clear need_root_dotdot if we rebuild the
	root dir
Message-ID: <20150309184326.GC18016@hades.maiolino.org>
References: <54F77199.8030708@redhat.com>
 <54F77216.5030106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F77216.5030106@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Wed, Mar 04, 2015 at 02:59:02PM -0600, Eric Sandeen wrote:
> It's possible to enter longform_dir2_rebuild with need_root_dotdot
> set; rebuilding it will add "..", and if need_root_dotdot stays set,
> we'll add another ".." entry, causing a second repair to find and
> fix that newly-introduced problem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 0ec4f07..1728609 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1354,6 +1354,9 @@ longform_dir2_rebuild(
>  
>  	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
>  
> +	if (ino == mp->m_sb.sb_rootino)
> +		need_root_dotdot = 0;
> +
>  	/* go through the hash list and re-add the inodes */
>  
>  	for (p = hashtab->first; p; p = p->nextbyorder) {
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
