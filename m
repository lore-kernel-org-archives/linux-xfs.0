Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE1CC32771
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 23:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCFB62469C
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 23:06:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XaEAqY7c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgARXGj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 18:06:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52304 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgARXGj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 18:06:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMwjdS105976;
        Sat, 18 Jan 2020 23:06:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=7u5eK+FvIX6ULRP9b8ougFE9Od0bvaDt/x/0hZNUplU=;
 b=XaEAqY7caBSEQSrBTiNbyuBzl7Eh9bOQXHnyXq4FNzAt40uKqxn0YZPaRERTNMKuhfjC
 1mS4OWbL/vgCBsPKxY7WTP8fh+fx9Nhy99dVOHeFjRk17BVHp2FCwebfm2RczokUGxim
 M7bxau32ZKeolbXJa87QU5tHP3Fzg+NZqejOAQRzBl+xsNL8hhXt7deueIeDSCvZR0oK
 ikzdMflTrPt6oaJnIYdYTWAdRNr/1G2QYAlhYglH4CFRFhHgWEQKZziPBXmx2tIpgBtz
 jkj8/KkX/45uIYZ/h8VaDvQ+Z5jb3e5R3TUjf6i9k1dhr00RzYWhqAsH81p1dd/qx1YU Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseu25nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jan 2020 23:06:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IN0klH150322;
        Sat, 18 Jan 2020 23:06:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xkr2dbcyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jan 2020 23:06:35 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00IN6Xo3001887;
        Sat, 18 Jan 2020 23:06:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 15:06:32 -0800
Date:   Sat, 18 Jan 2020 15:06:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink vs ThinLVM
Message-ID: <20200118230631.GX8247@magnolia>
References: <20200113165341.GE8247@magnolia>
 <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
 <20200113180914.GI8247@magnolia>
 <8e96231f-8fc6-b178-9e83-84cbb9af6d2e@assyoma.it>
 <9d8e8614-9ae1-30ee-f2b4-1e45b90b27f8@assyoma.it>
 <20200115163948.GF8257@magnolia>
 <761fcf8f9d68ee221a35d15c1a7120c5@assyoma.it>
 <e3dd598260d9f92c3b2c91cb81540e37@assyoma.it>
 <20200117234219.GM8257@magnolia>
 <cc3d0819966d2d3f5b8512ed0f6b1de1@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc3d0819966d2d3f5b8512ed0f6b1de1@assyoma.it>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 18, 2020 at 12:08:48PM +0100, Gionatan Danti wrote:
> Il 18-01-2020 00:42 Darrick J. Wong ha scritto:
> > How many fragments, and how big of a sparse file?
> 
> A just installed CentOS 8 guest using a 20 GB sparse file vdisk had about
> 2000 fragments.
> 
> After running "fio --name=test --filename=test.img --rw=randwrite --size=4G"

4GB / 1M extents == 4096, which is probably the fs blocksize :)

I wonder, do you get different results if you set an extent size hint
on the dir before running fio?

I forgot(?) to mention that if you're mostly dealing with sparse VM
images then you might as well set a extent size hint and forego delayed
allocation because it won't help you much.

--D

> for about 30 mins, it ended with over 1M fragments/extents. At that point,
> reflinking that file took over 2 mins, and unlinking it about 4 mins.
> 
> I understand fio randwrite pattern is a worst case scenario; still, I think
> the results are interesting and telling for "aged" virtual machines.
> 
> As a side note, a just installed Win2019 guest backed with an 80 GB sparse
> file had about 18000 fragments.
> Thanks.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
