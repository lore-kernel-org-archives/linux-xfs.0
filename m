Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EBFC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 17:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E76F6218AC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 17:12:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bKd8BnYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731173AbfJIRMW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 13:12:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44272 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731433AbfJIRMW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 13:12:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99H4RRg042492;
        Wed, 9 Oct 2019 17:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=D4ahQEa/3t7Vqczl0GG7OBaPn9wEXOpVUYF/xsTU20A=;
 b=bKd8BnYRSWqER8g5IqufuZVLV802nfphh27t2+XxSYmCHFbpLwbSc6FpmwFlMWdf7hXk
 2yEtCe3OGKV7uzoChJZqFZ2XExzaXLKPmQpnRnVmqAHSMRYdJjzzBgz8srQxYHpQ+ahq
 w2me6MDEGYOVFL32hsWoSBdirHCLRCQTJn92Qb9JpTSZbWi/iqiEV4lE6/aMGmk7GbmU
 jG/8Usa9cTzrTlq3GCTDZnUYHMaSdTldfLDyiLAWrXxb5AsDMQSvMjRFsyUwIVbjxQvt
 Nh7YNO01hlG0o3aaS9kxjTjfKjQC5+/7JHZqYxCLKd9jwzk9eab9//tpOerSohV4PVrn +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vektrnvmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Oct 2019 17:11:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99H42uk196304;
        Wed, 9 Oct 2019 17:11:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vh8k15e76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Oct 2019 17:11:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99HBswv025543;
        Wed, 9 Oct 2019 17:11:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 10:11:54 -0700
Date:   Wed, 9 Oct 2019 10:11:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>,
        linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org, rgoldwyn@suse.de,
        gujx@cn.fujitsu.com, david@fromorbit.com, qi.fuli@fujitsu.com,
        caoj.fnst@cn.fujitsu.com
Subject: Re: [RFC PATCH 0/7] xfs: add reflink & dedupe support for fsdax.
Message-ID: <20191009171152.GF13108@magnolia>
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
 <20191009063144.GA4300@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009063144.GA4300@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=843
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=930 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 08, 2019 at 11:31:44PM -0700, Christoph Hellwig wrote:
> Btw, I just had a chat with Dan last week on this.  And he pointed out
> that while this series deals with the read/write path issues of 
> reflink on DAX it doesn't deal with the mmap side issue that
> page->mapping and page->index can point back to exactly one file.
> 
> I think we want a few xfstests that reflink a file and then use the
> different links using mmap, as that should blow up pretty reliably.

Hmm, you're right, we don't actually have a test that checks the
behavior of mwriting all copies of a shared block.  Ok, I'll go write
one.

--D
