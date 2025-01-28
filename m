Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15E51A0BF1
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 10:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738061877; cv=none; b=KocG4tLawWDdC/V7wVFA3gIgRppIJq011NFy3EyzinaJQr4QoAIBntb9PJPuMerEPjjO+0KYxbBbOPOEd/3wD8QZFK4AvGIg3GHzccPVQIC8/AeSs344FIN/oepZSzwm5IitIfVKunStt3ZmdJ+52jDVdv66tcHuujjDrjyUqTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738061877; c=relaxed/simple;
	bh=UstsEpGaEHGCFgaXAJx6pWjSiFEflNKG+uM6sOqVWHY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WfiBbCRVSEUnbiFELrK1MRcnFr1jIoanN8vOobGnGA7tgFfS+QK1oQNhFEGrXEdwsZT5yG6lUiKRaZj/jQKR1Uht/4J5dHCjfoNNKm+rfL9VmswFcTXfwg00/EXzpsjb8EnaR0zKtumXeGoxQsr1VCzV+tl+aErntdrLYJK2y/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOS/fpeT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOS/fpeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F271C4CED3;
	Tue, 28 Jan 2025 10:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738061876;
	bh=UstsEpGaEHGCFgaXAJx6pWjSiFEflNKG+uM6sOqVWHY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=cOS/fpeTbDwOi7DoGNb0WLcRfb40LfilJk6XNJsCdEw6Sm8kHf6rOvsUfi8N0pqTk
	 5pDgIhWO/gx+z+Xekl60+FXiXcV5OEZtKafbBTw1OAUb8hj3GmO1EHJ8k2EqQM8gps
	 m5Fs8OmN0+gCX+kLwBKUA1R3n1rjEGkhO/c5IzrL7ISPqQjI7L33EgRXavGdibc0Gj
	 haXk3RSN4UIIp1Waj67pxC33idST0NbCfIHhpugN+6Lq91n9lkybctl/R686qJLH9q
	 SqPsewA3LnJi8X26U6+sobZ5h+TRaqmFm04G3A9RoesWp0X1/VsVx5dkIN5mANZQ/G
	 KJk8BRuoLN42w==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org, 
 "Lai, Yi" <yi1.lai@linux.intel.com>, Carlos Maiolino <cmaiolino@redhat.com>
In-Reply-To: <20250128052315.663868-1-hch@lst.de>
References: <20250128052315.663868-1-hch@lst.de>
Subject: Re: [PATCH v2] xfs: remove xfs_buf_cache.bc_lock
Message-Id: <173806187500.500545.1535852127701117070.b4-ty@kernel.org>
Date: Tue, 28 Jan 2025 11:57:55 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 28 Jan 2025 06:22:58 +0100, Christoph Hellwig wrote:
> xfs_buf_cache.bc_lock serializes adding buffers to and removing them from
> the hashtable.  But as the rhashtable code already uses fine grained
> internal locking for inserts and removals the extra protection isn't
> actually required.
> 
> It also happens to fix a lock order inversion vs b_lock added by the
> recent lookup race fix.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove xfs_buf_cache.bc_lock
      commit: a9ab28b3d21aec6d0f56fe722953e20ce470237b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

