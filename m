Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B0DECE58E
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 17:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F32521925
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 17:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VdDyutdV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394925AbfJQR4b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 13:56:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46590 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394803AbfJQR4a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 13:56:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jw2QxeO03VZMlAkRGSUIbK+gG6Sw9+eOdiudXNUt6kw=; b=VdDyutdVx8kvP536fioAZJ7hD
        eFnbnXRldFfeoeKRIcGRHAf6nVV4faIhh+dR4j0XGsyxhb+6L5K5rwau8VDijaIlOkefk3rjuV+Nk
        njQ1548WtKpM+b4lK3iesZn7PNSSGTikuauFErIcJD8DlqpibNJZ/0qEFnYfiTp/IAuoQgFyjkuSL
        1Af6TwRrp9F6kwK5itQQeWQghz5XyHF3dHCjSIKp/ND/R6N+AicnU4qIftycbMmrx779haolLRUhP
        tP2H6x9zAtcYkVWHhL/+UJd2G3mtop4PGLh6pWd7I6LtHSPlDwRvpnQwEwelQ0umn5wM936EdXLrW
        8Sb04VwZw==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLA0g-0000eK-Uc; Thu, 17 Oct 2019 17:56:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: lift the xfs writepage code into iomap v8
Date:   Thu, 17 Oct 2019 19:56:10 +0200
Message-Id: <20191017175624.30305-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

this series cleans up the xfs writepage code and then lifts it to
fs/iomap/ so that it could be use by other file system.

Note: the submit_ioend hook has not been renamed.  Feel free to
rename it if you really dislike the name.


Changes since v7:
 - fix various commit log typos
 - fix up various comments
 - move some of the iomap tracepoint additions to an earlier patch
 - rebased on top of "iomap: iomap that extends beyond EOF should be
   marked dirty"

Changes since v6:
 - actually add trace.c to the patch
 - move back to the old order that massages XFS into shape and then
   lifts the code to iomap
 - cleanup iomap_ioend_compare
 - cleanup the add_to_ioend checks

Changes since v5:
 - move the tracing code to fs/iomap/trace.[ch]
 - fix a bisection issue with the tracing code
 - add an assert that xfs_end_io now only gets "complicated" completions
 - better document the iomap_writeback_ops methods in iomap.h

Changes since v4:
 - rebased on top 5.4-rc1
 - drop the addition of list_pop / list_pop_entry
 - re-split a few patches to better fit Darricks scheme of keeping the
   iomap additions separate from the XFS switchover

Changes since v3:
 - re-split the pages to add new code to iomap and then switch xfs to
   it later (Darrick)

Changes since v2:
 - rebased to v5.3-rc1
 - folded in a few changes from the gfs2 enablement series

Changes since v1:
 - rebased to the latest xfs for-next tree
 - keep the preallocated transactions for size updates
 - rename list_pop to list_pop_entry and related cleanups
 - better document the nofs context handling
 - document that the iomap tracepoints are not a stable API
