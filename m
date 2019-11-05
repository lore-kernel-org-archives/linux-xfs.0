Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2856CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C185020717
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:59:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bNnTNQ6Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbfKEB7c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 20:59:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40496 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbfKEB7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 20:59:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51xPY8178562;
        Tue, 5 Nov 2019 01:59:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CfdpLyYGC29nxDmhBz+vYhP2SqL4ojpPlKdqmS21wR4=;
 b=bNnTNQ6Y84HXwGZZbhMBUZjQ/TEtM5dGVpzRUqXjSAQ+CJH5f64h7S2np3XXFEAAtHvF
 m3JLgU3Q+UzOsC6A2KLYa5gO6ap/4V6Z4UjzSZcYkotgc6Av3U1QbPQ6FXkZoJSuXAX8
 GhjaZNl1q06/XHacFKGHkb1ONrU0dx8deQWqxGrnt1lGvAobfxDCwRjzjr9rMZN8Zbjp
 QBAMAF9xQp+WFxUP5MgwW4bo41KNn3jvaUdqxsafUDSnYkDyBqf6AcYuR+1uuJwaPiyE
 R9G+d/roDdUDW05LYOgLTX+P0+pkPD+3KrI/eHb4ZixFcULbdUst73DMHJrllfKGpMjM LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w117tu4g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 01:59:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51xN9f011531;
        Tue, 5 Nov 2019 01:59:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w1kxndjvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 01:59:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA51wvmD011059;
        Tue, 5 Nov 2019 01:58:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 17:58:56 -0800
Date:   Mon, 4 Nov 2019 17:58:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/34] xfs: move the max dir2 leaf entries count to
 struct xfs_da_geometry
Message-ID: <20191105015856.GY4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-12-hch@lst.de>
 <20191104200744.GL4153244@magnolia>
 <20191105014215.GC32531@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105014215.GC32531@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 05, 2019 at 02:42:15AM +0100, Christoph Hellwig wrote:
> On Mon, Nov 04, 2019 at 12:07:44PM -0800, Darrick J. Wong wrote:
> > > diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> > > index 5e3e954fee77..c8b137685ca7 100644
> > > --- a/fs/xfs/libxfs/xfs_da_btree.h
> > > +++ b/fs/xfs/libxfs/xfs_da_btree.h
> > > @@ -27,6 +27,7 @@ struct xfs_da_geometry {
> > >  	int		magicpct;	/* 37% of block size in bytes */
> > >  	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
> > >  	int		leaf_hdr_size;	/* dir2 leaf header size */
> > > +	unsigned int	leaf_max_ents;	/* # of entries in dir2 leaf */
> > 
> > Why does this one get 'unsigned' but the header size fields don't?
> > Or maybe I should rephase that: Why aren't the header sizes unsigned
> > too?
> 
> They probably should all be unsigned and I should add a prep patch
> for the existing ones.

Sounds good!

--D
