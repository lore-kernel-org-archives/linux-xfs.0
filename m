Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CFEC282DD
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 23:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255B3206DA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 23:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N6u7K9f6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgAHXEV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 18:04:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57678 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgAHXEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 18:04:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008N3mHs162495;
        Wed, 8 Jan 2020 23:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=zwndaK9ySvu5ARNiA+4OvvciNuWUEUjWCNq5E+gFQOQ=;
 b=N6u7K9f6eb77Znio4p19UFli3fXiVw+NVCH3fuVAE/RzIDpjatWDsnsBzqJwGr4RR8T4
 zZhtmY8vzrPr7aoeTlcfVb1WoSENzdeiGFYeA81hVEHV54kibIi1VoKTvyC0rOCPsllk
 /siaaMRaspwV0OMf5d9zdl8zcxtDuES6TKqmeN2wtzVG1GVqhVlDIDQ+mmGDUIM19RZS
 9x31qpkPc77uCMGfgyy+J+9szTHtDssDxd96U0v3sFPUXkfz25YOAxTyMWMlKi8R3eVp
 M2Z9TyOIC/RyW4lH652e+5jlXopREKFKEpKOvQLldM8DNuq62HrcYkCxLtdsyyNyykYn Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xajnq72xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 23:04:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008N3hsP104401;
        Wed, 8 Jan 2020 23:04:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xdmrwv575-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 23:04:17 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 008N4HS4016214;
        Wed, 8 Jan 2020 23:04:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jan 2020 15:04:16 -0800
Date:   Wed, 8 Jan 2020 15:04:15 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: introduce XFS_MAX_FILEOFF
Message-ID: <20200108230415.GM5552@magnolia>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
 <157845705884.82882.5003824524655587269.stgit@magnolia>
 <20200108204041.GF23128@dread.disaster.area>
 <20200108223238.GK5552@magnolia>
 <20200108224216.GH23128@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108224216.GH23128@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 09, 2020 at 09:42:16AM +1100, Dave Chinner wrote:
> On Wed, Jan 08, 2020 at 02:32:38PM -0800, Darrick J. Wong wrote:
> > On Thu, Jan 09, 2020 at 07:40:41AM +1100, Dave Chinner wrote:
> > > On Tue, Jan 07, 2020 at 08:17:38PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Introduce a new #define for the maximum supported file block offset.
> > > > We'll use this in the next patch to make it more obvious that we're
> > > > doing some operation for all possible inode fork mappings after a given
> > > > offset.  We can't use ULLONG_MAX here because bunmapi uses that to
> > > > detect when it's done.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_format.h |    1 +
> > > >  fs/xfs/xfs_reflink.c       |    3 ++-
> > > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > > index 1b7dcbae051c..c2976e441d43 100644
> > > > --- a/fs/xfs/libxfs/xfs_format.h
> > > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > > @@ -1540,6 +1540,7 @@ typedef struct xfs_bmdr_block {
> > > >  #define BMBT_BLOCKCOUNT_BITLEN	21
> > > >  
> > > >  #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
> > > > +#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK)
> > > 
> > > Isn't the maximum file offset in the BMBT the max start offset + the
> > > max length of the extent that is located at BMBT_STARTOFF_MASK?
> > 
> > Apologies for responding to a question with another question, but has
> > there ever been an XFS that supported an inode size of more than 8EB?
> 
> Doubt it.
> 
> > Linux supports at most a file offset of 8EB, which is 2^63-1, or
> > 0x7FFF,FFFF,FFFF,FFFF.  On a filesystem with 512-byte blocks, the very
> > last byte in the file would be in block 2^54-1, or 0x3F,FFFF,FFFF,FFFF.
> > Larger blocksizes decrease that even further (e.g. 2^47-1, or
> > 0x7FFF,FFFF,FFFF on 64k block filesystems).
> >
> > Therefore, on Linux I conclude that the largest file offset (block)
> > possible is 2^54-1, which is BMBT_STARTOFF_MASK.  Unless there's an
> > XFS port that actually supports 16EB files, BMBT_STARTOFF_MASK will
> > suffice here.
> 
> Sure, but my point was that checks against the max file offset
> as a block count are applied to the startoff field, not the
> startoff + blockcount value, so we can potentially get extents on
> disk beyond the above definition of XFS_MAX_FILEOFF...
> 
> i.e. startoff can be < XFS_MAX_FILEOFF, but startoff + blockcount
> can be > XFS_MAX_FILEOFF, and there's nothing in the code that
> prevents that from occurring...
> 
> e.g. what's preventing speculative delalloc from going beyond
> XFS_MAX_FILEOFF, even though the actual file offset that is being
> written is within XFS_MAX_FILEOFF?

I thought we constrained the @prealloc_blocks argument to
xfs_bmapi_reserve_delalloc based on s_maxbytes:

	p_end_fsb = min(p_end_fsb,
		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes));

But as there's nothing in the verifiers or anywhere else prohibiting
this, I'll change it to (BMBT_STARTOFF_MASK + MAXEXTLEN) for now.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
