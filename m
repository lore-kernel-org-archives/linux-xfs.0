Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AAEDC25B4E
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Jan 2023 07:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjAVHUM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Jan 2023 02:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVHUM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Jan 2023 02:20:12 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052291716D;
        Sat, 21 Jan 2023 23:20:10 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D803A68AA6; Sun, 22 Jan 2023 08:20:06 +0100 (CET)
Date:   Sun, 22 Jan 2023 08:20:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Hugh Dickins <hughd@google.com>, linux-afs@lists.infradead.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nilfs@vger.kernel.org
Subject: Re: return an ERR_PTR from __filemap_get_folio v2
Message-ID: <20230122072006.GA3654@lst.de>
References: <20230121065755.1140136-1-hch@lst.de> <20230121170641.121f4224a0e8304765bb4738@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121170641.121f4224a0e8304765bb4738@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 21, 2023 at 05:06:41PM -0800, Andrew Morton wrote:
> This patchset doesn't apply to fs/btrfs/ because linux-next contains
> this 6+ month-old commit:

Hmm.  It was literally written against linux-next as of last morning,
which does not have that commit.
