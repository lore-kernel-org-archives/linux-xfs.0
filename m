Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30789 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753877AbdLMVwO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 16:52:14 -0500
Date: Thu, 14 Dec 2017 08:52:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] tests/xfs/group: add injection group
Message-ID: <20171213215211.GX4094@dastard>
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-10-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213004519.29340-10-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 12, 2017 at 04:45:19PM -0800, Luis R. Rodriguez wrote:
> XFS error injection requires CONFIG_XFS_DEBUG and not all kernels
> have this enabled.

NAK. this should be automatically detected by the tests and they
_not_run when support is not available.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
