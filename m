Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B55547F56
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 09:35:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4423BAC002
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 07:35:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Tw1RoZj3MW60ygyu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Mar 2015 07:35:47 -0700 (PDT)
Date: Fri, 13 Mar 2015 10:35:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs_repair: collapse 2 cases in process_sf_dir2
Message-ID: <20150313143544.GF2678@laptop.bfoster>
References: <54FF59DA.60700@sandeen.net>
 <54FF5C4F.80709@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54FF5C4F.80709@sandeen.net>
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

On Tue, Mar 10, 2015 at 05:04:15PM -0400, Eric Sandeen wrote:
> process_sf_dir2() has 2 cases for a bad namelen: on-disk namelen
> is 0, or on-disk namelen extends beyond the directory i_size.
> 
> After the prior 2 patches, the code for each case is now essentially
> the same, so collapse the two cases.
> 
> Note, this does slightly change some of the error messages.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 7aede6a..5512e41 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -861,36 +861,44 @@ process_sf_dir2(
>  _("entry \"%*.*s\" in shortform directory %" PRIu64 " references %s inode %" PRIu64 "\n"),
>  				namelen, namelen, sfep->name, ino, junkreason,
>  				lino);
> -		if (namelen == 0)  {
> -			/*
> -			 * if we're really lucky, this is
> -			 * the last entry in which case we
> -			 * can use the dir size to set the
> -			 * namelen value.  otherwise, forget
> -			 * it because we're not going to be
> -			 * able to find the next entry.
> -			 */
> +
> +		/* is dir namelen 0 or does this entry extend past dir size? */
> +		if (namelen == 0) {
> +			junkreason = _("is zero length");
>  			bad_sfnamelen = 1;
> +		} else if ((__psint_t) sfep - (__psint_t) sfp +
> +				xfs_dir3_sf_entsize(mp, sfp, sfep->namelen)
> +							> ino_dir_size)  {
> +			junkreason = _("extends past end of dir");
> +			bad_sfnamelen = 1;
> +		}
>  
> +		if (bad_sfnamelen) {
> +			/*
> +			 * if we're really lucky, this is the last entry in

"... in which case ..."

(irrelevant as this is removed by the next patch)

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +			 * case we can use the dir size to set the namelen
> +			 * value.  otherwise, forget it because we're not going
> +			 * to be able to find the next entry.
> +			 */
>  			if (i == num_entries - 1)  {
>  				namelen = ino_dir_size -
>  					((__psint_t) &sfep->name[0] -
>  					 (__psint_t) sfp);
>  				if (!no_modify)  {
>  					do_warn(
> -_("zero length entry in shortform dir %" PRIu64 ", resetting to %d\n"),
> -						ino, namelen);
> +_("entry #%d %s in shortform dir %" PRIu64 ", resetting to %d\n"),
> +						i, junkreason, ino, namelen);
>  					sfep->namelen = namelen;
>  					*dino_dirty = 1;
>  				} else  {
>  					do_warn(
> -_("zero length entry in shortform dir %" PRIu64 ", would set to %d\n"),
> -						ino, namelen);
> +_("entry #%d %s in shortform dir %" PRIu64 ", would set to %d\n"),
> +						i, junkreason, ino, namelen);
>  				}
>  			} else  {
>  				do_warn(
> -_("zero length entry in shortform dir %" PRIu64 ""),
> -					ino);
> +_("entry #%d %s in shortform dir %" PRIu64),
> +					i, junkreason, ino);
>  				if (!no_modify)
>  					do_warn(_(", junking %d entries\n"),
>  						num_entries - i);
> @@ -903,39 +911,6 @@ _("zero length entry in shortform dir %" PRIu64 ""),
>  				 */
>  				break;
>  			}
> -		} else if ((__psint_t) sfep - (__psint_t) sfp +
> -				xfs_dir3_sf_entsize(mp, sfp, sfep->namelen)
> -							> ino_dir_size)  {
> -			bad_sfnamelen = 1;
> -
> -			if (i == num_entries - 1)  {
> -				namelen = ino_dir_size -
> -					((__psint_t) &sfep->name[0] -
> -					 (__psint_t) sfp);
> -				do_warn(
> -_("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
> -					ino);
> -				if (!no_modify)  {
> -					do_warn(_("resetting to %d\n"),
> -						namelen);
> -					sfep->namelen = namelen;
> -					*dino_dirty = 1;
> -				} else  {
> -					do_warn(_("would reset to %d\n"),
> -						namelen);
> -				}
> -			} else  {
> -				do_warn(
> -_("size of entry #%d overflows space left in in shortform dir %" PRIu64 "\n"),
> -					i, ino);
> -				if (!no_modify)
> -					do_warn(_("junking %d entries\n"),
> -						num_entries - i);
> -				else
> -					do_warn(_("would junk %d entries\n"),
> -						num_entries - i);
> -				break;
> -			}
>  		}
>  
>  		/*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
