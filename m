Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p27KCWnY176450 for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 14:12:33 -0600
Subject: Re: xfstests: change directory to / before _cleanup_testdir in
	test 135
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1299511558.3183.115.camel@dhcp-31-190.brq.redhat.com>
References: <1299511558.3183.115.camel@dhcp-31-190.brq.redhat.com>
Date: Mon, 07 Mar 2011 14:12:29 -0600
Message-ID: <1299528749.2578.821.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Boris Ranto <branto@redhat.com>
Cc: xfs <xfs@oss.sgi.com>

On Mon, 2011-03-07 at 16:25 +0100, Boris Ranto wrote:
> Nfs tries to umount $testdir in _cleanup_testdir function. The test 135 calls the function from directory $SCRATCH_MNT that is equal to $testdir (at least for nfs). The umount will therefore fail causing the test to fail due to the output mismatch.
> 
> This simple patch fixes the issue for me.
> 
> Signed-off-by: Boris Ranto <branto@redhat.com>

This looks OK to me.  Most other tests do this chdir
in their cleanup function.

I did a quick scan and found that test 126 may suffer the
same problem.  Can you check this?  We could include the
fix for both tests in the same commit.


It also looks to me like tests 069, 089 might have a
similar issue if they get interrupted.

					-Alex

> diff -urpN a/xfstests/135 b/xfstests/135
> --- a/xfstests/135	2011-03-07 14:54:15.855172101 +0100
> +++ b/xfstests/135	2011-03-07 14:54:29.895048375 +0100
> @@ -34,6 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
>  
>  _cleanup()
>  {
> +    cd /
>      _cleanup_testdir
>  }
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
