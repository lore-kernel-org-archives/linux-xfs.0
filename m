Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7494219FA8D;
	Tue, 28 Jan 2025 10:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738061873; cv=none; b=HpLw/J4DEMAGZWzHlpT6PS444wO9l4FqoklJHDoeESLKZl3a0DEr+JWqnpij8QpmDp1eqwqutv7Lvkm78iwr52FrYOFVtVEoMdTDOVW8dn3I7hwPjSRg4aaU8WHYUk2LUeuHhkXyjFvRDirpGH34QpM4yLK/x2yp4fnxlO9F3fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738061873; c=relaxed/simple;
	bh=68E5P3TFIAc42PenlCHODK1Ggu/7sXaArU4ynHUORho=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=U3OOaqM6HqwtClKYT0+o/xcu/qTAUS4eNeBoKNrrguruSI7Wo7e6mfguVA+BtTP65ipBbCqnJHu9s3W7NKbtJ1q3b4xinBa5uRouJz65Tv5k2g57NDDWXeceBA3QNa3wyh2BN3J8Y8CamAz9wN1VHswJEeHABuwow7MInPBigi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVDPAyFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVDPAyFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89A4C4CED3;
	Tue, 28 Jan 2025 10:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738061873;
	bh=68E5P3TFIAc42PenlCHODK1Ggu/7sXaArU4ynHUORho=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=QVDPAyFEb2KsjErnlJPDfHgEMoBhr0UQ8Vhgssy8EIhQ8YUuOfa1hjESmBpLS08UX
	 pP1VeM3GC0RHeX7vu4q7PgZjNGw9VJclUV77biYcBfD7v4us1fQRzSWRYHKZ66o7WK
	 Q5ysFpQTkR2JX+yuY9brVNR/S86EImdIGaObd6KRU5+gbifhiw1Td0epAUaHvwcp02
	 F9cyuQslBXeDmHiMGmKuxZMTB698BAlwRsl4lXcroE3v8f5j0mSUS6lpA5xACVfMzG
	 rjKJDRTnwZasZRvpgk59EBNn6/gNo7mOsddfdaBVXc5GZMZep5hffpUoPIZp1H6HZ5
	 4yLlrVnQ8kqmg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>, 
 Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20250124032228.587-1-vulab@iscas.ac.cn>
References: <20250124032228.587-1-vulab@iscas.ac.cn>
Subject: Re: [PATCH v2] xfs: Propagate errors from
 xfs_reflink_cancel_cow_range in xfs_dax_write_iomap_end
Message-Id: <173806187153.500545.11076256768222782414.b4-ty@kernel.org>
Date: Tue, 28 Jan 2025 11:57:51 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 24 Jan 2025 11:22:28 +0800, Wentao Liang wrote:
> In xfs_dax_write_iomap_end(), directly return the result of
> xfs_reflink_cancel_cow_range() when !written, ensuring proper
> error propagation and improving code robustness.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Propagate errors from xfs_reflink_cancel_cow_range in xfs_dax_write_iomap_end
      commit: fb95897b8c60653805aa09daec575ca30983f768

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

