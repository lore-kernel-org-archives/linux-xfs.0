Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270FC28468E;
	Tue, 10 Mar 2026 05:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773120388; cv=none; b=kyAK7vKmAOXAZnNRC4k3m/mNHGd+Ufem6v1M228QGlH7cilEuKuioeXWeaQCh2S+0Fng2TFzw2BjPG24K3llnLytaphPZ21CD/C7dXG+MU9oxZlid/XsN+1PJFPtkt2c1wADGsS4Ecwtr74QtL9SrFnYApzY5hDcGRhrrEPUvPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773120388; c=relaxed/simple;
	bh=0bPFvI+bvGqSsi7hw1Np85uO1UMoCJKmLayZ/eoxw0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GvKcS8SkaLgynwCbx6TYWgGt7sx1eShXLxF8M0GEsaNqAh3wXcnyooRbx01hcERb6zT8Lq51sEpq32hh5uRjWrbALlhWZJSBUJkHWYvUqr5p2ktkVU8U6vzaATnY0EW4VldLjUN382hKxwBlQJcBMjguN9BE8ZVuNgANwj3yAjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0HF644F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0HF644F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674F9C19423;
	Tue, 10 Mar 2026 05:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773120387;
	bh=0bPFvI+bvGqSsi7hw1Np85uO1UMoCJKmLayZ/eoxw0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c0HF644FSgEiuD3vEV/JKFqxJZ546qUhn8sCkA9KOSQXPyqnpvv1R5T4l8hmZLk1k
	 qkO3ZQdrDoD5FnQVFcb7EXTJNIlWl52eIPxczNsJzFQ1w3jJZAJKwVb49Yb1ww8IZX
	 Ce/TF5LTSry3U7FYJskVhNrGoRKzn2gJMD/eryOG9MNMCAS2Kv1+wUO9t3S0CbI7Tr
	 Y6tMd/cWZZTamXDtnrPb5Drc1B+1anj0evaj4WJ5cNRUylKl3lCKq7vuSgdOpBm11e
	 v0Oyo7VUwG7G+h5F7j/86GG6ef9q6CmH5pi/6HsJOwST5nqt0NHHI3noG6W8KWJmJD
	 rA2A+33BJoW+Q==
Date: Tue, 10 Mar 2026 16:26:22 +1100
From: Dave Chinner <dgc@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/4] xfs: refactor xfsaild_push loop into helper
Message-ID: <aa-rfqemHJuWG8VL@dread>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
 <20260308182804.33127-8-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308182804.33127-8-ytohnuki@amazon.com>

On Sun, Mar 08, 2026 at 06:28:07PM +0000, Yuto Ohnuki wrote:
> Factor the loop body of xfsaild_push() into a separate
> xfsaild_process_logitem() helper to improve readability.
> 
> This is a pure code movement with no functional change. The
> subsequent patch to fix a use-after-free in the AIL push path
> depends on this refactoring.
> 
> Cc: <stable@vger.kernel.org> # v5.9
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
dgc@kernel.org
