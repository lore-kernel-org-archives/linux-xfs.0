Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D97C43214
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 19:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B3E560EC0
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 19:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhGVSVn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhGVSVn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 14:21:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 068B660EBD;
        Thu, 22 Jul 2021 19:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626980538;
        bh=7GgGJFS6xJVmooVGBYylZxHdGh3KahrNoOjnD3IBZh4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bjN5R0JA1ZOC8wjA61Y1swMxXVius9QzMBEkd/Q+XzcILTG/nk8WhikbCl/f8dcVe
         xBUvBAxvvuv4yk+TtrS2bQmDLUo6cNK6cr6ijdcSJVf10pY0norQVsPcDcnrtzpLjK
         5/zclwFKgRcfCoXAXINVmJ8Uu6Dsuv0UughYt6F1LIh2uvahcr2XPSJoOBKjmsz6L3
         JEHeoWKBWJmA8M0LMrby56FNZeTz6fXTMCT4kfBj4n8/Etg4RMVv6LPuRhQxGTdy3x
         Tic+8dcoWGj0Lw6udfxu/njKUvqxoIdZOsQtbyJsNAe3oKPu2fwXVDLaJLomnm3MFd
         wRUhzuCRggIPA==
Date:   Thu, 22 Jul 2021 12:02:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] xfs: test regression in shrink when EOFS splits a
 sparse inode cluster
Message-ID: <20210722190217.GG559212@magnolia>
References: <162674333583.2650988.770205039530275517.stgit@magnolia>
 <162674334129.2650988.5261253913273700235.stgit@magnolia>
 <YPkSu7fKSQr6GHMR@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPkSu7fKSQr6GHMR@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 07:39:55AM +0100, Christoph Hellwig wrote:
> What do EOFS and EOAG stand for?

End of Filesystem and End of AG.  The shrink code forgot that we can't
have inode records that stretch past the end of the last AG, even if
the upper inodes are sparse.

--D
