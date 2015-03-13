Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2DE157F3F
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 09:34:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1CBAF304051
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 07:34:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5g8vy2CBQw7EShaK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Mar 2015 07:34:21 -0700 (PDT)
Date: Fri, 13 Mar 2015 10:34:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs_repair: dirty inode in process_sf_dir2 if we
	change namelen
Message-ID: <20150313143417.GD2678@laptop.bfoster>
References: <54FF59DA.60700@sandeen.net>
 <54FF5A5F.90201@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54FF5A5F.90201@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 10, 2015 at 04:55:59PM -0400, Eric Sandeen wrote:
> There are two "fix sfep->namelen" cases, but we only mark
> *dino_dirty = 1 in one of them.  Add the other to ensure that
> the change gets written out.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 6b8964d..25793e9 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -881,6 +881,7 @@ _("entry \"%*.*s\" in shortform directory %" PRIu64 " references %s inode %" PRI
>  _("zero length entry in shortform dir %" PRIu64 ", resetting to %d\n"),
>  						ino, namelen);
>  					sfep->namelen = namelen;
> +					*dino_dirty = 1;
>  				} else  {
>  					do_warn(
>  _("zero length entry in shortform dir %" PRIu64 ", would set to %d\n"),
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
