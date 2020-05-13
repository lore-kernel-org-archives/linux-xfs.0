Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E2BC2D0FA
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 13:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6C6223E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 13:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D48OsAb0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387921AbgEMNjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 09:39:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46136 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388387AbgEMNjQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 09:39:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DDXcSw023838;
        Wed, 13 May 2020 13:39:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PvexMS2meS82OY541i238cspkD4E+hVHPZqNSlfraF0=;
 b=D48OsAb0cBVXdDoRrY/h8Tjk6+jhks0Jo3EhzVjqTlIiExu1AxLS2LncYUqDHwR4jEHN
 40sDIMjS5XEUEliOxxxFM+dm+mVOcqhInghzT0YHiN9jdoEFSUNkJ8HEcVaeI2v04SmQ
 SH+YdcOw6JPxMxgZb/HNsb9M/fdvD2pQEPkz1tT21SzXUYFGXcyjG15+J0oC3FffRVh3
 D3Z73QAh4TDb6LM5L2f/dsDAgmjibHN8h369mjemIoGrc7EFN3U4c9g0dZoPe1EPw8uJ
 BCBDek7BFANkg9GxMQegQJHAPRhVEj5nfqVQf3bOXg10xhk6iNEDLYxk1jYvCebKLaFs Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3100xwc82c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 13:39:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DDYXaa036264;
        Wed, 13 May 2020 13:39:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3100ym3sbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 13:39:12 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04DDdBd3004555;
        Wed, 13 May 2020 13:39:11 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 May 2020 06:39:10 -0700
Date:   Wed, 13 May 2020 16:39:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: fix error code in xfs_iflush_cluster()
Message-ID: <20200513133905.GB3041@kadam>
References: <20200513094803.GF347693@mwanda>
 <20200513132904.GE44225@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513132904.GE44225@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005130121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Oh yeah.  You're right.  This patch isn't correct.  Sorry about that.

I worry that there are several static analyzer's which will warn about
this code...

regards,
dan carpenter

