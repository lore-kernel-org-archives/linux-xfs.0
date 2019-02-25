Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60894 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfBYSPk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 13:15:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1PI9Pkx146767
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 18:15:39 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qtupe00b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 18:15:39 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1PIFXRW003474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 18:15:33 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1PIFWrr001477
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 18:15:33 GMT
Date: Mon, 25 Feb 2019 10:15:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: fix backwards endian conversion in scrub
Message-ID: <20190225181525.GF21626@magnolia>
References: <155111649548.15126.8995811550165658297.stgit@magnolia>
 <155111650186.15126.5896442701967175896.stgit@magnolia>
 <94dc02ba-ba62-012c-40b6-afb5d1bb201d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94dc02ba-ba62-012c-40b6-afb5d1bb201d@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 25, 2019 at 11:09:14AM -0700, Allison Henderson wrote:
> On 2/25/19 10:41 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix a backwards endian conversion of a constant.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >   fs/xfs/scrub/agheader.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 9d4e8293d37e..ddf06bfaa29d 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -399,7 +399,7 @@ xchk_agf_xref_cntbt(
> >   	if (!xchk_should_check_xref(sc, &error, &sc->sa.cnt_cur))
> >   		return;
> >   	if (!have) {
> > -		if (agf->agf_freeblks != be32_to_cpu(0))
> > +		if (agf->agf_freeblks != cpu_to_be32(0))
> >   			xchk_block_xref_set_corrupt(sc, sc->sa.agf_bp);
> >   		return;
> >   	}
> > 
> 
> Good catch.  I suppose there's not as much need to do the conversion if the
> value is 0?

Yep.  Fortunately, there's enough macro soup in cpu_to_be* (and all the
other endian conversion functions) to detect that the argument is a
constant value and transform it at compile time to avoid runtime
overhead.

> But I think the call helps to make clear that the value is supposed to
> be in big endian.

It's more or less to satisfy static checkers. :)

> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>



--D
