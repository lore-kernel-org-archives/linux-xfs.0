Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC1AC4BA15
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 16:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50700206E6
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 16:27:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nZWwbPim"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgBZQ1k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 11:27:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgBZQ1j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 11:27:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QGN3fg065686;
        Wed, 26 Feb 2020 16:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tDlV7fD5JZT0/vjPwmWg/rBunqqwwDkOUxjmWB33Z3I=;
 b=nZWwbPimuzWoUlhJ5/8KCyatxW1qu7rw8SjMrhRUsVCwRI3Prrb9FjJPnJBio2dC87AN
 ft6Wa40RcPWt9xUKKJaQC3LfrlgVEcpZjdWfkB2Bq/M86TpR0Svo7d0pA4HQKaqqt2uA
 VGuSOY9kUd/NzFwZSUMxNNma132+EO8HkbdBBZOEZf9grkdZumVGgqNnLQMiFm14phgk
 mzR7MZHQVqYkyC3pjU91LJLCd4VBsnZ5ciUtsl+uIasGPW9Pg9Pm4GiayX28rl8zq0PK
 LEOAFKt3u4JW81kdIZ+jV+ctSleoFqPkNlg5MHGrztXiBkXR6pi4oyKgvlTGNH62/fxE 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ydct34saj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 16:27:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QGMKvD017844;
        Wed, 26 Feb 2020 16:27:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ydcs5dybv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 16:27:34 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01QGRXQP010140;
        Wed, 26 Feb 2020 16:27:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 08:27:33 -0800
Date:   Wed, 26 Feb 2020 08:27:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: clean up the attr interface v6
Message-ID: <20200226162732.GB8045@magnolia>
References: <20200225231012.735245-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225231012.735245-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 03:09:42PM -0800, Christoph Hellwig wrote:
> Also available as a git tree here:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-attr-cleanup.6
> 
> An xfsprogs tree porting over the libxfs changes is available here:
> 
>     http://git.infradead.org/users/hch/xfsprogs.git/shortlog/refs/heads/attr-cleanup
> 
> 
> Changes since v5:
>  - don't move xfs_da_args

Still looks fine to me...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Changes since v4:
>  - rename the attr_namespace field to attr_filter
>  - drop "properly type the buffer field in struct
>    xfs_fsop_attrlist_handlere", this was causing too much discussion for
>    a trivial cleanup
>  - improve a few commit messages and comments
>  - improve the ATTR_REPLACE checks a little more
>  - turn the xfs_forget_acl stub into an inline function
>  - fix a 0 vs NULL sparse warning in xfs_ioc_attr_list
> 
> Changes since v3:
>  - clean up a cast
>  - fixup a comment
>  - fix a flags check to use the right flags (bisection only)
>  - move a few hunks around to better spots in the series
> 
> Changes since v2:
>  - add more comments
>  - fix up an error handling corner case in __xfs_set_acl
>  - add more cowbell^H^H^H^H^H^H^Hbool
>  - add a new patch to reject invalid namespaces flags in
>    XFS_IOC_ATTRLIST_BY_HANDLE
>  - remove ATTR_ENTSIZE entirely
> 
> Changes since v1:
>  - rebased to for-next, which includes the fixes from the first
>    version
