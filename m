Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43680 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752385AbdLCVpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Dec 2017 16:45:24 -0500
Date: Mon, 4 Dec 2017 08:45:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/7] xfs: fix up agi unlinked list reservations
Message-ID: <20171203214522.GS5858@dastard>
References: <20171130185836.18481-1-bfoster@redhat.com>
 <20171130185836.18481-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130185836.18481-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 01:58:32PM -0500, Brian Foster wrote:
> The current AGI unlinked list addition and removal reservations do
> not reflect the worst case log usage. An unlinked list removal can
> log up to two on-disk inode clusters but only includes reservation
> for one. An unlinked list addition logs the on-disk cluster but
> includes reservation for an in-core inode.
> 
> Update the AGI unlinked list reservation helpers to calculate the
> correct worst case reservation for the associated operations.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

looks sane.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
