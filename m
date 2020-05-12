Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADECDC2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7D720753
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:44:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="se9+/v3H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgELXoj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 19:44:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42194 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELXoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 19:44:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNbYSm034179;
        Tue, 12 May 2020 23:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=myrQhpybV65S4yloMr2XUypUAbKhYCms/Sjx7MMzIW8=;
 b=se9+/v3H27n19RpGb+xws2YbgGxGIomZqwogSv73Ju5uIoZXxUiK9/ntylhj8ksLyKAX
 84at1t/YElwVIeIVH9XWR2gqDLu3733Gr4mxLv7YSMlnOt8eN1mmzNyFBTxtKmptFu+i
 No9mAD5/RzBtgn64fOLkUlzCxTzEul7VieX+OVSnv1MiHHvlDbzkTw7awIelVb7CeetH
 6NSZ+crhazxfL98k0lJT/K7ToLHrPq9WXgre7OluowP881XjJFSU3sXm9LHVlD6LjN8I
 YQF/XZ8xAjwwK0r1UUj9PGOsojnrLkvmCmdZMxJRpTJWB0oL6j9KPGZejeCRZ/RtTexA mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3100xw98pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 23:44:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNgQjL073702;
        Tue, 12 May 2020 23:42:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3100yjtuhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 23:42:34 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CNgY5w001703;
        Tue, 12 May 2020 23:42:34 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 16:42:33 -0700
Date:   Tue, 12 May 2020 16:42:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: actually account for quota changes in
 xfs_swap_extents
Message-ID: <20200512234233.GR6714@magnolia>
References: <158864100980.182577.10199078041909350877.stgit@magnolia>
 <158864102885.182577.15936710415441871446.stgit@magnolia>
 <20200506145728.GC7864@infradead.org>
 <20200506163424.GT5703@magnolia>
 <20200507060205.GA3523@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507060205.GA3523@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005120176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 11:02:05PM -0700, Christoph Hellwig wrote:
> On Wed, May 06, 2020 at 09:34:24AM -0700, Darrick J. Wong wrote:
> > On Wed, May 06, 2020 at 07:57:28AM -0700, Christoph Hellwig wrote:
> > > On Mon, May 04, 2020 at 06:10:29PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Currently, xfs_swap_extents neither checks for sufficient quota
> > > > reservation nor does it actually update quota counts when swapping the
> > > > extent forks.  While the primary known user of extent swapping (xfs_fsr)
> > > > is careful to ensure that the user/group/project ids of both files
> > > > match, this is not required by the kernel.  Consequently, unprivileged
> > > > userspace can cause the quota counts to be incorrect.
> > > 
> > > Wouldn't be the right fix to enforce an id match?  I think that is a
> > > very sensible limitation.
> > 
> > One could do that, but at a cost of breaking any userspace program that
> > was using XFS_IOC_SWAPEXT and was not aware that the ids had to match
> > (possibly due to the lack of documentation...)
> 
> I don't really expect that to be the case.  I'd throw in the check
> and a printk_once warning, and I bet a beer at the next conference
> (if there ever is one :)) that no one will trigger it.

<shrug> I guess I can at least see if fstests fails if you don't allow
swapping between extents with different [ugp]ids, but this really feels
like cutting corners off the quota functionality... :P

--D
