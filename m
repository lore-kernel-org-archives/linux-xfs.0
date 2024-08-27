Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66E4770F1;
	Tue, 27 Aug 2024 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784125; cv=none; b=YFu6213l2l054/5uB8zUaePZs9E0D/xYxM0/q+CeWMw/yTLeezfUBJbAdz33BFioRya8WToK+urE9pvlAxpfoMI805uSDVpObtrAjFGqF3AODKMIXb5n62YzoqB2dMZpKnH1BX1fT6/ri4Fmm1nmelIaApPEmI/moJcQaZNx1U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784125; c=relaxed/simple;
	bh=HFqq2pTpCaALfiAOL23ZksxdEaOy1FRwkK/hsoyRTZM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=O5EIMvOLt8xEqvUTWwPo8+9VDU7ds2cbgOAt0d9GFPkdM+hzdxbGF1jD4TSrYSAnnSlpTM23MfdwzIlJNMDrZ471CTjCIT6QvHQ3fQyinwNJ8Tunscvfby/+LaUTBx3JCwkqvLa3GjjZMjMmNv9SzvAxC7LvcgUOE9mQ45NfdBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azRnEYa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azRnEYa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB91C4FE0A;
	Tue, 27 Aug 2024 18:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784125;
	bh=HFqq2pTpCaALfiAOL23ZksxdEaOy1FRwkK/hsoyRTZM=;
	h=Date:From:To:Cc:Subject:From;
	b=azRnEYa+TNpb+1iWHE2L3SrQwoyCZRWWHN7DcyFs2WfrJiSry5DfH3ht7JbDW4y4L
	 0ugzwukQ8wYwWLdBZsEOmWlRNUCNmqQMk292GaV9sAomaQeViYC5YWeP+PK2eqoPX7
	 KJ4+OqBsQbik9sKpMWeQLARfuFePfUJBA+SDh1UFlX3kxDh9Tb2MztY/QM+xAsjMtW
	 DACNSaXc4+CNn8yPm2dhILm9AXyMcdkKAVkEb0r8KEQJ6bHB+rrG4082M5DJysqpMS
	 WJnQtLVMzNfmZJbiSA3YkXCkV77BCQTWoh/pfILacR9TPoli0EFJyxVqaHmkxrvXEF
	 09sRltNwzbJ7A==
Date: Tue, 27 Aug 2024 11:42:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB v2024.08.25] fstests: catch us up to xfsprogs 6.10
Message-ID: <20240827184204.GM6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Zorro,

Now that Carlos has released xfsprogs 6.10, here's some new functional
tests for the improvements that landed this cycle.  This includes the
new realtime volume FITRIM support, filesystem properties, deceptive
name detection in xfs_scrub, and the (hopefully final) structure of the
background xfs_scrub systemd services.

--D
