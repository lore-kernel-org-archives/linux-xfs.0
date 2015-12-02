Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5B5BF7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 14:29:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 537FF304039
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 12:29:26 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XIlqAXZzVYOV90ON for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 12:29:24 -0800 (PST)
Date: Thu, 3 Dec 2015 07:29:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests failures with xfs, dax and v4.4-rc3
Message-ID: <20151202202910.GH19199@dastard>
References: <20151202183438.GA1319@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151202183438.GA1319@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com, Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>

On Wed, Dec 02, 2015 at 11:34:38AM -0700, Ross Zwisler wrote:
> I'm hitting a few more test failures in my testing setup with v4.4-rc3, xfs
> and DAX.  My test setup is a pair of 4GiB PMEM partitions in a KVM virtual
> machine.  Here are the failures:

Which are caused by commit 1ca1915 ("xfs: Don't use unwritten extents
for DAX") because of this code for unwritten extent conversion in
get_blocks:

	tp->t_flags |= XFS_TRANS_RESERVE;

It's a minor problem compared to all the other issues DAX has right
now, so I ignored it to get the bigger problem solved first.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
