Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 01D5B7F86
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 12:15:48 -0500 (CDT)
Message-ID: <514205DC.9040902@sgi.com>
Date: Thu, 14 Mar 2013 12:16:12 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfstests patches
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 03/13/2013 09:57 AM, Eric Sandeen wrote:
> 2 pretty simple ones, and a new btrfs test
>
> [PATCH 1/3] xfstests: add 274 to the prealloc group
> [PATCH 2/3] xfstests: keep newlines out of SCRATCH_DEV_POOL
> [PATCH 3/3] xfstests: btrfs tests for basic informational commands
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

This series has been committed.

Thanks
--Rich

commit 2730c49a3e80426167e6f9984b070883dc51d4b6
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Wed Mar 13 19:01:58 2013 +0000

     xfstests: btrfs tests for basic informational commands

     Run basic btrfs information commands in various ways, performing
     sanity tests of: filesystem show, label, sync, and device stats
     (sync is included just because it's simple).  These are mostly
     just smoke tests, although for example show by label & UUID
     should verify that the correct fs was shown.

     This also adds quite a few new filters to accommodate the output
     of the new commands.

     Cc: linux-btrfs@vger.kernel.org
     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Stefan Behrens <sbehrens@giantdisaster.de>
     Signed-off-by: <rjohnston@sgi.com>

commit d6e352916fbe835432bac2aa835bac440fe44287
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Mar 13 14:57:02 2013 +0000

     xfstests: keep newlines out of SCRATCH_DEV_POOL

     SCRATCH_DEV_POOL processing actually takes the first
     device out for SCRATCH_DEV and leaves the rest in
     SCRATCH_DEV_POOL.

     I'm not totally sold on that behavior, but for now,
     at least don't populate SCRATCH_DEV_POOL with newlines.

     Cc: linux-btrfs@vger.kernel.org
     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: <rjohnston@sgi.com>
     Signed-off-by: <rjohnston@sgi.com>

commit e279134e14800f1d7b34093a93e304b5bed7ec4d
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Mar 13 14:57:01 2013 +0000

     xfstests: add 274 to the prealloc group

     test 274 does preallocation tests but is not in the prealloc group.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
