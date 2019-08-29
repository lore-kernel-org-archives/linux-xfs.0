Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247CFC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB50C2189D
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:01:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MtJG0rU1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfH2QB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 12:01:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53328 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfH2QB1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 12:01:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TFwwNA050951;
        Thu, 29 Aug 2019 16:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FBq5d5elXntWyQzcQ8AfNirX0MiAwT4t3K7j6VW1Xw8=;
 b=MtJG0rU1w7jSBTO3o1hyTW0G3Wm212Bd8kLGixJJ4hHQgGL4R8Uq2PmnqogD6XFNOCgU
 dzGh1CsCEcOUry2BVCGzSLdnHA6TIu1AldXdh9xyjXMK5urevy6VBt3aD7V+/JxycKy/
 TrCZCcFODL9aOd8LfhIo14ipKegzfwJxc+cSVV2fY+u3lxf2Qy/sLFd1YS7EFwNRJdvF
 btohHaFLcCqZgcSNmrYU4Ih2DwvSSmmhuPAvz1xGiIMGBpTp9ZVOSKdudAEY9/s4unE8
 jHblll3DeEw0qjctGB9LkUj3kp7mLOYR8HQ99DCk6HUqquC/cmB6Qk/9TBtZkJYgKL8f ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uphcygasd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 16:01:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TFiEAu129059;
        Thu, 29 Aug 2019 16:01:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2upc8uv7w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 16:01:21 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TG1JnX019184;
        Thu, 29 Aug 2019 16:01:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 09:01:19 -0700
Date:   Thu, 29 Aug 2019 09:01:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: reinitialize rm_flags when unpacking an offset
 into an rmap irec
Message-ID: <20190829160118.GG5354@magnolia>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
 <156685618619.2853674.16603505107055424362.stgit@magnolia>
 <20190829072957.GF18102@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829072957.GF18102@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=966
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 12:29:57AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 26, 2019 at 02:49:46PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xfs_rmap_irec_offset_unpack, we should always clear the contents of
> > rm_flags before we begin unpacking the encoded (ondisk) offset into the
> > incore rm_offset and incore rm_flags fields.  Remove the open-coded
> > field zeroing as this encourages api misuse.
> 
> This one doesn't fit the series' theme, does it? :)

Nope, there's always one cling-on patch. :/

> > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > @@ -168,7 +168,6 @@ xfs_rmap_btrec_to_irec(
> >  	union xfs_btree_rec	*rec,
> >  	struct xfs_rmap_irec	*irec)
> >  {
> > -	irec->rm_flags = 0;
> >  	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
> >  	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
> >  	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
> > diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> > index 0c2c3cb73429..abe633403fd1 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.h
> > +++ b/fs/xfs/libxfs/xfs_rmap.h
> > @@ -68,6 +68,7 @@ xfs_rmap_irec_offset_unpack(
> >  	if (offset & ~(XFS_RMAP_OFF_MASK | XFS_RMAP_OFF_FLAGS))
> >  		return -EFSCORRUPTED;
> >  	irec->rm_offset = XFS_RMAP_OFF(offset);
> > +	irec->rm_flags = 0;
> 
> The change looks sensible-ish.  But why do we even have a separate
> xfs_rmap_irec_offset_unpack with a single caller nd out of the
> way in a header?  Wouldn't it make sense to just merge the two
> functions?

xfs_repair uses libxfs_rmap_irec_offset_unpack, which is why it's a
separate function.

--D
