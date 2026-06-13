Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F50121256C;
	Sat, 13 Jun 2026 00:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310044; cv=none; b=VmWbkrW1HC/weSfzMF2WEKZo3mnXCCuT0fXFccpkVQ0YeqXpZW+6lHMN0DmDroLH0rZINbIIHzkc9kZkJrJ+7UtEUORW+817tkvcm0eN/fdkbBcxLVpTOtNLax2MxgOFX52E4QHyF5GpF1/g8unWwzC/MAG+Hp6X/WHth82/zEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310044; c=relaxed/simple;
	bh=XhLh+iI/QONB3oW3qacur9cMXq/IPbi9hgDtfjhJjEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tm7mjTYDnVFyEUGzHO3sSKcNzrng4J/GH+5qZYRf/PJGOHYTCCEk0YQLK22FwjV9gpXcaFWd7BvkAPC8Y/pq+Q0gqjkLmfXaArvs5MXcQfa+HGSK7ihD8SegOU+wWPc1fS08rq1HkKlViiH89hsstsXGRH47g7YFahiFWHirB7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xtn+nvhE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xtn+nvhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BEE1F00A3A;
	Sat, 13 Jun 2026 00:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781310038;
	bh=XhLh+iI/QONB3oW3qacur9cMXq/IPbi9hgDtfjhJjEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xtn+nvhEtUmKY9aYa/p0QFigyg93czwUpAavsl7UDTbijmbG85KT7Q+muQPKuvrJR
	 OTDUqgzS8Lg1lPI2oarSwkOol5ioAA0sNMOn7jxjhMEGzLvTOiH3qrFvF6vINMBuZt
	 gQD8GsUGMp6RNnZFjZYAbtinNESBlTc/GBJSLfCUhx4PzMHBycCaplNYq270D8TavG
	 iF76+MTR+Gdee+pR838xC98/D7iRuSBXrTwZkUOWOqtkHthb6HHbxI9EwHBdQgGcYb
	 O1gYGQ89rz/xgFpTtC4M7KD7jzfbneT5LLzJ83xNGbx1T0v0m+hO5Zea/itEk2A1qq
	 kk2eAdHZwMnag==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Gregg Leventhal <gleventhal@janestreet.com>,
	Eric Hagberg <ehagberg@janestreet.com>,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6.12.y] iomap: don't revert iov_iter on partially completed buffered writes
Date: Fri, 12 Jun 2026 20:20:33 -0400
Message-ID: <20260612233100.1-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612121047.397754-1-bfoster@redhat.com>
References: <20260612121047.397754-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jun 12, 2026 at 08:10:47AM -0400, Brian Foster wrote:
> Finally, note that I'm not intimately familiar with -stable process so
> I'm just sending a 6.12.y version here. Earlier branches can either also
> include this, revert 18e419f6e80a directly, or I can post targeted
> patches if needed. Thoughts, reviews, flames appreciated.

Queued for 6.12.y, 6.6.y and 6.1.y. Thanks!

--
Thanks,
Sasha
