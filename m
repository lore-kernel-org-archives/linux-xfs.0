Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E816238757B
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 08:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773304740; cv=none; b=elymiuUVBcGI9UGVOZ0inCBRvTCj9yMMfwy/pzNnDqQ5fzwJgoTuEI0ThRWO/sncZBbTZbrVB3VzmScH2U95Mzyt2mScZKnVIWCK0TLHu6hTRO80CVdSFvJM4c5ZYad0i/d3OsvgNsG2fcDrCb5OCEU/45waPFL/NXWyGQRadz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773304740; c=relaxed/simple;
	bh=pRnMpsxfgOixSr+e1LB2zzXo/+IfTKnhwyqZ0BznaxA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aIS8CvjbRCy5wLamnyNJhGN7rC+VfECKOUBn1TBonG1P3HuvfIUjN6WY25YPJGPN7/yNcaUkUlro77GVeP7lLaplhgdaqACAUmyYofo3CgfRSoroEY6HizCusD4M+z6Y9OoHVGyocUUPBIVitqUhAYd1WgRBOw0foyv5O6Skv0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I267E94C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I267E94C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F541C4CEF7;
	Thu, 12 Mar 2026 08:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773304739;
	bh=pRnMpsxfgOixSr+e1LB2zzXo/+IfTKnhwyqZ0BznaxA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=I267E94Cp0AwulHQzVM+uN1t/yvJqsw4CmIeER9SuEl294YUMrSK0qGWgcDX7tjpN
	 HeKEqTGXc41FpL9FyZWJc2qOMuefmpQdE81Vpvoq51mOaPEpMy3SG65Z5NfBzoLeVm
	 ibU8Chzju259oRNabZMTg438PDulhJlhlab4vhTekx4imf0FbZeLS0oX3Lg9EskytE
	 HxfvaxYvubwtdxfDfD2FFzLTKr19RFTXwQYJFfOTUP86mvmTXLC/P2EcB9dCVWhQuO
	 8DVmLO16jXs4Yp/mHZr99DPCNXeLc+kI9abeiv1vUHe+6pkYa5SP4qgJuDrhkEAYQV
	 2Dap9scjZTcbA==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com, 
 houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
In-Reply-To: <20260305084922.800699-1-leo.lilong@huawei.com>
References: <20260305084922.800699-1-leo.lilong@huawei.com>
Subject: Re: [PATCH 0/2] xfs: code cleanup and item deletion fix
Message-Id: <177330473709.21168.10891525491371559552.b4-ty@kernel.org>
Date: Thu, 12 Mar 2026 09:38:57 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 05 Mar 2026 16:49:20 +0800, Long Li wrote:
> This patch series contains the first two patches from the previously
> unfinished patch set [1]. I'm resubmitting them separately since patch 2
> addresses an corner case issue that should be fixed. At the same time, I
> rewrote the commit message and comments of patch 2.
> 
> Patch 1 : Simple clean code.
> Patch 2 : Fixes a issue where the tail LSN was incorrectly moved forward
> 	  due to improper deletion of log items from the AIL before log
> 	  shutdown.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: remove redundant set null for ip->i_itemp
      commit: f1d77b863b414586ee45e10d9837c9ab27d8692d
[2/2] xfs: ensure dquot item is deleted from AIL only after log shutdown
      commit: 186ac39b8a7d3ec7ce9c5dd45e5c2730177f375c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

