Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB338C38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 16:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjARQna (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 11:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjARQnH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 11:43:07 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA6C37558;
        Wed, 18 Jan 2023 08:42:12 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7BA7A67373; Wed, 18 Jan 2023 17:42:08 +0100 (CET)
Date:   Wed, 18 Jan 2023 17:42:08 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hugh Dickins <hughd@google.com>, linux-afs@lists.infradead.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 9/9] mm: return an ERR_PTR from __filemap_get_folio
Message-ID: <20230118164208.GA7584@lst.de>
References: <20230118094329.9553-1-hch@lst.de> <20230118094329.9553-10-hch@lst.de> <CAKFNMomcjvUSh-nS1MqptYdiT-1frRsmHgx2mHBBm_588kprrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKFNMomcjvUSh-nS1MqptYdiT-1frRsmHgx2mHBBm_588kprrQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2023 at 09:39:08PM +0900, Ryusuke Konishi wrote:
> > Also pass through the error through the direct callers:
> 
> > filemap_get_folio, filemap_lock_folio filemap_grab_folio
> > and filemap_get_incore_folio.
> 
> As for the comments describing the return values of these callers,
> isn't it necessary to rewrite the value from NULL in case of errors ?

Yes, thanks for catching this.
