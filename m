Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D1FEF7F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:40:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51EA0AC001
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 06:40:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DyMtx9sZIHwCQOcS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 06:40:15 -0700 (PDT)
Date: Fri, 19 Jun 2015 09:40:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs_repair: reformat lines to fit within 80 characters
Message-ID: <20150619134009.GE12833@bfoster.bfoster>
References: <1434705696-21705-1-git-send-email-mggr@pml.ac.uk>
	<1434705696-21705-2-git-send-email-mggr@pml.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434705696-21705-2-git-send-email-mggr@pml.ac.uk>
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
To: Mike Grant <mggr@pml.ac.uk>
Cc: xfs@oss.sgi.com

On Fri, Jun 19, 2015 at 10:21:35AM +0100, Mike Grant wrote:
> Signed-off-by: Mike Grant <mggr@pml.ac.uk>
> ---
>  repair/phase6.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 105bce4..0d66f9c 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2327,9 +2327,11 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  		if (db >= num_bps) {
>  			/* more data blocks than expected */
>  			num_bps = db + 1;
> -			bplist = realloc(bplist, num_bps * sizeof(struct xfs_buf*));
> +			bplist = realloc(bplist, num_bps *
> +				sizeof(struct xfs_buf*));

We usually try to align the split lines based on the "scope" within the
previous lines, for lack of a better term. For example, the above would
look something like this:

			bplist = realloc(bplist, num_bps *
					 sizeof(struct xfs_buf*));

... which is a bit easier to read at a glance. Anyways, Dave may or may
not pull this one and fix it up manually, but it's fine to me with the
above fix:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  			if (!bplist)
> -				do_error(_("realloc failed in %s (%zu bytes)\n"),
> +				do_error(
> +					_("realloc failed in %s (%zu bytes)\n"),
>  					__func__,
>  					num_bps * sizeof(struct xfs_buf*));
>  		}
> -- 
> 2.1.0
> 
> (apologies for the following junk forcibly appended by my company)
> 
> 
> Please visit our new website at www.pml.ac.uk and follow us on Twitter  @PlymouthMarine
> 
> Winner of the Environment & Conservation category, the Charity Awards 2014.
> 
> Plymouth Marine Laboratory (PML) is a company limited by guarantee registered in England & Wales, company number 4178503. Registered Charity No. 1091222. Registered Office: Prospect Place, The Hoe, Plymouth  PL1 3DH, UK. 
> 
> This message is private and confidential. If you have received this message in error, please notify the sender and remove it from your system. You are reminded that e-mail communications are not secure and may contain viruses; PML accepts no liability for any loss or damage which may be caused by viruses.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
