Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF4AC4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 15:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A491222C9
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 15:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfIZP4M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 11:56:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:58098 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726105AbfIZP4L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 11:56:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 290FDAF83;
        Thu, 26 Sep 2019 15:56:10 +0000 (UTC)
Date:   Thu, 26 Sep 2019 17:56:08 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Cyril Hrubis <chrubis@suse.cz>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ltp@lists.linux.it
Subject: copy_file_range() errno changes introduced in v5.3-rc1
Message-ID: <20190926155608.GC23296@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Amir,

I'm going to fix LTP test copy_file_range02 before upcoming LTP release.
There are some returning errno changes introduced in v5.3-rc1, part of commit 40f06c799539
("Merge tag 'copy-file-range-fixes-1' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux").
These changes looks pretty obvious as wanted, but can you please confirm it they were intentional?

* 5dae222a5ff0 ("vfs: allow copy_file_range to copy across devices") started to return -EXDEV.
* 96e6e8f4a68d ("vfs: add missing checks to copy_file_range") started to return -EPERM, -ETXTBSY, -EOVERFLOW.

Thanks for info.

Kind regards,
Petr
