Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8986AC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5257020644
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kRPTbB+7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfIPVbU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 17:31:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32880 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728241AbfIPVbU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 17:31:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GLTANY048847;
        Mon, 16 Sep 2019 21:31:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=K1EVqYemkkx8E2tSBbnyqhKXUdbHKbP3rg/DJN4RFFY=;
 b=kRPTbB+7+cIE8QRYZhQoCvQeAT3q44Rohvprf+oLVUtHiI0f78oH1PCrsCyKE+BDz+CV
 YfJ/xuUrSxmbxN8dQzofLQVAO6q6aCXMchoObpSAC5Dx4yNwzC3pVkMT8K7qC1cD90pJ
 lpEm+mr/D2uwwEMvlyWpD9C+XXBiuc8ocY0yli4Gz+vORj9ydLGi+hGuvZltUNwbwoy+
 hI3jHFv0X+SGfq0JVeU50LuoOpDyWEwWBj9AbMup/sV64Uxk7VkfZ8hGH2FcACyHd+Tm
 2d6ukJxrvxz9tP+5gMKVtuGWdndZFjHZwZLEWLcwAWrLKbA42IRxZpDTDfi/m9+Ha8JN oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v2bx2td5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 21:31:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GLT3aU128510;
        Mon, 16 Sep 2019 21:31:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v0r1h2jp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 21:31:01 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8GLV0qC004728;
        Mon, 16 Sep 2019 21:31:00 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 14:31:00 -0700
Date:   Mon, 16 Sep 2019 14:30:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Bill O'Donnell" <billodo@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: assure zeroed memory buffers for certain kmem
 allocations
Message-ID: <20190916213059.GO2229799@magnolia>
References: <20190916153504.30809-1-billodo@redhat.com>
 <5f1bcfbd-f16b-6d8a-416d-3a0639b9c7fe@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f1bcfbd-f16b-6d8a-416d-3a0639b9c7fe@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 04:24:40PM -0500, Eric Sandeen wrote:
> On 9/16/19 10:35 AM, Bill O'Donnell wrote:
> > Guarantee zeroed memory buffers for cases where potential memory
> > leak to disk can occur. In these cases, kmem_alloc is used and
> > doesn't zero the buffer, opening the possibility of information
> > leakage to disk.
> > 
> > Introduce a xfs_buf_flag, _XBF_KMZ, to indicate a request for a zeroed
> > buffer, and use existing infrastucture (xfs_buf_allocate_memory) to
> > obtain the already zeroed buffer from kernel memory.
> > 
> > This solution avoids the performance issue that would occur if a
> > wholesale change to replace kmem_alloc with kmem_zalloc was done.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> 
> I think this can probably be further optimized by not obtaining zeroed
> memory when we're about to fill the buffer from disk as the very
> next step.
> 
> (in this case, xfs_buf_read_map calls xfs_buf_get_map and then immediately
> reads the buffer from disk with _xfs_buf_read)  xfs_buf_read_map adds
> XBF_READ to the flags during this process.
> 
> So I wonder if this can be simplified/optimized by just checking for XBF_READ
> in xfs_buf_allocate_memory's flags, and if it's not set, then request
> zeroed memory, because that indicates a buffer we'll be filling in from
> memory and subsequently writing to disk.

I was wondering that ("Why can't we allocate a zeroed buffer only for
the get_buf case so that we don't have to do that for the read_buf
case?") too.  Once you do that then you can then remove all the explicit
memset calls too.

> -Eric
> 
> > ---
> >  fs/xfs/xfs_buf.c | 8 ++++++--
> >  fs/xfs/xfs_buf.h | 4 +++-
> >  2 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 120ef99d09e8..916a3f782950 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -345,16 +345,19 @@ xfs_buf_allocate_memory(
> >  	unsigned short		page_count, i;
> >  	xfs_off_t		start, end;
> >  	int			error;
> > +	uint			kmflag_mask = 0;
> >  
> >  	/*
> >  	 * for buffers that are contained within a single page, just allocate
> >  	 * the memory from the heap - there's no need for the complexity of
> >  	 * page arrays to keep allocation down to order 0.
> >  	 */
> > +	if (flags & _XBF_KMZ)
> > +		kmflag_mask |= KM_ZERO;
> >  	size = BBTOB(bp->b_length);
> >  	if (size < PAGE_SIZE) {
> >  		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> > -		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);
> > +		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS | kmflag_mask);

Does this overflow 80 columns?

--D

> >  		if (!bp->b_addr) {
> >  			/* low memory - use alloc_page loop instead */
> >  			goto use_alloc_page;
> > @@ -391,7 +394,7 @@ xfs_buf_allocate_memory(
> >  		struct page	*page;
> >  		uint		retries = 0;
> >  retry:
> > -		page = alloc_page(gfp_mask);
> > +		page = alloc_page(gfp_mask | kmflag_mask);
> >  		if (unlikely(page == NULL)) {
> >  			if (flags & XBF_READ_AHEAD) {
> >  				bp->b_page_count = i;
> > @@ -683,6 +686,7 @@ xfs_buf_get_map(
> >  	struct xfs_buf		*new_bp;
> >  	int			error = 0;
> >  
> > +	flags |= _XBF_KMZ;
> >  	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
> >  
> >  	switch (error) {
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index f6ce17d8d848..416ff588240a 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -38,6 +38,7 @@
> >  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
> >  #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
> >  #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
> > +#define _XBF_KMZ	 (1 << 23)/* zeroed buffer required */
> >  
> >  typedef unsigned int xfs_buf_flags_t;
> >  
> > @@ -54,7 +55,8 @@ typedef unsigned int xfs_buf_flags_t;
> >  	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
> >  	{ _XBF_PAGES,		"PAGES" }, \
> >  	{ _XBF_KMEM,		"KMEM" }, \
> > -	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
> > +	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> > +	{ _XBF_KMZ,             "KMEM_Z" }
> >  
> >  
> >  /*
> > 
