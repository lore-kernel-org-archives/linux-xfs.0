Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBAMhbtb121672 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 16:43:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3B5A1955F9B
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 14:44:11 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	nifDUF2SHeejzFxQ for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2009 14:44:11 -0800 (PST)
Date: Fri, 11 Dec 2009 09:44:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: update bmap help text
Message-ID: <20091210224408.GB30608@discord.disaster>
References: <4B216FCF.5010108@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B216FCF.5010108@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Thu, Dec 10, 2009 at 04:01:51PM -0600, Eric Sandeen wrote:
> Trivial addition of missing argument help text.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> iff --git a/io/bmap.c b/io/bmap.c
> index f79cf8c..5c4cf48 100644
> --- a/io/bmap.c
> +++ b/io/bmap.c
> @@ -43,6 +43,9 @@ bmap_help(void)
>  " -a -- prints the attribute fork map instead of the data fork.\n"
>  " -d -- suppresses a DMAPI read event, offline portions shown as holes.\n"
>  " -l -- also displays the length of each extent in 512-byte blocks.\n"
> +" -n -- query n extents.\n"
> +" -p -- obtain all unwritten extents as well (w/ -v show which are unwritten.\n"

Closing ')"?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
