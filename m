Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795637928;
	b=QUZdvnGiFv2iISZ8XXc67njWreGQ50wj4Cy14Kugk1A3ITxzvSUNcAbWzzYF3yhSzttC
	 2DYY+LU2I5qz8kTeiotFQddfrEAt5Vqk/51NII88S5vzAAy/UbHlAv80BP9DwONzJ+4Bq
	 Oi1cBmoObxAoWFe0fkLYyk2WWT06bsWOoqqgRzUEmNriBone9FGLWj+uUA+O6DArQA9S6
	 xIc7FrkO4w/2aGgMwYBY1sCGvflEp5rPuIxt+SKYrHK3h+XR90alPPgNcLVaios5EYwKf
	 izajDqogrH3QKc+HTMn6255l5OEGmbV40zFadUFGAEYY/Iily4FN+A5ezOCSUASn3lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795637928;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+s1CzQIp+ra31lVXhRrG+VAc19W8BFw9ZtWwSGoEvfM=;
	b=4Qjqe1q3/bkOrTHqO0/sGJdkAHe+sDuIVMRYRlqbrbaRamNhI7iqo0M27Bocd9zc752j
	 MH7bt8wpUcCKwbC/jQ4Fd8H8XdKf8dQdQk0TaTx+N5gtxidc/O66LdeJCIu3uDnHm4DUj
	 LhXDdr3Pn2nb1te72w9HpFzPHNhvGHP8JJFYnZqNRqjwz6h6eFmzkT3RDJBM6R2yAtW97
	 YASSmsyTt4vARHtg+D0pJR3NgjeTIszNkNM1eAyGJT/TA9cPimsu6z0JYzTRj4FWQ97oR
	 wTzgP79eJ+pVEeIoNFa4H1Pf0Aig46eKqoNBaoiDi3v4MBW9jAjXxgZEtoQjRirhgEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lhfuaryK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5918F606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 20:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lhfuaryK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1310B1F000C4;
	Wed, 25 Nov 2026 20:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795637928;
	bh=+s1CzQIp+ra31lVXhRrG+VAc19W8BFw9ZtWwSGoEvfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lhfuaryK3CnLPTDQTmUqyZ7M9Vq7fWH9braly3d4uaNMTNpWotZeYeH6S57UjAr4S
	 kW7X6DLdA0eDsu01Izcfnrr5e657928mdtA0IMwhzu+YOJG4jhGaY3E7P0BDIN9g3U
	 I/v0ouuvxdHjzmzEYGAlZSt4kzTckW7ogrUPWyNtNmShUNDnfsZXhM7J6shoUkw6Rn
	 wPiAgLpszvLbwhxrStkjqINUUOFZwbZ9wZDW/QjiRw9GImhRa2aFugi7r1jX96Vhs0
	 1iasaSdGSVxMekaM7ZG82TRIYpAxSP+++Ijnzci/HnZPKs4r2Tb8QIDWNARnyFsg0L
	 hIrC5ZmxbHV9g==
Date: Thu, 26 Nov 2026 07:18:39 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: handle ophdr formatting entirely in xlog_write
Message-ID: <awdCn4ByxYZSWE9E@dread>
References: <20261125144430.728485-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125144430.728485-1-hch@lst.de>

On Wed, Nov 25, 2026 at 03:42:21PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> for historic reasons, generating of the log ophdrs is split over the log
> item formatting and the core log write in somewhat awkward ways.  This
> less to subtle extra code, extra (small) memory usage for keeping the
> headers in memory when they are not needed.  This series refactors
> the log vec formatting a bit and the xlog_write code a lot so that the
> ophdrs are formatted when writing to the iclog, and the no memory
> for the ophdrs is allocated for logvecs in the CIL.

I don't have the capacity to review this any time soon.

Given all the issues we're still finding and having to fix from LLM
analysis, I'm not a great fan of doing open-heart surgery to the
core journal write path right now. This is not simple code, and
without proper on-disk journal format verification, we've never
really had a way of rigourously testing journal write path reworks.

These sorts of changes have always been a bit of a 'merge and hope'
process because 'test it with log stress' via fstests doesn't
actually verify that what has been written to the journal has been
recovered correctly. It just tests that recovery completes with
error, and the lack of errors used to imply 'the code is good'.

I don't think that's good enough anymore. In this new world of
journal fuzzing and LLM bug finding, we really need much
more rigourous verification of what gets written to the journal
before we start making fundamental changes to the way we track and
write formatted log items into the journal. That way the log stress
tests we currently have will formally verify that the contents
of the journal being recovered are valid, and that we haven't
introduced some subtle weird bug that will bite us in the future.

So, can we hold off making runtime infrastructure changes to the
journal write path until after we land the recovery time on-disk
journal format verification?

-Dave.
-- 
Dave Chinner
dgc@kernel.org
