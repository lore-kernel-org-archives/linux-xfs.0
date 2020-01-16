Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730A2C33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 23:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FB87207FF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 23:16:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cnAy3ckN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389740AbgAPXQM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 18:16:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38338 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389031AbgAPXQM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 18:16:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GNCdEv103301;
        Thu, 16 Jan 2020 23:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8FSRmGRWsfvT5yENbg0G6JvBkTqttQUQhw/r9pg0uYI=;
 b=cnAy3ckNTjejp2tDT59KfD6LYfXIh4ch1ylY16vuVeTQ7Tt0q3GgEKfMedWqd1xMZPBG
 zwfrCkbV9bhPZa0GNxg9ytVm1Rrqp1H3zggKTvXrBrUz3C9psKF4LqO8Ag/Noqeyy5Fg
 havmtEC7Y+UZRIvtQLx6rpYvZo3uWviUu27HRww0DdLU6CPUs/9Iq0WQ7MmPCzp+iOTK
 +jYNlnD38bqBZpqxznabXA6wx94+q/onbnT/8DjKnFCtp8OHPdw0BUIbGEu1qu0ZJqZZ
 eIrl14f3Lx2kwDfq2NFaBx77qdGhftU+dcCQrLwS3TwZK8S+DvW1yg9oD9+xW1GqqVRU Bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xf74snks8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 23:16:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GNFGek086488;
        Thu, 16 Jan 2020 23:16:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xj61ndaqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 23:16:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00GNG4C5019015;
        Thu, 16 Jan 2020 23:16:04 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 15:16:03 -0800
Date:   Thu, 16 Jan 2020 15:16:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200116231601.GM8247@magnolia>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <157915535059.2406747.264640456606868955.stgit@magnolia>
 <20200116164741.GA4593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116164741.GA4593@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 08:47:41AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 15, 2020 at 10:15:50PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When writing to a delalloc region in the data fork, commit the new
> > allocations (of the da reservation) as unwritten so that the mappings
> > are only marked written once writeback completes successfully.  This
> > fixes the problem of stale data exposure if the system goes down during
> > targeted writeback of a specific region of a file, as tested by
> > generic/042.
> 
> I think this is the only safe way to deal with buffered I/O into
> holes, so:

Ditto.  Thanks for reviewing things!

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
