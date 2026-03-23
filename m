Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BB23914F1
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 10:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262840; cv=none; b=mmg2FINpQAakC25QoTaQF/3xq/LvzaSGoti2A/LTV4P/8e+4UOG4gzK5nZuBs5IY/lOyZLuGiTyRguXuxznfJffybHjVBYRbJ780HQ5dV0JrRz7FUBDd1bUvdh0pqffvZ95zdfgjTLykSdAER1cpOH7zlflo4UMoge8w2lvuTEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262840; c=relaxed/simple;
	bh=xNLMOzF6y2qai3TkFXFAU7nI8y9Tp5pnlnDbyJlb2XA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=E8UctVBwoAQ1cwEzIsC/vixn5nnGNb781sr09pikOBcFvm2EEs5jzwbA+sY1a324ZCyYhwylQEcwfEW0IaGW1e8gtVJl+LEWM4bgAJb2gNMXGASf8nlhmGeFU4UWjfK36a8NIzUzDVE2pvEFBJkvPTsflezDgabElsiRXMDSi9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qALn1Jmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qALn1Jmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB10FC4CEF7;
	Mon, 23 Mar 2026 10:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774262839;
	bh=xNLMOzF6y2qai3TkFXFAU7nI8y9Tp5pnlnDbyJlb2XA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=qALn1JmnG8F3fBCEXHPl81+ugqz12cCySLTo2Mz4f6TSwIhRQbJNDEYVXJf4sDI1M
	 AVesnF+0OUuCTli6BF9PO05rJE7G6QC3cHwVuIqfiIw7dakh3VwLjasWXuNk/Zre4J
	 Xnw/TVjsTAX7KGagh7m+5YsdgS9xCs8/maIN54t2Wo3CNneFyb3PjBDbpXN9ZAphw/
	 6O0MY9t6VdPtU6MdM5e0mY5AIYdJRfhzIDo6UsfJ8fU76/goEuRfWXWZMV9crhmSPm
	 xw8uhqI4dxbpWeWsOz0t62khdXHMqr9NmsLWuFoBB6I4CAb43iYxm0EqZn7gaG3RJZ
	 Wl6polrPWtt4Q==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com, 
 houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
In-Reply-To: <20260320021130.2936657-1-leo.lilong@huawei.com>
References: <20260320021130.2936657-1-leo.lilong@huawei.com>
Subject: Re: [PATCH v3 0/2] xfs: fixes and clean up for attr item
Message-Id: <177426283747.254917.16728887930084727113.b4-ty@kernel.org>
Date: Mon, 23 Mar 2026 11:47:17 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 20 Mar 2026 10:11:28 +0800, Long Li wrote:
> This patch set fixes and cleans up several minor issues in the attr item.
> 
> V2->v3:
> - Patch1 is discarded, as Darrick has already fixed it.
> - Update the comments and add the reviewed tag
> 
> V1->V2:
> - Fix ip is not initialized issuse in patch-1
> - Add the reproduction script in patch-2.
> - Delete only the redundant code, and leave the rest unchanged in patch-3.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: fix ri_total validation in xlog_recover_attri_commit_pass2
      commit: d72f2084e30966097c8eae762e31986a33c3c0ae
[2/2] xfs: remove redundant validation in xlog_recover_attri_commit_pass2
      commit: c6c56ff975f046be25f527231a239e37920aca5e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

