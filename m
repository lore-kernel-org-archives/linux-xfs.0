Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2C6C3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0557215A4
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:38:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ro+NvTZF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgCCQi7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 11:38:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgCCQi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 11:38:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023GOdfl043878;
        Tue, 3 Mar 2020 16:38:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iulQb5j5zCut6O9dbrkyA7597YWEFqtrobni9tpHW68=;
 b=ro+NvTZF7CuVsqtkTe2BrKQthxh7FZZw9OcxCWIuIAO+v8jbmdR0mk7RpKkhq8PxqPuE
 ZEL7UIZfvVfKMT+j2GDZqgSuzFn5d+MzK/ScMD+zMF151glubhMMpuepV0PMtW7eFRZR
 uJPIeyLNh6yz88l6cvNhPEZyCJKuYItBxsQjkojjPTXwatsejq9cBQP7lxtsnCHXgeyO
 fGP6K3l5WwsC7pRkYk5JSK9yxfc2gNVI9qpWQvKmdx7qIsYn1XZrBTm8jzmzfDKzlzYj
 eRNBImPfZJu9fTqsZmsP/+OMNivuxo/wuMrDH0Ti/FuKxG7nZpKyzlrKTzq/vaXGEq0y yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yffwqrey5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 16:38:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023GNYYI142595;
        Tue, 3 Mar 2020 16:38:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yg1gxt2ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 16:38:55 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 023GcsLU001275;
        Tue, 3 Mar 2020 16:38:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 08:38:54 -0800
Date:   Tue, 3 Mar 2020 08:38:53 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: fix buffer state when we reject a corrupt dir
 free block
Message-ID: <20200303163853.GA8045@magnolia>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294092192.1729975.12710230360219661807.stgit@magnolia>
 <e38b8334-6b64-71ed-62d6-527f0fe57f09@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e38b8334-6b64-71ed-62d6-527f0fe57f09@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 05:54:07PM -0600, Eric Sandeen wrote:
> On 2/28/20 5:48 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix two problems in the dir3 free block read routine when we want to
> > reject a corrupt free block.  First, buffers should never have DONE set
> > at the same time that b_error is EFSCORRUPTED.  Second, don't leak a
> > pointer back to the caller.
> 
> For both of these things I'm left wondering; why does this particular
> location need to have XBF_DONE cleared after the verifier error?  Most
> other locations that mark errors don't do this.

Read verifier functions don't need to clear XBF_DONE because
xfs_buf_reverify will notice b_error being set, and clear XBF_DONE for
us.

__xfs_dir3_free_read calls _read_buf.  If the buffer read succeeds,
_free_read then has xfs_dir3_free_header_check do some more checking on
the buffer that we can't do in read verifiers.  This is *outside* the
regular read verifier (because we can't pass the owner into _read_buf)
so if we're going to use xfs_verifier_error() to set b_error then we
also have to clear XBF_DONE so that when we release the buffer a few
lines later the buffer will be in a state that the buffer code expects.

This isn't theoretical, if the _header_check fails then we start
tripping the b_error assert the next time someone calls
xfs_buf_reverify.

> xfs_inode_buf_verify does, but for readahead purposes:
> 
>  * If the readahead buffer is invalid, we need to mark it with an error and
>  * clear the DONE status of the buffer so that a followup read will re-read it
>  * from disk.
> 
> Also, what problem does setting the pointer to NULL solve?

This avoids returning to the caller a pointer to an xfs_buf that we
might have just released in xfs_trans_brelse.  The caller ought to bail
out on the EFSCORRUPTED return value, but let's be defensive anyway. :)

--D

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_dir2_node.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > index a0cc5e240306..f622ede7119e 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > @@ -227,7 +227,9 @@ __xfs_dir3_free_read(
> >  	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
> >  	if (fa) {
> >  		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
> > +		(*bpp)->b_flags &= ~XBF_DONE;
> >  		xfs_trans_brelse(tp, *bpp);
> > +		*bpp = NULL;
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > 
