Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24721C34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D98F42465D
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wA0TXXV6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgBSEcW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 23:32:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgBSEcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 23:32:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J4VcmB166555;
        Wed, 19 Feb 2020 04:32:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=sSmGBO0Yphoa8Ze1nC6arLiYrDyarfpUnXn+zymxOvI=;
 b=wA0TXXV6W+FvYo/A2UELIXOIQAePxKqhf4f9/mQ74RAeQLAZjC9k1FDT7kWEwZjyXj7G
 IT/wLValnaAxLpi6PhxhdG/K/IWrKdVZrlqqVD+UBkbd20J2+pLRjmC3p1Ik9W6Ysye/
 2PEjTwfhF4Qa/Mh88GOv8ugSlW9q9q9+hHkjif6z7d2dHP29uk04LepAIIgcPQnviPL+
 mYkjpXbmGAm7GLpnAPMxsdqH5vLj3rVGLkmRkkQ7VuoDBEIZZydiU+PnACfdm/V8/Gz9
 M7bxefazLCbujJlIP7lSLtSKBJRT6lM5dOSLXPU3x2TkAvwH+3NeXanPACUUnNIy6B2w lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y8udd0fe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 04:32:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J4SFaX024937;
        Wed, 19 Feb 2020 04:32:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2y8ud9pkp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 04:32:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01J4WELY024375;
        Wed, 19 Feb 2020 04:32:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 20:32:14 -0800
Date:   Tue, 18 Feb 2020 20:32:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 1/7] xfs_repair: replace verify_inum with libxfs inode
 validators
Message-ID: <20200219043212.GH9506@magnolia>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086360402.2079685.8627541630086580270.stgit@magnolia>
 <20200217135001.GE18371@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217135001.GE18371@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=741 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=803 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190029
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 05:50:01AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 04, 2020 at 04:46:44PM -0800, Darrick J. Wong wrote:
> > This fixes a regression found by fuzzing u3.sfdir3.hdr.parent.i4 to
> > lastbit (aka making a directory's .. point to the user quota inode) in
> > xfs/384.
> 
> Is that a bug or a regression?  If the latter, what commit caused the
> regression?

Eh, it's a bug found by a fuzzer fstest, so I guess this should be
reworded somehwat:

"This fixes a bug found by fuzzing..."

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
