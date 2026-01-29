Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D6E29C321;
	Thu, 29 Jan 2026 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769686247; cv=none; b=AQzvKg6Si+Gw0ggkpDcw3QS9xXx7POZJtgbNpiMPBtsq3Hm68nrCtn8Gkx8i11qAd/pSsEOqpLIg5XBhvpjy9ajYP3Ctl/cUDczAmMQ+1oCuLXySQsl0VDBGZxetgkWRm+IdZMU+Xj1erRdaGRK2ZLomb1Om+9gtMUR3GMQlsAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769686247; c=relaxed/simple;
	bh=B1BLOCQVHruD/97xw+PNrda5LMt6zZvN/jD7Q0qZeto=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ua5DYuUvULND4WT5tgzpuDX3DmzA4kDJPXQy7Ej6hzxLy3o1tPiATiEu8Kc1VV17MIOXni933kBQ6HIS72zPE5BSoPWoLbIIUOAOfIaI4KjZHYvgJQVfEQ7fv68YA9J2OGnoHdsSe9k2+xt+7tOdR3oEJo7kjHz76lv4vCFyk1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=piy52lXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="piy52lXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E69C4CEF7;
	Thu, 29 Jan 2026 11:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769686246;
	bh=B1BLOCQVHruD/97xw+PNrda5LMt6zZvN/jD7Q0qZeto=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=piy52lXqjAY80NSG1/x0xoBH2F0hYyMUQMGLNYKBm4KTb9Fi6FryiuhCnUhXmfany
	 RuoUE4hvtSerrGOKj0FzwnPxoIshtx51qre5QDRmSOtXh4OElcSneb8NNkIcKTxhi7
	 0n/tfeQ8+2msXyDoTZCLpe0KMLzBho7RhMjdKf42xPJj9MF56C6B+LV4GP1KxaPvfI
	 b6dmFtUMzq+jI2HvUSQu013YlicpMMGF+YdV3tanGzG9KusWp3HCKj14WBDNMmKw6P
	 ogzDOzvYcRW97NOypebJdHB9A4DG4RS7Pc0amna4zMluRJOMAC41AZWQHd0lL7acPL
	 WLmU3doztS+tA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Shin Seong-jun <shinsj4653@gmail.com>
Cc: sandeen@redhat.com, willy@infradead.org, djwong@kernel.org, 
 dchinner@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20260123150432.184945-1-shinsj4653@gmail.com>
References: <20260123150432.184945-1-shinsj4653@gmail.com>
Subject: Re: [PATCH] xfs: fix spacing style issues in xfs_alloc.c
Message-Id: <176968624483.19143.18231065921341063860.b4-ty@kernel.org>
Date: Thu, 29 Jan 2026 12:30:44 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Sat, 24 Jan 2026 00:04:32 +0900, Shin Seong-jun wrote:
> Fix checkpatch.pl errors regarding missing spaces around assignment
> operators in xfs_alloc_compute_diff() and xfs_alloc_fixup_trees().
> 
> Adhere to the Linux kernel coding style by ensuring spaces are placed
> around the assignment operator '='.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix spacing style issues in xfs_alloc.c
      commit: 0ead3b72469e52ca02946b2e5b35fff38bfa061f

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

