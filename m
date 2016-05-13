Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE7717CA0
	for <xfs@oss.sgi.com>; Fri, 13 May 2016 05:14:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EC488F8033
	for <xfs@oss.sgi.com>; Fri, 13 May 2016 03:14:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GgLZqricO9tkEF9h (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 May 2016 03:14:01 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 8901E90E74
	for <xfs@oss.sgi.com>; Fri, 13 May 2016 10:14:00 +0000 (UTC)
Received: from redhat.com (vpn-55-193.rdu2.redhat.com [10.10.55.193])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4DADvsv025403
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Fri, 13 May 2016 06:13:59 -0400
Date: Fri, 13 May 2016 12:13:56 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] db: limit AGFL bno array printing
Message-ID: <20160513101356.GB4393@redhat.com>
References: <1463103603-14610-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1463103603-14610-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Fri, May 13, 2016 at 11:40:03AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When asking for a single agfl entry such as:

Looks good to me, feel free to add

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> # xfs_db -c "agfl 0" -c "p bno[1]" /dev/ram0
> bno[1] = 1:6 2:7 3:8 4:null .....
> 
> The result should be just the single entry being asked for.
> Currently this outputs the entire remainder of the array starting at
> the given index. This makes it difficult to extract single entry
> values.
> 
> This occurs because the printing of a flat array of number types
> does not take into account the range that is specified on the
> command line, which is held in fl->low and fl->high. To make this
> work for flat arrays of number types (print function fp_num), change
> print_flist() to limit the count of values to be emitted to the
> range specified. This now gives:
> 
> # xfs_db -c "agfl 0" -c "p bno[1-2]" /dev/ram0
> bno[1-2] = 1:6 2:7
> 
> To further simplify external parsing of single entry values, if only
> a single value is requested from the array of fp_num type, don't
> print the array index - it's already known. Hence:
> 
> # xfs_db -c "agfl 0" -c "p bno[1]" /dev/ram0
> bno[1] = 6
> 
> This change will take effect on all types of flat number arrays that
> are printed. e.g. the range limiting will work for things like the
> AGI unlinked list arrays.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  db/fprint.c | 2 +-
>  db/print.c  | 7 +++++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/db/fprint.c b/db/fprint.c
> index f2b3794..fd7e7f4 100644
> --- a/db/fprint.c
> +++ b/db/fprint.c
> @@ -93,7 +93,7 @@ fp_num(
>  			val == -1LL : val == ((1LL << size) - 1LL);
>  		if ((arg & FTARG_SKIPNULL) && isnull)
>  			continue;
> -		if (array)
> +		if (array && count > 1)
>  			dbprintf("%d:", i + base);
>  		if ((arg & FTARG_DONULL) && isnull)
>  			dbprintf(_("null"));
> diff --git a/db/print.c b/db/print.c
> index 3ff2548..998daf4 100644
> --- a/db/print.c
> +++ b/db/print.c
> @@ -107,6 +107,7 @@ print_flist_1(
>  	const ftattr_t	*fa;
>  	flist_t		*fl;
>  	int		low;
> +	int		count;
>  	int		neednl;
>  	char		**pfx;
>  
> @@ -139,10 +140,12 @@ print_flist_1(
>  				low = fl->low;
>  			else
>  				low = 0;
> +			count = fcount(f, iocur_top->data, parentoff);
> +			if (fl->flags & FL_OKHIGH)
> +				count = min(count, fl->high - low + 1);
>  			if (fa->prfunc) {
>  				neednl = fa->prfunc(iocur_top->data, fl->offset,
> -					fcount(f, iocur_top->data, parentoff),
> -					fa->fmtstr,
> +					count, fa->fmtstr,
>  					fsize(f, iocur_top->data, parentoff, 0),
>  					fa->arg, low,
>  					(f->flags & FLD_ARRAY) != 0);
> -- 
> 2.8.0.rc3
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
