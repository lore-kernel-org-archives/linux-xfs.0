Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48617 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbfEOF5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 01:57:12 -0400
Date: Wed, 15 May 2019 15:57:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/11] libxfs: rename bp_transp to b_transp in ASSERTs
Message-ID: <20190515055709.GX29573@dread.disaster.area>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-5-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557519510-10602-5-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 03:18:23PM -0500, Eric Sandeen wrote:
> xfs_buf no longer has a bp_transp member; it's b_transp now.
> These ASSERTs get #defined away, but it's still best to not have
> invalid structure members cluttering up the code.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
