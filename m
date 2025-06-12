Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B6D22E3FD;
	Thu, 12 Jun 2025 04:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749700868; cv=none; b=q1ehLMolEHEyn5wGPpe13CKM4TZxhqG+9/EcL1sFURwIF9+D0IRtTHpupGZq6bcE9Zr8/THSGNQ/8FnJTQKlT1Kxdag6drNcx40rS+lv6sP3fEASWhQHcAv6SiuLOqhgIqRyRqviMM/Le0c4MGbkTo2Mu6k5RSGXpGodQxBonHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749700868; c=relaxed/simple;
	bh=DlYnPvwSd5QJOHz165HN3aJzMCRMYNiY1aULzVnK0R0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYEOxLpnhS567k+u9cCtRHxKdbLBz1QUs+jolzTlj/w90Igl5ENtqRs6g178jNGe/C8joFjIfb2rrwJ6U6b7CafW18UIjGMg8tu3OfiX9cq8qDja5AqYROcPc1xbarUCtYhwQ4cS05LWkZVCFCzL7OWd07B1h1oP0Bxuy55/7rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8vuuGO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8vuuGO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339BDC4CEEA;
	Thu, 12 Jun 2025 04:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749700868;
	bh=DlYnPvwSd5QJOHz165HN3aJzMCRMYNiY1aULzVnK0R0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A8vuuGO/ZQkXtHkgzlrzFh6h+zTd7xb9OS3LJK4Wlq0ZvFDhWNFYaiOKsSbzot/ni
	 PDgkLhlcnXnEJ4nPRESLIr7H0yvHXukEg7QKOWuo+6zQrAdj409cQKkMsMepJJdwni
	 1DPGCpiXGdeTEtzxl8ja8zwGVwoZI27/6a58qJYruTPQemksFUgIQAEN1GTjNeYe+8
	 DROx/ovbT4LLiHpKPJKqseMFE6eXdAvelNSuUaJ1qmNOcxWmBQhlJvUkjWDW5bUen3
	 /aLxLpQ3XtDe7DlAiX3ZLUg2D3ntl7wu7JaKfHxnlV39+JjzcCMbnD1E0Crs4iJ9Bj
	 NA7aXQ/8pc9SA==
Date: Wed, 11 Jun 2025 21:01:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	john.g.garry@oracle.com, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v4 1/3] common/atomicwrites: add helper for multi block
 atomic writes
Message-ID: <20250612040107.GO6143@frogsfrogsfrogs>
References: <20250612015708.84255-1-catherine.hoang@oracle.com>
 <20250612015708.84255-2-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612015708.84255-2-catherine.hoang@oracle.com>

On Wed, Jun 11, 2025 at 06:57:06PM -0700, Catherine Hoang wrote:
> Add a helper to check that we can perform multi block atomic writes. We will
> use this in the following patches that add testing for large atomic writes.
> This helper will prevent these tests from running on kernels that only support
> single block atomic writes.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  common/atomicwrites | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/common/atomicwrites b/common/atomicwrites
> index 391bb6f6..88f49a1a 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -24,6 +24,27 @@ _get_atomic_write_segments_max()
>          grep -w atomic_write_segments_max | grep -o '[0-9]\+'
>  }
>  
> +_require_scratch_write_atomic_multi_fsblock()
> +{
> +    _require_scratch

Seems fine to me.  The indentation is a little odd (four spaces vs tabs)
but meh

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
> +    _scratch_mkfs > /dev/null 2>&1 || \
> +        _notrun "cannot format scratch device for atomic write checks"
> +    _try_scratch_mount || \
> +        _notrun "cannot mount scratch device for atomic write checks"
> +
> +    local testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    local bsize=$(_get_file_block_size $SCRATCH_MNT)
> +    local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> +
> +    _scratch_unmount
> +
> +    test $awu_max_fs -ge $((bsize * 2)) || \
> +        _notrun "multi-block atomic writes not supported by this filesystem"
> +}
> +
>  _require_scratch_write_atomic()
>  {
>  	_require_scratch
> -- 
> 2.34.1
> 
> 
