Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9BE97F6B
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 15:39:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2F73304066
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 13:39:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id F4XJMAvve8KOEOzY for <xfs@oss.sgi.com>;
	Thu, 08 Aug 2013 13:39:15 -0700 (PDT)
Message-ID: <520401F1.3010609@sandeen.net>
Date: Thu, 08 Aug 2013 15:39:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfsprogs/io: add readdir command
References: <1374669868-14075-1-git-send-email-bfoster@redhat.com>
	<5203A5B7.4020102@sgi.com>
In-Reply-To: <5203A5B7.4020102@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 8/8/13 9:05 AM, Mark Tinguely wrote:

> Could we get a little info for the xfs_io man page?
> 

Yup, otherwise xfs/293 fails :)


# ./check xfs/293
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 bp-05 3.11.0-rc1+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb2
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdb2 /mnt/scratch

xfs/293 10s ... - output mismatch (see /mnt/test2/git/xfstests/results/xfs/293.out.bad)
    --- tests/xfs/293.out	2013-03-27 12:57:49.318520102 -0500
    +++ /mnt/test2/git/xfstests/results/xfs/293.out.bad	2013-08-08 15:38:30.881221070 -0500
    @@ -1,2 +1,3 @@
     QA output created by 293
     Silence is golden
    +readdir not documented in the xfs_io manpage
     ...
     (Run 'diff -u tests/xfs/293.out /mnt/test2/git/xfstests/results/xfs/293.out.bad' to see the entire diff)
Ran: xfs/293
Failures: xfs/293
Failed 1 of 1 tests


/me pats self on back ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
