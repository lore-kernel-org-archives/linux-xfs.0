Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34138370D7C;
	Thu, 24 Sep 2026 11:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249814; cv=none; b=WlOi1O/3YdCJmnsO15Iu348dcKzZa6YZ+iYeNBQdNrsqCGI4cN+vSmECyZsyMj+2vlga5iVv4qGhjSr5XXZiZaT3e3rbLziBX5YYbeJdWYKdY5jBk5IqTuXK4CgQAxKOqOe8ajq/lmXpqevJ2AW86ldkTxlyTIweGKR6UvnhCH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249814; c=relaxed/simple;
	bh=Aaxcjc0xFQV860Ea8OyRF7Lkc2RXrkkU2q9HOfpGIQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCD1IYaIDTgKkFE2mPv+UF6Ym5gbB2Dyvi0HBZuOJo5UA/OWkS81hY1F02tTlgggJ7rrsOErUpP80THdUa/sqZqi5Jf2YaP4J5On+iFaBDZBfbfm3HLf418Ru+No31sV0rGey/f+SMnkdTS1QlEseGVbKbCMqZ3+Pw3akMkL89Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MB/ZGJi2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MB/ZGJi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565731F000FF;
	Thu, 24 Sep 2026 11:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790249808;
	bh=Ob6SZGs22MaiArlkXsl87eym/XxNN25bTFL7Cvn+YAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MB/ZGJi2cUdLjmXmGzEUiGfStT6AosNRqc6HdIsBBC/sY8NSpzx28tNxb5mJl5e94
	 s9ocHkKrjFOEsOriRBCFtxcwPc2HGKqd2JPug0YjEfYdA0g9Edj65y612Iit4+x7Gz
	 h+Kar7JH64cY82+9zqumXSOMsuwxMfD1ENcDrzIt1BYBQd8wPa5Hcf9p3k6PK2a3F6
	 jiWLSRlY2UhlQl9kOeUxQ+eWaE3GGBCDhnC+6fI4kN0LIc7G/j7Bz5prkeO3y5uCg0
	 KgirNc/nmyX1zSnw6oVIf+KeOCorWgVQ++6fwgE66MaFvApAIlNmgqb/ZZT1A6s1bU
	 ySEFYtToVNyJQ==
Date: Thu, 24 Sep 2026 13:36:45 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>, 
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/{349,350,351}: fix scsi_debug parameter quoting
 issues
Message-ID: <arUIImXClDcDKN7g@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260924060315.GF6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924060315.GF6253@frogsfrogsfrogs>

On 2026-09-23 23:03:15, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Commit a90ba59dca447d reworked the argument handling code inside
> _get_scsi_debug_dev to put all the remaining arguments (after we extract
> the first four arguments) inside an array that gets passed to modprobe:
> 
> 	opts+=("$@")
> 
> This code takes every command line argument and copies them into the
> array verbatim.  Contrast this to what it did before (excerpted):
> 
> 	opts="...dev_size_mb=$size $@"
> 	echo "scsi_debug options $opts" >> $seqres.full
> 	modprobe scsi_debug $opts
> 
> The old code put all the arguments into a string, then passed the string
> unquoted to modprobe, which means that any spaces in the parameters
> given to _get_scsi_debug_dev become argument separators in the modprobe
> call.  Put more simply, passing "foo=1 bar=1" to _get_scsi_debug_dev
> results in "foo=1" "bar=1" being passed to modprobe.
> 
> Now we no longer do that, which causes these three tests to fail with:
> 
> 	scsi_debug: `1 lbpws10=1' invalid for parameter `lbpws'
> 
> because we're effectively passing lbpws="1 lbpws10=1" to scsi_debug.
> Fix this by removing the quoting from the three tests.
> 
> Cc: <fstests@vger.kernel.org> # v2026.09.22
> Fixes: a90ba59dca447d ("common/scsi_debug: don't slow down I/O")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
