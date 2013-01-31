Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3A2927F53
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 22:08:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 284678F8039
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 20:08:06 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZpYfCEOdR7whwZ5u for <xfs@oss.sgi.com>;
	Wed, 30 Jan 2013 20:08:04 -0800 (PST)
Date: Thu, 31 Jan 2013 15:07:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.8-rc5 xfs corruption
Message-ID: <20130131040748.GH32297@disturbed.disaster>
References: <614607656.11545086.1359601991846.JavaMail.root@redhat.com>
	<473604401.11548931.1359602207833.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <473604401.11548931.1359602207833.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Jan 30, 2013 at 10:16:47PM -0500, CAI Qian wrote:
> Hello,
> 
> (Sorry to post to xfs mailing lists but unsure about which one is the
> best for this.)

Trimmed to just xfs@oss.sgi.com.

> I have seen something like this once during testing on a system with a
> EMC VNX FC/multipath back-end.

This is a trace from the verifier code that was added in 3.8-rc1 so
I doubt it has anything to do with any problem you've seen in the
past....

Can you tell us what workload you were running and what hardware you
are using as per:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

As it is, if you mounted the filesystem after this problem was
detected, log recovery probably propagated it to disk. I'd suggest
that you run xfs_repair -n on the device and post the output so we
can see if any corruption has actaully made it to disk. If no
corruption made it to disk, it's possible that we've got the
incorrect verifier attached to the buffer.

> [ 3025.063024] ffff8801a0d50000: 2e 2e 2f 2e 2e 2f 75 73 72 2f 6c 69 62 2f 6d 6f  ../../usr/lib/mo 

The start of a block contains a path and the only
type of block that can contain this format of metadata is remote
symlink block. Remote symlink blocks don't have a verifier attached
to them as there is nothing that can currently be used to verify
them as correct.

I can't see exactly how this can occur as stale buffers have the
verifier ops cleared before being returned to the new user, and
newly allocated xfs_bufs are zeroed before being initialised. I
really need to know what you are doing to be able to get to the
bottom of it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
