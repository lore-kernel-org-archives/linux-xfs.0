Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A58067F54
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 09:34:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 948D7304051
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 07:34:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Zm8YEO01ixDyoMAQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Mar 2015 07:34:28 -0700 (PDT)
Date: Fri, 13 Mar 2015 10:34:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs_repair: remove impossible tests in process_sf_dir2
Message-ID: <20150313143424.GE2678@laptop.bfoster>
References: <54FF59DA.60700@sandeen.net>
 <54FF5BA6.4000508@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54FF5BA6.4000508@sandeen.net>
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

On Tue, Mar 10, 2015 at 05:01:26PM -0400, Eric Sandeen wrote:
> We're testing for an impossible case in here:
> 
>                 if (i == num_entries - 1)  {
> ...
>                 } else  {
> ...
>                                 if (i == num_entries - 1)
>                                     /* can't happen! */
> ...
>                 }
> 
> So, remove the impossible case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 25793e9..7aede6a 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -928,26 +928,12 @@ _("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
>  				do_warn(
>  _("size of entry #%d overflows space left in in shortform dir %" PRIu64 "\n"),
>  					i, ino);
> -				if (!no_modify)  {
> -					if (i == num_entries - 1)
> -						do_warn(
> -						_("junking entry #%d\n"),
> -							i);
> -					else
> -						do_warn(
> -						_("junking %d entries\n"),
> -							num_entries - i);
> -				} else  {
> -					if (i == num_entries - 1)
> -						do_warn(
> -						_("would junk entry #%d\n"),
> -							i);
> -					else
> -						do_warn(
> -						_("would junk %d entries\n"),
> -							num_entries - i);
> -				}
> -
> +				if (!no_modify)
> +					do_warn(_("junking %d entries\n"),
> +						num_entries - i);
> +				else
> +					do_warn(_("would junk %d entries\n"),
> +						num_entries - i);
>  				break;
>  			}
>  		}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
