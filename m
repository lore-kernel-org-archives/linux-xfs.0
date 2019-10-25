Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B456DCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8276C21872
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:21:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iF426s5i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404889AbfJYRVc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 13:21:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52988 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388862AbfJYRVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 13:21:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PHIvB3167882;
        Fri, 25 Oct 2019 17:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=lMnqtVc/KoxaP1SXmYyPMIONV6L5Cjrix4ceXkz5F1Q=;
 b=iF426s5iNk4o0zFcxTZga0M5EK3Z5Cawc8K4eIXcWkoXuxdvJFFqe5Ozrj7XuguCGwI2
 r1HdxGcu+JnE1F4ujIqCVy4M/ccGbEwCo5ZrdpG3NfcF2CF6U4H6pS6a9DsamcsX8nVL
 LirrDCGAlHK3VpLdRtpEmSXnO2MHV3WbXonnV+r8Ps1HyXZ4xGP6LouH++PB8FlxRFOQ
 Bmh+xgXnkGTHdzT+w1Z1fpiXgJI+kJBNwVLuKDH+gozWfRvj3HDyvgJY2WPWa+W5jZ1w
 CRElP81tVSFM38WTyemoUDm8ezr1ApsbvpqyeUaQ8eS5xEiZFW5UtNoFjEfaPO3eHT85 TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vqteqcfpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 17:21:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PHJRBL118804;
        Fri, 25 Oct 2019 17:21:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vu0fs1u3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 17:21:26 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9PHLPxl022714;
        Fri, 25 Oct 2019 17:21:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 10:21:25 -0700
Date:   Fri, 25 Oct 2019 10:21:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: refactor xfs_bmap_count_blocks using newer
 btree helpers
Message-ID: <20191025172124.GN913374@magnolia>
References: <157198051549.2873576.10430329078588571923.stgit@magnolia>
 <157198052157.2873576.11427854428031607748.stgit@magnolia>
 <20191025124028.GA16251@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025124028.GA16251@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 05:40:28AM -0700, Christoph Hellwig wrote:
> > +		error = xfs_btree_count_blocks(cur, &btblocks);
> > +		xfs_btree_del_cursor(cur, error);
> > +		if (error)
> > +			return error;
> > +
> > +		*count += btblocks - 1;
> 
> Can you throw in a comment explaining the -1 here?  Without doing
> extra research I can't think of a reason why it would be there.

/*
 * xfs_btree_count_blocks includes the root block contained in the inode
 * fork, so subtract one for the count of allocated disk blocks.
 */

Will do.

> > +		/* fall through */
> > +	case XFS_DINODE_FMT_EXTENTS:
> > +		*nextents = xfs_bmap_count_leaves(ifp, count);
> >  		return 0;
> 
> I don't think you need the return statement here as there is a return 0
> just below it.

Ok.

--D
