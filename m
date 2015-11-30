Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 119F429DF5
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 15:41:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E712B304062
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 13:41:51 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8qDjlQZQnNl9cF2g for <xfs@oss.sgi.com>;
	Mon, 30 Nov 2015 13:41:49 -0800 (PST)
Date: Tue, 1 Dec 2015 08:41:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Which xfsprogs version to which kernel version
Message-ID: <20151130214104.GL26718@dastard>
References: <5656DD39.8060403@poczta.onet.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5656DD39.8060403@poczta.onet.pl>
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
To: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Cc: xfs@oss.sgi.com

On Thu, Nov 26, 2015 at 11:21:45AM +0100, aluno3@poczta.onet.pl wrote:
> Hello,
> 
> I am using kernel 3.10 and would like to update xfsprogs (currently I
> have 3.1.5).
> 
> When I tried to use the newest version of xfsprogs 4.3.0 I get the call
> trace about detected version 5 of superblock when mounting volume which
> was formatted using mkfs.xfs from 4.3.0.

More recent xfsprogs versions enable features that are only
supported by recent kernels. We tend to wait at least a year before
enabling new features by default in xfsprogs so that kernel support
is usually picke dup by distros before they update xfsprogs....

If you have an old kernel, then you need to turn off the newer
features that your kernel does not support. This has always been the
case - if you update the xfsprogs yourself, then you need to use the
correct options for your kernel. In general, this:

# mkfs.xfs -f -m crc=0 -n ftype=0 <dev>

will make a filesystem that can be mounted on old kernels. If
distros are shipping old kernels with new xfsprogs and are not
changing the default behaviour to suit their kernel, then that is a
distro problem.

As it is, in future the version of xfsprogs will tell you what
kernel has the same feature support. i.e. xfsprogs 4.2.0 has exactly
the same code/feature support as kernel 4.2.0. Similarly for
xfsprogs/kernel 4.3.0. However, this won't prevent the fact that
xfsprogs 4.8.0 might enable features that kernel 4.3.0 does not know
about - the only way to prevent that sort of problem is to never
enable new features in mkfs.xfs, and that's not a viable solution.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
