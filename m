Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448DFC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 22:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B31B82064B
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 22:02:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kNkMRTIY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbgJPWC0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Oct 2020 18:02:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387923AbgJPWCZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Oct 2020 18:02:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GLoAln005903;
        Fri, 16 Oct 2020 22:02:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PF6rh6OqoHWMzx/StDciJinrnapFeyEmRN5e7X30620=;
 b=kNkMRTIYZHOfxLqIgEelcm3oqwzbGY8fJW23drgF3fmQOZr9BU9k233piykG34Hn/JPK
 z+EEaeeiSKnSYgn1QMm9SVQZD99BnCTuJHB4+HYFKGRxDgdBFfKnTJiyhf2uGYS5B/es
 5+i7QLclsW03u7GoTM+Qj/Yfwdsm3GDnX+rIg+deoYc4CrSyqkUWUxVR/oiEg2YLBQvS
 5i43DQPNBsmwKaVavXkeoOLLxU4FHe7mIxSzhz8a0xZ6STB9c4pu+e3r6jQOItgKxSZs
 ofOr/GEamHO9VJsxAfTHwQx59i+Mib+K5aAPBoLtbcfsiAO/+v6g1Z3jJNKvyCPAGugs Hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 343vaet8qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Oct 2020 22:02:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GLnf5D175655;
        Fri, 16 Oct 2020 22:02:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 344by74820-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Oct 2020 22:02:19 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09GM2IEW006952;
        Fri, 16 Oct 2020 22:02:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Oct 2020 15:02:18 -0700
Date:   Fri, 16 Oct 2020 15:02:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com
Subject: Re: [PATCH 2/2] xfs: fix fallocate functions when rtextsize is
 larger than 1
Message-ID: <20201016220215.GE9832@magnolia>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia>
 <160235127396.1384192.5095447151831725417.stgit@magnolia>
 <20201015075439.GI14082@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015075439.GI14082@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010160155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160155
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 09:54:39AM +0200, Christoph Hellwig wrote:
> I don't really like the xfs_inode_alloc_blocksize helper, given that
> it is very easy to be confused with the allocsize concept.
> 
> I'd just add a helper ala:
> 
> static bool
> xfs_falloc_is_unaligned(
> 	struct inode		*inode,
> 	loff_t			offset,
> 	loff_t			len)
> {
> 	struct xfs_mount	*mp = XFS_I(ip)->i_mount;
> 
> 	unsigned int blksize_mask = i_blocksize(inode) - 1;
> 
> 	if (XFS_IS_REALTIME_INODE(XFS_I(ip)))
> 		blksize_mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;

UGH the thing that I just noticed (and fstests doesn't seem to cover
given the number of them that sort of blew up) is the fact that the rt
extent size only has to be some multiple of the fs blocksize, not the
power-of-2 multiple that I mistakenly assumed.

Soooo none of this masking stuff actually works properly and I'm going
to drop this patch until I figure out how to do this properly, with a
bunch of fugly division and whatnot... I guess the silver lining is that
rtextsize can't be larger than 1G so at least I can probably use simple
division and not the div64 mess.

Self NAK.

--D

> 
> 	return (offset & blksize_mask) || (len & blksize_mask);
> }
