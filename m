Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D65CC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 18:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEC1D2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 18:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NRLK0WhC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfHZS7g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 14:59:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41304 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732403AbfHZS7f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 14:59:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QIsMDV078097;
        Mon, 26 Aug 2019 18:59:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=yeiex+TGtTyIWlgFoyDtPwKM33f9bFkrU9zbbooH50A=;
 b=NRLK0WhCp8uQipCtKAO0d9KU5Qb2DdMouyMG0vXp6p/KBL/bFohhBoE8tiV5DAamKDj5
 qoHQEakOAwcZZqC1WTPPFgOVBIAJc0bWTw2hNifKIiWQxJYJE9dsXcOvMwT2qpAv6D+7
 AtIA9MtiF9fGemF3Bk2zylHE5MQeO3uywq+XrkiLrtaNJUduUhrFc1QM/FqVPpdonqSe
 Hq3dFi4v6JW9MKLo4lZRfgviuCAjYM6TM12XmVlbC2OMpf1dHtmzH8NYW70npUVdfwbK
 oQsEbu8y7/Rn8wJnPDfhii1TWHpl4qDmEOV+wA6qVGbohQKkp+7vRUMLC7XpTu8XNisb 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ujw703g5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 18:59:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QIrK5b170852;
        Mon, 26 Aug 2019 18:59:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2umj1tc0hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 18:59:29 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QIxSFp002779;
        Mon, 26 Aug 2019 18:59:29 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 11:59:28 -0700
Date:   Mon, 26 Aug 2019 11:59:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: allocate xattr buffer on demand
Message-ID: <20190826185927.GR1037350@magnolia>
References: <20190724045911.GU7689@dread.disaster.area>
 <403e606b-1b7b-5983-d8e5-a7fecee84702@applied-asynchrony.com>
 <20190811010136.GD7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190811010136.GD7777@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 11, 2019 at 11:01:36AM +1000, Dave Chinner wrote:
> On Sat, Aug 10, 2019 at 11:45:35PM +0200, Holger Hoffstätte wrote:
> > 
> > Hi Dave -
> > 
> > great patch but I found something that seems off in xfs_attr3_leaf_getvalue:
> 
> It's not a "great patch" if there's something wrong with it. :/
> 
> > > @@ -2378,31 +2403,23 @@ xfs_attr3_leaf_getvalue((..snip..)
> > > +	if (args->flags & ATTR_KERNOVAL) {
> > >   		args->valuelen = args->rmtvaluelen;
> > > +		return 0;
> > >   	}
> > > -	return 0;
> > > +	return xfs_attr_copy_value(args, NULL, args->rmtvaluelen);
> > 
> > With gcc9 I get:
> > 
> >   CC      fs/xfs/libxfs/xfs_attr_leaf.o
> > In function 'xfs_attr_copy_value',
> >     inlined from 'xfs_attr3_leaf_getvalue' at fs/xfs/libxfs/xfs_attr_leaf.c:2425:9:
> > fs/xfs/libxfs/xfs_attr_leaf.c:421:2: warning: argument 2 null where non-null expected [-Wnonnull]
> >   421 |  memcpy(args->value, value, valuelen);
> >       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > In file included from ./arch/x86/include/asm/string.h:5,
> >                  from ./include/linux/string.h:20,
> >                  from ./include/linux/uuid.h:12,
> >                  from ./fs/xfs/xfs_linux.h:10,
> >                  from ./fs/xfs/xfs.h:22,
> >                  from fs/xfs/libxfs/xfs_attr_leaf.c:7:
> > fs/xfs/libxfs/xfs_attr_leaf.c: In function 'xfs_attr3_leaf_getvalue':
> > ./arch/x86/include/asm/string_64.h:14:14: note: in a call to function 'memcpy' declared here
> >    14 | extern void *memcpy(void *to, const void *from, size_t len);
> >       |              ^~~~~~
> > 
> > and sure enough, the NULL "value" arg is and passed as-is to memcpy in
> > xfs_attr_copy_value.
> 
> "sure enough", eh?
> 
> > Maybe you meant to sanitize the value when it's NULL?
> 
> Nope - look at the code:
> 
>         args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
> >>>>    args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
>         args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
>                                                args->rmtvaluelen);
>         if (args->flags & ATTR_KERNOVAL) {
>                 args->valuelen = args->rmtvaluelen;
>                 return 0;
>         }
>         return xfs_attr_copy_value(args, NULL, args->rmtvaluelen);
> }
> 
> And the relevant code in xfs_attr_copy_value() does:
> 
>         /* remote block xattr requires IO for copy-in */
> >>>>    if (args->rmtblkno)
> >>>>            return xfs_attr_rmtval_get(args);
> 
>         memcpy(args->value, value, valuelen);
>         return 0;
> }
> 
> The memcpy() is never reached in this case. Hence the compiler
> warning is a false positive and the code is not going to crash here.
> 
> Regardless, I'm going to have to change the code because I doubt gcc
> will ever be smart enough to understand the code flow as it stands.
> We have to do this every so often to avoid false positive
> uninitialised variable warnings, so it's not like working around
> compiler issues is something new.
> 
> I'll post an updated version tomorrow....

Ping?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
