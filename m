Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 782317F4E
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 19:43:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 651448F8078
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 17:43:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	eq7AlyFxxyq4NF2E for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 17:43:50 -0700 (PDT)
Date: Tue, 8 Oct 2013 11:43:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: filter projid32bit info out of growfs & info
	output
Message-ID: <20131008004317.GR4446@dastard>
References: <5251C392.1020407@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5251C392.1020407@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Oct 06, 2013 at 03:09:54PM -0500, Eric Sandeen wrote:
> commit 67e389c xfsprogs: support CRC enabled filesystem detection
> 
> changed xfs_growfs (and by extension xfs_info) to report
> the projid32bit value.  This breaks at least xfstest xfs/206 due to
> the changed output, so filter it as we do for mkfs in that test.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/tests/xfs/206 b/tests/xfs/206
> index fcbdd9e..d2c2ade 100755
> --- a/tests/xfs/206
> +++ b/tests/xfs/206
> @@ -86,6 +86,7 @@ echo "=== xfs_growfs ==="
>  xfs_growfs $tmpdir \
>  	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
>  		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
> +		-e "s/, projid32bit=[0-9]//" \
>  		-e "/.*crc=/d"
>  
>  # and double-check the new geometry
> @@ -93,6 +94,7 @@ echo "=== xfs_info ==="
>  xfs_info $tmpdir \
>  	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
>  		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
> +		-e "s/, projid32bit=[0-9]//" \
>  		-e "/.*crc=/d"
>  
>  # _cleanup cleans up for us

Yup, that's needed. There's a bunch of other things we need to do to
correctly test 16/32bit project ids without failures. Have a look
here:

http://oss.sgi.com/archives/xfs/2013-06/msg00219.html

For the mods I posted back in June to avoid failures with the CRC
enabled filesystems in tests that assume certain options can be
turned on/off on XFS filesystems.

I'm still running xfstests with that patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
