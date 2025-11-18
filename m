Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5782EA743
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 09:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763459597; cv=none; b=IyrxV+v6cqi4l645ymvKBoTC2Oi0jrCS0EjtExne3uIpeaFTZPLGUhg0GMQpY1MuLfreI/TOZzW6Cb69uEwmzU8YfTUTYBSybtfnmJs4mxObqxy6LA6VvkyzGf7OWjGew/0nCh8iVSKzpibnJdnEUjNp69RfhH5MzEMuJkm3KJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763459597; c=relaxed/simple;
	bh=k86vT54j85CuTUUdNBVp9M9GgqnWzecaDBnreE06n4Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=N94CJR+pDJL8y/nFYojkgUielLwFkvpjlGOFsdIQT+eCE109cAAw3sYAND6PbqzgJmDn+2azoMU6wjCmgHKti+AOuSEYVCJqRpqBHPTIylcZgSCpp5zUCgrThd4b/6hVHlOQEiK4l7gUO6LhQhz5Kvp+BBerEoQ7x+je16m/0iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lwdz2rQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lwdz2rQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5495BC4CEF5;
	Tue, 18 Nov 2025 09:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763459596;
	bh=k86vT54j85CuTUUdNBVp9M9GgqnWzecaDBnreE06n4Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Lwdz2rQynJwEA12cuhdNw7ZPzfvMAK/L/Im3Mou8+IHUMS5LN+QhrY54lmAjCwe5l
	 m4LzCvJWkWWd7sfjGDazjLffx8iQTZzn2kud2BBK9BYke4ZU3LZBYER+gFcqfIdXop
	 ROwNXTQKuK8UCLqYXiYxop09AopLbkEmbjC6W2gMnxin0e3LQsDLbXP+878LSnq1zb
	 tijqNcg1V6NJLTfWEvROd3rmQKJqT73Hb+KKViZQxh7RyswfkRka/pDwFGiULNwHFl
	 35eaeYlP8UukAG5FjKFEDwQJN9gtXHPPTtt0dIqX5LBFwxcFxQN4cw8mb4w5Il8EY9
	 t74spqJ+3mIuQ==
From: Carlos Maiolino <cem@kernel.org>
To: cmaiolino@redhat.com, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Hans Holmberg <hans.holmberg@wdc.com>
In-Reply-To: <20251027070154.727014-1-hch@lst.de>
References: <20251027070154.727014-1-hch@lst.de>
Subject: Re: [PATCH, resend] xfs: remove the unused bv field in struct
 xfs_gc_bio
Message-Id: <176345959498.25131.11531761018364077285.b4-ty@kernel.org>
Date: Tue, 18 Nov 2025 10:53:14 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 27 Oct 2025 08:01:50 +0100, Christoph Hellwig wrote:
> 


Applied to for-next, thanks!

[1/1] xfs: remove the unused bv field in struct xfs_gc_bio
      commit: 9b0305968d60a7672a7db29c07cfbe03bc5ae3ab

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

