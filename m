Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4B9C43334
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 00:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbiFBAwn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 20:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbiFBAwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 20:52:42 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D86FBFC9;
        Wed,  1 Jun 2022 17:52:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8CA1310E6F8A;
        Thu,  2 Jun 2022 10:52:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nwZ4o-001bL3-2C; Thu, 02 Jun 2022 10:52:38 +1000
Date:   Thu, 2 Jun 2022 10:52:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 5.10 CANDIDATE 1/8] xfs: fix up non-directory creation in
 SGID directories
Message-ID: <20220602005238.GK227878@dread.disaster.area>
References: <20220601104547.260949-1-amir73il@gmail.com>
 <20220601104547.260949-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601104547.260949-2-amir73il@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=629809d8
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=w3tfhtfA4d3Uo5KN1WgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 01, 2022 at 01:45:40PM +0300, Amir Goldstein wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.
> 
> XFS always inherits the SGID bit if it is set on the parent inode, while
> the generic inode_init_owner does not do this in a few cases where it can
> create a possible security problem, see commit 0fa3ecd87848
> ("Fix up non-directory creation in SGID directories") for details.

inode_init_owner() introduces a bunch more SGID problems because
it strips the SGID bit from the mode passed to it, but all the code
outside it still sees the SGID bit set. IIRC, that means we do the
wrong thing when ACLs are present. IIRC, there's an LTP test for
this CVE now, and it also has a variant which uses ACLs and that
fails too....

I'm kinda wary about mentioning a security fix and then not
backporting the entire set of fixes the CVE requires in the same
patchset.  I have no idea what the status of the VFS level fixes
that are needed to fix this properly - I thought they were done and
reviewed, but they don't appear to be in 5.19 yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
