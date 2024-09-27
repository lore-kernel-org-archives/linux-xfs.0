Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C11B18872D;
	Fri, 27 Sep 2024 18:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462738; cv=none; b=R33MjwzrPDqdVuOonLzP4ZgDGk56BKg3Ge5gXG64ZKC3KqPm1XnEEKa/EfX67CKCupxldtRsfjtmmW/lq2FDFF+z+m88Srm2UqlmK29k3WqAPJRVtAiO9r8fjXINkqK4EGVmFEWwWwRKNa6I/kQvY2i731iF5cGtFXsedIcV/oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462738; c=relaxed/simple;
	bh=M7iP7v9Qt9Zh+X/r4YT1GybGDs7MmvkGkWj3mjCDMEs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oz9h32Nx1Y3A+GSt00bjAnPh43akcOvasv3zA/amTcOZhA3ssjnXZmcPHKTQtPcnMNpSse3VJE/t4HOKZ78Uu+mD+DFwLWTFh1lnydbkawc6a5f/CkiqmxST6u/1hDEnk24aBLddIVMrtHzXhaFaur08bU8DpdBqFnn4jrRo9Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eE+hc+mQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eE+hc+mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACADC4CECE;
	Fri, 27 Sep 2024 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727462737;
	bh=M7iP7v9Qt9Zh+X/r4YT1GybGDs7MmvkGkWj3mjCDMEs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=eE+hc+mQk5GFR0EPRkfOmwrhP9FZoIPH5vzh2KQMpod/7lBZ04KzlPAcPHBcAsQb/
	 TklPYFUMNnwNZrRuUd7ZZa3Fpd45MEtQ+pr7dcYzTr5ryI/j3SZitqnAD+ixlY0Ghb
	 qLB6GyTZHqyiXvXao75KviyGKlxy0bDQ2w9n8aRhLr5SBoBMiRcBT19KuuR/n7HgLA
	 uwDPHyq1aSIbhl2RB32OQj+joK8FNuWJto1u6hd7CP2wAnsNYDIz65BLDL3Tp2NirR
	 QrlLcq185sym4qc5XiL23Hw/75MWY/tVf6voufRC0+fdzJHw5ift16sZPhzICpjuV7
	 6LU2KfAlDVf/w==
From: Carlos Maiolino <cem@kernel.org>
To: chandan.babu@oracle.com, Yan Zhen <yanzhen@vivo.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
In-Reply-To: <20240910122842.3269966-1-yanzhen@vivo.com>
References: <20240910122842.3269966-1-yanzhen@vivo.com>
Subject: Re: [PATCH v1] xfs: scrub: convert comma to semicolon
Message-Id: <172746273590.131348.11997711109844038194.b4-ty@kernel.org>
Date: Fri, 27 Sep 2024 20:45:35 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1

On Tue, 10 Sep 2024 20:28:42 +0800, Yan Zhen wrote:
> Replace a comma between expression statements by a semicolon.
> 
> 

Applied to xfs-6.12-rc2, thanks!

[1/1] xfs: scrub: convert comma to semicolon
      commit: 4956580c2d9ae8c81cdbe9ce19f5c8d14d56dac6

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

