Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D971DC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 13:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B62CB22DBF
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 13:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbfHTNb0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 09:31:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbfHTNb0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 09:31:26 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D73C33082A49;
        Tue, 20 Aug 2019 13:31:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3B751DA;
        Tue, 20 Aug 2019 13:31:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190814111535.GC1885@lst.de>
References: <20190814111535.GC1885@lst.de> <20190808082744.31405-1-cmaiolino@redhat.com> <20190808082744.31405-3-cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     dhowells@redhat.com, Carlos Maiolino <cmaiolino@redhat.com>,
        linux-fsdevel@vger.kernel.org, adilger@dilger.ca,
        jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu,
        rpeterso@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] cachefiles: drop direct usage of ->bmap method.
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19938.1566307880.1@warthog.procyon.org.uk>
Date:   Tue, 20 Aug 2019 14:31:20 +0100
Message-ID: <19939.1566307880@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 20 Aug 2019 13:31:25 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> > +	block = page->index;
> > +	block <<= shift;
> 
> Can't this cause overflows?

No, not unless the netfs allows files >16EiB in size and as long as block
(type sector_t) is a 64-bit integer.

A 16EiB-1 (0xffffffffffffffff) file would have 4P-1 (0xfffffffffffff) pages
assuming a 4K page size.

At a block size of 1 (and a shift therefore of 12), the maximum block number
calculated would be 0xfffffffffffff000.

David
