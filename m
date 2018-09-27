Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50300 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbeI0P1A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Sep 2018 11:27:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id s12-v6so5097866wmc.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Sep 2018 02:09:45 -0700 (PDT)
Date: Thu, 27 Sep 2018 11:09:41 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH 00/24] xfs-4.20: major documentation surgery
Message-ID: <20180927090941.qgxyoptogdnllrfc@odin.usersys.redhat.com>
References: <153799045443.31202.17537455000771265705.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153799045443.31202.17537455000771265705.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Sep 26, 2018 at 12:34:14PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series converts the existing in-kernel xfs documentation to rst
> format, links it in with the rest of the kernel's rst documetation, and
> then begins pulling in the contents of the Data Structures & Algorithms
> book from the xfs-documentation git tree.  No changes are made to the
> text during the import process except to fix things that the conversion
> process (asciidoctor + pandoc) didn't do correctly.  The goal of this
> series is to tie together the XFS code with the on-disk format
> documentation for the features supported by the code.
> 
> I've built the docs and put them here, in case you hate reading rst:
> https://djwong.org/docs/kdoc/filesystems/xfs/index.html
> 
> I've posted a branch here because the png import patch is huge:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=docs-4.20-merge
> 
> The patchset should apply cleanly against 4.19-rc5.  Comments and
> questions are, as always, welcome.
> 
> --D

Really nice.

I am not the best person to enter into the licensing discussion, but since
you've already agreed to repost it with updated licensing stuff, for the
documentation patches itself, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Cheers

-- 
Carlos
