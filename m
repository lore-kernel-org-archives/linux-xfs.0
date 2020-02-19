Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B3DC34031
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 00:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E03B82465A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 00:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WzHGRFJd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgBSAiY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 19:38:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56530 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgBSAiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 19:38:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0VljY019900;
        Wed, 19 Feb 2020 00:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LZYuixXjZKJ8hrpCivOER95mmtkbXBn9SZY+SNrC2Co=;
 b=WzHGRFJd06cOititG5+AlHTKahcadv6dHhN43+qtp0XLbUhMrV5XVgdu123DLv0q1UBo
 HdchCMx1ofmGR10sVh5hR9qgX6x7CmgZHizXiekYpGRaX4OIQ5wIU21SzCGFyTwa+JwR
 OLIGSjhAcWc96y3PAj9jJ2FDE9QqA9+1b5qzh0PI3N1dbLtmFjX7opf1R3pjJZs0yErY
 dUnkHiLXA0VwcfntkopWTzL6f6cEKOy/GN6hqSFLEZQuSqJHD+EhyA0TYxxbdPW+TOKv
 BZO/6Pg/RHFKFSM3UX/8T0CJrSvsESEB5+bx2UXAdmhFTqzyYetPgwsgyhYLNZTvu6hM zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y8e1hn7sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:38:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0SSTn151998;
        Wed, 19 Feb 2020 00:38:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y82c2dbc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:38:18 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01J0cHwS020704;
        Wed, 19 Feb 2020 00:38:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 16:38:17 -0800
Date:   Tue, 18 Feb 2020 16:38:16 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 05/31] xfs: use strndup_user in
 XFS_IOC_ATTRMULTI_BY_HANDLE
Message-ID: <20200219003816.GC9506@magnolia>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-6-hch@lst.de>
 <20200217221538.GJ10776@dread.disaster.area>
 <20200218152432.GB21275@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218152432.GB21275@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=964
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 04:24:32PM +0100, Christoph Hellwig wrote:
> On Tue, Feb 18, 2020 at 09:15:39AM +1100, Dave Chinner wrote:
> > >  
> > > -		ops[i].am_error = strncpy_from_user((char *)attr_name,
> > > -				ops[i].am_attrname, MAXNAMELEN);
> > > -		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> > > -			error = -ERANGE;
> > > -		if (ops[i].am_error < 0)
> > > +		attr_name = strndup_user(ops[i].am_attrname, MAXNAMELEN);
> > > +		if (IS_ERR(attr_name)) {
> > > +			ops[i].am_error = PTR_ERR(attr_name);
> > >  			break;
> > > +		}
> > 
> > This changes the error returned for an invalid attr name length from
> > -ERANGE to either -EINVAL or -EFAULT. Can you please document that
> > in the commit message. This change requires updates to the 
> > path_to_handle(3) man page shipped in xfsprogs in the xfslibs-dev
> > package (xfsprogs::man/man3/handle.3) to document the differences in
> > return values.
> 
> I can't find that man page documenting -ERANGE at all..

Should we add both to the errors list, then?  Seeing as (I think?) the
kernel can actually return this...

--D
