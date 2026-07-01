Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1759D48167D;
	Wed,  1 Jul 2026 12:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782910225; cv=none; b=kXm3Yl4eo+bwX6CfIAUab7/tvPoj3xbgRjCqSWGDAHN7XNickqDV04qH1WPu67gPu2QiemG1axGNfSvbx6JJNlVSac0vd5sAZElBiW3BmGCagUWIp8hs/UE4V1Vq9U42r1GvxapC3evGwymV5ZozDHpAFfsCdJ9RZbDAVv2spqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782910225; c=relaxed/simple;
	bh=EY26vsxuhr9ooBQveZn6aJcmwc8nQHLPVPkisJLc0Ak=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=c/qmJn+OImFqTdkWFnGnzxYqThzVPq2DhOGSZY9z1sx0tt6Gk7GhO35hSjQKqdJgQ9CUrtM600DBBX4w68ylpID8K3XLNQiKbBQkgkjky1uiGtnI024sF5lLMfJiI533hs1POoTemxMuGtbVl+rBaq4dILCf8jWF5dPLUHFhYyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGMEo+0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGMEo+0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549221F00A3A;
	Wed,  1 Jul 2026 12:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782910223;
	bh=BTDgKQ0h6KztG5KoQnxybcAKuEvep9s7TuEWF6RLb6I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=iGMEo+0aUB0urf31e9ot1FCo10looCS+0S71CoslDo8500dcWB3sT5seINVhD7O9T
	 gxhv/Pc+KQWS0y+oKOklA2RcUlnC7v6JEkFzC5WOwPi2y7qlLj1dBcUK2vVhRBUPz6
	 AqiGaaGu77Y3Y/fDSOvOMN5hK+1kl33rfAxnTJTXz76I4X/VwOc62yk5VKMQP21L0D
	 JAKZG3J7oMfjpB+xx0YC9UJYl0fohPZQSnXgaeblTh617STNigMnDUc4YV9eAo+K2c
	 vfyNtulc56v3AXSobSwp2xO93wh4uGUsO4AYeVni8XTPfNVPsrSb+YPXt4PA8XlhGA
	 aSAkNlmRjkdIw==
From: Carlos Maiolino <cem@kernel.org>
To: Yousef Alhouseen <alhouseenyousef@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
In-Reply-To: <20260630100607.7150-1-alhouseenyousef@gmail.com>
References: <20260630100607.7150-1-alhouseenyousef@gmail.com>
Subject: Re: [PATCH v2] xfs: use null daddr for unset first bad log block
Message-Id: <178291022202.353898.3754217860736181964.b4-ty@b4>
Date: Wed, 01 Jul 2026 14:50:22 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Tue, 30 Jun 2026 12:06:07 +0200, Yousef Alhouseen wrote:
> xlog_do_recovery_pass() may return before setting first_bad.  The caller
> must distinguish that case from an error at a valid log block, including
> block zero after the log wraps.
> 
> Initialize first_bad to XFS_BUF_DADDR_NULL and test it explicitly before
> treating the error as a torn write.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: use null daddr for unset first bad log block
      commit: cc9af5e461ea5f6e37738f3f1e41c45a9b7f45d6

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

