Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594BEC34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 05:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25A0F208C4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 05:42:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CuSMY/tI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgBSFmc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 00:42:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40066 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgBSFmc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 00:42:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J5W6oU086636;
        Wed, 19 Feb 2020 05:42:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=047H1yKl0jgd0eYU8C7MUC0DME5uIKLmOxTAteEaEh4=;
 b=CuSMY/tIzky2DLP/TxG4U1RhtoxGJqOpnui/B1UNw6WfDAiyHa7iXjsOL9gG6N92ZiWi
 bYdR1loYkhqS7p/j/Ic68/HlL5h8IVEiu/HB3o7yDhFNVUVmhhxCB7VduALMmaP2Uj8D
 dbtRRGOwXrtpM+WSIVab9G602QM6fbkpfjWZt4/c7zDoUnVUbeMa7CtRlDz4PRWLSQjM
 w0E9t+v/RCO3qUghoAjFx/ekP5+wYPK9DLYrfL99ertlXJCf0Ki78aDQSCKeSx+lsHOt
 99Uxmg/i+zkkGgDn00Ud8RAv5Ev3Vs701fmuWxevkDepA3nSiMtDPe9wNxQ+OX18s+We og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y8ud10pc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 05:42:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J5gPh3036931;
        Wed, 19 Feb 2020 05:42:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y8ud9s40c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 05:42:25 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01J5gNPj013319;
        Wed, 19 Feb 2020 05:42:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 21:42:23 -0800
Date:   Tue, 18 Feb 2020 21:42:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libxfs: libxfs_buf_delwri_submit should write
 buffers immediately
Message-ID: <20200219054222.GL9506@magnolia>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086365123.2079905.12151913907904621987.stgit@magnolia>
 <20200217135711.GL18371@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217135711.GL18371@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=995 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190037
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 05:57:11AM -0800, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But can we come up with a better name and description for
> libxfs_writebufr? and libxfs_writebuf?

I'll fix both of those warts in the next cleanup series, for which I'm
running one more overnight fstests run.

In the meantime, thanks for reviewing these three series!

--D
