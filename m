Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE6CC5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FF1320869
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WMYl5g60"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfKHH37 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:29:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54596 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfKHH37 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:29:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA87Sl6l090684;
        Fri, 8 Nov 2019 07:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=YpkCgaVsFrtQ8uDggZl+/y7CyGa/ElDONeldV4MPTOI=;
 b=WMYl5g6042BY8BPJ4+WvudNuY7VZM91C0sT9XZiNU7f/Xs+1pIkz4SFE/vQDvYssJsPF
 /3bNnTybdyToode9gSG631sZM7+tntPikt5FfAF5YEH5SlEQLiq5Q1NsFNFrnPV/Dbmx
 0zxwyES5w8NzaO99uTk0vjX+SOnBS1Fy2ThsJXK+NijKMLLAo8GQ2aUGfF7JU3Bu2B69
 Yn6YSmesdcJhiTENBXF38PVTCnvEPZKvFtP5eYW+5onfaHNe1er3yxBjv+tkukcdeLfb
 V9hK/fU5fnFu5pYJGbEYHCnKRtfZv0v+t2Ku7bimTbhhJEqrsHTNuhN72hNZJfuEK8PK 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w1bgx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:29:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA87Svro042804;
        Fri, 8 Nov 2019 07:29:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w41wh1ydx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:29:53 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA87TqqP027736;
        Fri, 8 Nov 2019 07:29:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:29:52 -0800
Date:   Thu, 7 Nov 2019 23:29:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
Message-ID: <20191108072951.GP6219@magnolia>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
 <157319670439.834585.6578359830660435523.stgit@magnolia>
 <20191108071441.GB31526@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108071441.GB31526@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080074
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:14:41PM -0800, Christoph Hellwig wrote:
> On Thu, Nov 07, 2019 at 11:05:04PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Coverity points out that xfs_btree_islastblock calls
> > xfs_btree_check_block, but doesn't act on an error return.  This
> > predicate has no answer if the btree is corrupt, so tweak the helper to
> > be able to return errors, and then modify the one call site.
> 
> Could we just kill xfs_btree_islastblock?  It has pretty trivial, and
> only has a single caller which only uses on of the two branches in the
> function anyway.

I'd rather leave it as a btree primitive, honestly.

That said, "Is this cursor pointing to the last block on $level?" only
makes sense if you've already performed a lookup (or seek) operation.
If you've done that, you've already checked the block, right?  So I
think we could just get rid of the _check_block call on the grounds that
we already did that as part of the lookup (or turn it into an ASSERT),
and then this becomes a short enough function to try to make it a four
line static inline predicate.

Same result, but slightly better encapsulation.

(Yeah yeah, it's C, we're all one big happy family of bits...)

--D
