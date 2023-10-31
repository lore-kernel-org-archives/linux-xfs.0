Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D10AC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 16:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbjJaQrk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 12:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbjJaQrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 12:47:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41D1199C
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 09:46:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447C8C433C7;
        Tue, 31 Oct 2023 16:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698770802;
        bh=AyaGNfbJHRJg+Dy92s8p21HMsXNSciBdwXR69AwcMo0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kcUxws4vKVPtosRGXgmEipJ8jGL7F36DCHFbly15cjHcRT8ZdaEYZVtE9YSbvEUWb
         mw3yFdnKfN1rN32c+zUzINpMhEVNb5kg77jV18M0YvDJOs/rYnEN9jwXFJFqelVPTp
         O7jI0HvJnrDu6Hep0EwmhDTUhlUbVgYXbfKko1WNQfK8H3uZlzB1yBCZBM2Ac/mgjE
         toly5FNF9qZ1HzZzhYRWcJSIg68dKyeQ5mPSHD+V6QZhTejd4BIhmFeK8E8+ZAU5tr
         90FTGH8FlCRWIDbfAzt2Q/BYgo/NtNRyk9pH5JqDqMQbbd+0K/JQSrd6vWWx5A/X5d
         68gDpnO18Iy8w==
Date:   Tue, 31 Oct 2023 09:46:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>,
        Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 00/23] Metadump v2
Message-ID: <20231031164640.GB1041814@frogsfrogsfrogs>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 10:05:04AM +0530, Chandan Babu R wrote:
> Hi all,
> 
> This patch series extends metadump/mdrestore tools to be able to dump
> and restore contents of an external log device. It also adds the
> ability to copy larger blocks (e.g. 4096 bytes instead of 512 bytes)
> into the metadump file. These objectives are accomplished by
> introducing a new metadump file format.

Gentle maintainer ping: Carlos, do you have any thoughts about this
series?  The only unaddressed review comment was <cough> me asking for
code golf around patch 18 or so.  Do you (or anyone else) see any
problems that I've not spotted?

--D

> 
> I have tested the patchset by extending metadump/mdrestore tests in
> fstests to cover the newly introduced metadump v2 format. The tests
> can be found at
> https://github.com/chandanr/xfstests/commits/metadump-v2.
> 
> The patch series can also be obtained from
> https://github.com/chandanr/xfsprogs-dev/commits/metadump-v2.
> 
> Darrick, Please note that I have removed your RVB from "metadump: Add
> support for passing version option" patch. copy_log() and metadump_f()
> were invoking set_log_cur() for both "internal log" and "external
> log". In the V3 patchset, I have modified the copy_log() function to,
> 1. Invoke set_log_cur() when the filesystem has an external log.
> 2. Invoke set_cur() when the filesystem has an internal log.
> 
> Changelog:
> V2 -> V3:
>   1. Document the meanings of metadump v2's ondisk flags.
>   2. Rename metadump_ops->end_write() to metadump_ops->finish_dump().
>   3. Pass a pointer to the newly introduced "union mdrestore_headers"
>      to callbacks in "struct mdrestore_ops" instead of a pointer to
>      "void".
>   4. Use set_log_cur() only when metadump has to be read from an
>      external log device.
>   5. Verify that primary superblock read from metadump file was indeed
>      read from the data device.
>   6. Fix indentation issues.
> 
> V1 -> V2:
>   1. Introduce the new incompat flag XFS_MD2_INCOMPAT_EXTERNALLOG to
>      indicate that the metadump file contains data obtained from an
>      external log.
>   2. Interpret bits 54 and 55 of xfs_meta_extent.xme_addr as a counter
>      such that 00 maps to the data device and 01 maps to the log
>      device.
>   3. Define the new function set_log_cur() to read from
>      internal/external log device. This allows us to continue using
>      TYP_LOG to read from both internal and external log.
>   4. In order to support reading metadump from a pipe, mdrestore now
>      reads the first four bytes of the header to determine the
>      metadump version rather than reading the entire header in a
>      single call to fread().
>   5. Add an ASCII diagram to describe metadump v2's ondisk layout in
>      xfs_metadump.h.
>   6. Update metadump's man page to indicate that metadump in v2 format
>      is generated by default if the filesystem has an external log and
>      the metadump version to use is not explicitly mentioned on the
>      command line.
>   7. Remove '_metadump' suffix from function pointer names in "struct
>      metadump_ops".
>   8. Use xfs_daddr_t type for declaring variables containing disk
>      offset value.
>   9. Use bool type rather than int for variables holding a boolean
>      value.
>   11. Remove unnecessary whitespace.
> 
> 
> Chandan Babu R (23):
>   metadump: Use boolean values true/false instead of 1/0
>   mdrestore: Fix logic used to check if target device is large enough
>   metadump: Declare boolean variables with bool type
>   metadump: Define and use struct metadump
>   metadump: Add initialization and release functions
>   metadump: Postpone invocation of init_metadump()
>   metadump: Introduce struct metadump_ops
>   metadump: Introduce metadump v1 operations
>   metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
>   metadump: Define metadump v2 ondisk format structures and macros
>   metadump: Define metadump ops for v2 format
>   xfs_db: Add support to read from external log device
>   metadump: Add support for passing version option
>   mdrestore: Declare boolean variables with bool type
>   mdrestore: Define and use struct mdrestore
>   mdrestore: Detect metadump v1 magic before reading the header
>   mdrestore: Add open_device(), read_header() and show_info() functions
>   mdrestore: Introduce struct mdrestore_ops
>   mdrestore: Replace metadump header pointer argument with a union
>     pointer
>   mdrestore: Introduce mdrestore v1 operations
>   mdrestore: Extract target device size verification into a function
>   mdrestore: Define mdrestore ops for v2 format
>   mdrestore: Add support for passing log device as an argument
> 
>  db/io.c                   |  56 ++-
>  db/io.h                   |   2 +
>  db/metadump.c             | 777 ++++++++++++++++++++++++--------------
>  db/xfs_metadump.sh        |   3 +-
>  include/xfs_metadump.h    |  70 +++-
>  man/man8/xfs_mdrestore.8  |   8 +
>  man/man8/xfs_metadump.8   |  14 +
>  mdrestore/xfs_mdrestore.c | 497 ++++++++++++++++++------
>  8 files changed, 1014 insertions(+), 413 deletions(-)
> 
> -- 
> 2.39.1
> 
