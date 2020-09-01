Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB1EC433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 06:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C91122098B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 06:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgIAGnt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 02:43:49 -0400
Received: from verein.lst.de ([213.95.11.211]:52046 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgIAGnt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Sep 2020 02:43:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 18CDD68B05; Tue,  1 Sep 2020 08:43:47 +0200 (CEST)
Date:   Tue, 1 Sep 2020 08:43:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs: reuse _xfs_buf_read for re-reading the
 superblock
Message-ID: <20200901064346.GA29057@lst.de>
References: <20200830061512.1148591-1-hch@lst.de> <20200830061512.1148591-14-hch@lst.de> <20200831204033.GV6107@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831204033.GV6107@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 01:40:33PM -0700, Darrick J. Wong wrote:

[fullquote deleted..]

> > +	error = _xfs_buf_read(bp, XBF_READ, &xfs_sb_buf_ops);
> 
> Question: xfs_getsb() returns mp->m_sb_bp.  The only place we set that
> variable is in xfs_readsb immediately after setting b_ops by hand.  Is
> there some circumstance where at the end of log recovery, m_sb_bp is set
> to a buffer but that buffer's ops are not set to xfs_sb_buf_ops?
> 
> In other words, do we have to do all this surgery on _xfs_buf_read to
> set the ops?  If they're not set (or worse, set to something else) at
> this point then there's probably something seriously wrong...
> 
> ...possibly my understanding of this buffer. ;)

No, I think your understanding is right.  I've thrown in two more
cleanup patches that helped me following how m_sb_bp is used, and
simplified this one to not need to explicitly passed ops.  Testing now..
