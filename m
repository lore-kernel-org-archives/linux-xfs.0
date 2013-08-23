Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9FBD129DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 13:35:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 600F630404E
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 11:35:14 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id y8F7VF9nu5PUusP2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Aug 2013 11:35:13 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B8CC29A03E9
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 12:35:12 -0600 (MDT)
Date: Fri, 23 Aug 2013 14:35:10 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH][RESEND] xfstests: add a test for btrfs device replace
	operation
Message-ID: <20130823183510.GH29654@localhost.localdomain>
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
	<1377263233-8903-2-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377263233-8903-2-git-send-email-sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 23, 2013 at 03:07:11PM +0200, Stefan Behrens wrote:
> This test performs btrfs device replace tests with all possible profiles
> (single/dup/mixed/raid0/raid1/raid10), one round with the '-r' option
> to 'btrfs replace start' and one round without this option. The
> cancelation is tested only once and with the dup/single profile for
> metadata/data.
> 
> This test takes 181 seconds on my SSD equiped test box and 237s on
> spinning disks. Almost all the time is spent when the filesystem is
> populated with test data. The replace operation itself takes less than
> a second for all the tests, except for the test that is marked as
> 'thorough' which will run for about 8 seconds on my test box.
> 
> The amount of tests done depends on the number of devices in the
> SCRATCH_DEV_POOL. For full test coverage, at least 5 devices should
> be available (e.g. 5 partitions). With less than 2 entries in
> SCRATCH_DEV_POOL, the test is not executed.
> 
> The source and target devices for the replace operation are arbitrarily
> chosen out of SCRATCH_DEV_POOl. Since the target device mustn't be
> smaller than the source device, the requirement for this test is that
> all devices have _exactly_ the same size. If this is not the case, the
> test terminates with _notrun.
> 
> To check the filesystems after replacing a device, a scrub run is
> performed, a btrfsck run, and finally the filesystem is remounted.
> 
> This commit depends on my other commit:
> "xfstest: don't remove the two first devices from SCRATCH_DEV_POOL"
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

This worked well, thanks,

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
