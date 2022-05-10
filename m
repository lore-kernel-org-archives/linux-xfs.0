Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8636C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 12:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242038AbiEJNAH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 09:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242096AbiEJNAF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 09:00:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C6517E3F
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pw8oZqVvH6E1KrNLfwXBPPoSYSLH5qEJt4x93JhzPAI=; b=UmgJMcwe463QecZJUwTLhYiUSe
        R1vzZ9yaBOA3qASpHn6BcHC+HmAU+t92ibrFX1EGV1cgmVZQJwIfYiypcswcsgbSbp9KqtTbPOuz7
        LmvmUd9V5wW+Ar2uCI8scZVMukbUNdQqN5DtHbgycGNkv4ET8Fg86EZno/SJvMCdynMFTMyyuw6QN
        wYZeAthYo6Zc9paClILFus0ettJL17KSFQp+s0PyidkcvJ2YRFUEOU4KcK8yMObSwLUh9v8MbG1G5
        9SXnMUUIJvSYdSUY8U7p7xcbgQyqK05tlDgTtVoNJbqqcwokqxyMKz7XOGClw+XiFDCnAq16W2ZAl
        LtC13suw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noPOz-0022tI-8I; Tue, 10 May 2022 12:55:45 +0000
Date:   Tue, 10 May 2022 05:55:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Catherine Hoang <catherine.hoang@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] mkfs: don't trample the gid set in the protofile
Message-ID: <Ynpg0UbWIJsvHKS3@infradead.org>
References: <165176670883.248587.2509972137741301804.stgit@magnolia>
 <165176674260.248587.3749201858763431936.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176674260.248587.3749201858763431936.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 09:05:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Catherine's recent changes to xfs/019 exposed a bug in how libxfs
> handles setgid bits.  mkfs reads the desired gid in from the protofile,
> but if the parent directory is setgid, it will override the user's
> setting and (re)set the child's gid to the parent's gid.  Overriding
> user settings is (probably) not the desired mode of operation, so create
> a flag to struct cred to force the gid in the protofile.
> 
> It looks like this has been broken since ~2005.

Ouch.  The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
