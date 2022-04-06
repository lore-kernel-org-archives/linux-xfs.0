Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5456DC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 07:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbiDFH1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 03:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576570AbiDFGqO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 02:46:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B9D3399F4;
        Tue,  5 Apr 2022 22:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DNgj8SdHFn5QyKE9xYEDK+F70Z
        m0ofosTmoG+EyUWhzwmrzqDyFHySJ2ikh9+dfxctxaI6VNiUqqNWdkRaHvQ8atm/PgEakfwpXVQzN
        sXOxuAmRulf5fTg61U1NvaAhd3ca0u22q53daFuB4CsGhUyU5l4vQV0hqGKzQdGL9psJzG5mZ+1DE
        9fOAra00qfmg5d7jJL4niqLTrH5K0JY8lEG8GhmqeA2uu1/aTWRRMnXapkhB5mhqIopaWmgbDsRkA
        Qz+biNG1/WHQ6iwp4UbA+iqIz2lDPnpcj3+r8EzDkEowlQQlWg5LQBT2U/Bg3QbGRCUKnQNMfX/fk
        qqE9GUdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nbxnk-003n4s-KZ; Wed, 06 Apr 2022 05:01:52 +0000
Date:   Tue, 5 Apr 2022 22:01:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jane Chu <jane.chu@oracle.com>
Cc:     david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
        hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
        agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
        linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v7 2/6] x86/mce: relocate set{clear}_mce_nospec()
 functions
Message-ID: <Yk0ewEadBLCjhtpC@infradead.org>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-3-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405194747.2386619-3-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
