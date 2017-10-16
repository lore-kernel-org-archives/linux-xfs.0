Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:41937 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751382AbdJPAkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 20:40:47 -0400
Date: Mon, 16 Oct 2017 11:40:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/30] xfs: create helpers to record and deal with scrub
 problems
Message-ID: <20171016004045.GM3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777250403.1724.2736736810868971865.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777250403.1724.2736736810868971865.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:41:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create helper functions to record crc and corruption problems, and
> deal with any other runtime errors that arise.

xfs_scrub_process_error() makes much more sense :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
