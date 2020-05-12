Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04670CA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 16:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D392E206B8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 16:21:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="flouKUZ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgELQVP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 12:21:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53896 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELQVP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 12:21:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CGD49s019079;
        Tue, 12 May 2020 16:21:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Kclc7X3DgJJhIRGIZwZwBX/5SegzJ5EoAxt5HAr878g=;
 b=flouKUZ2e0zxMwF0ZstFxVve3dmCWvTh/yWNsUlRNWgk9qYNmQASV41ueG+WqGGjhPF8
 ayk+o9dUxv92Ni49/DC7loQygFGwN/lb3Rq0hLpDQlVw86ZIwVp6OAo81rtE1SDEfWjr
 M2OdNH1wXON81HjpLFeQsNPzQ1I5drKWUIo/l5hWklQJg6vnM0uLsvhA86RqRpg+croJ
 EySk+M/c6WX0pGOONFbhVekKr1T9eJCS0GMFfTJ/SQXyvWmL3Rh2zS+uEAawKj8EXDMw
 iXvuFrUEng8iW9+IrS9r1owTZ6jq2KXPznOK1fFWmEIJkIhMk0bwmyE/gte39fp5VdV1 Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30x3mbv147-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 16:21:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CGHl2Y195475;
        Tue, 12 May 2020 16:19:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30x63q4hsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 16:19:09 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CGJ7M8030275;
        Tue, 12 May 2020 16:19:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 09:19:07 -0700
Date:   Tue, 12 May 2020 09:19:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: warn instead of fail verifier on empty attr3
 leaf block
Message-ID: <20200512161906.GG6714@magnolia>
References: <20200511185016.33684-1-bfoster@redhat.com>
 <20200512081037.GB28206@infradead.org>
 <20200512155320.GD6714@magnolia>
 <20200512160300.GA4642@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512160300.GA4642@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=1 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 09:03:00AM -0700, Christoph Hellwig wrote:
> On Tue, May 12, 2020 at 08:53:20AM -0700, Darrick J. Wong wrote:
> > I was gonna say, I think we've messed this up enough that I think we
> > just have to accept empty attr leaf blocks. :/
> > 
> > I also think we should improve the ability to scan for and invalidate
> > incore buffers so that we can invalidate and truncate the attr fork
> > extents directly from an extent walk loop.  It seems a little silly that
> > we have to walk the dabtree just to find out where multiblock remote
> > attr value structures might be hiding.
> 
> The buffers are indexed by the physical block number.  Unless you
> want to move to logical indexing that's what we'll need to do.

<shrug> I modded xfs_buf_incore and _xfs_buf_obj_cmp to return an
xfs_buf that matches map->bm_bn regardless of length and it seems fine
so far...

--D
