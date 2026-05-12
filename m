Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1803825B0AA;
	Tue, 12 May 2026 12:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778587741; cv=none; b=EnJDGeLTfLEQPbbaq2rSsxOFzA+t27Cw0x1LOdZXUFY2cwvWH91aBjaPX/ysRYzMqqQixlrRD9djS1Aw1zBWR7Z9tSGRaIrEh+lrMVkF0Ojrx+d1e6sx1G+MvGUucK7dTmTCOCqOsIYM1KxgSRQ8RLXNiKOeeoIyIEceg4W4x6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778587741; c=relaxed/simple;
	bh=7Jtxs5aK0BpmgB9EjYc07GrLzlZwlT+RKu5BmrpAe2M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mhakGHeddDPxI19i4mfEYVzHdrPzw5KgGuQkOn1K9QumlV/swI0gPlYRsu5Tnqi83Jai/HF6j6NCdsur/YC0emhzrt7hSRmD8lOm6X7EAFEARE7K/A3EF9ZAM+z1KbpaxZf3erO5C3rTsJmYtxmf94SX71S6oJc+8nVJY4RtX38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fqi9H+pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fqi9H+pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCEBC2BCF6;
	Tue, 12 May 2026 12:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778587740;
	bh=7Jtxs5aK0BpmgB9EjYc07GrLzlZwlT+RKu5BmrpAe2M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Fqi9H+pi9bRHUDAdkNWCODaH5YV/+yluKwD1+czCeIf7XtHEC8F2Ol24UxSSX9+9e
	 QVkKzqtEERW7btIauLoxClMQEVtnG1+6nYzylfvF+D4vakn83z6pqzcBeI505aG7zK
	 3JgvNCPcwb8FLw6YOf1ueH40/HmvTAV8NTcmQcU1FuKnqq0rpoRsdqdeKkq6CxkwF4
	 PcV0tSEXclb+uZSFlpxKUqmqb+aZp/CzAEz04Z53LpPdwThaOujXKcgnrh6+L3vIGP
	 c/Cw9FL0TO1u9glnuWabKrE2zXEeIAk151tRvHFTdujhaBKt2ghMlELMD+xSSr5lGh
	 8dbWe7+OFxRkg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Md Shofiqul Islam <shofiqtest@gmail.com>
Cc: djwong@kernel.org
In-Reply-To: <20260506163658.2318-1-shofiqtest@gmail.com>
References: <20260506163658.2318-1-shofiqtest@gmail.com>
Subject: Re: [PATCH v2] xfs: Fix typo in comment
Message-Id: <177858773946.168431.12839270938040613714.b4-ty@kernel.org>
Date: Tue, 12 May 2026 14:08:59 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 06 May 2026 19:36:58 +0300, Md Shofiqul Islam wrote:
> Fix spelling mistake in comment:
>  - occured -> occurred
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Fix typo in comment
      commit: 509fdeb3326be0db055e88d0f689a3888f147f90

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

