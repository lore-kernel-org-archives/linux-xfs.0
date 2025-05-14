Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9894C6C;
	Wed, 14 May 2025 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747243840; cv=none; b=BpE9TsH7n37qxEfjnUYUfaF1Ncr/auTeb8nCLNeJSWjmynpsYmNb650f7f+XZbo4FAiDMiq77XAd0xhrW5PbIqYY13u410UMNIPM4RZ8zXLoqrn1mtYI9oMjHYL/wNTtPHuvj1nRKs5eYAefw6MQlAqAr6vnvqMf8ILQC4k0bfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747243840; c=relaxed/simple;
	bh=LLQnYBz/6PCjmiq+Re16OkPaP+x/tV9AKLY5mosVOWQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=soWZeFW+aE9NI2T4idbzqiXiAjuGY8RyBKuoeyZM0tM9rOvtPux46wrrLyP9NbHbpqrDJpq/Ecsr0StEZcHm86xStKF1Iq+QUYZhwzAY82xFCnOA6BoKE1dIWTXr4SpVmNoD0gFgy4TxQpyVfbV8odIgClOmb4Z2RLziasgiVww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8P7hTI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8P7hTI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033D6C4CEE3;
	Wed, 14 May 2025 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747243840;
	bh=LLQnYBz/6PCjmiq+Re16OkPaP+x/tV9AKLY5mosVOWQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=f8P7hTI03u3eEGiNQ2iTogvUeiTxeAqTTcrskT/eVk57Rhv89PRNOA3DPs6SxKjQG
	 HX1h6Mhw7QNHlNInR8+utn7jx+2aT3j9JJLDh2f+Hls5RYTtucuVAIVowHPWuTBbK7
	 c135HH0WrQXlpexJLWuJjZfxLfZDDTJxOkSPnllGdOGUbcvIah6u26IwlS3+EX+vxL
	 hS/zrnWWnlyKDYTmqDOAOV4povO6oni2dY2YtwEv1vWTdNJFHxTzou8Cuweh6KFvzQ
	 pNuEvrQFkezteCvqW2xcReAxOOJeMbGTOM/uKEXhbbDQEYIsRKJiwOYhEwK2a12Acv
	 hNQza+kv9YoXQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, 
 "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com, 
 djwong@kernel.org, zlang@kernel.org, david@fromorbit.com, hch@infradead.org
In-Reply-To: <cover.1747067101.git.nirjhar.roy.lists@gmail.com>
References: <cover.1747067101.git.nirjhar.roy.lists@gmail.com>
Subject: Re: [PATCH v6 0/1] xfs: Fail remount with noattr2 on a v5 xfs with
 v4 enabled kernel.
Message-Id: <174724383763.752716.8413533777890731819.b4-ty@kernel.org>
Date: Wed, 14 May 2025 19:30:37 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 12 May 2025 22:00:31 +0530, Nirjhar Roy (IBM) wrote:
> This patch fixes an issue where remount with noattr2 doesn't fail explicitly
> on v5 xfs with CONFIG_XFS_SUPPORT_V4=y. Details are there in the commit message
> of the patch.
> 
> Related discussion in [1].
> 
> [v5] --> v6
>  - Added RB from Carlos in the commit message.
>  - Some formatting fixes in the comments (suggested by Christoph)
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Fail remount with noattr2 on a v5 with v4 enabled
      commit: 95b613339c0e5fe651a3ef7605708478bc34a5af

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

