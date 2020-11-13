Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3A4C2D0E4
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 00:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A16F22201
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 00:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mt3lp4pi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgKMAWX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:22:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48744 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgKMAWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 19:22:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD0K1DE048743;
        Fri, 13 Nov 2020 00:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pEdWsrC76FYTppmWd+vzRMUAov65nfE3/s7ArGyvO2k=;
 b=mt3lp4piyN1lu1uAiGAG9d9rauXgxB8bKrSNCX3FS9yypML3RxWVxapGI3fjhh31kDpu
 4sI6ASesbDPsWkBW2jrxz4Oja5k1SShfSVIhuaQuiRQfXfKy1JFUdOg4G3DQ6Os1hJhv
 oxAIV6nOzgD8prZMCH06dPQT2Ba93mRl804Fu9nm+4G/WxW2jvYuOR6jSfbozzcY58sC
 gXXIczVs75nGIUxvesit3MfiDgi675YTfkCiG26PbJuaYdnPdMpRLA3wk6LzZJNk+c2K
 eNbLVCjHSoFB3M+y9+YAH1fId4+Z0o3G83QQ2lNUmxT/u/To+ggOsqtCaxrFmYqQzgP9 cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3b8gkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 00:21:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD0FDCJ082268;
        Fri, 13 Nov 2020 00:21:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34rt56x31u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 00:21:25 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AD0LNQt029187;
        Fri, 13 Nov 2020 00:21:23 GMT
Received: from localhost (/10.159.255.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 16:21:23 -0800
Date:   Thu, 12 Nov 2020 16:21:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove the unused XFS_B_FSB_OFFSET macro
Message-ID: <20201113002122.GV9695@magnolia>
References: <1603169666-16106-1-git-send-email-kaixuxia@tencent.com>
 <20201027184708.GC12824@infradead.org>
 <cf86dd98-a6c8-20d1-b0fa-133731d9ea06@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf86dd98-a6c8-20d1-b0fa-133731d9ea06@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=761 suspectscore=1 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=775 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 12, 2020 at 10:44:25AM +0800, kaixuxia wrote:
> 
> 
> On 2020/10/28 2:47, Christoph Hellwig wrote:
> > On Tue, Oct 20, 2020 at 12:54:26PM +0800, xiakaixu1987@gmail.com wrote:
> >> From: Kaixu Xia <kaixuxia@tencent.com>
> >>
> >> There are no callers of the XFS_B_FSB_OFFSET macro, so remove it.
> > 
> > No callers in xfsprogs either.
> > 
> > Looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Hi Darrick,
> 
> There are some patches that have been reviewed but not been merged
> into xfs for-next branch, I will reply to them.
> Sorry for the noise:)

Yes.  AFAICT none of them are critical 5.10 bugfixes so they're all
waiting for 5.11.

--D

> Thanks,
> Kaixu
> > 
> 
> -- 
> kaixuxia
