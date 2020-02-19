Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE537C3404D
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 12:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8994024654
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 12:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgBSMJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 07:09:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:57664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgBSMJC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Feb 2020 07:09:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 22A5EBC45;
        Wed, 19 Feb 2020 12:09:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 08FB3DA838; Wed, 19 Feb 2020 13:08:43 +0100 (CET)
Date:   Wed, 19 Feb 2020 13:08:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qian Cai <cai@lca.pw>
Cc:     viro@zeniv.linux.org.uk, hch@infradead.org,
        darrick.wong@oracle.com, elver@google.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: fix a data race in i_size_write/i_size_read
Message-ID: <20200219120843.GU2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qian Cai <cai@lca.pw>,
        viro@zeniv.linux.org.uk, hch@infradead.org, darrick.wong@oracle.com,
        elver@google.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200219040426.1140-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219040426.1140-1-cai@lca.pw>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 11:04:26PM -0500, Qian Cai wrote:
> inode::i_size could be accessed concurently as noticed by KCSAN,
> 
>  BUG: KCSAN: data-race in iomap_do_writepage / iomap_write_end
> 
> The write is protected by exclusive inode::i_rwsem (in
> xfs_file_buffered_aio_write()) but the read is not. A shattered value
> could introduce a logic bug. Fixed it using a pair of WRITE/READ_ONCE().

We had a different problem with lack of READ_ONCE/WRITE_ONCE for i_size,
the fix was the same though. There was i_size_read(inode) used in max()
macro and compiled code two reads (unlocked), and this led to a race
when where different value was checked and then used.

The thread:
https://lore.kernel.org/linux-fsdevel/20191011202050.8656-1-josef@toxicpanda.com/

We had to apply a workaround to btrfs code because the generic fix was
not merged, even with several reviews and fixing a real bug. The report
from KCSAN seems to require some sort of splitting the values. What we
saw happened on 64bit platform without that effect so I'd call that a
more likely to happen because the pattern max(i_size_read(inode), ...) is
not something we'd instinctively consider unsafe.
