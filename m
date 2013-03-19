Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFFDB7F56
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 09:15:10 -0500 (CDT)
Message-ID: <5148730B.6020402@sgi.com>
Date: Tue, 19 Mar 2013 09:15:39 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3 V4] xfstests: btrfs tests for basic informational
	commands
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
	<1363186623-1378-4-git-send-email-sandeen@redhat.com>
	<5140AB9D.2070001@redhat.com> <5140CB3F.5010704@redhat.com>
	<5140CD26.7050201@sandeen.net> <20130315101625.GE6369@dastard>
	<737235E6-72C8-45F5-A6F4-EEEFD094706E@redhat.com>
	<51432EC5.5090208@sgi.com>
	<5F46F0D0-1C1D-4F53-A2DE-9D39A85D078F@sandeen.net>
In-Reply-To: <5F46F0D0-1C1D-4F53-A2DE-9D39A85D078F@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <esandeen@redhat.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


This has been reverted and recommitted as test 307.

Thanks
--Rich

commit 4f092a2e681c57394a0055a0735b8208bf83ec5f
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
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

commit 609b6f18b87bc19c5251c45342e0678cfbf0618c
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Tue Mar 19 08:13:12 2013 -0500

     Revert "xfstests: btrfs tests for basic informational commands"

     This reverts commit 2730c49a3e80426167e6f9984b070883dc51d4b6.

     Test number was not sequential.

     Conflicts:

         group


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
