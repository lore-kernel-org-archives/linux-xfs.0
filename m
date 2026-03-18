Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F713280A29;
	Wed, 18 Mar 2026 10:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773828755; cv=none; b=dHHd1u1BpR35EDU6nt4KDv54HwboslYsowd4X32l3ppuuitp1sly4nDiRLpk/5NiyvA3U0CpqHbPh12a385WYybtL95i/OxhZm135uPP6Cb0NtL+QJAWXygy0i8dztKA+9/jlWwdjeS6SySvl11K9a9x7809H3TxcqMcrlirCVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773828755; c=relaxed/simple;
	bh=i8asDK5amQdwS0fXosDtw2yBuq4TAVzjPy5N0fuwuQI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VW7WeOLLt2s5hCEUTxQiJ4MfBkpjq0zouy+acTA8WKfwh4gFDaXZ2mtFlj5ExduYIQL8AaaolWpWt/PFmI39FMQlqueMxkV/hlINSQiSqVaRUmdwY5+93U6EKa/Clpm9XXqpN4RRFPhpdfYOhDQrGAMFfDqdsJkuT+z69n371F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qZTPmflB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qZTPmflB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44E5C2BCB2;
	Wed, 18 Mar 2026 10:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773828755;
	bh=i8asDK5amQdwS0fXosDtw2yBuq4TAVzjPy5N0fuwuQI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=qZTPmflBVh9w2R3B2F4xSXtxCNHjZ+P/RJl3wRmw9a74cwYe8oJyolsm9N7pleoYH
	 CF4TazRa+Qdq7oNU18FdeKhcCFChu+vxGZxvlujgJDpklJd+MouOhAu88cGNNO6PT+
	 odcAnZsZnP9kzDUdbV7YX1OMmCuoasbWYUaUOMylQHR0alCxQe8sJENUunt05BLaQ0
	 30I+w9qR+x0Y69gsH2RJjs8a4yaCAe0UlTaNQ9PyK2ZYtl6E+yB08ZcdabUCASNQS7
	 c5K28IpayWS5fEPSghjnoc1cj0u15Ek64B4qnVUYYtJIy7ej8sceANxuU91MT00q3H
	 p0IuwAL6ZlbjA==
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <dchinner@redhat.com>, Yuto Ohnuki <ytohnuki@amazon.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, 
 Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260310183835.89827-6-ytohnuki@amazon.com>
References: <20260310183835.89827-6-ytohnuki@amazon.com>
Subject: Re: [PATCH v4 0/4] xfs: fix AIL push use-after-free during
 shutdown
Message-Id: <177382875345.271956.17498312779581645526.b4-ty@kernel.org>
Date: Wed, 18 Mar 2026 11:12:33 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 10 Mar 2026 18:38:36 +0000, Yuto Ohnuki wrote:
> When a filesystem is shut down, background inode reclaim and the xfsaild
> can race to abort and free dirty inodes. Since commit 90c60e164012
> ("xfs: xfs_iflush() is no longer necessary"), xfs_inode_item_push() no
> longer holds ILOCK_SHARED while flushing, removing the protection that
> prevented the inode from being reclaimed during the flush.
> 
> This results in use-after-free when dereferencing log items after
> iop_push() returns, or when reacquiring the AIL lock via lip->li_ailp.
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: stop reclaim before pushing AIL during unmount
      commit: 4f24a767e3d64a5f58c595b5c29b6063a201f1e3
[2/4] xfs: avoid dereferencing log items after push callbacks
      commit: 79ef34ec0554ec04bdbafafbc9836423734e1bd6
[3/4] xfs: save ailp before dropping the AIL lock in push callbacks
      commit: 394d70b86fae9fe865e7e6d9540b7696f73aa9b6
[4/4] xfs: refactor xfsaild_push loop into helper
      commit: 7cac60947335f8d88a6390814840590a61134484

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

