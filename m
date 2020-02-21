Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6DBC35669
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 22:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D2F724656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 22:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g7ke4hox"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgBUWNZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 17:13:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgBUWNZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 17:13:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LM8AUD077343;
        Fri, 21 Feb 2020 22:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=otYAWifPLsf1ZaSO6GxqlzVY3N7Kiz3nF1ldHREt5k8=;
 b=g7ke4hoxrqYo23q7Th3tw7fqN0/E2GTkM4S/prwxXZrM1A/4/U36bn445/zR9AkwIOG8
 peIjTnF40OMdIN/1ckloai0END3nxAyL3eQGh3oLvm5x4hMCqL+PUsGyQ8NxHvoBX0iC
 xIGbefUzovOhj6V44zp8AqNQNDMyo5Ib03R9Rk2ppCg+CnC8yweTzw85PyAvBsLTyAAj
 XbU5LKh3raZeIoQ4lwEAlQIWTMFFHNQyCravlx03B2Bqg98CzM7LBaPvAfqvoTb2ehWg
 ymiVaPvLX5MPSqT6iadA+CdAQzQRgpaNEd53KgY/v2pA6+QU2tT+jLDqcO7EeRH9TWtf 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2y8udku6ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 22:13:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LM8odF157900;
        Fri, 21 Feb 2020 22:13:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2y8udqqkd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 22:13:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01LMDIxg023642;
        Fri, 21 Feb 2020 22:13:18 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 14:13:18 -0800
Date:   Fri, 21 Feb 2020 14:13:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/14] libxfs: refactor libxfs_readbuf out of existence
Message-ID: <20200221221317.GC9506@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
 <158216309405.603628.3732022870551516081.stgit@magnolia>
 <20200221150001.GT15358@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221150001.GT15358@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=836
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=910 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 07:00:01AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 05:44:54PM -0800, Darrick J. Wong wrote:
> > +	/*
> > +	 * if the buffer was prefetched, it is likely that it was not validated.
> 
> Please capitalize the first character in multi-line comments.

Will fix.

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
