Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D09EC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 21:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8EF4229C7
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 21:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgLDVOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 16:14:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgLDVOv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 16:14:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4L9AZN057745;
        Fri, 4 Dec 2020 21:14:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ySpDoLNVpP80sKRP2bZkhD41X8Ok9mVnHjsdxkRuWgE=;
 b=bVjQ7EtzITHMiWZFKfTV94mA0gi0//pR0Y7p5uWBw64OPmcnks/bD+ZpKSBFpUbLxC+t
 vxR3SGZGNCEcespbx8RJruO99DthUGRPPnF3GHknlDBmQ1VS7Ql3JifTNDQsPs2HgWQd
 lJsXKx8nipCzsoRp/ESbYSRjf2w89vMMq3trN7r7QxRXRO3kBi/3Lz0c38gxLIodi/lg
 eQCmz7HP7THckp5U8Ko3aw5NML5zTezCT34TU9PjDbd07ObhQiFkFOyPXEgue8r5pepB
 TnbizbnSKqUse2BiQ+yEVFy2K5v29v/vcvHDbCzcOTp7JghOwoQ9HNy7ooDoqrah/O6C Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egm53xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 21:14:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4LAOMS056963;
        Fri, 4 Dec 2020 21:12:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540f3u029-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 21:12:08 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B4LC7kh022671;
        Fri, 4 Dec 2020 21:12:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 13:12:07 -0800
Date:   Fri, 4 Dec 2020 13:12:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move kernel-specific superblock validation out
 of libxfs
Message-ID: <20201204211206.GE106271@magnolia>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679384513.447856.3675245763779550446.stgit@magnolia>
 <d54542e0-728f-52b4-3762-c9353fcae8de@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d54542e0-728f-52b4-3762-c9353fcae8de@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 02:35:45PM -0600, Eric Sandeen wrote:
> On 11/30/20 9:37 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > A couple of the superblock validation checks apply only to the kernel,
> > so move them to xfs_mount.c before we start changing sb_inprogress.
> > This also reduces the diff between kernel and userspace libxfs.
> 
> My only complaint is that "xfs_sb_validate_mount" isn't really descriptive
> at all, and nobody reading the code or comments will know why we've chosen
> to move just these two checks out of the common validator...
> 
> What does "compatible with this mount" mean?

Compatible with this implementation?

> Maybe just fess up in the comment, and say "these checks are different 
> for kernel vs. userspace so we keep them over here" - and as for the
> function name, *shrug* not sure I have anything better...

_validate_implementation?  I don't have a better suggestion either.

--D

> -Eric
> 
