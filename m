Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF3957CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 19:21:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C8EBAC002
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 17:21:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oHuuNLZrfAEECpYf for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 17:21:11 -0700 (PDT)
Date: Thu, 25 Jul 2013 10:21:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 44/49] xfs: Reduce allocations during CIL insertion
Message-ID: <20130725002108.GA11222@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-45-git-send-email-david@fromorbit.com>
	<51EEF26F.5040001@sgi.com> <51EEF949.9020104@gmail.com>
	<51EFD68A.40400@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51EFD68A.40400@sgi.com>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On Wed, Jul 24, 2013 at 08:28:42AM -0500, Mark Tinguely wrote:
> If you could please redo the test and get the stack traces with
> /proc/sysrq-trigger and if you kernel works with crash, a core dump.
> For the stack trace, I mostly want to know if it has several
> "xlog_grant_head_wait" entries in it, because ...
> 
> ...I seemed to have triggered a couple log space reservation hangs
> with fsstress one XFS partition and a mega-copy on another
> partition, but will have to graft the new XFS tree onto a Linux 3.10
> kernel to get crash (and one of my sata controllers) to work again.

They are unrelated to this patchset.

Somewhere in the code there
is a mismatch between what we reserve as the base requirement for an
actual log write and what the CIL actually steals, and that is, most
likely, what is leading to log hangs.

This is demonstratable in the fact that generic/070 on 512 byte
block size filesystems regularly hits a transaction reservation
exhausted assert failure on transaction commit of the periodic log
dummy transaction on my test rigs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
