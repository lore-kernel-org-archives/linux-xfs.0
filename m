Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99542C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CE0B214E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:09:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pRtm6PMq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKLQJ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:09:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfKLQJ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 11:09:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACG4KBm110698;
        Tue, 12 Nov 2019 16:09:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=2yv+/sIJLa+/SHoiilLrOjsmIGrpt8lokyxjMLzn5u4=;
 b=pRtm6PMqre+d1ZOl6am9rcbi1QzZwUhmzdfHpEB1y6VLwAMXl4ukGaktg/C+oAMQOrXy
 8DMpCcfzCaBTCGlilwUQK6fI3qF5JHML6yuQsoRfK1mLBzchuzM+oP4+S4emgOXPlZJv
 R5YMwC58NwNYkk2c56t4IyGSoTjP/z2LeRoAbuSAusZJjzfp7/mfEIA25gByEbTasACf
 J38ziYKVL+h0OmYrxJ/+sLyb2Qz0sXJIwscw1dhCYMiiDpVTpFe4Cn4IoGXttwIBJW5d
 DY2OW1+vvKO6XtxpjT7KRZ2cw89+IAYJ3JmB5XosLhpKeAqm/vSIYwfxOOTtjUhUi3b4 gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5p3qnshq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 16:09:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACG4niX161153;
        Tue, 12 Nov 2019 16:09:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w7khkj08w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 16:09:17 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xACG9Eko029289;
        Tue, 12 Nov 2019 16:09:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 08:09:14 -0800
Date:   Tue, 12 Nov 2019 08:09:13 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
Message-ID: <20191112160913.GW6219@magnolia>
References: <20191111213630.14680-1-amir73il@gmail.com>
 <20191111223508.GS6219@magnolia>
 <20191112082524.GA18779@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112082524.GA18779@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=995
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 12:25:24AM -0800, Christoph Hellwig wrote:
> On Mon, Nov 11, 2019 at 02:35:08PM -0800, Darrick J. Wong wrote:
> > Also, please change struct xfs_inode.i_crtime to a timespec64 to match
> > the other three timestamps in struct inode...
> 
> Or you could just merge my outstanding patch to do just that..

I must've missed it, got a link?

/me digs...

--D
