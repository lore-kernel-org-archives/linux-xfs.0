Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C540D47A0A9;
	Tue, 21 Jul 2026 10:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630708; cv=none; b=sQ6rrtQAOpsa2II1ekg8q51Ec65TZirLIMdd/MwW82cTxm8FhNGkd9eCVyCY3yLuyb3L8xCkdEPeXeSBKjaMP/AMmGtOVMZMpy0wINfgzANt9SeQsGEwJk2s6idrTis1XsB5qk5HYpd1uwQOtBgtfGGEPHaZ+LXplKEZyaIE9SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630708; c=relaxed/simple;
	bh=fUhC26o+AawoCH4Cgf27miKwI/Zu25y7UaUyFfLvyL8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jNsQjZTQDNSrWE7FJPoPDHtjkiPdbhRBma7XBf84D5p75+xZanRZMJK1+Z+hay/kf0x76fpQlnfv/WekHIVYS7C4FvPcykd+2c+d/ZUiX+uybLq8QLcVx+H7NN/WCY3NtDFk0mbhc8WvKPN5ZoktA3d/6o7H6ix1W+jxcVdAces=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tlaw3oIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tlaw3oIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE071F00A3A;
	Tue, 21 Jul 2026 10:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630693;
	bh=/7gKrygiveFz576bMbFnThKhghzfk8TzZCm1qj1QcEw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Tlaw3oIaRN0UiIw8a12riaulph2xuNq1TWlVJl9fVkNeuUEI12rFxn5/st2EUxkcN
	 L3yf/fZEeUNifZ/kGFnEPABeDQ4DvCKDCbxxS1l/ioR8JUglGBjNu/uJZNFM1ivGa+
	 ciFPB4gkmd1+mRbJi2bPruFRevdsfWjHYaHNvuYGSGVQzZbsydujydaE4/jg2tJA/I
	 5n3QFcRpju+q7thqEFu4ieE3AbK9kI7kVNr8Mxxxo5d/pJCM4JISWAKysv/U07G7mB
	 Vv29Bk2yJGoylQECaWJkAk/9Y//Eqbgo34NOWs87DTfSQ50A3aYau/dIvsIOyxa2OC
	 1nU7VP4lwC0xQ==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, linux-xfs@vger.kernel.org, 
 Ibrahim Hashimov <security@auditcode.ai>
Cc: bfoster@redhat.com, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260715071723.81917-1-security@auditcode.ai>
References: <20260715071723.81917-1-security@auditcode.ai>
Subject: Re: [PATCH v5] xfs: bounds-check buffer log item's dirty bitmap
Message-Id: <178463069213.324722.9171765123928848896.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:52 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Wed, 15 Jul 2026 09:17:23 +0200, Ibrahim Hashimov wrote:
> xlog_recover_do_reg_buffer() replays each dirty region described by a
> buffer log item's bitmap into the buffer read for that item:
> 
> 	memcpy(xfs_buf_offset(bp, (uint)bit << XFS_BLF_SHIFT),
> 		item->ri_buf[i].iov_base,
> 		nbits << XFS_BLF_SHIFT);
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: bounds-check buffer log item's dirty bitmap
      commit: c42b8e3237f697aedd6f75d07c5a6d59ef2a26e0

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

