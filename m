Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:54430 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750731AbdJPEvA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 00:51:00 -0400
Date: Mon, 16 Oct 2017 15:50:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 26/30] xfs: scrub extended attributes
Message-ID: <20171016045058.GC3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777261222.1724.8888733974981391611.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777261222.1724.8888733974981391611.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:43:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Scrub the hash tree, keys, and values in an extended attribute structure.
> Refactor the attribute code to use the transaction if the caller supplied
> one to avoid buffer deadocks.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
