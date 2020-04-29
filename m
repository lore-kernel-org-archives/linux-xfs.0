Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63D6C83006
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 14:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E6D2074A
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 14:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eEL4UGhl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgD2OaQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 10:30:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44156 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgD2OaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 10:30:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TEMxpv166142;
        Wed, 29 Apr 2020 14:30:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+eK15enNCNbC2YaWFljR0GyGK/E29sVgWFZFp0ZH0tQ=;
 b=eEL4UGhlzI2JMdnioJ8kt58Y93i77814PpFcTowXaA/w6hbM4E2TWF0oruPK48M0AHnx
 p6k+jYGAg5HAFQN03nO9jAKDrOFAKmx16Tja1Rq4IOoLtUDgVopTqoeek2Fnw2DOvfvM
 JGMHG0AFH4Ff+6yKWKvxjl/cxYK84AxD2ZfT1YJNXgfup3F6rALnohoxIahi48eENPCN
 nouNJi5G/htReraNuIWco5KQ7csoPb1Ca3I0OdB9o1RBFxO5rcB6Vo58zDxlfa2joQen
 Kt6X+3v3oI3+XphQfxp5xqG9vrBEfYTo958NgVNKvkuyBzozP55DScYOugTeZlI6lPd8 Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucg636q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 14:30:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TES2L7112004;
        Wed, 29 Apr 2020 14:28:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30pvd158xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 14:28:09 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03TES8j7014767;
        Wed, 29 Apr 2020 14:28:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 07:28:08 -0700
Date:   Wed, 29 Apr 2020 07:28:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: teach deferred op freezer to freeze and thaw
 inodes
Message-ID: <20200429142807.GU6742@magnolia>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130655.2142108.9338576917893374360.stgit@magnolia>
 <20200425190137.GA16009@infradead.org>
 <20200427113752.GE4577@bfoster>
 <20200428221747.GH6742@magnolia>
 <20200429113803.GA33986@bfoster>
 <20200429114819.GA24120@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429114819.GA24120@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=2 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=2 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 04:48:19AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 29, 2020 at 07:38:03AM -0400, Brian Foster wrote:
> > That aside, based on your description above it seems we currently rely
> > on this icache retention behavior for recovery anyways, otherwise we'd
> > hit this use after free and probably have user reports. That suggests to
> > me that holding a reference is a logical next step, at least as a bug
> > fix patch to provide a more practical solution for stable/distro
> > kernels. For example, if we just associated an iget()/iput() with the
> > assignment of the xfs_bmap_intent->bi_owner field (and the eventual free
> > of the intent structure), would that technically solve the inode use
> > after free problem?
> 
> Yes, that's what I thought.
> 
> > 
> > BTW, I also wonder about the viability of changing ->bi_owner to an
> > xfs_ino_t instead of a direct pointer, but that might be more
> > involved than just adding a reference to the existing scheme...
> 
> It is actually pretty easy, but I'm not sure if hitting the icache for
> every finished bmap item is all that desirable.

It came with a noticeable (~2%) slowdown on a swapext-heavy fsstress
run, which was my motivation for this (somewhat clunky) system for
avoiding all that overhead except for recovery.

Hmm.  Actually now that I think harder about it, the bmap item is
completely incore and fields are selectively copied to the log item.
This means that regular IO could set bi_owner = <some inode number> and
bi_ip = <the incore inode>.  Recovery IO can set bi_owner but leave
bi_ip NULL, and then the bmap item replay can iget as needed.  Now we
don't need this freeze/thaw thing at all.

--D
