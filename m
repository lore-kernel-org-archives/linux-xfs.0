Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F72C282DD
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 22:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3427320705
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 22:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MNhwIZji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgAHWcn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 17:32:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgAHWcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 17:32:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008MSa6W136722;
        Wed, 8 Jan 2020 22:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=xH4YCmBilu6H55PnACWesaYFeeYv/3dmCr2t20o1Ppw=;
 b=MNhwIZjiqKAAunH1qJbfKIm1Xae7Gf0uOUf+w0Sl1B55/qkHnOsMoZoXRQc9krjDpP1F
 G+5gc88CAI7yrUtnzgNm3OOAqu+MCVaE9BX/ktlB54XX3ID3CCqnGdO492bUgW/yb7pe
 jx9lKs+AfSg+8YVn6hZD2faxco7AhfiKtwUZsgNtvJrW+w5XIjr+iCe9EDBURr2WdWzC
 hHKHf4jwN0nzsp8icQqxjByi9pBxcsJHz7OVx+1uIx7ku2WyZJ8Pob9BmwY+iZhAwKfo
 QOVLrbGJYuxm5SuLyUk0ay/URMdWBva4MIRISExUxucKFdS2zeSIhEy6T0ONL2Z1eokg LA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xajnq6yhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 22:32:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008MSSci028859;
        Wed, 8 Jan 2020 22:32:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xdmrwtphq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 22:32:40 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 008MWd68010841;
        Wed, 8 Jan 2020 22:32:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jan 2020 14:32:39 -0800
Date:   Wed, 8 Jan 2020 14:32:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: introduce XFS_MAX_FILEOFF
Message-ID: <20200108223238.GK5552@magnolia>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
 <157845705884.82882.5003824524655587269.stgit@magnolia>
 <20200108204041.GF23128@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108204041.GF23128@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 09, 2020 at 07:40:41AM +1100, Dave Chinner wrote:
> On Tue, Jan 07, 2020 at 08:17:38PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Introduce a new #define for the maximum supported file block offset.
> > We'll use this in the next patch to make it more obvious that we're
> > doing some operation for all possible inode fork mappings after a given
> > offset.  We can't use ULLONG_MAX here because bunmapi uses that to
> > detect when it's done.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |    1 +
> >  fs/xfs/xfs_reflink.c       |    3 ++-
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 1b7dcbae051c..c2976e441d43 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -1540,6 +1540,7 @@ typedef struct xfs_bmdr_block {
> >  #define BMBT_BLOCKCOUNT_BITLEN	21
> >  
> >  #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
> > +#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK)
> 
> Isn't the maximum file offset in the BMBT the max start offset + the
> max length of the extent that is located at BMBT_STARTOFF_MASK?

Apologies for responding to a question with another question, but has
there ever been an XFS that supported an inode size of more than 8EB?

Linux supports at most a file offset of 8EB, which is 2^63-1, or
0x7FFF,FFFF,FFFF,FFFF.  On a filesystem with 512-byte blocks, the very
last byte in the file would be in block 2^54-1, or 0x3F,FFFF,FFFF,FFFF.
Larger blocksizes decrease that even further (e.g. 2^47-1, or
0x7FFF,FFFF,FFFF on 64k block filesystems).

Therefore, on Linux I conclude that the largest file offset (block)
possible is 2^54-1, which is BMBT_STARTOFF_MASK.  Unless there's an
XFS port that actually supports 16EB files, BMBT_STARTOFF_MASK will
suffice here.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
