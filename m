Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q91DieuD130220 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 08:44:40 -0500
Message-ID: <50699E95.7020905@sgi.com>
Date: Mon, 01 Oct 2012 08:45:57 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 068: Add mmap load
References: <50651A99.1070307@redhat.com>
In-Reply-To: <50651A99.1070307@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 09/27/12 22:33, Eric Sandeen wrote:
> Test 068 is the go-to test for freeze deadlock coverage;
> unfortunately it only uses fsstress, which doesn't do any mmap
> IO.
>
> Using the existing fstest binary gets us a cheap mmap exerciser
> as well.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> I think it's fair to modify this test vs. making a new one -
> it's never passed yet, and will only start passing in kernel 3.6,
> so it shouldn't cause new test regressions to add mmap ops.
>
> And I can verify that this finds mmap bugs; I had a backport
> which messed up ext4's freeze vs. mmap handling, and this exposes
> it.  :)
>



Committed to git://oss.sgi.com/xfs/cmds/xfs.git, master branch.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
