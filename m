Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD741E5734
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 08:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739263474; cv=none; b=bQWUXox85rn7v5wRrB/n9hA/1PmXwph10nqEFTttT/KDACnjDFj/as5IYVefmDfwT7k3AHsUzoHdQ2Al0wmzeeIcC9BPZwGy7SCFIuAExuXK51Xtx55r3hLjpPrxt9ubfGuclK8gp+cGmfNDxhjpJ5aBEv2Uh5uOQJ4cX1CsX4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739263474; c=relaxed/simple;
	bh=SW4k3eaFc7Y/VRwbZ9Fd3b4hbd2yTCgjzsExpSdwZx8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UsNMMPrsSRY2y7I6bGqKPV9lmrpWFGV/MlESveoQMSHKFNippzg0epoIr7+m0rrW7JkeRaTbgwjAFL488SCJAnO9vgIeG8DE3wsXJhXvJrWbFOdqBAY+/g6RmxwNCztp39uGYvMMrwOG6h4Fe28VRppzfucB3W5g5QbQL1UhRaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KSUYBD5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSUYBD5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D009FC4CEDD;
	Tue, 11 Feb 2025 08:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739263473;
	bh=SW4k3eaFc7Y/VRwbZ9Fd3b4hbd2yTCgjzsExpSdwZx8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=KSUYBD5qXSg4BtDfSGvbsHnrV+yfsA6Mqz/Vn8aE69ticAetyNS3BVdDCqUj2uJ3Y
	 PHeglpWjlYcZEAcahUfaplUc7H6QbVW+LOJSibfTDu8+wrX/kYLiM4mCBLSqje1lX5
	 7MtnYfYVaeZOuG+lrQnETl71heEn3O922moGnL1iymNsg5JVUhFf/bxcUInzxF2ihK
	 /HZYJLsAZOOIz+VLGjGWq3Vl0qJOJI1KCqC7oLkdSXGhBzFrvhjoiOF0jdQ3ReqZ+3
	 XBDFEPxQxeEZiyYXKqVU2eWZRSmB+5/NJoxhCfqlpy0XTSn1yBU3dCX7N430NcU/hY
	 ivJVXPUTRyGwQ==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: david.flynn@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
In-Reply-To: <173862194217.2448987.122994949207801411.stg-ugh@frogsfrogsfrogs>
References: <173862180286.2446958.14882849425955853980.stgit@frogsfrogsfrogs>
 <173862194217.2448987.122994949207801411.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL] xfs: bug fixes for 6.14
Message-Id: <173926347245.43797.6644715677325078212.b4-ty@kernel.org>
Date: Tue, 11 Feb 2025 09:44:32 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Mon, 03 Feb 2025 14:32:46 -0800, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs for 6.14-rc2.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> [...]

Merged, thanks!

merge commit: 84ea4c9d978b995f284a22a374b9caabde440195

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

