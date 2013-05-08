Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5139429E12
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 19:25:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D06DEAC008
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 17:25:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sUdmyGPSF3LJnbuA for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 17:25:04 -0700 (PDT)
Message-ID: <51899B5F.2000107@sandeen.net>
Date: Tue, 07 May 2013 19:25:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] Make test 306 use null and zero device nodes on
	SCRATCH_MNT
References: <1367964573-29620-1-git-send-email-jack@suse.cz>
	<1367964573-29620-2-git-send-email-jack@suse.cz>
In-Reply-To: <1367964573-29620-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On 5/7/13 5:09 PM, Jan Kara wrote:
> In one place of test 306, we mistakenly used /dev/null and /dev/zero
> instead of equivalent devices created on tested filesystem. So we were
> not really testing the functionality we intended.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Ugh.  A fine mistake on my part.  Thanks for catching that, cripes!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/generic/306 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/306 b/tests/generic/306
> index e8e0fc0..f45d142 100644
> --- a/tests/generic/306
> +++ b/tests/generic/306
> @@ -73,9 +73,9 @@ _scratch_mount -o ro || _fail "Could not mount scratch readonly"
>  echo "== try to create new file"
>  touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch
>  echo "== pwrite to null device"
> -$XFS_IO_PROG -F -c "pwrite 0 512" /dev/null | _filter_xfs_io
> +$XFS_IO_PROG -F -c "pwrite 0 512" $DEVNULL | _filter_xfs_io
>  echo "== pread from zero device"
> -$XFS_IO_PROG -F -c "pread 0 512" /dev/zero | _filter_xfs_io
> +$XFS_IO_PROG -F -c "pread 0 512" $DEVZERO | _filter_xfs_io
>  
>  echo "== truncating write to null device"
>  echo foo > $DEVNULL 2>&1 | _filter_scratch
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
