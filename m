Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 067557F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 15:47:10 -0500 (CDT)
Date: Tue, 25 Jun 2013 15:47:09 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: fsync-tester: fix pwrite() return check and
	disable direct for test 19
Message-ID: <20130625204709.GE20932@sgi.com>
References: <1370999583-16725-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370999583-16725-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 11, 2013 at 09:13:03PM -0400, Josef Bacik wrote:
> Test 19 in direct mode was failing on xfs because it was not actually doing the
> write because the writes were not sectorsize aligned.  This test is to test
> btrfs's inline extent fsync()ing so the writes won't be sectorsize aligned, and
> inline extents will fall back to buffered anyway so direct mode is meaningless
> for this test.  So just check if we are test 19 and disable direct mode so we
> don't have to change the golden output.  Also change test_five() to compare
> against a ssize_t instead of a size_t since apparently comparing against size_t
> makes it cast the return value of pwrite() to size_t which screws up the error
> case, so instead of seeing the pwrite() error on xfs which would have explained
> this all it appeared as if it was succeeding and screwing up the fsync(), which
> unfortunately wasted a bit of Daves time.  This patch should fix all this up.
> Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
