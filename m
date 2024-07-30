Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAB41917DF
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 22:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722379046; cv=none; b=hows96BRhnQijBN0qksV/bAOV8l9BKyw08sZEIC/BouOX1i+ZKRD5CBuyXO24O5IE1vkBoau1ns9AAHllOrr5315PtY5gryz3nQ+pq7Ts/Qwzja/PZpIUQgN71iCROIk+KrrdShXm9prOE1DaJF9uzzX2H8vwGDzXoGU4oZV2G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722379046; c=relaxed/simple;
	bh=B7FIIK/+fcUDCLt8/GGC2syVheAgXlAvyD5fUe7vTjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsqOlpNP14po+c7nTwhoAZ5qTRlt31zJGA3UyVGyV41g/RReA0zxrPEuKW4uM8YI/DaCBCmVuEyDobs7ptzrPQqsAPLlTkEWXWLy8Wfub1mbQA6hlm309OplRQtDsQozKTxIc93bLJRVj8/TCiFyV1DosqTdI1a8CX9kvuM3E5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bV/Dlg5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bV/Dlg5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E3AC4AF0E;
	Tue, 30 Jul 2024 22:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722379045;
	bh=B7FIIK/+fcUDCLt8/GGC2syVheAgXlAvyD5fUe7vTjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bV/Dlg5W9JPOaGGYqRQ8UXo9qkXrZrJyjDQNoBybvzjy6BIsKpZ2MdSp1sG0iBB0s
	 e4/5LOOvRRfatdVonTWrfRWLuCiRWJiaxziFrX/0tAs2Kjtoq0lF5PNzVW3snxd2yy
	 NiwPlo1MkZr/wRY2L1Uq0VNyezx0EuTrzcwysRq65VMfQdAVO+fG1zBgvSBxKrst1M
	 J2/KKgt1mfn0lvDgX3Y/Fh2QZgRP67q8Qa4s2hyG8FOmPtouPksB4RaW1aZZaBcdwq
	 101XXZn4cWsjPEoo9Cq/QFV7XpILScLrWxoWlkOaIp62MhCQLIkEivAHDnNh28vpkf
	 PnH/IXQe4VBqw==
Date: Tue, 30 Jul 2024 15:37:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs_spaceman: edit filesystem properties
Message-ID: <20240730223725.GL6352@frogsfrogsfrogs>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940600.1543753.11770032596501355577.stgit@frogsfrogsfrogs>
 <ZqleFeJhCVee5ttL@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqleFeJhCVee5ttL@infradead.org>

On Tue, Jul 30, 2024 at 02:41:41PM -0700, Christoph Hellwig wrote:
> Is this really a xfs_spaceman thingy?  The code itself looks fine,
> but the association with space management is kinda weird.

I dunno.  It could just as easily go into xfs_io I suppose; the tiny
advantage of putting it in spaceman is that spaceman grabs the
fsgeometry structure on file open so we don't have to do that again.

--D
