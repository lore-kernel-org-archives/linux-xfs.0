Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 30CA829E08
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 16:59:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EAB0F304043
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 14:59:42 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	K5ryCkMnF2YX40TL for <xfs@oss.sgi.com>;
	Tue, 23 Feb 2016 14:59:39 -0800 (PST)
Date: Wed, 24 Feb 2016 09:59:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs resize: primary superblock is not updated immediately
Message-ID: <20160223225926.GN25832@dastard>
References: <3685DFAD20214109878873CF81232704@alyakaslap>
	<20160222212019.GI25832@dastard>
	<CAOcd+r1XY2kcp+qJ=mPOAQSmb90QUnLfmT3-FkMjQN_+Ejmt8A@mail.gmail.com>
	<20160222235628.GK25832@dastard>
	<D5578D3E98EE48B88EA9A1126B671155@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D5578D3E98EE48B88EA9A1126B671155@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Christoph Hellwig <hch@infradead.org>, Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com

On Tue, Feb 23, 2016 at 02:25:38PM +0200, Alex Lyakas wrote:
> Hi Dave,
> 
> Below is a detailed reproduction scenario of the problem.

Can you package this for xfstests and send to
fstests@vger.kernel.org, please?

> No
> snapshots involved, only XFS. The scenario is performed on a VM,
> running kernel 3.18.19.

And a current kernel (e.g. 4.5-rc5) behaves how?

> 9) mount
> # mount -o sync /dev/mapper/xfs_base /mnt/xfs/
> 
> Kernel panics with [2].

It tried to read a buffer beyond the current end of filesystem that
log recoery knows about. Given the on-disk superblock had not been
updated by the growfs operation, this should have been detected
by _xfs_buf_find() and errored out, not tried to look up a per-ag
structure that is beyond the current end of filesystem.

i.e. the code I pointed out in my previous email failed to detect
the situation is it supposed to be protecting against.  Why did that
"block beyond the end of the filesystem" detection fail?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
