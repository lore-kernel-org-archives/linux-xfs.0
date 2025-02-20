Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9B013AF2;
	Thu, 20 Feb 2025 22:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740088966; cv=none; b=nxQkJuGhI2Z6JQNSSKDx6IEvmAVdgMZw805sa64UlGhG8fqxK+fwWsrAyGYMHTkvkyCiUoRUurqC5y2Hw5vHxBtmfkEKvR3GkE3OXvUihxp03HIrrpIx+0sdTn7HNhndAuc1cXtBTByVwyN54FO/uuR22CyMZpVfD8J9Q56WjTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740088966; c=relaxed/simple;
	bh=oXSDjLPlPEzGdwFoxfnnXwWVFIUWEh2Lb4isbmQGeNw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZuLoDc0oMR7dOlTvGeOxX12A6Qu4mNGo1yxf4kPH2ciAmVhz+g5JRcMAfXWi165wDJOKqy/H6ausFv3XYcfWcVAEwBQSuXnE0t/i8UKPDbf+V0Z6dFnG/qzZgMdhXWXLPjmA2P+lidb0w+W8SYNIUlF4CS6W2bRvSnl7tOqvAn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+SrJVe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+SrJVe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281D9C4CED1;
	Thu, 20 Feb 2025 22:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740088966;
	bh=oXSDjLPlPEzGdwFoxfnnXwWVFIUWEh2Lb4isbmQGeNw=;
	h=Date:From:To:Cc:Subject:From;
	b=h+SrJVe9A+tJUXnGQbwNi8+El/dgl0OfXpwdWjcJfisRruMrfEL2aKe2hakJPbhaB
	 tYTHuR0R5gF2mdkC7W9RB1SaJRx1+v5dNnOaV9RDD+zR71q8uINI8d5bfMkPqZFa8u
	 KJCULoLjhI9SI/jYx1kxyLeG/2CrfqpdEQBsoAE2rocS9r2O31M5HJ/KTi2WI1A3a1
	 mgJHkLiM9f9oic6/96YY2eybmmWhLvHbyywom8r9NdyTCeFhFnb3XzIuIRLW3yflN9
	 vpNWnbKUK8hMCAuD8sgiFhkxpF2DZbMHTz1J4bTXEntfvoyiyhGCsLhQ82hm78Aq4r
	 GEt81lVY15zfw==
Date: Thu, 20 Feb 2025 14:02:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: [GIT PULLBOMB] fstests: catch us up to 6.12-6.14
Message-ID: <20250220220245.GW21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Zorro,

Please accept these pull requests with all the changes needed to bring
fstests for-next uptodate with kernel 6.12-6.14.  These PRs are
generated against your patches-in-queue branch, with the hope that not
too much of that will get changed.

--D
