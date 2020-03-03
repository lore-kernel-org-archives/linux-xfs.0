Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A706DC3F2D1
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 17:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7239A21739
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 17:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yk4Ka0yX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbgCCRnh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 12:43:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58328 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730627AbgCCRn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 12:43:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023HcAsk149420;
        Tue, 3 Mar 2020 17:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=U4dBAhahdS2/q6GRjZOYhdk7Uq6qDkkObTrVmV1aVz4=;
 b=yk4Ka0yXw2aPymV1JEeaQALCjnEOAqg2A7aDsulEIAKjZ/IElWUyoKVT1xhBtO4srBm2
 H+0TolxMTY0HD1M9sTfj+fJPFa/m4fbicLw4+8BG+zG9+hRsO+u2r2neC1p0OkABEFy8
 2+uXyTd20r+iL6awG+7xWU42x0uZtIQ1gCXMKK9LMWDGyPNsAiq0/5sBVftpYSYQMD1+
 WxmxubmNXa1s+Qw7bT99qDChGDWJ0V2cNsJWMNoSGRQbbKiXyy81ypx3oIMVHFtL6few
 mg38nQeHWqgrkiyUW3XDTTmVvtUqJ2bcybTg2zQ48NdsSKxLyRE6yTT3gWWQ+XLNPR9h /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yffcuh0bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 17:43:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023HgRKJ022897;
        Tue, 3 Mar 2020 17:43:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2yg1p4yu0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 17:43:24 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 023HhM21022224;
        Tue, 3 Mar 2020 17:43:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 09:43:22 -0800
Date:   Tue, 3 Mar 2020 09:43:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: fix buffer state when we reject a corrupt dir
 free block
Message-ID: <20200303174321.GE8045@magnolia>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294092192.1729975.12710230360219661807.stgit@magnolia>
 <e38b8334-6b64-71ed-62d6-527f0fe57f09@sandeen.net>
 <20200303163853.GA8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303163853.GA8045@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=2 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 08:38:53AM -0800, Darrick J. Wong wrote:
> On Mon, Mar 02, 2020 at 05:54:07PM -0600, Eric Sandeen wrote:
> > On 2/28/20 5:48 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Fix two problems in the dir3 free block read routine when we want to
> > > reject a corrupt free block.  First, buffers should never have DONE set
> > > at the same time that b_error is EFSCORRUPTED.  Second, don't leak a
> > > pointer back to the caller.
> > 
> > For both of these things I'm left wondering; why does this particular
> > location need to have XBF_DONE cleared after the verifier error?  Most
> > other locations that mark errors don't do this.
> 
> Read verifier functions don't need to clear XBF_DONE because
> xfs_buf_reverify will notice b_error being set, and clear XBF_DONE for
> us.
> 
> __xfs_dir3_free_read calls _read_buf.  If the buffer read succeeds,
> _free_read then has xfs_dir3_free_header_check do some more checking on
> the buffer that we can't do in read verifiers.  This is *outside* the
> regular read verifier (because we can't pass the owner into _read_buf)
> so if we're going to use xfs_verifier_error() to set b_error then we
> also have to clear XBF_DONE so that when we release the buffer a few
> lines later the buffer will be in a state that the buffer code expects.
> 
> This isn't theoretical, if the _header_check fails then we start
> tripping the b_error assert the next time someone calls
> xfs_buf_reverify.

As an addendum to that, in the long run I will just fix it so that
_read_buf callers pass all the necessary context info through to the
verifiers and all of this will go away, but before that gets to RFC
status I need to iterate all the use cases that I can think of.

I /think/ all we need is an AG number, a XFS_HEALTH code, and some
combination of a (struct xfs_inode *) or an inode number to cover all
the cases of owner verification and automatic reporting of corruptions
to the health reporting subsystem.

--D

> > xfs_inode_buf_verify does, but for readahead purposes:
> > 
> >  * If the readahead buffer is invalid, we need to mark it with an error and
> >  * clear the DONE status of the buffer so that a followup read will re-read it
> >  * from disk.
> > 
> > Also, what problem does setting the pointer to NULL solve?
> 
> This avoids returning to the caller a pointer to an xfs_buf that we
> might have just released in xfs_trans_brelse.  The caller ought to bail
> out on the EFSCORRUPTED return value, but let's be defensive anyway. :)
> 
> --D
> 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_dir2_node.c |    2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > > index a0cc5e240306..f622ede7119e 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > > @@ -227,7 +227,9 @@ __xfs_dir3_free_read(
> > >  	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
> > >  	if (fa) {
> > >  		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
> > > +		(*bpp)->b_flags &= ~XBF_DONE;
> > >  		xfs_trans_brelse(tp, *bpp);
> > > +		*bpp = NULL;
> > >  		return -EFSCORRUPTED;
> > >  	}
> > >  
> > > 
