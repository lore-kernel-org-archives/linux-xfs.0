Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE045C3F2D1
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C03C920870
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:43:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mVFm86WT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgCCQn6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 11:43:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55746 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgCCQn6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 11:43:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023GNX9b066400
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 16:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4EeRxDDpvENCKV8iy3itkDnNwc5QbEfpAH3GbkncmtA=;
 b=mVFm86WTs/7H46ZvlgW1pNiG412OL0wnCcQSfLnBlPHFzy777VLsY/wlCpbA5CcrhQaQ
 +pMUwAQLDggVav4EFFAvMt5Fb+bn3531yFfx/Wpjrhq+JdYswj9xzWylvogMPFy1+iPX
 fOiH/O5p6omjclNH38EaNKI1kAl8Jf9HGGUwnjcfxlVViIWI5/6hTfI/JYMkfk64nAhm
 eFXinWT8NgtQjc+dUTmzZc1lnx3oL16l9EID8fvjPxPqnrk2t+wv1lBX2SVTWejqi5mp
 ltlIwMje1qv83GSN07e7C1n6JnufwajCaeh/8sltKQGOThMbaiurZ0AXVDp660aZ/3mV WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yghn34b5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 16:43:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023GN4bM145047
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 16:43:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2yg1em5gx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 16:43:56 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 023GhtcB023995
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 16:43:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 08:43:54 -0800
Date:   Tue, 3 Mar 2020 08:43:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: check owner of dir3 data blocks
Message-ID: <20200303164353.GB8045@magnolia>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294093423.1729975.14006020261164830361.stgit@magnolia>
 <41400676-7ed3-4e9e-a0c2-8fddc25569b4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41400676-7ed3-4e9e-a0c2-8fddc25569b4@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 11:12:17AM -0700, Allison Collins wrote:
> On 2/28/20 6:48 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Check the owner field of dir3 data block headers.
> "Check the owner field of dir3 data block headers, and release the buffer on
> error." ?
> 
> It's a bit of an api change though isnt it?  Do we need to go find all the
> callers and make sure there's not going to be a double release if error ==
> -EFSCORRUPTED ?

There shouldn't be, since we set *bpp to NULL before returning
EFSCORRUPTED.  The callers all seemed to handle nonzero return and/or
null bp properly.

(I dunno, did I miss one?  It's entirely likely... :))

--D

> Allison
> 
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >   fs/xfs/libxfs/xfs_dir2_data.c |   32 +++++++++++++++++++++++++++++++-
> >   1 file changed, 31 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> > index b9eba8213180..e5910bc9ab83 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_data.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> > @@ -394,6 +394,22 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
> >   	.verify_write = xfs_dir3_data_write_verify,
> >   };
> > +static xfs_failaddr_t
> > +xfs_dir3_data_header_check(
> > +	struct xfs_inode	*dp,
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_mount	*mp = dp->i_mount;
> > +
> > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
> > +
> > +		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
> > +			return __this_address;
> > +	}
> > +
> > +	return NULL;
> > +}
> >   int
> >   xfs_dir3_data_read(
> > @@ -403,11 +419,25 @@ xfs_dir3_data_read(
> >   	unsigned int		flags,
> >   	struct xfs_buf		**bpp)
> >   {
> > +	xfs_failaddr_t		fa;
> >   	int			err;
> >   	err = xfs_da_read_buf(tp, dp, bno, flags, bpp, XFS_DATA_FORK,
> >   			&xfs_dir3_data_buf_ops);
> > -	if (!err && tp && *bpp)
> > +	if (err || !*bpp)
> > +		return err;
> > +
> > +	/* Check things that we can't do in the verifier. */
> > +	fa = xfs_dir3_data_header_check(dp, *bpp);
> > +	if (fa) {
> > +		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
> > +		(*bpp)->b_flags &= ~XBF_DONE;
> > +		xfs_trans_brelse(tp, *bpp);
> > +		*bpp = NULL;
> > +		return -EFSCORRUPTED;
> > +	}
> > +
> > +	if (tp)
> >   		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
> >   	return err;
> >   }
> > 
