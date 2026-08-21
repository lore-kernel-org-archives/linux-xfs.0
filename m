Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB013A9013;
	Fri, 21 Aug 2026 07:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297759; cv=none; b=Bl1lPmlHqnVk5TU/8/m4cKDNuEtQvNW4cURE8nGEYR+uis+pNPhh/r2kQgZCrijpUr3OmOidN1edlQyBKbWJDBwH/D/aIK90JvVXXx4//VWJl3zZbJYlbYPhR+N2+3gMYykS5IBkbrKObj17CGZnXLT2tQItbMJInVK8vbfm998=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297759; c=relaxed/simple;
	bh=gM4PB6jvCLru1np0dn2TPj9uBM5huYtR1q+FIfKPyEc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Q0pntciQ4r5wTMb4pZl4UfLh8jhWUg1O6Ox6En8DnUsrPsmsdO4vYUatjkm0M1OdJNTjPAhSNaftDlJegoSK4l5xdN4r/Mc40wygWzy77iNQUVqGkUK52Dg58VptW4prW8YBTR3qyAliTLNB2mhvQTPetx2SXlGQ6Ybrg++W8WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFo2Mzbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFo2Mzbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D12C1F00A3A;
	Fri, 21 Aug 2026 07:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787297748;
	bh=oXJHDemgkjAm5LklJrh1F1XKs3DWVt7AuCSXuQJ9UzM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GFo2MzbqiNmMXOyixmdPPSRnwCpWqFBjwwcAC5SBSwu+o9ebem6ZB6h6HCu9bc5tm
	 Ukwkxr0DXEWNM7l39JF+IQ0rfJrLkOtHnNBiRLRgfgCivk1CqMPDppfT6k6ZFrfo/7
	 cy/tulnQ3A1aoC2edh66OnABVnU4nygKd9J3XZPTdzYJTfTBxWdwVMYjD1/UWytozW
	 8XbENWtaxkIEbt7eweeqaXqG6wwo5m3oB6O5WBlKTObiNnHcWW+q3In8/bE1Gwllqb
	 BMegBlYFiz3KHjoj+rZXF5bxzVUJLQXFKGlXpRmVc0aLYWNCM5MODKgXh2HMWkT5n3
	 0acHA1cpqGXKQ==
From: Carlos Maiolino <cem@kernel.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260731031010.2627884-1-yun.zhou@windriver.com>
References: <20260731031010.2627884-1-yun.zhou@windriver.com>
Subject: Re: [PATCH v3] xfs: don't hold buffer locks across sync
 transaction commit in xfs_sync_sb_buf
Message-Id: <178729774687.580975.9479028821685428366.b4-ty@kernel.org>
Date: Fri, 21 Aug 2026 09:35:46 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 31 Jul 2026 11:10:10 +0800, Yun Zhou wrote:
> xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
> xfs_trans_commit(), which flushes the CIL push workqueue internally.
> If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
> lock these buffers to fail them, causing a deadlock:
> 
>   setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
>   CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf
      commit: 41a28c865d1d5843f8cb9e0af17a8f4d9e2961ff

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

