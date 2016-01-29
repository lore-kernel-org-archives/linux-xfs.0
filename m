Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E94227CA2
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 14:37:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BBD5530405F
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 12:37:55 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YBHuc27u2g7LEhXb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 29 Jan 2016 12:37:44 -0800 (PST)
Date: Fri, 29 Jan 2016 12:37:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfstests xfs/293 failure with current xfstests
Message-ID: <20160129203740.GG20038@birch.djwong.org>
References: <20160129192145.GC5224@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160129192145.GC5224@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 29, 2016 at 12:21:45PM -0700, Ross Zwisler wrote:
> It looks like the current version of xfsprogs (v4.3.0) has an inconsistency
> between its documentation and implementation that is making the xfstest
> xfs/293 fail:
> 
> ./check xfs/293
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 lorwyn 4.5.0-rc1
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
> MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch
> 
> xfs/293	 - output mismatch (see /root/xfstests/results//xfs/293.out.bad)
>     --- tests/xfs/293.out	2015-10-02 10:19:36.836796097 -0600
>     +++ /root/xfstests/results//xfs/293.out.bad	2016-01-29 10:41:25.530512911 -0700
>     @@ -1,2 +1,4 @@
>      QA output created by 293
>      Silence is golden
>     +help not documented in the xfs_io manpage
>     +zero not documented in the xfs_io manpage
>     ...
>     (Run 'diff -u tests/xfs/293.out /root/xfstests/results//xfs/293.out.bad'  to see the entire diff)
> Ran: xfs/293
> Failures: xfs/293
> Failed 1 of 1 tests
> 
> "help" and "zero" are indeed options in xfs_io, but aren't listed in the man
> page.

Commit 270dae6c0b41d855729fec73f94f33665bd36349 in xfsprogs for-next fixes
this.

--D

> 
> Thanks,
> - Ross
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
