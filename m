Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA51C33CA9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 00:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E205621569
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 00:59:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W3E0uVrz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgANA7t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 19:59:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56646 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbgANA7t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 19:59:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E0w0tq117438;
        Tue, 14 Jan 2020 00:59:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+uksYo3JL46igpo9HEkpQGmlz0jK3W+RQFNdqtBFL1Q=;
 b=W3E0uVrz7QG9E3JQpOYjJFV091p+dZx07dF4oO4I3hjwVToW+/J62UHQUlrLuDJK8+j+
 EOvGPNurDo5MHYKaD0ITA5U5/eZY/PefnAz7I1sHO3cP0UpP1SBwNQKhv1u6QVY9kHjv
 GTtt/aLaqoO9mVVADT6dlv1Oihm7i4FS015BaFtcccyxo118BDmU8lzltdPKA41S7ari
 Zd6eS745IwfPcxry2z9ouxiR0b7F5eR09XJBik2uN22ZrYyiNNCTnGdT40xZiP+0Rj7k
 ZWWHU/MlMjTNZ3nm/TKVxE37sMLqk2zMDZzNvsw9T1g1T9gOzqWtM6kBWlBok+AD47pi xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74s2krw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 00:59:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E0xDAi150764;
        Tue, 14 Jan 2020 00:59:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xh30xdrcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 00:59:42 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00E0xgUl014878;
        Tue, 14 Jan 2020 00:59:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 16:59:41 -0800
Date:   Mon, 13 Jan 2020 16:59:41 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: fix memory corruption during remote attr value
 buffer invalidation
Message-ID: <20200114005941.GR8247@magnolia>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
 <157859549406.164065.17179006268680393660.stgit@magnolia>
 <20200110115742.GD19577@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110115742.GD19577@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001140006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001140006
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 10, 2020 at 03:57:42AM -0800, Christoph Hellwig wrote:
> > While running generic/103, I observed what looks like memory corruption
> > and (with slub debugging turned on) a slub redzone warning on i386 when
> > inactivating an inode with a 64k remote attr value.
> > 
> > On a v5 filesystem, maximally sized remote attr values require one block
> > more than 64k worth of space to hold both the remote attribute value
> > header (64 bytes).  On a 4k block filesystem this results in a 68k
> > buffer; on a 64k block filesystem, this would be a 128k buffer.  Note
> > that even though we'll never use more than 65,600 bytes of this buffer,
> > XFS_MAX_BLOCKSIZE is 64k.
> > 
> > This is a problem because the definition of struct xfs_buf_log_format
> > allows for XFS_MAX_BLOCKSIZE worth of dirty bitmap (64k).  On i386 when we
> > invalidate a remote attribute, xfs_trans_binval zeroes all 68k worth of
> > the dirty map, writing right off the end of the log item and corrupting
> > memory.  We've gotten away with this on x86_64 for years because the
> > compiler inserts a u32 padding on the end of struct xfs_buf_log_format.
> > 
> > Fortunately for us, remote attribute values are written to disk with
> > xfs_bwrite(), which is to say that they are not logged.  Fix the problem
> > by removing all places where we could end up creating a buffer log item
> > for a remote attribute value and leave a note explaining why.
> 
> I think this changelog needs an explanation why using
> xfs_attr_rmtval_stale which just trylock and checks if the buffers are
> in core only in xfs_attr3_leaf_freextent is fine.

Hmm, maybe the *function* needs an explanation for why it's valid to use
rmtval_stale here:

/*
 * Invalidate any incore buffers associated with this remote attribute
 * value extent.   We never log remote attribute value buffers, which
 * means that they won't be attached to a transaction and are therefore
 * safe to mark stale.  The actual bunmapi will be taken care of later.
 */
STATIC int
xfs_attr3_rmt_inactive(
	struct xfs_inode	*dp,
	struct xfs_attr_inactive_list *lp)

I say the function is also confusingly named and could have its
arguments list trimmed.

> And while the incore
> part looks sane to me, I think the trylock is wrong and we need to pass
> the locking flag to xfs_attr_rmtval_stale.

Hmm, yeah, it's definitely wrong for the inactivation case -- the
inactivation thread holds the only incore reference to this unlinked
inode, so the buffer had better not be locked by another thread.

I'm not even all that sure why XBF_TRYLOCK is necessary in the remove
case, since we hold ILOCK_EXCL and there shouldn't be anyone else
messing around inside the xattr data.

--D
