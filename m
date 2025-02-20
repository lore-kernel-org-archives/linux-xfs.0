Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218FA1632DF
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 06:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740032455; cv=none; b=dZcCs8upvu7Z1/O7gvYzP3S1qd/Bb6bFnQKKN5xYgf58PAwm1wuglnvxL8XyCqSNEGI8BtTwpPIuyfCDbPySyz+jQHW7HuraOtT9Y/gvy3A8J7WynMcu2+TpPYxaZroIJaOqAH+jFy4iCyOyHFzQNuDHzso/9lEtBuMeFUXVWvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740032455; c=relaxed/simple;
	bh=O5ozAggo11NIhu6XzSzMLwUqHUcyaHHocN3zlm+fYcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rse9nrm33gVlHuAMn2UT1haWXhC7ud+X4vV95r91VMPbE74QmIeczV0JK8upEIzlGtNmccjFWm1ZG/+a9sQgt48Btb8hb7qqOKR6GrqNAX8LhmnRfA217EMwQIqG/e8qJR6JI67/uCObYWbMCbWACc6IaOuV2oFQwC6jnpEqe0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FCqZtAFe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FCqZtAFe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DYehw8TM+WXhZ8yq4XPVzpXMeriV0Zfu3a/GY3T6WXc=; b=FCqZtAFelhfdc5QrbF5pxHrOEW
	A4VT7PmUvyMWU12GASHIdvX42gbZanavvmfERZSct1KhU3hbLq/VWaVfAA39AeZmQy59WgIhkWFrc
	BrbTYRiPqiVPNcWTTShmBLAndrQ8ZgJTWr23GVUSLj5669Xe/yCI8H9IXp9E74EhWOyULyUjf0nP9
	NNxb8CXWa6xQV0c+JxHVmDWmT2vkfbtjtAcL2v4IGlakcgiTkMlRWz267hXxOZEEqce6eN0N4uT5H
	sNvvVgVGqN0G5Ke88YQhwbiGu3vRYLcJPOz8wVkHKF3HpX+jpNQc4vO7EhQKjDJ+Rm1v9lOBuhaZs
	ehlXpXtA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkzvZ-0000000GvAx-312E;
	Thu, 20 Feb 2025 06:20:53 +0000
Date: Wed, 19 Feb 2025 22:20:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_db: add command to copy directory trees out of
 filesystems
Message-ID: <Z7bJxXli_0OMpEKo@infradead.org>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089664.2742734.11946589861684958797.stgit@frogsfrogsfrogs>
 <Z7RGkVLW13HPXAb-@infradead.org>
 <37ea5fed-c9ad-4731-9441-de50351a90d7@sandeen.net>
 <20250219183056.GR21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219183056.GR21808@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 19, 2025 at 10:30:56AM -0800, Darrick J. Wong wrote:
> If instead it turns out that 2037-era userspace (coughsystemdcough)
> doesn't work on an old 2030 kernel, then they'll have to go install a
> 2030-era userspace, boot the 2030 kernel, and migrate the data.  Now
> they have a V5 filesystem with 2030 era features.  If they want 2037 era
> features, they have to move the device to the new system and migrate a
> second time.

You probably wouldn't boot the old kernel on hardware but in a VM.
Or have and old user mode Linux build around :)
