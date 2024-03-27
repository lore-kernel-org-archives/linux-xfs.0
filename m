Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6440518E28
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711503641; cv=none; b=jsVAFuHWrlZzS5tsUuDkz35vnfoPE0wJcIhvKZ0WJ+2nurfcyej7ut8rnlJBGn2AHDI0zT0iRBR+duqb4Q3BaqvaqHzU48l+FBv9O3yG/sGiTIxoOcGSqatRujrxTeMZaA0F+juhrzI2Yijenpm2UzE+fnGH+XNlQHRQDYYOYX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711503641; c=relaxed/simple;
	bh=TZjInAVES8BzjQ4ABYWGGh0Szj5/colPEvcBAf9DPdU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lY/cQnWL+51wLPESbMrPkMo/X3BorYMgwdI1eEwhCmhSLns1shV8B/y38egV/mrYHD46jK6xRSqCQSG7/j4Of/H32blr5VmHGPw4va6SbBJiLrgZfdX6iXtpiHKY27gDdBocJJ3MgjsE/6cizMF/+WmAivaOzf/oTdmkP1fOc7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aalswlNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aalswlNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE432C433C7;
	Wed, 27 Mar 2024 01:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711503640;
	bh=TZjInAVES8BzjQ4ABYWGGh0Szj5/colPEvcBAf9DPdU=;
	h=Date:From:To:Cc:Subject:From;
	b=aalswlNBGoA62FXPmzBJzlHsounl69fK4Np/dSmIRCYAtGrmSWGCXvNu49ZBZrrD5
	 WikcEdRJY26DP6kaeRDaxkR/TguIweRpKzYIuoxtUj1eHmzUWhAFSkidn5YaCjh9Qi
	 b3BV9AKOE31xe6GtM8uM4M92462odFdt2xp17DptoiUGW/eF5lCeTwOh9QpL9VKptI
	 8ZGfSdraBbFd2jhtpxndtWpPQmigtJl71VepcgfzmY6xQhrOaHIGQPaf391qv7gtNl
	 Kg5YiIW6Z4lJO+SfIaPcGfK+pmMcSL2+xRyABbFme5uhKV4+z8u1PuxnPyASBBPiDi
	 2hgk8hys2cNXA==
Date: Tue, 26 Mar 2024 18:40:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB v30] xfs: online fsck patches for 6.10
Message-ID: <20240327014040.GU6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Now that 6.9-rc1 is out, here's v30 of the remaining patches in part one
of online repair.  Of the 68 patches I'm sending, these are the only
ones that are not yet reviewed:

Patchset 1:
 [PATCH 1/1] xfs: fix potential AGI <-> ILOCK ABBA deadlock in

Patchset 3:
 [PATCH 5/7] xfs: hoist multi-fsb allocation unit detection to a

Patchset 4:
 [PATCH 02/15] xfs: introduce new file range exchange ioctl
 [PATCH 14/15] xfs: introduce new file range commit ioctls

Patchset 5:
 [PATCH 1/4] xfs: hide private inodes from bulkstat and handle

Patchset 7:
 [PATCH 03/10] xfs: reduce indenting in xfs_attr_node_list

Patchset 8:
 [PATCH 7/7] xfs: create an xattr iteration function for scrub

Patchset 10:
 [PATCH 5/5] xfs: ask the dentry cache if it knows the parent of a

Patchset 12:
 [PATCH 1/1] xfs: online repair of symbolic links

Patchset 15:
 [PATCH 1/1] xfs: fix severe performance problems when fstrimming a

--D
