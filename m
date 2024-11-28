Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E2A19CC33
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 12:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732796368; cv=none; b=UbhfYfCwZsethOMzN9UvKZ1wmczGDa8OglrgEdzqizTsO8IA/MA07lUg6knlCJGo/5YvO9Mc+T8v2uoAPMLr9rcqiLK2uH2lKmpBVctDx4wJBZ5h0E6wWzsRe30sbv5aR7HX56oJZrdmSEw6TdyzaQzcpihN9++aXhIHm1MLC5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732796368; c=relaxed/simple;
	bh=vhtctPs1b+RhV/ARAODHbkBcmaN1JTdurHxJnrxv2Xk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FoAv1zkY0Eojq7C8C0rxYhojFMzXDxzSMUITfkYOCoQLyH41EWGRS3bjV13L8nM2NuPZR9uRMeWS3LXA3JgvScBydr0vrAhVXH7mqMShSgCvj2VfIZzAAtP2tF1oG68yF9TPoI4LBYOE/IH18l4n2psHFCWL98EgR2CvTOdK6nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZucZRMVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZucZRMVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CA4C4CED2;
	Thu, 28 Nov 2024 12:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732796367;
	bh=vhtctPs1b+RhV/ARAODHbkBcmaN1JTdurHxJnrxv2Xk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ZucZRMVU1IaCxXbYHQ28SJy7WlQrGFaCyMUY5xxTmyI46EMdaBF1n7d5UZT2XVqZe
	 jc/wmRzD84B4wrAHlG1tqIURs1Kde5vmjqr4B7+cdRb/SaYSfYcgzjb/atifvAdbLv
	 LEJ6bQeKU2H9vTFMX++5OoaeW5/2RFck55Y/MU8X+oN3ugC9dE6fCIuiaPkMX5OXS0
	 AxKP4xmi0mR2kzJzTLE+cNaE+5JmVucEm1kgfTBFzieP+mU+55jBl9j5pz+zTv4le2
	 3n0mQTWOZrIQGpqMDzsbJEoEfOTHFWFLL32Gl9sS5//zO1hIOBeodwe6gSfO1Y/cMk
	 i/IZew1ZS2sfA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
In-Reply-To: <20241126123117.631675-1-hch@lst.de>
References: <20241126123117.631675-1-hch@lst.de>
Subject: Re: [PATCH] xfs: don't call xfs_bmap_same_rtgroup in
 xfs_bmap_add_extent_hole_delay
Message-Id: <173279636658.817822.452789975706647401.b4-ty@kernel.org>
Date: Thu, 28 Nov 2024 13:19:26 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 26 Nov 2024 13:31:06 +0100, Christoph Hellwig wrote:
> xfs_bmap_add_extent_hole_delay works entirely on delalloc extents, for
> which xfs_bmap_same_rtgroup doesn't make sense.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay
      commit: cc2dba08cc33daf8acd6e560957ef0e0f4d034ed

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

