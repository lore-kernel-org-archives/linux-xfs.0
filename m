Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5951 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752908AbdLMVlc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 16:41:32 -0500
Date: Thu, 14 Dec 2017 08:41:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/9] generic/381: use username fsgqa-381
Message-ID: <20171213214129.GV4094@dastard>
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213004519.29340-2-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 12, 2017 at 04:45:11PM -0800, Luis R. Rodriguez wrote:
> Some systems are not allowing usernames prefixed with a number now.
> One can however use numbers as a postfix so use that.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  README                |  2 +-
>  tests/generic/381     | 16 ++++++++--------
>  tests/generic/381.out |  4 ++--
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/README b/README
> index ed69332e774e..e05142be1a87 100644
> --- a/README
> +++ b/README
> @@ -20,7 +20,7 @@ _______________________
>  - run make
>  - run make install
>  - create fsgqa test user ("sudo useradd fsgqa")
> -- create 123456-fsgqa test user ("sudo useradd 123456-fsgqa")
> +- create fsgqa-381 test user ("sudo useradd fsgqa-381")
>  	
>  ______________________
>  USING THE FSQA SUITE
> diff --git a/tests/generic/381 b/tests/generic/381
> index 006f0d879638..cdc29c2e029e 100755
> --- a/tests/generic/381
> +++ b/tests/generic/381
> @@ -3,7 +3,7 @@
>  #
>  # Test xfs_quota when user or names beginning with digits.
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This isn't a "test names with digits" test, but "test names begining
with digits" test.  Changing the username to not begin with digits
invalidates the entire purpose of the test which is to ensure that
xfs_quota can differentiate between UIDs and names beginning with
numbers....

So from that perspective, NAK.

IF there are distros not allowing usernames to start with digits,
then this test needs a _requires check and to _notrun on those
systems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
