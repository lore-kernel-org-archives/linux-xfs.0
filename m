Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5777BCDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 04:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjJSE6g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 00:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjJSE6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 00:58:36 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F77A4;
        Wed, 18 Oct 2023 21:58:34 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AC54B67373; Thu, 19 Oct 2023 06:58:30 +0200 (CEST)
Date:   Thu, 19 Oct 2023 06:58:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     djwong@kernel.org, willy@infradead.org, hch@lst.de,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2] iomap: fix short copy in iomap_write_iter()
Message-ID: <20231019045830.GA13900@lst.de>
References: <8762e91a210f4cc5713fce05fe5906c18513bd0a.1697617238.git.jstancek@redhat.com> <e1cb4f8981f8c6e7e0384e95faf1911d9937e979.1697647960.git.jstancek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1cb4f8981f8c6e7e0384e95faf1911d9937e979.1697647960.git.jstancek@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
