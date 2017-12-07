Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10772 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752132AbdLGWYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 17:24:05 -0500
Date: Fri, 8 Dec 2017 09:24:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 1/4] xfs: create agfl block free helper function
Message-ID: <20171207222403.GI4094@dastard>
References: <20171207185810.48757-1-bfoster@redhat.com>
 <20171207185810.48757-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171207185810.48757-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 07, 2017 at 01:58:07PM -0500, Brian Foster wrote:
> Refactor the AGFL block free code into a new helper such that it can
> be invoked from deferred context. No functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

That's a good cleanup by itself - I think I have a patch hanging
around somewhere that does this, too :P

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
