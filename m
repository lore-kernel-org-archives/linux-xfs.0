Return-Path: <SRS0=vvgS=W4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45389C3A5A4
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 20:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B25621897
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 20:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NLfyNSZo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbfIAUbt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Sep 2019 16:31:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33058 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbfIAUbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Sep 2019 16:31:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x81KVim7135956;
        Sun, 1 Sep 2019 20:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ACUUaKFrU/PKH9Sy3DRP4t0ApY5SLVC/hSU6glBdoz0=;
 b=NLfyNSZoKVcDwD5rJXOiFgUFaCkgKcA3c5Zu2U1GddRjC42MGq7VWvqq+9+VGMgVDpeO
 oBbP9TdKr1dSwTx69WA7HUMPZPcvhIed/+OhA2Ae45+1W+X1xmtJVA5n7Sy2ulq3aSQv
 R0ZDTdPiLTXBmw54wQjv2Gn5asOXVpUDqr5OeBvNOFwQpQXlOw/zwcj9Z6gDkkVhrEbK
 CzTv9d0JuFIxZDpUKwKoudNW6eqr2Ton4jxDQYGZwaMdG3VA5EEaaKo6cHZlpJK2OvGc
 4DUQQcgdE7rpB3CjD/LqqkSVIKt52TRlKdye7iO6fujBRZe9zXdGM5S9b70us/5E00Se Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2urn3m0004-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Sep 2019 20:31:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x81KSiDr049306;
        Sun, 1 Sep 2019 20:31:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uqgqjtytu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Sep 2019 20:31:44 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x81KVb5b018481;
        Sun, 1 Sep 2019 20:31:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Sep 2019 13:31:37 -0700
Date:   Sun, 1 Sep 2019 13:31:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a xfs_valid_startblock helper
Message-ID: <20190901203140.GP5354@magnolia>
References: <20190830102411.519-1-hch@lst.de>
 <20190830102411.519-2-hch@lst.de>
 <20190830150650.GA5354@magnolia>
 <20190830153253.GA20550@lst.de>
 <20190901073634.GA11777@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901073634.GA11777@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9367 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909010235
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9367 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909010235
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 01, 2019 at 09:36:34AM +0200, Christoph Hellwig wrote:
> On Fri, Aug 30, 2019 at 05:32:53PM +0200, Christoph Hellwig wrote:
> > On Fri, Aug 30, 2019 at 08:06:50AM -0700, Darrick J. Wong wrote:
> > > > --- a/fs/xfs/libxfs/xfs_bmap.h
> > > > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > > > @@ -171,6 +171,9 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
> > > >  		!isnullstartblock(irec->br_startblock);
> > > >  }
> > > >  
> > > > +#define xfs_valid_startblock(ip, startblock) \
> > > > +	((startblock) != 0 || XFS_IS_REALTIME_INODE(ip))
> > > 
> > > We have more robust validators for data/rtdev fsblock_t, so why not:
> > > 
> > > #define xfs_valid_startblock(ip, startblock) \
> > > 	(XFS_IS_REALTIME_INODE(ip) ? xfs_verify_rtbno(startblock) : \
> > > 				     xfs_verify_fsbno(startblock))
> > > 
> > > and why not make it a static inline function too?
> > 
> > I tried an inline function, but I could not find a header to place
> > it that would actually easily compile everywhere...  Maybe we should
> > just make that a xfs_verify_bno(mp, startblock) and move that out of
> > line such in a way that a smart compiler avoids the function call
> > overhead for xfs_verify_rtbno / xfs_verify_fsbno.  I'll take another
> > stab at this.
> 
> So I looked into your suggestion, but xfs_verify_rtbno / xfs_verify_fsbno
> do a lot of validity checking, but they don't actually contain the
> check that was in the existing code.  The bmap code just checks that
> there is a startblock of 0 for non-rt devices, probably this was added
> to find some old bug where a irec structure that was zeroed was returned.
> 
> So replacing it with xfs_verify_rtbno / xfs_verify_fsbno would not help
> in any way.  But the big question is if keeping the 0 check is even
> worth it.

It's been mildly helpful for noticing when my online/offline repair
prototype code totally screws up, but at that point so much magic smoke
is already pouring out everywhere that it's hard not to notice. :)

--D
