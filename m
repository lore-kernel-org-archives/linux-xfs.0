Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4761CEEA7;
	Wed, 23 Oct 2024 17:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729704232; cv=none; b=qmDPvT2+wudICJsZmgX6BJG4MsAHJ9+7BkTMPX8Gx6kTAJQRtRjQNgUyeH5NGbeqgTv/7CA9N/bH3MCOh3uTSkvwvBqmQENQnVg0DABpR/o1omaW46A2ve43WVYIGb4HDuNBmzKVbYLW+jU2ZCkv0qZtrSDLM3/PNAuYxm0Mq34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729704232; c=relaxed/simple;
	bh=XFXBGIo+FUi9CYYdnxdyFf/SaqNv2pJyGqV9jFI+h0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nmCpoFKHKD/fcm/pQhZ15A6vHqiQ3bg4Gfr47DX8AGwVo4PI8Nk2GUaS9AtlMhfY1MK8bwJlTN7loevVK6dmIBCfLlee4N6vGpJs4HKZgfYk+BUgcjfzidTHk3a7wn60eJQ/v1e63Q7I4MHNFvQAYvjHpcW9IYj2wqSvDZ2LLtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hYAfSfER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hYAfSfER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0B0C4CEC7;
	Wed, 23 Oct 2024 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729704231;
	bh=XFXBGIo+FUi9CYYdnxdyFf/SaqNv2pJyGqV9jFI+h0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hYAfSfERjA+NAZxw1sfd7sMh/P7CVAj3XuX6xUd30/PxMtJj78YpNM15439PXUIe+
	 bMoCcAj+/MoI3cTjVJx0+8oQL7DdHXLK0700YCxa2T7WZSk9AdBXc+JKRN4fPD+sd7
	 qo/izSzeCT6J8t/Vg0Tyj8GIylVqYwqBE9iOC4q9JM3XyeBG9hL3dzHch2NN0epRb4
	 VJ1keZtBq4qZLyYEpMZDuU3EyOkAyQ7roFbVgGWZCV8pDWjIAb9pO53ZM3Ieqw2HIZ
	 n+k7qAtNJoend7xJhzzEcthUaAY3/kKk4i1KAwIfXUv2dmih4DcENAy42cc9L2lTnV
	 /ehVVzsA9aaIQ==
Date: Wed, 23 Oct 2024 10:23:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the post-EOF prealloc tests from the auto
 and quick groups
Message-ID: <20241023172351.GG21853@frogsfrogsfrogs>
References: <20241023103930.432190-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023103930.432190-1-hch@lst.de>

On Wed, Oct 23, 2024 at 12:39:30PM +0200, Christoph Hellwig wrote:
> These fail for various non-default configs like DAX, alwayscow and
> small block sizes.

Shouldn't we selectively _notrun these tests for configurations where
speculative/delayed allocations don't work?

I had started on a helper to try to detect the situations where the
tests cannot ever pass, but never quite finished it:

diff --git a/common/xfs b/common/xfs
index 557017c716e32c..5cb2c102e2c04f 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2238,3 +2238,34 @@ _scratch_xfs_scrubbed() {
 
 	$XFS_SCRUBBED_PROG "${scrubbed_args[@]}" "$@" $SCRATCH_MNT
 }
+
+# Will this filesystem create speculative post-EOF preallocations for a file?
+_require_speculative_prealloc()
+{
+	local file="$1"
+	local tries
+	local overage
+
+	# Now that we have background garbage collection processes that can be
+	# triggered by low space/quota conditions, it's possible that we won't
+	# succeed in creating a speculative preallocation on the first try.
+	for ((tries = 0; tries < 5; tries++)); do
+		rm -f $file
+
+		# a few file extending open-write-close cycles should be enough
+		# to trigger the fs to retain preallocation. write 256k in 32k
+		# intervals to be sure
+		for i in $(seq 0 32768 262144); do
+			$XFS_IO_PROG -f -c "pwrite $i 32k" $file >> $seqres.full
+
+			# Do we have more blocks allocated than what we've
+			# written so far?
+			overage="$(stat -c '%b * %B - %s' $file | bc)"
+			test "$overage" -gt 0 && return 0
+		done
+	done
+
+	_notrun "Warning: No speculative preallocation for $file after " \
+			"$tries iterations." \
+			"Check use of the allocsize= mount option."
+}

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/629 | 2 +-
>  tests/xfs/630 | 2 +-
>  tests/xfs/631 | 2 +-
>  tests/xfs/632 | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/xfs/629 b/tests/xfs/629
> index 58beedc03a8b..e2f5af085b5f 100755
> --- a/tests/xfs/629
> +++ b/tests/xfs/629
> @@ -8,7 +8,7 @@
>  #
>  
>  . ./common/preamble
> -_begin_fstest auto quick prealloc rw
> +_begin_fstest prealloc rw
>  
>  . ./common/filter
>  
> diff --git a/tests/xfs/630 b/tests/xfs/630
> index 939d8a4ac37f..df7ca60111d6 100755
> --- a/tests/xfs/630
> +++ b/tests/xfs/630
> @@ -8,7 +8,7 @@
>  #
>  
>  . ./common/preamble
> -_begin_fstest auto quick prealloc rw
> +_begin_fstest prealloc rw
>  
>  . ./common/filter
>  
> diff --git a/tests/xfs/631 b/tests/xfs/631
> index 55a74297918a..1e50bc033f7c 100755
> --- a/tests/xfs/631
> +++ b/tests/xfs/631
> @@ -8,7 +8,7 @@
>  #
>  
>  . ./common/preamble
> -_begin_fstest auto quick prealloc rw
> +_begin_fstest prealloc rw
>  
>  . ./common/filter
>  
> diff --git a/tests/xfs/632 b/tests/xfs/632
> index 61041d45a706..3b1c61fdc129 100755
> --- a/tests/xfs/632
> +++ b/tests/xfs/632
> @@ -9,7 +9,7 @@
>  #
>  
>  . ./common/preamble
> -_begin_fstest auto prealloc rw
> +_begin_fstest prealloc rw
>  
>  . ./common/filter
>  
> -- 
> 2.45.2
> 
> 
