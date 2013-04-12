Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7DA4229DFA
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 02:57:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 549DB30404E
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 00:57:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	U84KxNQ85aGbnnfV for <xfs@oss.sgi.com>;
	Fri, 12 Apr 2013 00:57:30 -0700 (PDT)
Date: Fri, 12 Apr 2013 17:57:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix the regex pattern in get_group_list of check
Message-ID: <20130412075728.GD30622@dastard>
References: <5167A5D3.4070903@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5167A5D3.4070903@gmail.com>
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
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>, Rich Johnston <rjohnston@sgi.com>, Dave Chinner <dchinner@redhat.com>

On Fri, Apr 12, 2013 at 02:12:35PM +0800, Wang Sheng-Hui wrote:
> In group files, non comment line starts with a 3-digits, then followed by
> space and other characters, but no group names.

I don't follow. A group file line looks like:

003 db auto quick

Which defines the test name, followed by the group names the test
belongs to.

> The old regex in get_group_list uses the group name as part of the regex,
> and fails './check -g xfs' run:
>         Group "xfs" is empty or not defined?

Well, yes, "xfs" is not a defined group name:

$ grep xfs tests/*/group
$

If I define a "xfs" group by assigning tests to it, check runs just
fine.

$ grep xfs tests/*/group
tests/xfs/group:003 db auto quick xfs
$ sudo ./check -g xfs
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-2 3.9.0-rc4-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

xfs/003  1s
Ran: xfs/003
Passed all 1 tests
$

So what check is doing looks perfectly OK to me and doesn't need
changing.

> The patch removes the pattern for group name, and thus we can trigger tests
> like "./check -g xfs" as normal.

If you want to run all the tests in a specific subdirectory regardless
of groups, then you can do it like:

$ sudo ./check xfs/[0-9][0-9][0-9]
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-2 3.9.0-rc4-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

xfs/003  0s
xfs/004  0s
xfs/008  1s
.....

There's definitely better ways to do this, but conflating source tree
layout with runtime test group definitions is not it. ;)

Perhaps something like "check xfs" will just run all tests in the
xfs test dir, similar for ext4, shared, etc?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
