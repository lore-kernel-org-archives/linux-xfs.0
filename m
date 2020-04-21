Return-Path: <SRS0=MzXO=6F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C88C54FCC
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 00:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2C7020782
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 00:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TWLUxzN8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgDUAFe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 20:05:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41252 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgDUAFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 20:05:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KNwaU6069144;
        Tue, 21 Apr 2020 00:05:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PiGmBa8p6gDyW8Vr6ZICFDKWLiLx5qfhq+YjZfGciBk=;
 b=TWLUxzN8WGihHJCRC2tQpZg6/4rt62wygkuDzVzFWAUHNxfSOaIZKdpzqyeQGrX8CUEt
 mRmkx/YwWUEgCR8wEHBrsYo197kmUQUh3aIfa9KlppNXAPjLQiWIz5AxECo0wwKnfDzt
 bb1xafUziGTUB0CSL157OoMZoXslY4pLOxSDmemFeBpJ9I7/Fp758hBjSudEddaoIbIz
 zABpZiAXI8ClrpsA2lC+BAFZaM+u5GUYw41J1LtCguZbCvwKOZUNEuJAKsAPOSWkQUhw
 s5BdhrInRuWC0ynghRLP0VV8hyP7HxPG/haMESxVBZ/iwtvbOGLWGenpsCoGTO2VExn/ Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30ft6n23s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 00:05:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KNvWrL001820;
        Tue, 21 Apr 2020 00:05:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30gb3raxxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 00:05:28 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03L05PI9017640;
        Tue, 21 Apr 2020 00:05:26 GMT
Received: from localhost (/10.159.234.119)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 17:05:25 -0700
Date:   Mon, 20 Apr 2020 17:05:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Anthony Iliopoulos <ailiop@suse.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: fix crc invalidation segfault
Message-ID: <20200421000524.GW6742@magnolia>
References: <20200420195235.14260-1-ailiop@suse.com>
 <0f21ae94-5901-c6d2-06a0-ba016511065d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f21ae94-5901-c6d2-06a0-ba016511065d@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 03:33:36PM -0500, Eric Sandeen wrote:
> On 4/20/20 2:52 PM, Anthony Iliopoulos wrote:
> > The nowrite_ops var is declared within nested block scope but used
> > outside that scope, causing xfs_db to crash while trying to defererence
> > the verify_write pointer. Fix it by lifting the declaration to the outer
> > scope, where it is accessed.
> > 
> > Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> 
> Yup, thanks for spotting & fixing this.
> 
> Fixes: b64af2c "xfs_db: add crc manipulation commands"

<nitpick> commit ids should be 14(?) digits long these days.

> Reviewd-by: Eric Sandeen <sandeen@redhat.com>

"Pat, I'd like to buy a vowel..." :D

--D

> 
> > ---
> >  db/crc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/db/crc.c b/db/crc.c
> > index 95161c6df..b23417a11 100644
> > --- a/db/crc.c
> > +++ b/db/crc.c
> > @@ -53,6 +53,7 @@ crc_f(
> >  	char		**argv)
> >  {
> >  	const struct xfs_buf_ops *stashed_ops = NULL;
> > +	struct xfs_buf_ops nowrite_ops;
> >  	extern char	*progname;
> >  	const field_t	*fields;
> >  	const ftattr_t	*fa;
> > @@ -127,7 +128,6 @@ crc_f(
> >  	}
> >  
> >  	if (invalidate) {
> > -		struct xfs_buf_ops nowrite_ops;
> >  		flist_t		*sfl;
> >  		int		bit_length;
> >  		int		parentoffset;
> > 
