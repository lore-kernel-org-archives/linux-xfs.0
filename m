Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793925112;
	b=Hralmv98gAYdmg3Weje6fsD6wxBzTs46Q+sbTdfVtpD7vply11k+S8Vq5bkQjjMBV/bq
	 XaDyg5HXg3XqXDIGQ1UrIv9iWQggzIdQcedoKwHSad7kNVwQOfcioVD//YkXaZAY6A3bU
	 Icfh3bK8muM+gaKVeCjZF/bEvcJI5/LeLstModz8+p7YSGNgjh1pUdKM9K5uLpco0p61I
	 yYLTibFRG3DBTHlL1c7SzDNe4Fm0JbCUdA2cNGD+NDE41knCXfo5e03Yim2nsqI5ciKtc
	 hGojVGknWG6Iyt/L7DTewc9ziUQv8NKoFOPa+u7PnWxg8knV3FwsbTeUs/m3/9PcGiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793925112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1otFFXdDof6ggI5sQakdV+w/DaicL2aXrQ4bTY44jlQ=;
	b=IrkAdavgNz4TaErFh1Qk5rjuoQ8E9LhQeyN+coXSoVwmcmYVrLxCuY36uhBljDxIxwIy
	 vHw6it4JVmuo9XRG9OGtIyMLVL1P/nkZH13Xcmh9VekAiM/RzkNa6GPUGS/FqVlAplWRy
	 9JWLVOSsjPGI8pOUFiu4v66LZ02pyk2fPIXEqZWgLiD973I9K/+K9clNz33eyy3CjEjbC
	 eF56SP7ryzk0qfJocKOhbGqLeU0AQarYcwwleETSDaoA05fPxYmLbV3csPqKfSYuuOqrB
	 9fu6RvzSlLDon2PSzkzacueg5oRPl9gaZdxWrUf5qwy7vrbi1dGuF7c59gnt9ZVFrMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J0kEdA0H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E634E606A31B;
	Fri,  6 Nov 2026 00:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J0kEdA0H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7E81F0089F;
	Fri,  6 Nov 2026 00:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793925111;
	bh=1otFFXdDof6ggI5sQakdV+w/DaicL2aXrQ4bTY44jlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0kEdA0H/7AskFv0xSLHnpmFKPu8OVP54rNURNvOmb16qmpSHm0vEv/ZENxdeGtyo
	 KmafwdZA/Z00TIs6m9Zx6JoB2GJGNP2Br5Ld72sgTjuuKJ8hycIl1xitjn3EAMyEwb
	 QztyeC0cz3YjBzqgm2dt6ht39WcPcM5UyQ49CNVwikNpFfsfEjt0D0CGbhji8d+4Ot
	 WP+2nKCwEPK1Y5npFMffZ+jaQG0LZeg4Y8+1qJKaWeS0e7PuYeRiTMoNFe2PPYghCV
	 HXOAtqZABR89ynrIymCWDdReJbyrNYZlcZXluSdL3eVJxkwKkGw0fEWGEJ6WDdf0vd
	 CdwPNeN1QUI7Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
Date: Fri,  6 Nov 2026 01:31:38 +0100
Message-ID: <20261106003138.73413-1-ojeda@kernel.org>
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 04 Nov 2026 16:03:04 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.2 release.
> There are 547 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

On loongarch64, I am seeing:

     fs/xfs/scrub/agheader.c:123:6: warning: variable 'error' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
      123 |         if (agno == 0)
          |             ^~~~~~~~~
    fs/xfs/scrub/agheader.c:435:9: note: uninitialized use occurs here
      435 |         return error;
          |                ^~~~~
    fs/xfs/scrub/agheader.c:123:2: note: remove the 'if' if its condition is always false
      123 |         if (agno == 0)
          |         ^~~~~~~~~~~~~~
      124 |                 goto out_xref;
          |                 ~~~~~~~~~~~~~
    fs/xfs/scrub/agheader.c:111:13: note: initialize the variable 'error' to silence this warning
      111 |         int                     error;
          |                                      ^
          |                                       = 0

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev

Cc: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org

Thanks!

Cheers,
Miguel
