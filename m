Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 109727F81
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 09:12:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E1CD330405F
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 07:12:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ed1l707DEwAz9pwg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 07:12:32 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: xfstest failure with xfs, dax and v4.4-rc3
References: <20151201224346.GA15684@linux.intel.com>
	<20151201235158.GF19199@dastard>
Date: Wed, 02 Dec 2015 10:12:29 -0500
In-Reply-To: <20151201235158.GF19199@dastard> (Dave Chinner's message of "Wed,
	2 Dec 2015 10:51:58 +1100")
Message-ID: <x49k2owq3z6.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Dec 01, 2015 at 03:43:46PM -0700, Ross Zwisler wrote:
>> I'm seeing a new intermittent xfstests failure with v4.4-rc3 using XFS and
>> DAX.  The test that is failing is generic/083, and it fails about 50% of the
>> time in my setup.  Here's the output:
>> 
>> FSTYP         -- xfs (debug)
>> PLATFORM      -- Linux/x86_64 lorwyn 4.4.0-rc3
>> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
>> MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2
>> /mnt/xfstests_scratch
>> 
>> generic/083 2s ... 2s
   ^^^^^^^
>> _check_xfs_filesystem: filesystem on /dev/pmem0p2 is inconsistent (r) (see
>> /root/xfstests/results//generic/083.full)
>> Ran: generic/083
>> Failures: generic/083
>> Failed 1 of 1 tests
>
> $ grep 083  tests/xfs/group
> 083 dangerous_fuzzers
> $

That's great, but Ross reported an issues with *generic*/083.  ;-)

/me hands Dave more coffee.

-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
