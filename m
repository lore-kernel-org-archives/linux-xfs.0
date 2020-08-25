Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20D3C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 22:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D18E206EB
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 22:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R/7Tol5i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHYWSs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:18:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46070 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgHYWSr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 18:18:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PM9nNO171494;
        Tue, 25 Aug 2020 22:18:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+sr3hUKnzuHbS5ZpQN25AWHoIXmqmeAytVcFuZ9ixMY=;
 b=R/7Tol5iLiHAwmPjcC4YJNKBGHF1MImaKOnUIehP+zwNEqrSTuSYR8bZidrgugIGI6gc
 t5kZOgV7ck6VEVQkOx50GW2d5kuAvpY0Rsi0wPDL3TM+xmQ+r2c+l1Hzeu6AGkKbPjOu
 R02IxUHk7C3LdnxYBnR1khYfBEMLW9krCHnJlLu9ozodHhD9JF8gEolGoP1aXTnIFZ0X
 3kwrzbr9dDTT9Wviz5UQv6pSEDiMxPaRASmtUkBl9Rie7EkFV2D6WAdGjoHTgzq022oQ
 drO8mSuWRt4OeKnsvYrkfbGiF9QYQYVFCB7ojQ972spRCuuXWny286j2l9E+oBVc38/7 gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 333dbrw7d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 22:18:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PMBJWG189974;
        Tue, 25 Aug 2020 22:18:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 333r9k4x0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 22:18:44 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07PMIh3V004780;
        Tue, 25 Aug 2020 22:18:43 GMT
Received: from localhost (/10.159.234.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Aug 2020 15:18:43 -0700
Date:   Tue, 25 Aug 2020 15:18:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: "signed < sizeof()" bug in xfs_attr_shortform_verify() ?
Message-ID: <20200825221842.GR6107@magnolia>
References: <20200825211048.GA2162993@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825211048.GA2162993@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9724 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9724 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 12:10:48AM +0300, Alexey Dobriyan wrote:
> xfs_attr_shortform_verify() contains the following code:
> 
> 
> 	int64_t size = ifp->if_bytes;
>         /*
>          * Give up if the attribute is way too short.
>          */
>         if (size < sizeof(struct xfs_attr_sf_hdr))
>                 return __this_address;
> 
> 
> In general "if (signed < sizeof())" is wrong because of how type
> promotions work. Such check won't catch small negative values.
> 
> I don't know XFS well enough to know if negative values were excluded
> somewhere above the callchain, but maybe someone else does.

The initial allocations are always positive and the subsequent
xfs_idata_realloc are checked to prevent if_bytes from going negative,
but it does seem funny to me that if_bytes is declared int64_t...

--D
