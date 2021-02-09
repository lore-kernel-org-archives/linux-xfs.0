Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A95C433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 19:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77C5C64EC7
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 19:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhBITMH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 14:12:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233454AbhBIS46 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 13:56:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9051F64E56;
        Tue,  9 Feb 2021 18:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612896352;
        bh=8VmciO7cGIcuZq6aO7WX3Bzy9hhc7dfsrl2rtAlTVUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eEwhOQoaGti5vYqfp5PVa1lxhI7UgUMvjregAo9FBStaH3qS828KGUW2Q1QBXUZ0w
         ZVZ+DPlhggstq+McBIi67+LmeXfJcITnw1CAFGbSDCw7Gn/OkzGQ8yDHFhdiN/tfCL
         Tnzin/4MXzO4OaEFg85VBIEVpUUS7lmLO9Rbt6S+vmFkFZ2XywAWE843gJj5uf/f6v
         NkCjp5yGKd7m5HykYUoJj5p6pA8DVZjq3VGBk9rCu26eEP0daDxoQkfPwHlBk6Tcea
         pUoW9yT7bMW5NEdXLLg+FIVWRkTDJ9JtmYtiEir+ufwxyaVNAolHQOi9Kx4s9PWoUq
         CRqu0yJea/7YA==
Date:   Tue, 9 Feb 2021 10:45:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 07/10] xfs_repair: set NEEDSREPAIR when we deliberately
 corrupt directories
Message-ID: <20210209184552.GX7193@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384405.3057868.8114203697655713495.stgit@magnolia>
 <20210209091336.GG1718132@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209091336.GG1718132@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 09:13:36AM +0000, Christoph Hellwig wrote:
> On Mon, Feb 08, 2021 at 08:10:44PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There are a few places in xfs_repair's directory checking code where we
> > deliberately corrupt a directory entry as a sentinel to trigger a
> > correction in later repair phase.  In the mean time, the filesystem is
> > inconsistent, so set the needsrepair flag to force a re-run of repair if
> > the system goes down.
> 
> I guess this is an improvement over what we have no, but I suspect an
> in-core side band way to notify the later phases would be much better
> than these corrupt sentinel values..

It would be, but we'd still have to track which directory entries are
thee ones that we don't want to preserve.  We could rewrite the
directory entry to point to a plausible inode number that isn't
allocated, but that runs the risk that someone will come along and
allocate that inode for lost+found and then we're really in a mess.

Alternately, I suppose we could rewrite the directory entry to be a
DHT_WHITEOUT entry that doesn't look like any that the kernel would
produce ... insofar as I'm not even sure what the real ones were
supposed to look like, given the weird left turn that overlayfs took on
that. :(

--D
