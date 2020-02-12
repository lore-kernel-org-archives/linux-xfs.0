Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1D4C352A4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 18:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA68721569
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 18:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgBLSvb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 13:51:31 -0500
Received: from albireo.enyo.de ([37.24.231.21]:36718 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgBLSvb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Feb 2020 13:51:31 -0500
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1j1x6Z-00041J-SJ; Wed, 12 Feb 2020 18:51:23 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1j1x5F-0004YG-Bi; Wed, 12 Feb 2020 19:50:01 +0100
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, libc-alpha@sourceware.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: XFS reports lchmod failure, but changes file system contents
References: <874kvwowke.fsf@mid.deneb.enyo.de>
        <20200212161604.GP6870@magnolia>
        <20200212181128.GA31394@infradead.org>
Date:   Wed, 12 Feb 2020 19:50:01 +0100
In-Reply-To: <20200212181128.GA31394@infradead.org> (Christoph Hellwig's
        message of "Wed, 12 Feb 2020 10:11:28 -0800")
Message-ID: <87pnejmyhy.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

* Christoph Hellwig:

> xfs doesn't seem all that different from the other file systems,
> so I suspect you'll also see it with other on-disk file systems.
> We probably need a check high up in the chmod and co code to reject
> the operation early for O_PATH file descriptors pointing to symlinks.

We will change the glibc emulation to avoid trying to lchmod symbolic
links in this way.  This will avoid triggering the kernel bug.

(We'd really like to get a proper fchmodat system call with a flags
argument, though, for AT_EMPTY_PATH and AT_SYMLINK_NOFOLLOW.)

And part of my testing was wrong, this is a symbolic-link-only issue.
