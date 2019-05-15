Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60587 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbfEOFwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 01:52:00 -0400
Date: Wed, 15 May 2019 15:51:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] libxfs: remove i_transp
Message-ID: <20190515055156.GU29573@dread.disaster.area>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557519510-10602-2-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 03:18:20PM -0500, Eric Sandeen wrote:
> i_transp was removed from kernel code back in 2011, but it was left
> in userspace.  It's only used in a few asserts in transaction code
> (as it was in the kernel) so there doesnt' seem to be a compelling
> reason to carry it around anymore.
> 
> Source kernel commit: f3ca87389dbff0a3dc1a7cb2fa7c62e25421c66c
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
