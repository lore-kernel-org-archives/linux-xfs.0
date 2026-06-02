Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60CD145FE0;
	Tue,  2 Jun 2026 20:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430972; cv=none; b=q3XulPBu0ICLOvAEOogky0CGvSUMJbNdehUNJNNA9794TNyDjha8V7S8/jW/wWiKKi/SeFlUfx0rWVR/2QKAqr9T1LsXokYW5ABilMWamF+US4gRa+VKlBGrm+a4R2UoTDSN4F5QXZF9f7aGZA6F36L1wsWkkuNH8dmqTSX0QD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430972; c=relaxed/simple;
	bh=dse0fSeQIzHmXLihQLU4iYzX1+cWq3tl1wF5/UYdSKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3FmJvE6F2zwzsYjgIPTz+DwrWx6wmsOK5jGrJal0Ojw8GFkSgRmJe2l2xf3obo36IojhUQlyzDme8ZmB9uM7VBEzygwF7NBTO8HIKW/YtYReYKfU97/8ByGp10uIeowRBoj7p7Q9KvUxKQcmJDcOS4NWUwJrjpbqUNOwq+kHk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BvpO3Eb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BvpO3Eb7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 677AF1F00893;
	Tue,  2 Jun 2026 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780430971;
	bh=RCTqdMUIQL2wPOqBPUz/XcErDodBJvj0B3QqO1rdp0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BvpO3Eb7BPEzluCrqCkH6rc3op61E+WQQNdp6Wrul7YVkgjPb9iGzbb8nx4aRzq1k
	 7WKSykOfbdkIm0doMDJ7D49fjaAdH2edxb860X94/FKyZN5dR3IzNjvTWUNOY/dd+i
	 KLoZM6ywHHypWr/X51FxTpjjni9U6DlCijss6pt5OYtdguTTQgZizdeQgkETXJffCU
	 1fjWCwMnLmUAuHa8tMWRgJ4bi2Ia4zZ5vXyYrRNfLnXb9hnevvz+7BqUfU1G5fMucL
	 gCSv363bK4/GQQnIGxxcZ1hkc5BQUSntVyuJZY3z9WuhDcWyKHuCCJkfUqTo4HO8Fc
	 VW5WjoSNEMBMg==
Date: Tue, 2 Jun 2026 13:09:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Disha Goel <disgoel@linux.ibm.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] common/defrag: Skip defrag tests on DAX-enabled
 filesystems
Message-ID: <20260602200930.GB6054@frogsfrogsfrogs>
References: <20260602101418.55131-1-disgoel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602101418.55131-1-disgoel@linux.ibm.com>

On Tue, Jun 02, 2026 at 03:44:18PM +0530, Disha Goel wrote:
> Online defragmentation is not supported on DAX-enabled filesystems
> because DAX bypasses the page cache required for defrag operations.
> 
> Add check in _require_defrag() to skip tests when DAX is enabled,
> avoiding false failures on ext4/301-304, ext4/308 and generic/018.
> 
> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
> ---
>  common/defrag | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/common/defrag b/common/defrag
> index 055d0d0e..28db2f7a 100644
> --- a/common/defrag
> +++ b/common/defrag
> @@ -6,6 +6,10 @@
>  
>  _require_defrag()
>  {
> +    # Defragmentation is not supported on DAX-enabled filesystems
> +    if echo "$MOUNT_OPTIONS" | grep -qw "dax"; then
> +        _notrun "Defragmentation not supported on DAX-enabled filesystem"
> +    fi

Defrag doesn't work on XFS on DAX as well?  It seems to work fine on my
VMs...

<confused>

--D

>      case "$FSTYP" in
>      xfs)
>          # xfs_fsr does preallocates, require "falloc"
> -- 
> 2.45.1
> 
> 
