Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE43CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 02:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7377D21882
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 02:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="egenY8IO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbfKECIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 21:08:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40288 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbfKECIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 21:08:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA524ScT173210;
        Tue, 5 Nov 2019 02:07:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KU1akmE4658chpedvcpdU1xHvUmPgjCC1K7YTCzZ8zY=;
 b=egenY8IOBR4+Rp0B3MYaGCpyHw407eRWiIXQVG8iIGwgXzVz13V/mP9Bejxs1OI0+QL6
 LrQ2c0AiRf9XPa2qcy6eqx7DMTqoK4gXg2YNSqhby0crdpka0F8jiHOVRZ4oX/jv+E89
 Gc7XXfbHPf09C3l/UJysv9jxyawPsf8yJSTGDfABvoHCs9oe3XI70R9E1leCmz2EKBEI
 aH3EgN0yxS6IZIPpLQqXgJiJ8C7QlRVMc7aiiLpieQsvVDCjUqEbBFlGrMy+WaKPM8DV
 R2hzOtV8EapISQVsYhOgJ8ZA7oxcwGztueQP/VntM+mhb+3t6qbPi/HIbcXMWfPyAjcO ZA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w11rpu47q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 02:07:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51x1kZ179981;
        Tue, 5 Nov 2019 02:05:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w1k8vw6un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 02:05:55 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA525sT4014628;
        Tue, 5 Nov 2019 02:05:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 18:05:54 -0800
Date:   Mon, 4 Nov 2019 18:05:53 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/34] xfs: add a bests pointer to struct
 xfs_dir3_icfree_hdr
Message-ID: <20191105020553.GA4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-16-hch@lst.de>
 <20191104202145.GP4153244@magnolia>
 <20191105014403.GD32531@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105014403.GD32531@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 05, 2019 at 02:44:03AM +0100, Christoph Hellwig wrote:
> On Mon, Nov 04, 2019 at 12:21:45PM -0800, Darrick J. Wong wrote:
> > > @@ -233,6 +233,7 @@ xfs_dir2_free_hdr_from_disk(
> > >  		to->firstdb = be32_to_cpu(from3->hdr.firstdb);
> > >  		to->nvalid = be32_to_cpu(from3->hdr.nvalid);
> > >  		to->nused = be32_to_cpu(from3->hdr.nused);
> > > +		to->bests = (void *)from3 + sizeof(struct xfs_dir3_free_hdr);
> > 
> > Urgh, isn't void pointer arithmetic technically illegal according to C?
> 
> It is not specified in ISO C, but clearly specified in the GNU C
> extensions and used all over the kernel.

Just out of curiosity, do you know if clang supports that extension?

Once in a while we get patches from them to fix various clang warnings,
and at least as of a few years ago clang got grouchy about void pointer
arithmetic.

> > In any case, shouldn't this cast through struct xfs_dir3_free instead of
> > open-coding details of the disk format that we've already captured?  The
> > same question also applies to the other patches that add pointers to
> > ondisk leaf and intnode pointers into the incore header struct.
> 
> I don't really understand that sentence.  What would do you instead?

if (xfs_sb_version_hascrc(&mp->m_sb)) {
	struct xfs_dir3_free	*from3 = (struct xfs_dir3_free *)from;

	...
	to->nused = be32_to_cpu(from3->hdr.nused);
	to->bests = &from3->bests[0];
}

Since we're already passing around pointers to the xfs_dir[23]_free
structure, we might as well use it instead of open-coding the arithmetic.
Sorry that wasn't clear. :/

--D
