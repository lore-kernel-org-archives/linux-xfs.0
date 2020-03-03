Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A80C3F2D1
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4118206E2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:08:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XMhUq91g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgCCQIg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 11:08:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbgCCQIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 11:08:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023G433u100377;
        Tue, 3 Mar 2020 16:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XaaISgWh6vVXeo5qXE9vze5jtU2ac6qX9LM7ClKjNz4=;
 b=XMhUq91gU1PtUCqzjUdvWpciQuqaXaXH7HNoHkRZvDcadXPgVZab659TwXJF2OB9/4uS
 dA6MWagNlx0qE0QPXKu4xWyADpDapnPad19hHK2UiydTBRrRk9pz+DRsKByGbMA60CLE
 td7vUvBgvWLxsMHTjstUSb7V5huqfJ4qiTYOi0aTRY7G/B8h9XtK2Gao3+cUQ1aO6KeL
 1PDZSlkpcjZerVtG9s3xxRyaAiCU9oL+W+dPfxozAixZ63unSoc7GSjaAc8nfOt7K56p
 a294++QZOtjD9wadfhsrEajTt3av5jRDcNMtXRYnDk2n9YKJOIeAAZWcvsWYWjfh+6CY JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yffwqr8ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 16:08:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023G33uw156107;
        Tue, 3 Mar 2020 16:08:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2yg1gxr8xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 16:08:30 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 023G8Suu032120;
        Tue, 3 Mar 2020 16:08:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 08:08:28 -0800
Date:   Tue, 3 Mar 2020 08:08:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: check owner of dir3 free blocks
Message-ID: <20200303160827.GZ8045@magnolia>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294092825.1729975.10937805307008830676.stgit@magnolia>
 <3a1406aa-10c2-733c-2fa1-cc6d064f0849@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a1406aa-10c2-733c-2fa1-cc6d064f0849@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030114
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 06:04:07PM -0600, Eric Sandeen wrote:
> On 2/28/20 5:48 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Check the owner field of dir3 free block headers.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Do we need a similar check in xfs_repair?

Yeah, working on that...

> Should this also check
> 
> hdr.blkno == bp->b_bn? ?

That's checked by xfs_dir3_free_verify.

--D

> > ---
> >  fs/xfs/libxfs/xfs_dir2_node.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > index f622ede7119e..79b917e62ac3 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > @@ -194,6 +194,8 @@ xfs_dir3_free_header_check(
> >  			return __this_address;
> >  		if (be32_to_cpu(hdr3->nvalid) < be32_to_cpu(hdr3->nused))
> >  			return __this_address;
> > +		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
> > +			return __this_address;
> >  	} else {
> >  		struct xfs_dir2_free_hdr *hdr = bp->b_addr;
> >  
> > 
