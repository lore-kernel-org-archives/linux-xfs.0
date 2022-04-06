Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D69C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 18:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbiDFSDi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239989AbiDFSC1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 14:02:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983621DB7D5
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2WaqR9z1/tXsr/pxr3H1dFvdHgfLbV+tntbG4dWO/ho=; b=Gf+sWieCnAuuEMo4H90bSFwiP4
        doYuaNvqS1rdggZtKjWXJpQYdb9tHCUQD3Wxfj6V3HkB7AxWRVnMOTcw8euAQ0C6b7CD2Ei4tA6T1
        MZNcbvNCfVxdAKOkgInObdjYefg1IZS4vFkb79hLUGSb3nQ8f/qyvZBj/VFcNNiG+4inusT7HnD6u
        7NJaoNDJ2QYvkGB9YiuH77JLfxoi+Ee6lrpnVyqYRGZXgs6/MdBuU0NXzUKmVam4Dw1eBH0Djyl+j
        ABO7Eots4GAH8GwsI6/gfxPSgDMPBnhdSvr13uArEdzBQql1fmvM/iUg1Zn4JkwUMuAFtf5KSS2Dd
        BTKY2ZzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8eN-007Dbt-32; Wed, 06 Apr 2022 16:36:55 +0000
Date:   Wed, 6 Apr 2022 09:36:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_quota: split get_quota() and
 report_mount()/dump_file()
Message-ID: <Yk3Bp4rPbukT9VC7@infradead.org>
References: <20220328222503.146496-1-aalbersh@redhat.com>
 <20220328222503.146496-4-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328222503.146496-4-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Can you explain the split and the reason for it a little more here?

>  dump_file(
>  	FILE		*fp,
>  	fs_disk_quota_t *d,
> -	uint		id,
> -	uint		*oid,
> -	uint		type,
> -	char		*dev,
> -	int		flags)
> +	char		*dev)
>  {
> -	if	(!get_quota(d, id, oid, type, dev, flags))
> -		return 0;

I think it would make more sense to move this into the previous
patch that passes the fs_disk_quota to dump_file.

And maybe this and the previous patch should be split into one for
dump_file and one for report_mount?

> +			while ((g = getgrent()) != NULL) {
> +				get_quota(&d, g->gr_gid, NULL, type, mount->fs_name, 0);

Overly long line.  (and a few more below).

