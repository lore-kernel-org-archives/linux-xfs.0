Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D754EC11D24
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 04:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9F93207FD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 04:41:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wxKIwQJS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgBUElR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 23:41:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55382 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729229AbgBUElQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 23:41:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01L4bTw1092159;
        Fri, 21 Feb 2020 04:41:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CNikVF1F9aRj0qsSyGByTc5/A+gEGMmZ5eMAuTc6yPc=;
 b=wxKIwQJSlsGd6KApduQf6Qm6WS0GqVK4DlcvSiMD5Y0BEZsEc5RMGFqnRTDRjFNeN8hu
 6eojKEHSkEGRUinM4G2fof0YLZa2KyJr29rfpfDpZgPDDVD21XSUIHMDKXVa07N3LLVV
 kHyyfVUjEpL6DjTcxOCmqqEzWzz9qLOrSyL7xSkRgL8nC+ICbx5BksFCQoMO1R+JbEtW
 uJuSmtz09rZXJDKDn0/O+eiiWyS0g8hyybWYEiuEe1snox0U5Xx6cpKyWDlIqUDtbW1I
 TsJ2vRPy/wYVqPSoFp+Ft3a+T4x0bL5+LaR4bzW7ocDPIUuP+VdEf+6rm+wrDiRFIvor 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2y8udkpba1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 04:41:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01L4bl20177913;
        Fri, 21 Feb 2020 04:41:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2y8ud5j7my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 04:41:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01L4f6Jt027771;
        Fri, 21 Feb 2020 04:41:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 20:41:05 -0800
Date:   Thu, 20 Feb 2020 20:41:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: reduce dmesg spam v2
Message-ID: <20200221044105.GG9506@magnolia>
References: <20200220153921.383899-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220153921.383899-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=835 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=910 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:39:19AM -0800, Christoph Hellwig wrote:
> Hi all,
> 
> When a device keeps failing I/O (for example using dm-flakey in various
> tests), we keep spamming the log for each I/O error, although the
> messages are very much duplicates.  Use xfs_alert_ratelimited() to reduce
> the number of logged lines.
> 

This series looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Changes sinve v1:
>   - use xfs_alert_ratelimited
