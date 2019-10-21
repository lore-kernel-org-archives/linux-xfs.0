Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3708CCA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 18:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0824020882
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 18:10:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Frg4rrid"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbfJUSKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 14:10:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38156 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730015AbfJUSKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 14:10:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LI8rem050098;
        Mon, 21 Oct 2019 18:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Blb0LxyEqCExgcFKomjKBXBclWFvqAcfxGrZd5LhjWg=;
 b=Frg4rrid/lhL6N8H/6ttt75XHFow3ySpOl5CkJBhCPHkJkaxR3bY1UrzkT5SVJSR4Vgq
 qk4wP6LpKqP9asGy3SbJoAq4h3OgUbOsjpfxof4Y9RsECajg5fVa6vZk2LMNjA21OP+b
 AvVNnTCxkBqt9BocHp2OBRrc+kHiVGLsRbQN44h+vk7tGser3gSQyNNvrI9zRBJaB9hf
 rJOUCK1kHink/dZvl+YxTUEVW9kzJIVw2UWfkPvVyZeCVqw0PMzfLda6ObsMcn8SwQHW
 Vjr8Pogn4+E7Dfpp8eeiO9zaS4VXdb/wkfNw4t9var1pWM1aEcQfq8dRa6WhAxactFxT qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqtephg2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 18:10:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LI3fDn182251;
        Mon, 21 Oct 2019 18:10:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vsakbnae4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 18:10:16 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9LIAFKp001831;
        Mon, 21 Oct 2019 18:10:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 18:10:14 +0000
Date:   Mon, 21 Oct 2019 11:10:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs_scrub: better reporting of metadata media
 errors
Message-ID: <20191021181013.GC913374@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
 <156944738604.300131.8278382614496808681.stgit@magnolia>
 <a8138e48-c327-3eef-eb35-5dbe31595fcb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8138e48-c327-3eef-eb35-5dbe31595fcb@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 11:46:23AM -0500, Eric Sandeen wrote:
> On 9/25/19 4:36 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we report bad metadata, we inexplicably report the physical address
> > in units of sectors, whereas for file data we report file offsets in
> > units of bytes.  Fix the metadata reporting units to match the file data
> > units (i.e. bytes) and skip the printf for all other cases.
> 
> kernelspace has been plagued with stuff like this - sectors vs bytes vs
> blocks, hex vs decimal, leading 0x or not ... A doc in xfs_scrub about
> how everything should be reported seems like it might be a good idea?

I'll see what I can come up with...

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/phase6.c |   12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/scrub/phase6.c b/scrub/phase6.c
> > index a16ad114..310ab36c 100644
> > --- a/scrub/phase6.c
> > +++ b/scrub/phase6.c
> > @@ -368,7 +368,7 @@ xfs_check_rmap_error_report(
> >  	void			*arg)
> >  {
> >  	const char		*type;
> > -	char			buf[32];
> > +	char			buf[DESCR_BUFSZ];
> >  	uint64_t		err_physical = *(uint64_t *)arg;
> >  	uint64_t		err_off;
> >  
> > @@ -377,14 +377,12 @@ xfs_check_rmap_error_report(
> >  	else
> >  		err_off = 0;
> >  
> > -	snprintf(buf, 32, _("disk offset %"PRIu64),
> > -			(uint64_t)BTOBB(map->fmr_physical + err_off));
> > -
> 
> so did this double-report if the error was associated with a file?

This snprintf call formats the error message prefix for the case where
getfsmap tells us that a bad range intersects with some metadata...

> > +	/* Report special owners */
> >  	if (map->fmr_flags & FMR_OF_SPECIAL_OWNER) {
> > +		snprintf(buf, DESCR_BUFSZ, _("disk offset %"PRIu64),
> > +				(uint64_t)map->fmr_physical + err_off);

...so we move it here to avoid wasting time on string formatting for
other badblocks cases such as the one we add in the next patch.

--D

> >  		type = xfs_decode_special_owner(map->fmr_owner);
> > -		str_error(ctx, buf,
> > -_("%s failed read verification."),
> > -				type);
> > +		str_error(ctx, buf, _("media error in %s."), type);
> >  	}
> 
>  
> >  	/*
> > 
