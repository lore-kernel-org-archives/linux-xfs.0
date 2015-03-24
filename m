Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF98E7F5D
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 07:07:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD380304043
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:07:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QdEOqECSCGnfPMcU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 05:07:53 -0700 (PDT)
Date: Tue, 24 Mar 2015 08:07:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/13 V2] xfs_repair: don't clear . or .. in
	process_dir2_data
Message-ID: <20150324120751.GD21657@bfoster.bfoster>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-13-git-send-email-sandeen@redhat.com>
	<551074F6.80706@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <551074F6.80706@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Mon, Mar 23, 2015 at 03:17:58PM -0500, Eric Sandeen wrote:
> process_dir2_data() has special . and .. processing; it is able
> to correct these inodes, so there is no reason to clear them.
> 
> Do this before we adjust a length 0 filename to length 1, so
> that we don't take this action on an accidentally created "."
> name from a hidden dotfile.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: Move the new hunk up, before we possibly reset the namelen to 1; 
> a 0-length ".hidden" file could turn in a length-1 "." and not get
> cleared.
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 9e6c67d..8ecc29b 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -1318,6 +1318,18 @@ _("entry \"%*.*s\" at block %d offset %" PRIdPTR " in directory inode %" PRIu64
>  				dep->namelen, dep->namelen, dep->name,
>  				da_bno, (intptr_t)ptr - (intptr_t)d, ino,
>  				clearreason, ent_ino);
> +
> +		/*
> +		 * We have a special dot & dotdot fixer-upper below which can
> +		 * sort out the proper inode number, so don't clear it.
> +		 */
> +		if ((dep->namelen == 1 && dep->name[0] == '.') ||
> +		    (dep->namelen == 2 &&
> +		     dep->name[0] == '.' && dep->name[1] == '.')) {
> +			clearino = 0;
> +			clearreason = NULL;
> +		}
> +
>  		/*
>  		 * If the name length is 0 (illegal) make it 1 and blast
>  		 * the entry.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
