Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C67D67F4E
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 15:54:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5A4B304032
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 13:54:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	p1a4mN3Eb2lmTYAf for <xfs@oss.sgi.com>;
	Thu, 06 Nov 2014 13:54:32 -0800 (PST)
Date: Fri, 7 Nov 2014 08:54:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: EIO and data corruption on XFS file system
Message-ID: <20141106215400.GG23575@dastard>
References: <BLU175-W376F83659C1C70DE51C3D9DF840@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BLU175-W376F83659C1C70DE51C3D9DF840@phx.gbl>
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
To: GuangYang <yguang11@outlook.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Nov 06, 2014 at 01:03:45PM +0000, GuangYang wrote:
> Hello,While working on the storage system, I got one question in
> terms of the XFS utilities to fix file system corruption.
> Basically, our storage system put 3 copies of data and the system
> would detect data inconsistency on regular basis, there are two
> patterns we observed so far:
>
> 1) the data is corrupted which result in an EIO,

Data corruption doesn't trigger EIO errors. EIO errors from the
underlying storage might cause data corruption, but the only thing
that can detect bad data is the application itself, not the kernel.

> 2) data is still accessible but the content is changed.

Again, data being incorrect is generally not a filesystem issue
unless there's a bug somewhere in the filesystem IO path. You'll
need to give us a *lot* more information about your storage and
application workload  if you think XFS is corrupting data. Start
with:

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
