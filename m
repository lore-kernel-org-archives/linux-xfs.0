Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478EBC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 May 2022 14:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348534AbiEQOMO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 10:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348733AbiEQOL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 10:11:56 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAE6013CFD
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 07:11:53 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E5F5C170B67;
        Tue, 17 May 2022 09:11:41 -0500 (CDT)
Message-ID: <69bfaaca-ba42-a055-2f73-be845302591f@sandeen.net>
Date:   Tue, 17 May 2022 09:11:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176689880.252326.13947902143386455815.stgit@magnolia>
 <165176691556.252326.13840084561552016776.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 3/4] xfs_scrub: balance inode chunk scan across CPUs
In-Reply-To: <165176691556.252326.13840084561552016776.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:08 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use the bounded workqueue functionality to spread the inode chunk scan
> load across the CPUs more evenly.  First, we create per-AG workers to
> walk each AG's inode btree to create inode batch work items for each
> inobt record.  These items are added to a (second) bounded workqueue
> that invokes BULKSTAT and invokes the caller's function on each bulkstat
> record.
> 
> By splitting the work items into batches of 64 inodes instead of one
> thread per AG, we keep the level of parallelism at a reasonably high
> level almost all the way to the end of the inode scan if the inodes are
> not evenly divided across AGs or if a few files have far more extent
> records than average.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Insofar as I at least read through it, applied it, built it, and
regression-tested it and didn't see anything wrong,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

