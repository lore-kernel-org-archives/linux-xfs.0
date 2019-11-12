Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855CCC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 12:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 659352084E
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 12:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfKLMIX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 07:08:23 -0500
Received: from verein.lst.de ([213.95.11.211]:55449 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbfKLMIW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Nov 2019 07:08:22 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id AA4E468BE1; Tue, 12 Nov 2019 13:08:18 +0100 (CET)
Date:   Tue, 12 Nov 2019 13:08:18 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     Ian Kent <raven@themaw.net>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        lkp@lists.01.org, Christoph Hellwig <hch@lst.de>,
        ltp@lists.linux.it
Subject: Re: [LTP] [xfs] 73e5fff98b: kmsg.dev/zero:Can't_open_blockdev
Message-ID: <20191112120818.GA8858@lst.de>
References: <20191111010022.GH29418@shao2-debian> <3fb8b1b04dd7808b45caf5262ee629c09c71e0b6.camel@themaw.net> <1108442397.11662343.1573560143066.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1108442397.11662343.1573560143066.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 07:02:23AM -0500, Jan Stancek wrote:
> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/fs/fs_fill/fs_fill.c
> 
> Setup of that test is trying different file system types, and it looks
> at errno code of "mount -t $fs /dev/zero /mnt/$fs".
> 
> Test still PASSes. This report appears to be only about extra message in dmesg,
> which wasn't there before:
> 
> # mount -t xfs /dev/zero /mnt/xfs
> # dmesg -c
> [  897.177168] /dev/zero: Can't open blockdev

That message comes from fs/super.c:get_tree_bdev(), a common library
used by all block device based file systems using the new mount API.

It doesn't seem all that useful to me, but it is something we'll
need to discuss with David and Al, not the XFS maintainers.
