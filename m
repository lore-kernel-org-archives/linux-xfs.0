Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAEDC4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 19:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E40E22CA1
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 19:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgLDT5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 14:57:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37446 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgLDT5G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 14:57:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4Jn7p6076994;
        Fri, 4 Dec 2020 19:56:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Uey9IqZdBNwTCCXICZGTvd53TMH3baXRmQktfRbigno=;
 b=ABUab/XgH1OTMkFGCnGcJh5dyqlpp8pJz/wTJ7eWSQ7VIjYJrQOK1BeNbv4CA6+K0JZG
 SZmqxg0Z7KJ42oxdRySYQwSugeeWToAzbh4kzYwSLLy3k4wQwuUu2pe6LNb5LkASM48m
 4fni4CzDgUnYSokuNGlcoWmLhbCuALWIXINwsql0jftwAG9LMp1ehHdsTYX8YARYNhXN
 vrFZrlfwa9f8oelmM3dtA8AuzY4ODN52at3bzLn3K0+3caed4xcdNCbnSB6AzuDMMNX3
 v9U4Ju88DWp/FuKd56IHTBNArCo6vaWVgxkjWsFET/S4ZgSJojdiQVKDawjiQTX8fh9l Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 353egm4v9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 19:56:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4JoaEv050133;
        Fri, 4 Dec 2020 19:54:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35404sqjgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 19:54:17 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B4JsEv1017779;
        Fri, 4 Dec 2020 19:54:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 11:54:14 -0800
Date:   Fri, 4 Dec 2020 11:54:13 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: improve the code that checks recovered bmap
 intent items
Message-ID: <20201204195413.GE629293@magnolia>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704430659.734470.2948483798298982986.stgit@magnolia>
 <20201204135638.GD1404170@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204135638.GD1404170@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040114
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 08:56:38AM -0500, Brian Foster wrote:
> On Thu, Dec 03, 2020 at 05:11:46PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The code that validates recovered bmap intent items is kind of a mess --
> > it doesn't use the standard xfs type validators, and it doesn't check
> > for things that it should.  Fix the validator function to use the
> > standard validation helpers and look for more types of obvious errors.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_bmap_item.c |   26 +++++++++++++-------------
> >  1 file changed, 13 insertions(+), 13 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 555453d0e080..78346d47564b 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> ...
> > @@ -448,13 +442,19 @@ xfs_bui_validate(
> >  		return false;
> >  	}
> >  
> > -	if (startblock_fsb == 0 ||
> > -	    bmap->me_len == 0 ||
> > -	    inode_fsb == 0 ||
> > -	    startblock_fsb >= mp->m_sb.sb_dblocks ||
> > -	    bmap->me_len >= mp->m_sb.sb_agblocks ||
> > -	    inode_fsb >= mp->m_sb.sb_dblocks ||
> > -	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
> > +	if (!xfs_verify_ino(mp, bmap->me_owner))
> > +		return false;
> > +
> > +	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
> > +		return false;
> > +
> > +	if (bmap->me_startblock + bmap->me_len <= bmap->me_startblock)
> > +		return false;
> > +
> > +	if (!xfs_verify_fsbno(mp, bmap->me_startblock))
> > +		return false;
> > +
> > +	if (!xfs_verify_fsbno(mp, bmap->me_startblock + bmap->me_len - 1))
> >  		return false;
> 
> If this is going to be a common pattern, I wonder if an
> xfs_verify_extent() or some such helper that covers the above range
> checks would be helpful. Regardless:

Yes.  I'll add a new patch to refactor all the bmap extent validators at
the end.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  
> >  	return true;
> > 
> 
