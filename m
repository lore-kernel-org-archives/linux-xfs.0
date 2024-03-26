Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D78A1757E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 16:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711471814; cv=none; b=Ggut5fzSpfyjuqNvKvjXfwwfCMakjAPdWX8O6Xz+amb/rpMNAIgwswoPNRnO7p+6+ua0ehRNs8sB0Uo3YAmNw9XYCrZWaWrmCA1n5mRBgTkN/kZbu1GzPynii1QEq6uFcA2bO6hTM/QGOS323pDcBHHxkc4ZYp/xQbZeJegXyYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711471814; c=relaxed/simple;
	bh=t+kngLJN7cMKkSWgoTtgPZR9ika9u8s3THdJ4NcIEJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eekKPp4qY2NUBy2YfqDC2VZpsDimqhjsXGcbgD8o9tpfBL1VxWLMht/vRyEhxJNd99tFGdwuCMJbp9uqyzj1dxlHkT4OJCxapH3mQQ8XJ2wPHARJniXQaOv0GXPEi4M5QAiq9IgRfwrj7GvPHGxMCovUEPXm+n2UrtoIkX+Wg2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eh4hXzoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eh4hXzoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE882C433F1;
	Tue, 26 Mar 2024 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711471813;
	bh=t+kngLJN7cMKkSWgoTtgPZR9ika9u8s3THdJ4NcIEJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eh4hXzoX9QpDMEWKDPNP08LbxMzSj+Hz91BsJpCxyzx6QBVhuxGwFr5Vgablu7rLU
	 I2FZ6K2KbqmFmUNLfSJCL5cctu84LmNpRxZLUbclGz3f5s/ZNsWH6egCfVyPTVC/MT
	 6HSLBtYZDxfJyr2ISRMZqDYOzUjnzBZ9QlPAopqLWWZvZLGB5nknPhMkNrsr38Z4dv
	 NZQX9H1S2owtNvxjh3r+yo2SFsjrLq2d/NtKkYe9kWq3pUgcbqqJdDZgQc5yFU11W1
	 vKKq0KrlFGWd7J6DUF0JOD8Y63HXyraWpjRCVtelSszQBGUzKQ1Db0yh4zUx/Pccaq
	 3qCQEmFJyWdLQ==
Date: Tue, 26 Mar 2024 09:50:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 089/110] libxfs: add xfile support
Message-ID: <20240326165013.GL6390@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
 <171142132661.2215168.16277962138780069112.stgit@frogsfrogsfrogs>
 <ZgJfAQ0viwnfyK1P@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgJfAQ0viwnfyK1P@infradead.org>

On Mon, Mar 25, 2024 at 10:37:05PM -0700, Christoph Hellwig wrote:
> Oh, and xfile_stat is only used in xfile_bytes, might be worth to
> just fold it into that and simplify the code.

Done.

> And while we're at it - the partition_bytes field seems oddly named
> to me.  This really just is maxbyes, isn't it?

Yep.  Will rename.

--D
