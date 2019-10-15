Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7598EC10F14
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 08:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CFD420873
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 08:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L6p5C1wC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfJOIBM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 04:01:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37824 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfJOIBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 04:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QQ9QN/iK5ai9ajNOdo+9OkqRPuRUL2eL7TDow4sjeu4=; b=L6p5C1wC28xb4xV/ytStImi/n
        SV2iv4Hjrb+zQYIjHC5OIRoQt2FCR3rotBnYGdihUInJs5Y+lXexNKAZKw1XhTXXTzxcqSL5L86hZ
        kKgdo28rNBbi+hPf8BlLlY9trWgIHMU7EaYEgNuVg6jq/rwQBiZ3mmyUVqJHmJd7/TJG3voH/jXr+
        zoR3ladcSEOvo1Z1l2E1eXyZ7+edNMBda6a9KuH0FIWk2RjvsWzNKuNbegHEMx+3j6EHdx7SwAMUH
        NmdlCkggWdeE6ObgGfQ8L6DYKa0sYuW7P5cGl/Snou5v4lh8+gKAe1LIaN5lLQ6IffEfoucjqR71U
        /kODYccaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKHlO-0002Ht-4T; Tue, 15 Oct 2019 08:01:02 +0000
Date:   Tue, 15 Oct 2019 01:01:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Jan Kara <jack@suse.cz>, Pingfan Liu <kernelfans@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>, Jan Kara <jack@suse.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: introduce "metasync" api to sync metadata to fsblock
Message-ID: <20191015080102.GB3055@infradead.org>
References: <1570977420-3944-1-git-send-email-kernelfans@gmail.com>
 <20191013163417.GQ13108@magnolia>
 <20191014083315.GA10091@mypc>
 <20191014094311.GD5939@quack2.suse.cz>
 <d3ffa114-8b73-90dc-8ba6-3f44f47135d7@sandeen.net>
 <20191014200303.GF5939@quack2.suse.cz>
 <5796090e-6206-1bd7-174e-58798c9af052@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5796090e-6206-1bd7-174e-58798c9af052@sandeen.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 14, 2019 at 03:09:48PM -0500, Eric Sandeen wrote:
> We're in agreement here.  ;)  I only worry about implementing things like this
> which sound like guarantees, but aren't, and end up encouraging bad behavior
> or promoting misconceptions.
> 
> More and more, I think we should reconsider Darrick's "bootfs" (ext2 by another
> name, but with extra-sync-iness) proposal...

Having a separate simple file system for the boot loader makes a lot of
sense.  Note that vfat of EFI is the best choice, but at least it is
something.  SysV Unix from the 90s actually had a special file system just
for that, and fs/bfs/ in Linux supports that.  So this isn't really a new
thing either.
