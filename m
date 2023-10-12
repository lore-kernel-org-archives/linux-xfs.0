Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A69B4CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 17:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344076AbjJLRiD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 13:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347377AbjJLRhm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 13:37:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BC1186
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 10:35:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F018C433C8;
        Thu, 12 Oct 2023 17:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697132099;
        bh=+pnaZEfFjRmLDJfUeuDmUddfq6kf5WbhLedkCQ+HpHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f87VQq8pLjfDXko16AqekJ7tl/wtJuACcGYbcKk+UnxjJXzjBGr03OGRUDJxhk8KM
         eulJf7N5MPexqk5OKK86xtD9BO29Rv5xjymrQ4S9DAz/IC9tM7Mxogeag4nUJZiMaX
         7hdhE0q/wiEXFq58uR/1cn4mQeWJcdTehAOMPQfr+ddiwwbGoiEnhom0MY0YrdrkQI
         ngSNnmjQwlEDHzSrgnAPMSqO5IAOsAphxAbEcxBLvQ24A/ACgVz4L/TZc8lB3fNJ4v
         cL7DRAc2XAp/PShqdocNZYEOzVVwTGVDGUFPF9IcXTpCOgKMrzLzE0UEFBCppADWB1
         YWOWNpTVIYkyw==
Date:   Thu, 12 Oct 2023 10:34:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 1/3] xfs: bump max fsgeom struct version
Message-ID: <20231012173459.GG21298@frogsfrogsfrogs>
References: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs>
 <169704720351.1773263.12324560217170051519.stgit@frogsfrogsfrogs>
 <20231012045130.GA1637@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012045130.GA1637@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 06:51:30AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:02:03AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The latest version of the fs geometry structure is v5.
> 
> The commit log and change left me a little confused, having it in
> a RT series even more.  So I went out and tried to understand it:
> 
>  - the fsgeom struct version is used by xfs_fs_geometry
>  - XFS_FS_GEOM_MAX_STRUCT_VER is not used in the kernel at all,
>    but libxfs uses it to always query all information in db and
>    mkfs
>  - commit 1b6d968de22bffd added the v5 structure, which mostly
>    contains extra padding, but otherwise just reports the struct
>    version for now
> 
> So this commit is a no-op for the kernel, and mostly a no-op for
> userspace as nothing looks at the new field, but probably useful
> for later changes.
> 
> Maybe capture this in the commit log.

I've changed the commit message to:

xfs: bump max fsgeom struct version

The latest version of the fs geometry structure is v5.  Bump this
constant so that xfs_db and mkfs calls to libxfs_fs_geometry will fill
out all the fields.

IOWs, this commit is a no-op for the kernel, but will be useful for
userspace reporting in later changes.

> With that:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you!

--D
