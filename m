Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7CBF17F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 20:17:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1667FAC002
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 18:17:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0vY2e05nsihZ2d8H (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 18:17:51 -0700 (PDT)
Date: Mon, 9 Mar 2015 21:17:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts
	beyond dir size
Message-ID: <20150310011745.GA2722@laptop.bfoster>
References: <54FDFEDC.5090106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54FDFEDC.5090106@sandeen.net>
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
Cc: Rui Gomes <rgomes@rvx.is>, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 09, 2015 at 04:13:16PM -0400, Eric Sandeen wrote:
> When process_sf_dir2() is trying to salvage entries in a corrupted
> short form directory, it may attempt to shorten the last entry in
> the dir if it extends beyond the directory size.
> 
> However, if the name already starts past the dir size, no amount
> of name-shortening will make it fit, but the code doesn't realize
> this.  The namelen variable comes out to be negative, and things
> go downhill from there, resulting in a segfault when we try to
> memmove a negative number of bytes.
> 
> If no amount of name-shortening can make the last dir entry fit
> in the dir size, simply junk the entry.
> 
> Reported by: Rui Gomes <rgomes@rvx.is>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> This adds a bit more spaghetti to an existing pot, but I think
> it clearly fixes the problem; I might try to rework these cases
> to coalesce some of the code.
> 
> (I also wonder about the tradeoff between shortening entries and
> increasing the dir size, but for now I'm just following the
> direction the repair code already takes).
> 

Seems Ok on a first glance. The fix is associated with the specific
namelen calculation. Are we susceptible to a similar problem in the
previous branch where we also calculate namelen from the dir size (the
namelen == 0 case)? It looks like we could set a bad value there.

Brian

> diff --git a/repair/dir2.c b/repair/dir2.c
> index 6b8964d..308808d 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -911,6 +911,20 @@ _("zero length entry in shortform dir %" PRIu64 ""),
>  				namelen = ino_dir_size -
>  					((__psint_t) &sfep->name[0] -
>  					 (__psint_t) sfp);
> +				/* Entry name starts past size of dir; junk it */
> +				if (namelen <= 0) {
> +					do_warn(
> +_("start of last entry name overflows space left in in shortform dir %" PRIu64 ", "),
> +						ino);
> +					if (!no_modify)
> +						do_warn(
> +						_("junking entry #%d\n"), i);
> +					else
> +						do_warn(
> +						_("would junk entry #%d\n"), i);
> +					break;
> +				}
> +				/* Ok, truncate this entry to end of dir */
>  				do_warn(
>  _("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
>  					ino);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
