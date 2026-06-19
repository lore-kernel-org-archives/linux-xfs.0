Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14A8823DD;
	Fri, 19 Jun 2026 08:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781857528; cv=none; b=u5wJlfJIVlxQcLgDzumU577OZe6wbNYYfKQ2nMkUxFO3loxMweiPbXgeejq04xUTYjEAytv8OgeyysmQSJZnz2/O0N0h2fq0Bet2twcwPk8wPm/+Sj1RS1ZOpEtR966WJ1w/E0x9FpHWubd+j09ElbVvY8WqN7PqX+8wmwe2FEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781857528; c=relaxed/simple;
	bh=JAoXastpqbLfEbaMJJVXBQkuSJqPcM3uC249DpZhMOY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UNIUUNXPPniaugGUK03P2XG9XAh3A3aLLFKYmASDXEO1tsxDv29qhyD5CKJSn0sSkf9H1JlnN3tGxvbFrhvXKnPZkmXaasEoiLQbLFRJ4ZTThvdPmZlyYcX3hnuS/V8gnaNDvm40LaHUbNTfzgFpnVMHokC77FoXmNcvIbCArFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnEaZ5rK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnEaZ5rK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEB51F000E9;
	Fri, 19 Jun 2026 08:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781857527;
	bh=KRZUzo39MsJfwpIcRF9lV0M/rGo1K2di/pvIPlBo/Iw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RnEaZ5rK59+kW6NHSATqoGBus8/ku/YLORDYaZF605GjPjga+PPNNKjX++RdaMovC
	 KHpIRlrffZsVl9M4GVoiE+SNeJ/Piyiuxz58u40kku3E5qqahg/zGHVss01R24pSSO
	 gYCQH0atQKPuq8yAjV6qjBeEf7jpLhUzVYbitrg+rJE6tMloqOPLmWdw2KgmpALdmj
	 aBoIRldvmzLkknIrpzmQc98CzfIABpZZiCdIsKZgBIrkGI984OFTnOQAOcCADzBela
	 SBeYgGO9aqEHqbC5WLRsFRb3s+5WQi9MPFbqAEOn+P3aCMgvIhfGzMS8g+F1Pv8gqa
	 DjBwjKXb9V7cg==
From: Christian Brauner <brauner@kernel.org>
To: Morduan Zang <zhangdandan@uniontech.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 djwong@kernel.org
In-Reply-To: <863D407CB3ECEB04+20260618053820.506635-1-zhangdandan@uniontech.com>
References: <863D407CB3ECEB04+20260618053820.506635-1-zhangdandan@uniontech.com>
Subject: Re: [PATCH] iomap: guard io_size EOF trim against concurrent
 truncate underflow
Message-Id: <178185751919.166019.3738199100239942302.b4-ty@b4>
Date: Fri, 19 Jun 2026 10:25:19 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-aeb64
X-Developer-Signature: v=1; a=openpgp-sha256; l=910; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JAoXastpqbLfEbaMJJVXBQkuSJqPcM3uC249DpZhMOY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSZ/Pm246XtzPmBzcq8GyTY3OpS723cfUTkYEuOzcGdV
 w48OP6RoaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi5+0Z/pl/fBbT/+Afn0ph
 uUuWCq/ifemNjmF3fSwi0l/8OB7ZVszI8Ke988Zz63c+Zx74zLh4OrnnVZFA/K/PDt5Xnte5+ZZ
 ncQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Thu, 18 Jun 2026 13:38:20 +0800, Morduan Zang wrote:
> iomap: guard io_size EOF trim against concurrent truncate underflow

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] iomap: guard io_size EOF trim against concurrent truncate underflow
      https://git.kernel.org/vfs/vfs/c/2cd97101983e

