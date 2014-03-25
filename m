Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA9D67F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 17:46:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A21E2AC002
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 15:46:11 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9fJXBoj062L7yNk5 for <xfs@oss.sgi.com>;
	Tue, 25 Mar 2014 15:46:06 -0700 (PDT)
Date: Wed, 26 Mar 2014 09:45:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfstests: Make some shared tests generic
Message-ID: <20140325224546.GI18572@destitution>
References: <1395781911-13084-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1395781911-13084-1-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 25, 2014 at 10:11:50PM +0100, Lukas Czerner wrote:
> There are couple of tests in shared directory which really should be
> made generic, so move it. It is mostly collapse range tests, which
> really can be generic to make super we test every file system which adds
> collapse range support.
> 
> Here is what we're moving in this commit.
> 
> shared/001 -> generic/004
> shared/002 -> generic/009
> shared/003 -> generic/012
> shared/004 -> generic/016
> shared/005 -> generic/017
> shared/218 -> generic/018
> shared/305 -> generic/019
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
....
>  tests/shared/group    |   8 ---
>  30 files changed, 865 insertions(+), 866 deletions(-)
>  create mode 100755 tests/generic/004
>  create mode 100644 tests/generic/004.out
>  create mode 100644 tests/generic/009
>  create mode 100644 tests/generic/009.out
>  create mode 100644 tests/generic/012
>  create mode 100644 tests/generic/012.out
>  create mode 100644 tests/generic/016
>  create mode 100644 tests/generic/016.out
>  create mode 100644 tests/generic/017
>  create mode 100644 tests/generic/017.out

Looks fine at a quick glance, but can you fix the modes on these
test files (009,012...) while you are moving them?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
