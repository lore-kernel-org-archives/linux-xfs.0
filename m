Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06F114B94B
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 19:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724182760; cv=none; b=Od7tschsGhnLdyFraa+IohsY0aqHfyljKw6Udxetm7R6Uz6chzauuEBGnzsmyOsDiL2nno3L+otLNQ+M6HNcsjH1qSAjiDRVa3554pc5/BCvCE14I+snT99O8W5K2eiWpx9RMas1vu+DSdE1jr3BN/+ShO4gW/UwUQLqit3B33M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724182760; c=relaxed/simple;
	bh=wYSeE26qJIB7joo4Tv+/ux8wK4l0U/6vMdbtFRyE7Cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQJQZSYoehERO8537N9Tv3b1CVGkT8U9vZtL7fntWLFDN7jrqm9xOAa7Xnln3Gmmx4dw7/Gk4rH0mLtuPfno8lBru08NB514kFnO28JUMIQXk9llYcpYXZ6pTmUkhatqmJ9xbaUJK6SkrfSqj/Uttd6JvJRQzmeSCGQPVtJkqGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJi1/G95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJi1/G95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5BCC4AF18;
	Tue, 20 Aug 2024 19:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724182760;
	bh=wYSeE26qJIB7joo4Tv+/ux8wK4l0U/6vMdbtFRyE7Cg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gJi1/G95U77QWM5lcVnIMARyM50JcUABi/L8rnOmu4OaQonyi1CRxvrESQO3B1ZEg
	 nXAR0qfjx5A31PssPZWj+zbdcuiQjK19S2p1ND9BCJaEQXD9+bdDv8fhXi/M31qj2b
	 WM9ifCQAkZMll+4Ijeqg67OKaeyHR04OVnLdI47L+lUlAYP+vZnDh8WE3Qd7M/2og6
	 JKF40eRFOxVoECkFPw7mWLYaBjX2qVP/AruFp5A66+BR5KK2W9CQo1XpMcIuucXUsB
	 SZkvBnfa/GiBLXSU0QrrbAmUTMpc8XpTp1J81fGSRVuALO6lSdybYyBNjZl/8j1w2g
	 GcfvkZJ4kansg==
Date: Tue, 20 Aug 2024 12:39:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, wbx@openadk.org
Subject: Re: [PATCH V2] xfs_io: Fix fscrypt macros ordering
Message-ID: <20240820193918.GB1178@sol.localdomain>
References: <20240817093256.222226-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240817093256.222226-1-cem@kernel.org>

On Sat, Aug 17, 2024 at 11:32:48AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> We've been reported a failure to build xfsprogs within buildroot's
> environment when they tried to upgrade xfsprogs from 6.4 to 6.9:
> 
> encrypt.c:53:36: error: 'FSCRYPT_KEY_IDENTIFIER_SIZE' undeclared
> here (not in a function)
>         53 |         __u8
> master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
>            |
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>      encrypt.c:61:42: error: field 'v1' has incomplete type
>         61 |                 struct fscrypt_policy_v1 v1;
>            |                                          ^~
> 
> They were using a kernel version without FS_IOC_GET_ENCRYPTION_POLICY_EX
> set and OVERRIDE_SYSTEM_FSCRYPT_POLICY_V2 was unset.
> This combination caused xfsprogs to attempt to define fscrypt_policy_v2
> locally, which uses:
> 	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
> 
> The problem is FSCRYPT_KEY_IDENTIFIER_SIZE is only after this block of
> code, so we need to define it earlier.
> 
> This also attempts to use fscrypt_policy_v1, which is defined only
> later.
> 
> To fix this, just reorder both ifdef blocks, but we need to move the
> definition of FS_IOC_GET_ENCRYPTION_POLICY_EX to the later, otherwise,
> the later definitions won't be enabled causing havoc.
> 
> Fixes: e97caf714697a ("xfs_io/encrypt: support specifying crypto data unit size")
> Reported-by: Waldemar Brodkorb <wbx@openadk.org>
> Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> V2:
> 	- Remove dangling leftover comment
> 	- define FS_IOC_GET_ENCRYPTION_POLICY_EX on it's own block.
> 
> Bill, as the updates for the V2 are trivial, I'm keeping your RwB,
> hopefuly you agree :)
> 
>  io/encrypt.c | 67 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 34 insertions(+), 33 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
