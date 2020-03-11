Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by sandeen.net (Postfix) with ESMTP id F34277B8C
	for <sandeen@sandeen.net>; Wed, 11 Mar 2020 11:07:09 -0500 (CDT)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbgCKQHb (ORCPT <rfc822;sandeen@sandeen.net>);
        Wed, 11 Mar 2020 12:07:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56324 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729921AbgCKQHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 12:07:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QhggRvVEOI7SSsd7sGS11n30r1ifjgwFt19zu9tM1d8=; b=oBrAK7ZsTsGkPjCUl2WQSHd6Cr
        wrx4Hw3q1gYy6WcsBX3Okewwge9n3nkCSTUBE2GjuF0cvzkanNszUPUGsPwesG5s33G2UT78I/zyA
        IMknYZIK59BQHh7kqNSjv0pPou8q6VZf3wm8dXtBTxP7Kz6E9KmC/bTZPMMEvJ2xLatq/jKoMvX98
        QWtzhdrB5tdaMJlLi7nikJgwzoHJ/+JK3ctEoAdUbWnCv0xBdXHluQSX3qk5bL/C91guq41UO6v+P
        SJ+Sl8t8PVCBNL32LkK5tvnbso3ehxBza3OSbSV+dMRNLa/6SaLJ4XyeFW89TA+N9R2sPLUJLhcN4
        gmPfi32g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jC3tL-0007WU-2t; Wed, 11 Mar 2020 16:07:31 +0000
Date:   Wed, 11 Mar 2020 09:07:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/2] xfs: fix xfs_rmap_has_other_keys usage of
 ECANCELED
Message-ID: <20200311160731.GA28849@infradead.org>
References: <158388761806.939081.5340701470247161779.stgit@magnolia>
 <158388763048.939081.7269460615856522299.stgit@magnolia>
 <20200311160329.GF8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311160329.GF8045@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 09:03:29AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In e7ee96dfb8c26, we converted all ITER_ABORT users to use ECANCELED
> instead, but we forgot to teach xfs_rmap_has_other_keys not to return
> that magic value to callers.  Fix it now by using ECANCELED both to
> abort the iteration and to signal that we found another reverse mapping.
> This enables us to drop the separate boolean flag.
> 
> Fixes: e7ee96dfb8c26 ("xfs: remove all *_ITER_ABORT values")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

