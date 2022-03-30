Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2A7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 15:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344901AbiC3PvW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 11:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348412AbiC3PvT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 11:51:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984AB2E09D;
        Wed, 30 Mar 2022 08:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PCuBPF5hsRb/FMuxwZS7UpXV4qd0D79dqbvfk53dcbE=; b=Ukr7Hifw8pU5JfYiPGLkf7XKAM
        0QeINXFlW1dVUv6yQ0WU0S7w1cKoH/5TDqRoNbK5IAtmT3sKbNl/daSTjjob/p/CeKCPZyYYLyb0L
        uVXHYJ91smhuSIXTRaExHdk/6wmhB+iLGkR0k/WoeDaS6duxaaBTbnFIezrxY3E5XyO39qQLJ2tIC
        iEBgjRN+fYwh9dpO5LMqGx12aO/ygCGO0F15BL6BXLfcvLezsbqiCjHyBawNW4c44Nj8Hd2A5dTJz
        UqP6oDboQrEY2rHdKNWhWMnf347LI7JT2kUIjoIFkyGIybDm7Kd61AvSJ1FqzX9XbrhgtaNH8dd07
        aCk44OqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZaZd-00GeeR-FT; Wed, 30 Mar 2022 15:49:29 +0000
Date:   Wed, 30 Mar 2022 08:49:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Jane Chu <jane.chu@oracle.com>
Subject: Re: [PATCH v11 1/8] dax: Introduce holder for dax_device
Message-ID: <YkR8CUdkScEjMte2@infradead.org>
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-2-ruansy.fnst@fujitsu.com>
 <CAPcyv4jAqV7dZdmGcKrG=f8sYmUXaL7YCQtME6GANywncwd+zg@mail.gmail.com>
 <4fd95f0b-106f-6933-7bc6-9f0890012b53@fujitsu.com>
 <YkPtptNljNcJc1g/@infradead.org>
 <15a635d6-2069-2af5-15f8-1c0513487a2f@fujitsu.com>
 <YkQtOO/Z3SZ2Pksg@infradead.org>
 <4ed8baf7-7eb9-71e5-58ea-7c73b7e5bb73@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ed8baf7-7eb9-71e5-58ea-7c73b7e5bb73@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 30, 2022 at 06:58:21PM +0800, Shiyang Ruan wrote:
> As the code I pasted before, pmem driver will subtract its ->data_offset,
> which is byte-based. And the filesystem who implements ->notify_failure()
> will calculate the offset in unit of byte again.
> 
> So, leave its function signature byte-based, to avoid repeated conversions.

I'm actually fine either way, so I'll wait for Dan to comment.
