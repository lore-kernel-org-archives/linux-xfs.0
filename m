Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DACEC35647
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 12:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25047222C4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 12:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgBUMAS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 07:00:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:38958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgBUMAS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Feb 2020 07:00:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9004EAF2B;
        Fri, 21 Feb 2020 12:00:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B113FDA70E; Fri, 21 Feb 2020 12:59:58 +0100 (CET)
Date:   Fri, 21 Feb 2020 12:59:58 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dsterba@suse.cz, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 00/23] Change readahead API
Message-ID: <20200221115957.GE2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org
References: <20200219210103.32400-1-willy@infradead.org>
 <20200220175400.GB2902@twin.jikos.cz>
 <20200220223909.GB24185@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220223909.GB24185@bombadil.infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 02:39:09PM -0800, Matthew Wilcox wrote:
> > >  - Now passes an xfstests run on ext4!
> > 
> > On btrfs it still chokes on the first test btrfs/001, with the following
> > warning, the test is stuck there.
> 
> Thanks.  The warning actually wasn't the problem, but it did need to
> be addressed.  I got a test system up & running with btrfs, and it's
> currently on generic/027 with the following patch:

Thanks, with the fix applied the first 10 tests passed, I'll let the
testsuite finish and let you know if ther are more warnings and such.
