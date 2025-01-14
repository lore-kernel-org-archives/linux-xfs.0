Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2820222DC20
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850636; cv=none; b=W/LarwsN5qWXseQIq5pF9THjG/UKBCISfbZ3wILcIfxF+QlW5MPSzp+L+/Dq+O9Ws4SSV1nr5ASBneCeqrQtYNFxik0KVlP6BdTWU8kdbcpD3SF/Hxqt7Y44Wd2XJ5t+GurSaHGbHHfldUUNnyIOdbWclO107KbFOQnVqESsY8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850636; c=relaxed/simple;
	bh=vCdU8NTEWFZOTP9RhEfYi6uj3VicfULXchiSzEQtJ1I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TeEbtuU2aDMS+Ek7WV+s1rRLPjW41Gb8YKx0Paerjrp5lpGxSZ2qreZoSbebgJy9vP8kICU/tKy/Hsr31GwZ/e3fA+h62ovezPTs08fLZvP6JJ0MlY/HCSFqe7uRL4bK3HbhZpFzOam6jmY+z8prw4r+yn86Mux+Xp6iPhwGC8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ue4z8Z2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ue4z8Z2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361F5C4CEE5;
	Tue, 14 Jan 2025 10:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850636;
	bh=vCdU8NTEWFZOTP9RhEfYi6uj3VicfULXchiSzEQtJ1I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Ue4z8Z2VNNWNwUMyfbNytCFel1MdrS2L70QOoU1j25Z0XACpBuyxHu7iog1Ng7ufV
	 kuIEM/gxrlZf6JFYJHjogp2CxAFzlR1lIyCN7Wa1SaOh/RRsa3hSowUciaIVq7xUpD
	 w911wk8NYGHlmk8kQpeGkFdxn1S+OKkmwXW1RUsxSM3raAxCUyTzRKI27WjbKFC/Ms
	 6Q7kS6VMIyEawaIqOLeTFcfYeez9Ka5kL+5dx/0fpB7n+DlU2gQb2GTwKEcdKPxd4F
	 ctgImWxbrJj7jMhrf7o3on3S/0GuxdC00I6iufRsv1IJCKBzufv2H3hb43XBBWh08q
	 FzSfE2soIoOMA==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com, 
 houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
In-Reply-To: <20241223114511.3484406-1-leo.lilong@huawei.com>
References: <20241223114511.3484406-1-leo.lilong@huawei.com>
Subject: Re: [PATCH v2 0/2] xfs: two small cleanup
Message-Id: <173685063393.121209.13387610036266159713.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:30:33 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 23 Dec 2024 19:45:09 +0800, Long Li wrote:
> This series contains two small cleanup patches. No functional changes.
> 
> v2-v3:
>   Rewrite commit message, make the explaine clearly.
> 
> Long Li (2):
>   xfs: remove redundant update for ticket->t_curr_res in
>     xfs_log_ticket_regrant
>   xfs: remove bp->b_error check in xfs_attr3_root_inactive
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: remove redundant update for ticket->t_curr_res in xfs_log_ticket_regrant
      commit: adcaff355bd8abb9b5097cc72339fb9cbf2eefda
[2/2] xfs: remove bp->b_error check in xfs_attr3_root_inactive
      commit: 09f7680dea8760d48dd5b8b5288a388fec122275

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

