Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1BA9E7F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 00:55:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2EA8304043
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 22:55:17 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rPtrWnEbKma1WCO7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 22:55:16 -0700 (PDT)
Date: Thu, 24 Apr 2014 22:55:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140425055516.GC30118@infradead.org>
References: <1398315722-20870-1-git-send-email-david@fromorbit.com>
	<1398315722-20870-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398315722-20870-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  	sb = (xfs_sb_t *)calloc(BBSIZE, 1);

If you already do various cosmetic changes I'd recommend removing the
useles case here as well.

> -	if (status & XR_AG_AGF)  {
> +	if (agf_dirty || status & XR_AG_AGF)  {

> -	if (status & XR_AG_AGI)  {
> +	if (agi_dirty || status & XR_AG_AGI)  {

I can't see how agf_dirty and agi_dirty would ever be set at this point.

> +out_free:
> +	if (sb)
> +		free(sb);
> +	if (agibuf)
> +		libxfs_putbuf(agibuf);
> +	if (agfbuf)
> +		libxfs_putbuf(agfbuf);
> +	if (sbbuf)
> +		libxfs_putbuf(sbbuf);
> +	if (objname)
> +		do_error(_("can't get %s for ag %d\n"), objname, agno);
> +	return;

No need for a return statement at the end of a void returning function.

Also any reason for not using one goto for each unwind step like we do
elsewhere instead of the if (!NULL) checks?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
