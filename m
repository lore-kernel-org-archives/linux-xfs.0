Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795459549;
	b=iLCBTZdosWyq4TfP8gIjvBciyy8hbu4midkfyBnu2wqt0zEz5ixtmpO+vbMGQcJtVhm5
	 anDnffU33NOllTp5e/X0QDM91k0pNHs33soNjR4QwIgHktU5X4/uVrQyOI7S3R3t/T4Jw
	 qiMwKmCFGuYotI/JUYOO4sE+FC48DclH1iLxx291u/MY5rTDiAqeRHkEp0xc0ED04cnQ6
	 jbj6LSQfJqHRB0Oc9rPN+aZFjOgDq3TyyjhksjNGRyri2KRNr51kL6A5Jcbihejzbxqe9
	 JUoUnV1zMXT9jaARTxn6yUVmWa9SyDPxDShWJBfRRSOhjhMNUTjqgm08u+IkYkPQwwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459549;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=PxiNA7miBJTHGn0Z9SSPAwEi4XJ3UirlOj8JQBSf8JA=;
	b=mHx3NoTsV8ux32opau8IJW8/TdwbYyaqnkv5p9Dp+0q92VT2qGQJjgE3SC3DLo3Cfuqp
	 JcZNsNrhdJYTQgrYUPrKEVnBKFrxXFsCvmxiyD5fjhammIYe5DUS7LZapJCGmfsAOmMHB
	 R3/LJeQRvjTGwocIcWkbIfs6qDLts7CWM8+QULKGOku2NjT04r65h3SezSkFCJIG5wRQt
	 6dBBa67+9qPaPJZHzSr1bb8QaVQgZT1BiVxUmpEyjfWDSAdfCP51UQWKI1pmOrSMf7ikF
	 uUug7pVAoeaIuAbxrk3EXAyne6WxZ1v0GSoJiSyQzccFmw7RRqSJYMeTPUjzdHcChCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fg1T6wql;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2957C606A31A;
	Mon, 23 Nov 2026 18:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fg1T6wql
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067081F000D4;
	Mon, 23 Nov 2026 18:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459547;
	bh=PxiNA7miBJTHGn0Z9SSPAwEi4XJ3UirlOj8JQBSf8JA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fg1T6wqlWfCdvHfchAwMVIpFqeJYm34dDAF1fdbyHK8/cQtm/QaABqnz9D+g4Sjr2
	 SoZrWgXXt85Ls09buOpcM0RhFYgiQm2Yf/8cr6ajo33w9fnurbJW6WyuXHmdA+O32l
	 Yu6+FyvJ1P6KN8fKmu4j+GsO58mXTf0xb3l0SM6enPKe7YJu77yXoUKwmo7LP35c0W
	 hXq7swXRei4oIZob7BrlQ6x0tY7DTkXF9kRLXY+AdH4Cadecgyj1b7pMFmTgTPspAu
	 BmDG4jqJ7GCFdcEY9ZOvgvnCHv+Dc9yrccDDAvSkR8bGSMGpO9B4enYJsIDx1r68Lz
	 yYKZfxn/Xe+9w==
Date: Tue, 24 Nov 2026 02:45:34 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 10/21] fstests: add helpers to verify the expected f_fsid
Message-ID: <awSJlKPANuJTZtJK@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <d33f55ca2c1b13426dd27c1c9921b2a60c3afbf2.1791272793.git.asj@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33f55ca2c1b13426dd27c1c9921b2a60c3afbf2.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:36PM +0800, Anand Jain wrote:
> Add two helpers to common/rc:
> 
> _require_uuid_based_fsid() skips the test unless the filesystem derives
> statfs f_fsid from the UUID alone (currently btrfs and ext4).
> 
> _scratch_expected_fsid() prints the f_fsid expected for a filesystem
> created with the fixed test UUID.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/rc | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 37df780f64ef..a11235ec03b8 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6065,6 +6065,37 @@ hexdump()
>  	_fail "Use _hexdump(), please!"
>  }
>  
> +# Require a filesystem whose statfs f_fsid is derived from the filesystem
> +# UUID only, so that it is stable across devices and mounts.
> +_require_uuid_based_fsid()
> +{
> +	case $FSTYP in
> +	btrfs|ext4)
> +		;;
> +	*)
> +		_notrun "Require a filesystem that derives f_fsid from the UUID only"
> +		;;
> +	esac
> +}
> +
> +# Print the statfs f_fsid expected for a filesystem created with the test
> +# UUID 12345678-1234-1234-1234-123456789abc.
> +# Must be guarded by _require_uuid_based_fsid.
> +_scratch_expected_fsid()
> +{
> +	case $FSTYP in
> +	ext4)
> +		echo "4c44000088884c44"
> +		;;
> +	btrfs)
> +		echo "444c444c888d"
> +		;;
> +	*)
> +		return 1
> +		;;
> +	esac
> +}
> +
>  # Try to create a file with inode->i_blocks >= (length / blocksize).
>  # There may be some small overhead, e.g. ext2 filesystem allocates a
>  # substantial number of blocks to store block mappings. Those are accounted
> -- 
> 2.43.0
> 
