Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D96C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D3A864EC2
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhBIRPz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:15:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233088AbhBIRPy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 12:15:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FD6064EC2;
        Tue,  9 Feb 2021 17:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612890913;
        bh=YP3Ua7zorqH6p+WwqPc7lXGhfoMf2Aa7JEFt0J7y/cg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RwkTpIMIr7A3Ilp9RadlcstHCHwz/QOG4H5RuRRg+k7cPbVTphpD2HSoqAFEQyGw7
         3zfOFfeieK77r/nsMAhTuAiP37l+VvAAkdEoEL/S6cnJIhIQCUBRLuBh20FTrWR6f8
         7UCxdnO4v661Dm9CYplqyobQqyIGJlBjd1W5J2JU3G82N6oxK8hPPvaQrcpslGXd9d
         1tjETliuSWH+PsrLdW7aryWsAE1PAaJ5YcJJ5OG/jAcqaJM0NgPhhRobk9rD6ECYkh
         CM/6gtUMHdcI3NSxUjAaoDiHXduKfJFTg5OP6v8qT2KB020Cs3ydb1jnjaNqFFOOgR
         I5Frb5pERRK0Q==
Date:   Tue, 9 Feb 2021 09:15:12 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 03/10] xfs_db: support the needsrepair feature flag in
 the version command
Message-ID: <20210209171512.GQ7193@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284382116.3057868.4021834592988203500.stgit@magnolia>
 <20210209090940.GC1718132@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209090940.GC1718132@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 09:09:40AM +0000, Christoph Hellwig wrote:
> On Mon, Feb 08, 2021 at 08:10:21PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Teach the xfs_db version command about the 'needsrepair' flag, which can
> > be used to force the system administrator to repair the filesystem with
> > xfs_repair.
> 
> In the "version" command?

Urk.  Yeah, this patch is a bit incoherent.  Two of the hunks merely
report the presence of needsrepair in check/version; and the middle two
are used to prevent the administrative changes that we allow via
xfs_admin (aka label/uuid) on a needsrepair fs.

Will split them up and repost with better commit messages.

Thanks for the review!

--D
