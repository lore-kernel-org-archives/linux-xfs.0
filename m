Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442B81A072C;
	Tue, 28 Jan 2025 10:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738061875; cv=none; b=Vz478ILL2I3C9SB32fZuVWPV4x9ALCD5k5f0g9dDWYAA1lnd9CZnTTWAI7EJDFwpQRN8SSOu3oUjQxYmiYIL6Sw5l8FwjSERlmvDND6y4MUYBK1a8CKa9lB3rbER6VJFJuVLDmX+BeXBDFQJ6gaKGO5BDuaj/kCj3+/AVLM/9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738061875; c=relaxed/simple;
	bh=lFxdvN90zFk2ZyFiU4DFSBcvhRkEe5LKdZHcde4F94g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lpNKQ8BSpzbvPudTWzk7hjH3RHDZqWJxf/QRv1ezu9vgJGUiFvP54GLmTlCDtG+thF8Hmw9pvr9vBdY7FU9z5Y6L8tQ8zLVpzSEEX8k3XysnQcEWutegDUa+AdmwTY8cEYFkAdM/q/81ItZjMWxcmLSz8ay7wPR5EqJlyzQPH6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8sWM7Qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8sWM7Qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8615BC4CEE3;
	Tue, 28 Jan 2025 10:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738061874;
	bh=lFxdvN90zFk2ZyFiU4DFSBcvhRkEe5LKdZHcde4F94g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Y8sWM7Qfu+iaf/GBjSi1eyRgdBnEoSRvAOje9jULAvf5GFJ1yK5jpakkgYvVD7dbW
	 +qHwmXHPWqzkDFxtpFm82xfNLN4+243vfqI0q6CTn5tyixaAblADszRTVBSb5asCGH
	 MZiB7lcvFcP48065zddrzGB2YkPVX58W75QUzTiAWKnjZriKfUIKC2N5XE/HQjCend
	 YsrBFU1wHoGADUqXJdWHWC7gYDGKpsIHEF1ikfanIardiY8RiRaddIQgwXkqjzywhW
	 rFd/7mxo2UGhXzgzrOrubLhIaN66RipbTmVfKJchVn9z8ScSdTz8mgjFLrMYUgKXut
	 AapniEge9dv4A==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>, 
 Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20250124034510.672-1-vulab@iscas.ac.cn>
References: <20250124034510.672-1-vulab@iscas.ac.cn>
Subject: Re: [PATCH v2] xfs: Add error handling for
 xfs_reflink_cancel_cow_range
Message-Id: <173806187325.500545.9001168827368063176.b4-ty@kernel.org>
Date: Tue, 28 Jan 2025 11:57:53 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 24 Jan 2025 11:45:09 +0800, Wentao Liang wrote:
> In xfs_inactive(), xfs_reflink_cancel_cow_range() is called
> without error handling, risking unnoticed failures and
> inconsistent behavior compared to other parts of the code.
> 
> Fix this issue by adding an error handling for the
> xfs_reflink_cancel_cow_range(), improving code robustness.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Add error handling for xfs_reflink_cancel_cow_range
      commit: 26b63bee2f6e711c5a169997fd126fddcfb90848

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

