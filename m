Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D50D77F85
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 15:43:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F9E8AC006
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 13:43:54 -0700 (PDT)
Date: Wed, 16 Oct 2013 07:43:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] xfs corruption - structure need cleaning
Message-ID: <20131015204346.GS4446@dastard>
References: <CAMg3XqqJgxnc2+ZkuMaK9RC1_Basfh9AzcqCpNdvmPpCXgNHZg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMg3XqqJgxnc2+ZkuMaK9RC1_Basfh9AzcqCpNdvmPpCXgNHZg@mail.gmail.com>
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
To: Roy Zhang <royzhangzzl@gmail.com>
Cc: xfs-masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>

On Tue, Oct 15, 2013 at 09:45:27PM +0800, Roy Zhang wrote:
> Hi,
> I met a problem that cannot mount xfs, log as below.
> I got know xfs_repair -L will fix this situation, I want to know how
> and why cause it, it's a bug in xfs or hdd? Is there any patch to fix
> it?
> 
> Thanks
> Roy
> 
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.232985] XFS
> (dm-3): Mounting Filesystem
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.327773] XFS
> (dm-3): Internal error xlog_clear_stale_blocks(2) at line 1353 of file
> fs/xfs/xfs_log_recover.c.  Caller 0xffffffffa01f894d

The head and tail of the log are confused - different cycle numbers
but the tail is behind the head. That implies that there are 3 cycle
numbers visible in the log, when here should only be 2, which would
mean that some log write did not make it to disk correctly.

You'll need to provide a copy of the log (xfs_logprint can get that
for you) and the information about your system described here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
