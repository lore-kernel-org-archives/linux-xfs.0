Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:14627 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753839AbdLMVzX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 16:55:23 -0500
Date: Thu, 14 Dec 2017 08:55:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/9] tests/xfs/group: add group for tests which require
 mkfs v4_5
Message-ID: <20171213215520.GY4094@dastard>
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-9-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213004519.29340-9-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 12, 2017 at 04:45:18PM -0800, Luis R. Rodriguez wrote:
> This lets us skip these tests on newer systems.

This already _not_runs on new systems. we do not want to be adding
one-off group descriptors to avoid tests like this - the tests
themselves already detect whether they should run or not.

xfs/096 2s ... [not run] Requires older mkfs without strict input checks: the last supported version of xfsprogs is 4.5.

Why are you trying to add groups to define tests that not_run
correctly on systems they aren't supported on?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
