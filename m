Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932B5C34031
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 00:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6278424654
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 00:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ESYvszIH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgBSAud (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 19:50:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43282 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgBSAuc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 19:50:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0WF9M124911;
        Wed, 19 Feb 2020 00:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZRtHjeh3ARen1amEnYjyuqTRNXk4ABsNjDC6ojyl0YA=;
 b=ESYvszIHy85FYuq4iEb2cplfN6bRhqumI/uODQVqnwAJ89ieMnkLTKUAG7ZLyV+MeHtw
 aeLzlEny0vooa03lmJrRJSy25P2cIPNa7DP/q4PVLeEjSHol0YZbp+77VjsD2WM7wI2a
 649EUYQf+lfuQWKI85k+6DQqCVLDabbPiarna/++YeCsaJlTwDBO94ta8sVv3Ik7zFBc
 El9+6Cnid9R2U+buN2taBIzhudtKmZbdjozwfmruCccp4IwIrjc0ubFqDKA2Oc/aPLFx
 MsJieJppsGv2lbXBXSP2UESYk4v7B810XLp20F4GamJ2LRg+AW4N9w486SQcAsVa2QRq VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y7aq5w0mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:50:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0SEgM059306;
        Wed, 19 Feb 2020 00:48:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2y6tc3ecec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:48:29 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01J0mSR9008420;
        Wed, 19 Feb 2020 00:48:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 16:48:27 -0800
Date:   Tue, 18 Feb 2020 16:48:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: clean up the attr interface v4
Message-ID: <20200219004824.GE9506@magnolia>
References: <20200217125957.263434-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=747
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=801 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:26PM +0100, Christoph Hellwig wrote:
> Also available as a git tree here:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-attr-cleanup
> 
> An xfsprogs tree porting over the libxfs changes is available here:
> 
>     http://git.infradead.org/users/hch/xfsprogs.git/shortlog/refs/heads/attr-cleanup

Oooh, Darrick like!

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

MOOOOOOOOOOOOOOOOOO! :)

--D

>  - add a new patch to reject invalid namespaces flags in
>    XFS_IOC_ATTRLIST_BY_HANDLE
>  - remove ATTR_ENTSIZE entirely
> 
> Changes since v1:
>  - rebased to for-next, which includes the fixes from the first
>    version
