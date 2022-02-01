Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1185C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 20:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236912AbiBAUGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 15:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiBAUGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 15:06:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3CCC061714
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 12:06:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E91061698
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 20:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DF9C340EB;
        Tue,  1 Feb 2022 20:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643745993;
        bh=Uxf7cCMAabkaoetHi93CEQuQmoIurEs1WLsbzC5Fa/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MJjYrvoiU222K430N3tRcbm6BW0T9O3Z5J137dmcilur8LEnEKO9F/6LtCw1aYhvc
         CDi7vNpbPgpU+Bx/02OcO0BO5CAzDXjqpQXqSmmBcihyJHcFk8j4R8pGTiCIRNdm7n
         PEPTCfStsCvhrNbsmfce874Aj1IqXw4wBslWQtsYn5yVPr8le2nyjl91PfRVvqTHx6
         dog/CoaHFSkXNyFNkCZStx7sQO9lWOAV0RGkM5kVjjvRl0w7gGDn85T2GWUSnL72A3
         5Y55d5LXaxHOwT0Y6DKAWV4Kslvz/mocGKzb7acEDGAYts/n4s19ceaEHJZ1g2WL5o
         CpsXyBhiaGwjg==
Date:   Tue, 1 Feb 2022 12:06:32 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/2] xfsprogs: add error tags for log attribute
 replay test
Message-ID: <20220201200632.GP8313@magnolia>
References: <20220201171755.22651-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220201171755.22651-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 01, 2022 at 05:17:53PM +0000, Catherine Hoang wrote:
> Hi all,
> 
> These are the corresponding userspace changes for the new log attribute
> replay test. These are built on top of Allison’s logged attribute patch
> sets, which can be viewed here:
> https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v26_extended
> 
> This set adds the new error tags da_leaf_split and larp_leaf_to_node,
> which are used to inject errors in the tests. 
> 
> v2->v3:
> Rename larp_leaf_split to da_leaf_split

With the XFS_ERRTAG_LARP_LEAF_TO_NODE -> XFS_ERRTAG_ATTR_LEAF_TO_NODE
change made, you can add:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

For the whole series.

--D

> 
> Suggestions and feedback are appreciated!
> 
> Catherine
> 
> 
> Catherine Hoang (2):
>   xfsprogs: add leaf split error tag
>   xfsprogs: add leaf to node error tag
> 
>  io/inject.c            | 2 ++
>  libxfs/xfs_attr_leaf.c | 5 +++++
>  libxfs/xfs_da_btree.c  | 3 +++
>  libxfs/xfs_errortag.h  | 6 +++++-
>  4 files changed, 15 insertions(+), 1 deletion(-)
> 
> -- 
> 2.25.1
> 
