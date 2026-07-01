Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33794481FA2;
	Wed,  1 Jul 2026 12:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782910223; cv=none; b=tOZvqJ511SR9o6YLAqkraR2955hg0CSAagB914gUMPK0e1Vyx4fGmludE+rvrMntHj/JIZorUQtbXsbCbmZUbI7VnMna1lKduIysX9gO/0oQ1poNjghqSAASB93zEiu9s/m2lwi67V7b8jRNlGfV2udM45KlxWhPNIfr8v0Hwdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782910223; c=relaxed/simple;
	bh=detUbZrgUvA+9uPju04NHgTnrkdUao4SkdZZ09nQQOU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iiMEUsbIk/vzDK2L+fKEeDVLVF+2H/lrW4tQQqs9hn/Cy4iBIha2p+6XzE2BBU9A8k5lxBfpDm/OC02ut6k984MDqAJ7RF+nJSXhKrZTBGrDwr73m2HxlAmb7o0L5K/pp/+5TrXRGocmq9wZQlZ9VW+xNT/aUwnCHjGTuxIr4dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJbMczVB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJbMczVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379261F00ACF;
	Wed,  1 Jul 2026 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782910221;
	bh=das9fe4BLc1rw94oj94HmXrYzMBPLP7/uEWIlEDh1IU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=dJbMczVB+TUFTLsHnWBpQeJ8xbg6cCC5n/bYM66wmgKdUQf0zWQv9z15I6vdOZsGY
	 p1zajWxdXt/QaaemE3j5lNZHGUAVch22qB6XdtP5rkgvYUvW4MjHayoxo44MPz8cpj
	 jiqZeYJ7FWCulZJJpA3+JYXKVh4Prs6qPaTp/jSybX7o49TRZheNFmVVfDYhoaOVsj
	 VSUrW2TGADlaujS4DQ3T6yd/MXe1FsRR6EOEwv/SY5uuvdKa1GilXZrEc33WDkRkpm
	 qwHgnDeF04cTeKY5xOs9rTSh5u3eulUDPM0YdO7V2NUWY5B414RDqRRv0jKwplzQgc
	 SvaLNRE+mo97Q==
From: Carlos Maiolino <cem@kernel.org>
To: Dawei Feng <dawei.feng@seu.edu.cn>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, jianhao.xu@seu.edu.cn, 
 zilin@seu.edu.cn
In-Reply-To: <20260627060402.2544349-1-dawei.feng@seu.edu.cn>
References: <20260627060402.2544349-1-dawei.feng@seu.edu.cn>
Subject: Re: [PATCH] xfs: fix memory leak in xfs_dqinode_metadir_create()
Message-Id: <178291021990.353898.12065940355634080852.b4-ty@b4>
Date: Wed, 01 Jul 2026 14:50:19 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Sat, 27 Jun 2026 14:04:02 +0800, Dawei Feng wrote:
> If xfs_metadir_create() fails in xfs_dqinode_metadir_create(), the current
> code returns directly, leaking the allocated update and transaction state.
> If the subsequent commit fails, the caller-owned inode reference is left
> behind.
> 
> Fix this memory leak by routing the create failure path through
> xfs_metadir_cancel().  For both create and commit failures, finish and
> release any inode returned to the caller, mirroring the unwind pattern in
> xfs_metadir_mkdir().
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix memory leak in xfs_dqinode_metadir_create()
      commit: 45de375b25060edf46e20abb36521ba530336ceb

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

