Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF8E38FF04;
	Tue, 13 Jan 2026 13:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768309843; cv=none; b=AVrJHJXz8ZmE2jTHgiYUAqjAWDJnvhNtEuatERkADeE9oPvQBQ+5gZ9FidH5+rsQHitcJvv9uWnG0iCF659AnSAW3wpeR0jsHE7hNb0IIhO18xzXFbk5O5yLA2WD465Ul5XgVTs4DNJ/+zCn8h2EL+WdlMms6mpZCiFl44s/rPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768309843; c=relaxed/simple;
	bh=SAkRW3R4HH1/+qn76DfyQKdUBBdSRD5KY0q/RfLTWoM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Akwu98X8VfOujc4OmBQbj1VGoFtTgAV0i6C5qNYsqgFsd9iXd9WVe1EPUokjCd7bTPvQRweGcLb2EmcU97kIR474hMEtqPibcmNuPSYqQ4rpRpjK5vLQsJOacL+czKrIKxNhyTTSwh/7aMINP8wA9R2lgyiTZ4n5wiJXjTsK4Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9LbziVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9LbziVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4E9C116C6;
	Tue, 13 Jan 2026 13:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768309843;
	bh=SAkRW3R4HH1/+qn76DfyQKdUBBdSRD5KY0q/RfLTWoM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Z9LbziVmoGZsMZ4kMlb0RHoplfC38I4R5qhEJyRagyDQW+74slBZmIr7movRcxev3
	 lAtp4jJy+xpnWN1j34uQpufmbWMFJz5e+0MuE1m7kIDdGWN57sJs9NCUv3u2BXKwQj
	 zPVar+ByyhMggwM9nzoXnZtA0H/eGOSA7XK4G2TqNF+LNIjQUNsDntmYIVB3soYSAQ
	 1tXcYBEyGF8tbjyegAU1oeku845FzUtv/e6JbVBGNyg8meb57hvKr7zt9fukpGDXGZ
	 04yXpIZ1zaFjMVrmLDy3ACxw6rFJBN95S6YDj4tl6jPaHNM+vdiwpLrg83UwBVsWZR
	 HneQOggHiWxxQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Cc: stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
In-Reply-To: <20260109174905.26372-1-bfoster@redhat.com>
References: <20260109174905.26372-1-bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: set max_agbno to allow sparse alloc of last
 full inode chunk
Message-Id: <176830984207.127908.986837300693754685.b4-ty@kernel.org>
Date: Tue, 13 Jan 2026 14:10:42 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 09 Jan 2026 12:49:05 -0500, Brian Foster wrote:
> Sparse inode cluster allocation sets min/max agbno values to avoid
> allocating an inode cluster that might map to an invalid inode
> chunk. For example, we can't have an inode record mapped to agbno 0
> or that extends past the end of a runt AG of misaligned size.
> 
> The initial calculation of max_agbno is unnecessarily conservative,
> however. This has triggered a corner case allocation failure where a
> small runt AG (i.e. 2063 blocks) is mostly full save for an extent
> to the EOFS boundary: [2050,13]. max_agbno is set to 2048 in this
> case, which happens to be the offset of the last possible valid
> inode chunk in the AG. In practice, we should be able to allocate
> the 4-block cluster at agbno 2052 to map to the parent inode record
> at agbno 2048, but the max_agbno value precludes it.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: set max_agbno to allow sparse alloc of last full inode chunk
      commit: c360004c0160dbe345870f59f24595519008926f

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

