Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o213FRVu135186 for <xfs@oss.sgi.com>; Sun, 28 Feb 2010 21:15:27 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DAD2202D64
	for <xfs@oss.sgi.com>; Sun, 28 Feb 2010 19:16:51 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Efsniohs2iFVYwMd for <xfs@oss.sgi.com>;
	Sun, 28 Feb 2010 19:16:51 -0800 (PST)
Date: Mon, 1 Mar 2010 14:16:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Proposed patch for xfsprogs
Message-ID: <20100301031642.GG22370@discord.disaster>
References: <1267311250.28691.40.camel@lh10.linush.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267311250.28691.40.camel@lh10.linush.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "C. Linus Hicks" <linush@mindspring.com>
Cc: xfs@oss.sgi.com

On Sat, Feb 27, 2010 at 05:54:10PM -0500, C. Linus Hicks wrote:
> During my recent experience with having to reconstruct parts of an XFS
> filesystem that got corrupted as a result of several bad blocks, I found
> that some of the information displayed using "blockget -v" was pretty
> useless, and I am proposing the following code change to introduce a
> slight summarization.
> 
> Repeating lines of "setting block <foo> to <bar>" and "setting inode to
> <foo> for {,rt}block <bar>" will be summarized down to two lines.

Agreed, that would certainly help reduce the verbosity of the output.
However, I don't think the patch is correct.

> --- a/xfsprogs-3.1.1/db/check.c	2010-01-29 14:46:13.000000000 -0500
> +++ b/xfsprogs-3.1.1/db/check.c	2010-02-27 17:02:14.111418960 -0500
> @@ -1509,6 +1509,7 @@
>  {
>  	xfs_extlen_t	i;
>  	int		mayprint;
> +	int		isfirst = 1;
>  	char		*p;
>  
>  	if (!check_range(agno, agbno, len))  {
> @@ -1520,10 +1521,15 @@
>  	mayprint = verbose | blist_size;
>  	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
>  		*p = (char)type2;
> -		if (mayprint && (verbose || CHECK_BLISTA(agno, agbno + i)))
> +		if (isfirst && mayprint && (verbose || CHECK_BLISTA(agno, agbno + i))) {
>  			dbprintf(_("setting block %u/%u to %s\n"), agno, agbno + i,
>  				typename[type2]);
> +			isfirst = 0;
> +		}
>  	}
> +	if ((len > 1) && mayprint && (verbose || CHECK_BLISTA(agno, agbno + i)))
> +		dbprintf(_("    ... until %u/%u\n"),
> +				agno, agbno + len - 1);
>  }

This doesn't take into account that not all blocks in the extent
range might be bad and the change is actually doing something. i.e.
only is CHECK_BLISTA() evaluating as true is there a printout
occurring (unless you specify verbose mode). Hence if only interior
portions are being changed or there are multiple ranges being
changed, this output won't reflect the errors being detected
accurately.

The other sections of the patch have the same issue.

I think that changing it to something like:

	int	last_print == -1;
.....
		if (mayprint && (verbose || CHECK_BLISTA(agno, agbno + i))) {
			if (i > 0 && last_print == i - 1) {
				last_print = i;
				continue;
			}
			if (last_print != i - 1) {
				dbprintf(_("    ... until %u/%u\n"),
					agno, agbno + last_print);
				last_print == -1;
			}
			if (last_print == -1) {
				dbprintf(_("setting block %u/%u to %s\n"),
					agno, agbno + i, typename[type2]);
				last_print = i;
			}
		}
	}
	if (len > 1 && last_print != -1)
		dbprintf(_("    ... until %u/%u\n"), agno, agbno + last_print);

would do the trick. What do you think?

Cheers,

Dave.



-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
