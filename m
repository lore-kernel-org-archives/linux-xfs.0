Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1355C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 14:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3DC52080C
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 14:34:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NAq7bu8K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgFSOeA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 10:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbgFSOd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 10:33:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA21C06174E
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jun 2020 07:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FI674DfX2JgUR06RTryMgM+6US7wRn741kkqiXhM3/8=; b=NAq7bu8Kbfv+8rRXNSyuHhntcC
        FxvqWjMF0zmXn73OkvXjMq2Hhd3jDqmnutnXHM1Ptnun2gHJISRipBnQL5diDI2srqHEv7vHjdzN7
        73Z0lT1Kt+oQCGM1zxSCTt+fMk0vc+kqi+g4JxllNoiG0qhTqxcibw8XJJFOulbn2wt4A+zrZ0VO6
        QN9FBu9HtdcKmN0hHnsAVrQytHZI8Bzhg8GBzUemtlrN6TfPGSTJRjVldkJgaj8xhLKS9R+KMAsup
        KzukQIrbaB2PiaFUyvkEzG5k3e9FLxWIrTDlpsqxMEK/ox81gW9ZzSLBonX/Ajov3727fcnP/PyQz
        VAuqqY1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmI5a-0007yJ-SF; Fri, 19 Jun 2020 14:33:54 +0000
Date:   Fri, 19 Jun 2020 07:33:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com, hch@infradead.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/7] xfs: Fix log reservation calculation for xattr
 insert operation
Message-ID: <20200619143354.GA29528@infradead.org>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200606082745.15174-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606082745.15174-2-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 06, 2020 at 01:57:39PM +0530, Chandan Babu R wrote:
> -		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -				 M_RES(mp)->tr_attrsetrt.tr_logres *
> -					args->total;
> -		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> -		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +		tres = M_RES(mp)->tr_attrset;
>  		total = args->total;

tres can become a pointer now, and we can avoid the struct copy.
