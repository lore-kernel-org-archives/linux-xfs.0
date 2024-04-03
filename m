Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE773FE37
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 05:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712120671; cv=none; b=fpiLQurLmiCsSAYuEWegQtNkd/RX+HPQKRHPEBH+nnWFsZmOtKuqt4fJObyRutfzU4bw13p8BXV65JxpqnIbH757VKBcLVr663HHS7VT6Lwa63m17GjHL14jLX1fEohWvw6pteU6BxFRq8n552rbcPACdjeccJyPaCcRtMDlQGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712120671; c=relaxed/simple;
	bh=On2W1ULointMl0a6N7G3lriCPwCv1HfRm4Jf2vBgRLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d7uCKvXRMMC0sjZ2PNHnyotENNPWVDHzNMbdZ45SEFvEfnVswnVHOCLOvKlxTFq6DqheFmRVw6aEp8d6g8v5INV4h4JZK9Zh8A9iQCsxL1tStfW0WvtxBLu5pZqGf/T7cfQ1yCGsf2t6kPSNIWqT6XJJOWdqxb2UiaWYqm6LyhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NcevaN+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NcevaN+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0ACC433C7;
	Wed,  3 Apr 2024 05:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712120670;
	bh=On2W1ULointMl0a6N7G3lriCPwCv1HfRm4Jf2vBgRLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NcevaN+PEL/WnGj6M2bDLOvuwHmGrfMXKihdF2YbIw+1uRsVufODvCOLEOJbN+UCF
	 3BLaPzwUYen6+p9+8bZKmdsQpddvowjFH7Amoqgaytt6gfZQ/92uM/X1Ah6KZbnKMm
	 /LqM5ILdJTc/hbafbbmPRzAzZs1jAkKsZB9udamScKdcumHqu/v3N4ZhPuF2HhsCzm
	 WH2DMP6LA8652r49cUpntgVVHKRkC/4zOe5OYinzBv4JoMO2aZUnP4Ohh6ps9dEjtG
	 RuSMO6d/sJv/jyV7u7BHMjE7W0IsGb3oKNzcRTGcuxos+M1iXRtpMCNmnqoqu7d5lC
	 FUeUUDc9c6uBw==
Date: Tue, 2 Apr 2024 22:04:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org
Subject: Re: [PATCH 3/4] xfs: handle allocation failure in
 xfs_dquot_disk_alloc()
Message-ID: <20240403050430.GT6390@frogsfrogsfrogs>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-4-david@fromorbit.com>
 <ZgzeFIJhkWp40-t7@infradead.org>
 <20240403045456.GR6390@frogsfrogsfrogs>
 <ZgzheEqxrVBg3dbs@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgzheEqxrVBg3dbs@infradead.org>

On Tue, Apr 02, 2024 at 09:56:24PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 02, 2024 at 09:54:56PM -0700, Darrick J. Wong wrote:
> > Usually this will result in the file write erroring out, right?
> 
> quota file allocations usually come originally from a file write or
> inode creation.  But I'm not entirely sure if that was the question..

Heh, and the question was based on a misreading of your comment. 8-)

AFAICT this can result in dqattach erroring out, which seems mostly
benign.

--D
