Return-Path: <SRS0=1MH2=27=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24807C282DD
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 16:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E68ED20673
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 16:54:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jn0vcvgH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgAJQyI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jan 2020 11:54:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36530 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728564AbgAJQyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jan 2020 11:54:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AGiDOP018288;
        Fri, 10 Jan 2020 16:53:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ZYm/VheIuqMQdGX1yZBTdFNcnZdEXeHm6pUbi9eJkB4=;
 b=jn0vcvgHwOe4vQxnlKIbREhCxMggVFfSDrZgoWVLLUIScPKEEDBetMY2tzyj4G7iMYtG
 fbZR/Peak7CQ1MpM+7fFnrUeBCV5bzi9hMtSdhkgalqw0If4MqXycjrmEq5Wk6Rv1+i0
 qlNO3NDVaWObduVy/XhAH2fwzl/oEW3xf/+eomSrBdxepoyymJfHD4okmogPSU2ZUMCK
 +A8AkOhPIFlO4gTyXb02nDwN9NGRuax5fgEhkHJvyqCIQX1qCm3eUSlSZhVMZzfoX1ta
 nj0ubbeZYcW+3Jz6+nM0AmeEEx9dirBayQ9BOq1cBhNlUBOQJ30AXy8xaQO4PkpAyL1S Ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xaj4ukhnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 16:53:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AGiB8V091910;
        Fri, 10 Jan 2020 16:53:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xekkvbjm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 16:53:51 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00AGro4V013986;
        Fri, 10 Jan 2020 16:53:50 GMT
Received: from localhost (/10.159.152.15)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jan 2020 08:53:50 -0800
Date:   Fri, 10 Jan 2020 08:53:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: make struct xfs_buf_log_format have a
 consistent size
Message-ID: <20200110165348.GD8247@magnolia>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
 <157859551417.164065.16772455171549647070.stgit@magnolia>
 <20200110115938.GG19577@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110115938.GG19577@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 10, 2020 at 03:59:38AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 09, 2020 at 10:45:14AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Increase XFS_BLF_DATAMAP_SIZE by 1 to fill in the implied padding at the
> > end of struct xfs_buf_log_format.  This makes the size consistent so
> > that we can check it in xfs_ondisk.h, and will be needed once we start
> > logging attribute values.
> 
> Isn't this an incompatible change in the on-disk format for 32-bit
> systems?

AFAICT it isn't, because log recovery reads the on-disk log op head to
figure out the length of the log iovec, allocates that much memory for
the log buf, reads in the contents, and then casts i_addr to
xfs_buf_log_format.

On the log writing side, the logging code takes the buffer item and
writes out whatever's in the incore structure, assuming that the incore
structure is actually large enough to cover data_map[map_size - 1].

(Someone else might want to check that to make sure I haven't gone mad
from looking at the log code... :P)

--D
