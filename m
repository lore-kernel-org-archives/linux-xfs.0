Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53FA4AED6
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 11:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714391293; cv=none; b=MyvJksZgluOo/hIIHT+wdSZBDf0hp57TTuJHY7U+wka9SPlxOtUBQ+rA6GJIk16MpRBz4s9dqYPHJ9At5wgLs8N3tYHykgJWGQXd6iDrGUtgHLrK4jy8KtLfzrD8RK+yFovQvbFFLBW0hYKqfjiXUSxw+y3j2/D8QQZRUr5YgnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714391293; c=relaxed/simple;
	bh=mz0O67DGLfjwOmtDeAJldvb0GYKgLkfc5yfZWeXcG/o=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=aRAkk0k/0bExAS+ioxLErearrgEZIaOKVR7V0Z8yea+K2iB9xOvK2XhkpgJUw+CTqSMbW6SnXwONB8NA4Q/2iSgRBGeMKc57rNWL//u2A4ouOE8JYg9qZOl/fvv2/L669C0kWP/UMTjkILNaqtWLDlxC8SAxfB0IphoTXyksiz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khUWtgo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khUWtgo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED3FC113CD;
	Mon, 29 Apr 2024 11:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714391293;
	bh=mz0O67DGLfjwOmtDeAJldvb0GYKgLkfc5yfZWeXcG/o=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=khUWtgo4YMrU/A1dLqm1oFGRQmtVBslD0+rzcmtSPK8M7JF0JwPHtmoJNVUJ5M3OB
	 l01D94E07PevJoddFyh/RIkR5qZ319rZpt95PUvFLfTULbJLB5KsKhQ8chBIJ7ODh8
	 ipAyFDfyBG5u7H3rZ+SRdLIYGBzwMGxnbSq7387NU/tCmsJuBrXgSihx3wNOP9qHF4
	 wM514Km8Ahbg+y0P1VR6hw2Qp8w6Z9sj5gr2DoWu0ZOqdMQxL883iyDyT5cvvJ0aGf
	 yWvYVdXPyl1cL0LE+vJbQHkCfHfe5n6sewvI6IQ7JaKymk/8ShCcX1lbl2iqlwx34T
	 B+q4KVoHV2ksg==
References: <20240427050400.1126656-1-hch@lst.de>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: add higher level directory operations helpers v2
Date: Mon, 29 Apr 2024 17:17:20 +0530
In-reply-to: <20240427050400.1126656-1-hch@lst.de>
Message-ID: <87sez4peyt.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, Apr 27, 2024 at 07:03:55 AM +0200, Christoph Hellwig wrote:
> Hi all,
>
> with the scrub and online repair code we now duplicate the switching
> between the directory format for directory operations in at least two
> places for each operation, with the metadir code adding even more for
> some of these operations.
>
> This series adds _args helpers to consolidate this code, and then
> refactors the checking for the directory format into a single well-defined
> helper.
>
> This is now based against the for-next branch in the xfs tree.
>
> Changes since v1:
>  - removed two stray whitespaces in the last patch

I had already applied patches from v1 and cleaned up the trailing whitespaces
while doing so.

-- 
Chandan
