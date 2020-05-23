Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46944C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 00:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01990206B6
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 00:25:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CXP3wsU/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbgEWAZR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 20:25:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60790 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387452AbgEWAZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 20:25:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N0HkiK104179;
        Sat, 23 May 2020 00:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2orX2DmbCUiDRxZifqjjsey+RhzydYzlx0fl2Pg1pUo=;
 b=CXP3wsU/V+dmANPxTx2Q0sxaPBoCH1JOgO2ZRqvIAi8aHAaWmwhT4Wj9BEw74+0/ko7q
 fePGYU7jApkggTafp/CaS5XCj6031UQpIR8aadoD1fIMdlN1uO8DEHjhVmWjeZa6juWu
 W3YEy/x/7SlKfqAzzdJ8v10Go2CvYi3gNgqdxPUbzyavVFm+e6UDa0reDRr4+0oP3umq
 cH/wilrRKUzom+aw3n4joN6O5Fv4rkGpuKOoY9urQa7UuASaOOfDCqlPP4IbSpzPdtj6
 36ppIqUzWXwqySdoCmFIrsQbFM9Z/lMYJkBG6O+0lwCNB1kzfYRcvcbC+tiX0k3UhUEY uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krr7e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 00:25:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N0HITG062655;
        Sat, 23 May 2020 00:25:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t3g5efh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 00:25:03 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04N0P2ZS014005;
        Sat, 23 May 2020 00:25:02 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 17:25:01 -0700
Date:   Fri, 22 May 2020 17:25:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/4] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200523002500.GC8230@magnolia>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
 <159011598984.76931.15076402801787913960.stgit@magnolia>
 <20200522065650.GA11266@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522065650.GA11266@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 11:56:50PM -0700, Christoph Hellwig wrote:
> On Thu, May 21, 2020 at 07:53:09PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're estimating a new speculative preallocation length for an
> > extending write, we should walk backwards through the extent list to
> > determine the number of number of blocks that are physically and
> > logically contiguous with the write offset, and use that as an input to
> > the preallocation size computation.
> > 
> > This way, preallocation length is truly measured by the effectiveness of
> > the allocator in giving us contiguous allocations without being
> > influenced by the state of a given extent.  This fixes both the problem
> > where ZERO_RANGE within an EOF can reduce preallocation, and prevents
> > the unnecessary shrinkage of preallocation when delalloc extents are
> > turned into unwritten extents.
> > 
> > This was found as a regression in xfs/014 after changing delalloc writes
> > to create unwritten extents during writeback.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> A minor nitpick, though:
> 
> > +	struct xfs_iext_cursor	ncur = *icur; /* struct copy */
> >
> > +	struct xfs_bmbt_irec	prev, got;
> 
> The comment is pretty pointless, as the struct copy is obviously form
> the syntax (and we do it for the xfs_iext_cursor structure in quite a
> few other places).
> 
> Also please don't add empty lines between the variable declarations.

I didn't... not sure where that came from.

--D
