Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8D3CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 04:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbjJLEvi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 00:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjJLEvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 00:51:36 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD5A90
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 21:51:34 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 061546732D; Thu, 12 Oct 2023 06:51:31 +0200 (CEST)
Date:   Thu, 12 Oct 2023 06:51:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 1/3] xfs: bump max fsgeom struct version
Message-ID: <20231012045130.GA1637@lst.de>
References: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs> <169704720351.1773263.12324560217170051519.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704720351.1773263.12324560217170051519.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:02:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The latest version of the fs geometry structure is v5.

The commit log and change left me a little confused, having it in
a RT series even more.  So I went out and tried to understand it:

 - the fsgeom struct version is used by xfs_fs_geometry
 - XFS_FS_GEOM_MAX_STRUCT_VER is not used in the kernel at all,
   but libxfs uses it to always query all information in db and
   mkfs
 - commit 1b6d968de22bffd added the v5 structure, which mostly
   contains extra padding, but otherwise just reports the struct
   version for now

So this commit is a no-op for the kernel, and mostly a no-op for
userspace as nothing looks at the new field, but probably useful
for later changes.

Maybe capture this in the commit log.

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>
