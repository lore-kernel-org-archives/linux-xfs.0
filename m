Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A71B729E03
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 19:46:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 94554304039
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 17:46:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mITLSH2htTUoSRx2 for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 17:46:45 -0700 (PDT)
Date: Tue, 8 Oct 2013 11:46:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3] xfstests: restrict 259 device sizes to multiples of 512
Message-ID: <20131008004641.GT4446@dastard>
References: <5250CA13.8040006@redhat.com> <5250CC9B.50807@sandeen.net>
	<5250CD80.9090708@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5250CD80.9090708@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Sat, Oct 05, 2013 at 09:40:00PM -0500, Eric Sandeen wrote:
> Test 259 tries to make a loop device size which is 1 byte less
> than 4T; losetup now warns that this makes little sense, and
> the warning breaks the test output:
> 
>     +losetup: /mnt/test/259.image: warning: file does not fit into a 512-byte sector the end of the file will be ignored.
> 
> The RH QE testcase did originally use loopback, so did
> not in effect test anything other than 512-multiple boundaries.
> 
> Just drop the non-512-byte-multiple cases, they produce
> devices exactly the same size as their 512-byte-multiple
> neighbors.
> 
> (FWIW, this is a regression test for the bug that
> d943b11 mkfs: get size of device properly
> fixed.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
