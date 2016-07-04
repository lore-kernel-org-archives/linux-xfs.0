Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C43F7CA2
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 01:51:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E4F08F8033
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2016 23:51:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 71yOb3lXaYUyVUHZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jul 2016 23:51:39 -0700 (PDT)
Date: Mon, 4 Jul 2016 14:51:37 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 16/20] reflink: test cross-mountpoint reflink and dedupe
Message-ID: <20160704065137.GW23649@eguan.usersys.redhat.com>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
	<146612806287.25024.6626531953151914169.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612806287.25024.6626531953151914169.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:47:42PM -0700, Darrick J. Wong wrote:
> Test sharing blocks via reflink and dedupe between two different
> mountpoints of the same filesystem.  This shouldn't work, since
> we don't allow cross-mountpoint functions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/reflink        |    2 +
>  tests/generic/927     |   88 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/927.out |    9 +++++
>  tests/generic/928     |   86 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/928.out |   10 ++++++
>  tests/generic/group   |    2 +
>  6 files changed, 196 insertions(+), 1 deletion(-)
>  create mode 100755 tests/generic/927
>  create mode 100644 tests/generic/927.out
>  create mode 100755 tests/generic/928
>  create mode 100644 tests/generic/928.out
> 
> 
> diff --git a/common/reflink b/common/reflink
> index 4ec390d..1363971 100644
> --- a/common/reflink
> +++ b/common/reflink
> @@ -107,7 +107,7 @@ _require_scratch_dedupe()
>  	_scratch_mount
>  	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$SCRATCH_MNT/file1" > /dev/null
>  	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$SCRATCH_MNT/file2" > /dev/null
> -	testio="$("$XFS_IO_PROG" -f -c "dedupe $TEST_DIR/file1 0 0 65536" "$TEST_DIR/file2" 2>&1)"
> +	testio="$("$XFS_IO_PROG" -f -c "dedupe $SCRATCH_MNT/file1 0 0 65536" "$SCRATCH_MNT/file2" 2>&1)"
>  	echo $testio | grep -q "Operation not supported" && \
>  		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
>  	echo $testio | grep -q "Inappropriate ioctl for device" && \

I think this hunk belongs to a seperate patch.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
