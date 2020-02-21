Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032B3C35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA2A22073A
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UhXwNTta"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgBUQPi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 11:15:38 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36312 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbgBUQPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 11:15:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LGEGgF152595;
        Fri, 21 Feb 2020 16:15:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tOlaXPWIJ21IPttA4HXvKx7zo6BJfKOu/ZN4KJoBrSw=;
 b=UhXwNTtabpcVH2oD9lQkkZgPEDKgBwXgY+UowXXWotobEuniotLETbVehxmE1FGOE4iC
 hj38m/Mo9cvQYAaTv4ZTN/iYRzt2pAp9R9xt3CuzrPnyMHblO7IH4g9zbjrUT0uDW7P+
 9SGCSeX5Sqhi9D6hqe1bJQCOtbXca2r/Ut4KLtNd/zYoBX+zRdYXi5MihZpj8vSNkx6m
 RfjkdmznlulBLmbjcl9KOH+9g7QR/nNNVLyHo05odUekOduR6GdImZY+P+mEOLgkYuWf
 SR/ucJFgawxk9QbBlnXNRZXMQ4g7AOc5jTD30ZS/vNLxVoJrMp7kIXCa0X2pcv4YCPt/ WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y8ud1het0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 16:15:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LGBtl5194354;
        Fri, 21 Feb 2020 16:15:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2y8udnpky0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 16:15:33 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01LGFWil023504;
        Fri, 21 Feb 2020 16:15:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 08:15:31 -0800
Date:   Fri, 21 Feb 2020 08:15:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] libxfs: make libxfs_buf_read_map return an error
 code
Message-ID: <20200221161530.GX9506@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
 <158216310149.603628.17465705830434897306.stgit@magnolia>
 <20200221150339.GU15358@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221150339.GU15358@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 07:03:39AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 05:45:01PM -0800, Darrick J. Wong wrote:
> > @@ -1050,15 +1083,26 @@ libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
> >  				flags);
> >  	else
> >  		error = libxfs_readbufr_map(btp, bp, flags);
> > +	if (error == -EIO && salvage)
> > +		goto ok;
> 
> I understand the part about skipping the verifiers.  But how does ignoring
> EIO in this case fir the scheme?

"Salvage" mode means that the caller wants an xfs_buf even if the
contents are invalid or missing due to EIO.  This is useful for db and
repair because we can fill the buffer with fixed or new metadata and
write it back to disk.

On a practical level this means I don't have to amend all callsites:

	err = libxfs_buf_read(...LIBXFS_READBUF_SALVAGE..., &bp);
	if (err == -EIO)
		err = libxfs_buf_get(..., &bp);
	if (err)
		goto barf;

...since EIO doesn't seem that much more special than EFSCORRUPTED.

--D
