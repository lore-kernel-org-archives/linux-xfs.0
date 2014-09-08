Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E0407F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 08:45:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C698304039
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 06:45:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HzPDip6jJKyjY2JC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 06:45:14 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s88DjDOH001935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 8 Sep 2014 09:45:13 -0400
Date: Mon, 8 Sep 2014 09:45:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs_repair: clear bad flgs in process_dinode_int
Message-ID: <20140908134510.GA52419@bfoster.bfoster>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
	<1410108065-18156-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410108065-18156-2-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 11:41:01AM -0500, Eric Sandeen wrote:
> process_dinode_int() reports bad flags if
> dino->di_flags & ~XFS_DIFLAG_ANY - i.e. if
> any flags are set outside the known set.  But
> then instead of clearing them, it does
> flags &= ~XFS_DIFLAG_ANY which keeps *only*
> the bad flags.  This leads to persistent,
> unrepairable errors of the form:
> 
> "Bad flags set in inode XXX"
> 
> Fix this.
> 
> While we are at it, fix a couple lines which
> look like they used to be continuation lines,
> but are no longer.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/dinode.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8891e84..38a6562 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2456,7 +2456,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  	_("Bad flags set in inode %" PRIu64 "\n"),
>  					lino);
>  			}
> -			flags &= ~XFS_DIFLAG_ANY;
> +			flags &= XFS_DIFLAG_ANY;
>  		}
>  
>  		if (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) {
> @@ -2513,11 +2513,11 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  		}
>  		if (!verify_mode && flags != be16_to_cpu(dino->di_flags)) {
>  			if (!no_modify) {
> -				do_warn(_(", fixing bad flags.\n"));
> +				do_warn(_("fixing bad flags.\n"));
>  				dino->di_flags = cpu_to_be16(flags);
>  				*dirty = 1;
>  			} else
> -				do_warn(_(", would fix bad flags.\n"));
> +				do_warn(_("would fix bad flags.\n"));
>  		}
>  	}
>  
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
