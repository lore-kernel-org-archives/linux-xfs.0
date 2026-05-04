Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19753232395
	for <linux-xfs@vger.kernel.org>; Mon,  4 May 2026 16:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777913378; cv=none; b=HZS5XxSODuEK2/6qetC4+Pld4zWZH9TI4SiC4Fx2FPeo/7Q8y7NdPNHcH+I8VCC9cuj7TesC2AuijQejPO77hU0jwvQyPqUDCwC9JeA0U1bW+B+tCwQ7LwUFYMaQlPT+7UuSF/NuIx3K3WRxZpQGLF0tqVEjL8nO/mddi94zk/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777913378; c=relaxed/simple;
	bh=wbiGoo5upyicFj7FHYcPSFIZVQUwB6TLcF4lOH8DqOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ppUejjaBjBF4R1sttsVNjI+rv+VZATTVPVyJnRmfol0Pgu8C/R42ujdS8XbpihXTiGwEJR8VIj5SmKOoLjh/v0d1sR6Vv1bYzlSvVhBDLRv3q/VVxAHz+c5tIbgd9DcuIehjm2HCg61m473B2FqMLsgSdX+1ORGK56e1RWLE2p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e33YTY6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e33YTY6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76A9C2BCB8;
	Mon,  4 May 2026 16:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777913377;
	bh=wbiGoo5upyicFj7FHYcPSFIZVQUwB6TLcF4lOH8DqOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e33YTY6r39Bs8wUQkrhY/J3zoCJAEGStG4ky+1EXsV2fcJuf92lLwKDQAOtaJ2qIa
	 F2f0Cg4aUBlgPqhkVT6mwNwkTFuAv7MTn+LMTdXnJUIvhBLJBmjHIwQI6XxB/apjYD
	 9oX01be/Xsw+EKZujIbSwOESQHkeiPF+SYj+V82if554FzKwR7yKiPOiGPm73r4gjs
	 ipuAwsDYKBs9nRwybfB6wHCC7Wc/Zid0vdcaqvPTzTQ+vAoKySAC6n7n0dvFz2ZIax
	 atd1smDYTUfcvv3/Ob1tY0E1a4VhB3r1mRTguR0jNciTKIJgJaSgjHEByWqtG2bQBR
	 E2yBUfno/oZqw==
Date: Mon, 4 May 2026 09:49:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Gedalya <gedalya@gedalya.net>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfs_scrub: UNICRASH_BIDI_MIXED
Message-ID: <20260504164937.GG7751@frogsfrogsfrogs>
References: <8961ee4a-3830-498b-a432-5545695db599@gedalya.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8961ee4a-3830-498b-a432-5545695db599@gedalya.net>

On Mon, May 04, 2026 at 05:52:09PM +0700, Gedalya wrote:
> Hi,
> 
> xfs_scrub looks for file names mixing right-to-left and left-to-right
> characters. However, it is rather unrealistic for a file name to
> contain only right-to-left characters.
> 
> First, well-known file name extensions are not internationalized.
> While the file name can be in non-latin letters, the extension will be
> in latin. Hence you would expect to see file names such as עברית.pdf .

Yes, that's a reasonable usecase.  Clearly I hadn't thought deeply
enough when proposing this filter...

# touch 'עברית.pdf'
# xfs_scrub -dTvn /home/
Phase 1: Find filesystem geometry.
/home/: using 8 threads to scrub.
Phase 2: Check internal metadata.
Phase 3: Scan all inodes.
Phase 5: Check directory tree.
Info: inode 128 (0/128): Unicode name "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa.pdf" in directory mixes bidirectional characters.
Phase 7: Check summary counters.
321.1MiB data used;  346 inodes used.
209.7MiB data found; 347 inodes found.
347 inodes counted; 345 inodes checked.
Phase 8: Trim filesystem storage.

Soooo... in byte order, the filename is:

	AYIN BET RESH YOD TAV FULLSTOP P D F

and AFAICT (because I don't know Hebrew, sadly) that's supposed to
display as:

	TAV YOD RESH BET AYIN FULLSTOP P D F

correct?

KDE's file picker renders that as tav-yod-resh-bet-ayin-fullstop-p-d-f.

GNOME's does p-d-f-fullstop-tav-yod-resh-bet-ayin.

The raw console just garbles the whole thing and renders nonsense, but I
can't say I'm surprised by that.

> Even if we consider file names without an extension, or if we exclude
> the extension from the test, a file name can be, for example, a title
> of an article, as when you save a web page as a PDF file. In non-latin
> texts, titles, or sentences in general, often contain words in latin
> script. Technical or scientific terms, or names of published works,
> and many other things are often written in their original latin
> script. Whether the file name was suggested by software or manually
> written, it would often contain an RTL/LTR mix. This is entirely
> normal and not problematic in any way. To a user of an RTL language, a
> requirement to avoid any LTR characters seems utterly bizarre.
> 
> I don't know what the original motivation for this test was.

The motivation for all the bidirectional naming warnings is to flag
names that abuse RTL sequences, such as:

	myfile<RTL OVERRIDE>txt.exe

because some file pickers don't notice the override and render that as:

	myfileexe.txt

which can mislead users into thinking they're opening a text file, when
instead it launches a program!  A similar attack exists for source code:
https://en.wikipedia.org/wiki/Trojan_Source

That said, the sample filename you gave me contains five HEBREW LETTER
____ codepoints.  There's no override codepoint here, just the five
letters with RTL bidirectional classification followed by four letters
with LTR bidi classification.

> Perhaps it can be entirely removed. If not, then perhaps it should be
> possible to disable it, or perhaps it can be disabled by default.

According to UTR 36, the Unicode consortium says it's not good practice
to mix bidi characters.  From section 2.5 ("Bidirectional text
spoofing") of https://www.unicode.org/reports/tr36/tr36-15.html

"Recommendations:

  * Never allow bidi override characters.

  * As much as possible, avoid mixing right-to-left and left-to-right
    characters in a single name.

  * When right-to-left characters are used, limit the usage of
    left-to-right characters to well-known cases such as TLD names and
    URL scheme names (such as http, ftp, mailto, and so on).

  * Minimize the use of digits in host names and other components of
    IRIs containing right-to-left characters.

  * Keep IRIs containing bidi content simple to read.

  * Use reverse-bidi (visual order -> storage order) to detect possible
    bidi spoofs. That is, one can apply bidi, then reverse bidi: if the
    result does not match the original storage order, then the visual
    reading is ambiguous and the string can be rejected. This is,
    however, subject to false positives, so this should probably be
    presented to users for confirmation."

It's the second bullet point that inspired me to add this warning.
However, it's clear to me now that it's trivial for users to make names
like this.

Seeing as the confusing rendering attack relies on bidi override
codepoints in a name and not just mixing codepoints with different bidi
directions in a name, I think I'll take your suggestion and remove the
"Unicode name \"...\" in XXX mixes bidirectional characters" warning.

How does that sound?

--D

> As it stands, a systemd timer is shipped which runs the scrub
> periodically which should exit cleanly. But I have it reporting
> useless warnings, and sending an email about that.
> 
> Thanks for your consideration.
> 
> Gedalya
> 
> 
> 
