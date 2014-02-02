Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1425E7F96
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 15:57:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DB0E5304043
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 13:57:23 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Y687yNBEdUIGHG9o for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 13:57:22 -0800 (PST)
Date: Mon, 3 Feb 2014 08:57:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: more tests for test case btrfs/030
Message-ID: <20140202215720.GT2212@dastard>
References: <1391220332-22118-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391220332-22118-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Sat, Feb 01, 2014 at 02:05:32AM +0000, Filipe David Borba Manana wrote:
> This change adds some new tests for btrfs' incremental send feature.
> These are all related with inverting the parent-child relationship
> of directories, and cover the cases:
> 
> * when the new parent didn't get renamed (just moved)
> * when a child file of the former parent gets renamed too
> 
> These new cases are fixed by the following btrfs linux kernel patches:
> 
> * "Btrfs: more send support for parent/child dir relationship inversion"
> * "Btrfs: fix send dealing with file renames and directory moves"
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Rather than modifying 030 which will cause it to fail on kernels
where it previously passed, can you factor out the common code and
create a new test with the additional coverage?

i.e. the rule of thumb is that once a test is "done" we don't go
back and modify it in significant ways - we write a new unit test
that covers the new/extended functionality. Redundancy in unit tests
is not a bad thing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
