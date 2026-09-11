Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D90734388E
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 07:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111772; cv=none; b=S+oSqhe0YD3KWHMz0Vq4F4gWYjXFUQE22vxsoqrhbi2+4MvhtfAUPxkDWdL3RR9mjWxnD0W2EWL15Dq712iJJef0lS4bp+ImmjpBPB6yafJevsDqorKBd1qMkdZo3esv/kGNQX34KRIBzzePigYou/7roJI5xJby7bd3RBgbI+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111772; c=relaxed/simple;
	bh=wNAXNJvye/NP0y0Qq+8+Zxy7VjY0qV7hTnQGed4t6GE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=imiQPCELInuPVGQsDmN7QT7i1WBRZJvgRC3m7/KOena6iWjKwWA3qxqjL3pJelJ1TGkLF7NBY7kkmDLR0e4Cpg/yocoFACw0UfOpo6puj2C0PGhdwxVjlqkEvjEt+ZRS68We6wJVVtSmvns7F1TQIMb2QcHlQt2fs//podUE9XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+ngno3b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+ngno3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6619C1F000FF;
	Fri, 11 Sep 2026 07:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789111771;
	bh=Jo/hWStyHId7s8SRDD951TXECL8UdbWS029afalh1kQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=A+ngno3b0Gi+AxHH+bmlSIcuuaYjjzur6xJeRGgULdQtqwZceheolSXAK2Ocv0h7W
	 kVFQD0v7eFTxWPTToUH58HPVQaOxcmJAD58eFfb9l9S0rrcYT8I3+UtKQFfl3ywuYE
	 +Jn2l2pbRN52+xGAs6yRxh8KozMA7qBUshQtoF7L+2Y87t8oHv8NWClKSnU2AqP3hr
	 f67jWPDxP3aLxihMhsR1i5gw+nSGyQHc7aJmZIp9xFZuqEv+mZ8uwzOGSCJKvCwCfr
	 erg5BZKLhnlK0bJksjDGEEeVOat9fCVxWYLjxF+mSxiZLuMFWcoLEZKxtPB7IA2jLz
	 3ZRsGVcfEf2bA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260907073427.719935-1-hch@lst.de>
References: <20260907073427.719935-1-hch@lst.de>
Subject: Re: fix cache flushes for the RT device
Message-Id: <178911177011.25559.13679453709186597443.b4-ty@kernel.org>
Date: Fri, 11 Sep 2026 09:29:30 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 07 Sep 2026 10:33:06 +0300, Christoph Hellwig wrote:
> when tracing workloads, I realized that currently the volatile write
> cache on RT devices is only flushed by fsync, but never at all for
> workloads that do not use fsync.
> 
> Changes since v1:
>  - drop the patches that are pure optimizations for a minimal fix
>    series
>  - improve a commit log
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: also flush the RT device cache in xlog_write_iclog
      commit: ad0033e2dbd3ecc063dfe613060da5cbab9a4970
[2/3] xfs: don't continue on error in xfs_fsync
      commit: c84455c683eb0b0397b0f5c5f5ce5cd82572a23f
[3/3] xfs: avoid extra cache flushes for multi-device file systems in xfs_fsync
      commit: 761e015e5a54851043c3b5bb7cfb6f539b01a35e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

