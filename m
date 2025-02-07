Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676811AAA32
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 09:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738919530; cv=none; b=Cwb3rm6HkRZxhhi004eZBx9fUnvHzc1dxNxPFBf6JPYWfwb9RtoCKiafaUqtesU6QlHZ1FXxVBz0IRb7uDG2aIdlDLoNA9ZgVHhvm74sCNK2sOzUMnMDrbTMa92a5AJ3yJ1GKwpZ/J7V3bc9vt2lvSsCmGFtB9xgwygKrCphSBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738919530; c=relaxed/simple;
	bh=2xZzTJIdCX7nhqoraOnp82AnS4LKXy7B/kuIrGHdAdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IkuMNMsfq0ayu7SCQlqWm0apDgNV+D+nN5MzolhJ9HVSIalvoF77VVlBLMTGpyWRhRBcvu31QeUF45gz+eEU0dKfo5CayaG4zKLHumP3AogI1pjZ/Sx7P7JaPVLZs/0zxghfcbMP7nVJhsKrAFpo/5yBx7OipJPpHWRtIRXaxIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OyktFdSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyktFdSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4794FC4CEE2;
	Fri,  7 Feb 2025 09:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738919529;
	bh=2xZzTJIdCX7nhqoraOnp82AnS4LKXy7B/kuIrGHdAdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OyktFdSrgTdODy1oZ4Z4fiiAwtp0tJuBN7LiHu+SbfWDlv/8wdek7vxVdxc26UwqS
	 2zpjaxNpU9h+bkoKfI1in+sYUc/sjFtHKYWZqRNx2b+1WrhF+YhtDks8BTt+6L9SyN
	 FKSiF6DfScz4OTBjZ7CYs1XbI9zLm2bAOmS+vSp5r5xNibneZYZlnZTO+fNrHlFto9
	 gfu3LL5xol5lQ8ATldNKjz2rV1mbmnG4oA5PZDS+vL4YZ9QsxjkL87QwuPSZ7Jj4Jy
	 ItQVy59k+H7dC7ZU8id9cTUbAj64BtXZq3QF5ChtmtENRWQDbuyOQkFbPpNo4Qe6g5
	 XYNVfrgItFbDg==
Date: Fri, 7 Feb 2025 10:12:07 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, Daniel Gomez <da.gomez@samsung.com>, 
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <xqv4zn3atz47a4iowk75tf6sjslyo2pqgj4qpcb6vsmvezwcaz@fade7dldiul4>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <20250206222716.GB21808@frogsfrogsfrogs>
 <Z6U8tAQ3AKMKIlWs@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z6U8tAQ3AKMKIlWs@bombadil.infradead.org>

On Thu, Feb 06, 2025 at 02:50:28PM +0100, Luis Chamberlain wrote:
> On Thu, Feb 06, 2025 at 02:27:16PM -0800, Darrick J. Wong wrote:
> > Now you've decreased the default blocksize to 512 on sda, and md0 gets
> > an impossible 512k blocksize.  Also, disrupting the default 4k blocksize
> > will introduce portability problems with distros that aren't yet
> > shipping 6.12.
> 
> Our default should be 4k, and to address the later we should sanity
> check and user an upper limit of what XFS supports, 64k.

To clarify, the patch addresses the cases described above. It sets mkfs.xfs's
default block size to the device’s reported minimum I/O size (via stx_blksize),
clamping the value between 4k and 64k: if the reported size is less than 4k, 4k
is used, and if it exceeds 64k (XFS_MAX_BLOCKSIZE), 64k is applied.

> 
> Thoughts?
> 
>  Luis
