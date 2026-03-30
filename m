Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1266D33344A;
	Mon, 30 Mar 2026 15:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774883425; cv=none; b=tGXw64XxMFatfSQPJbQq0tQA4dZWs50yIb37TGe0kChgnPLvHVMB5+LrPk+caPgacHvzKm8fDaFboyt0dfVpMvDpHWuQeJVeyCJCp/QXkDbWtJuo6b9ifhK0TzQw2KNDlVb6RGRxoJM5PW5SIgQtW5fGlKRB1YVn4UdLYWAogcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774883425; c=relaxed/simple;
	bh=Nd4MyiAB+HC8PV4nITunLv3it81T+8xr/zQ+qcjkw44=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=g7EfHTzmYACLmLN9472Z1TrwCnMdoFrsWKYMt62uQ+86FKXiZpYhMZZUuqeHaE3fRShXP/P8jFkM3Xf+FK+h6WKZlqjVXLlRpZtKkAko3ujBNvZ4Pl+jR1lylXwRwAhPTq/1ocBQ09Et5SYXDtQGpwlJjSGFjlZKKcsGvs9EGn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIqlF6uH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIqlF6uH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2962BC2BCB1;
	Mon, 30 Mar 2026 15:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774883424;
	bh=Nd4MyiAB+HC8PV4nITunLv3it81T+8xr/zQ+qcjkw44=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=SIqlF6uHJ7H9SOQY2WvV+w0Tq3CKio0Gd+nRs3pbseqtrSGkUapvuZ0RMobMoY2fm
	 wByyfrgE5u6QFfMZ4s0pdVR6yPGeJ1qY0gNsbdZr9whuPHMTgHvyRFPS/2bXM3774w
	 zyxtbwnRmF/YyveNkI9nlGd5Z8G0ZUMGbDYlBpQ5L/38W4dS8OD3jtE1ZNQY9MnqO4
	 LFEitvAQzmoR6HcAPW/A6Z8WJ3RC9akiTmblXOKHmidN9/uJyNFyy7jC8FzKoHR7O3
	 qBM/cl/xqKDDA/RfevbZ7s8TDrrWT6TDoX9cz1plbA1fcQsv2WbuFuTdomJ4VcQ9+V
	 /telNuYXb6QJw==
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, 
 "Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260325124312.26349-1-hans.holmberg@wdc.com>
References: <20260325124312.26349-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH v2] xfs: start gc on zonegc_low_space attribute updates
Message-Id: <177488342287.47445.1575593681467138399.b4-ty@kernel.org>
Date: Mon, 30 Mar 2026 17:10:22 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 25 Mar 2026 13:43:12 +0100, Hans Holmberg wrote:
> Start gc if the agressiveness of zone garbage collection is changed
> by the user (if the file system is not read only).
> 
> Without this change, the new setting will not be taken into account
> until the gc thread is woken up by e.g. a write.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: start gc on zonegc_low_space attribute updates
      commit: 181ea4e2de422aa0a66f355bd59bccccdd169826

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

