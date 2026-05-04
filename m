Received: from smtp-in-1.gedalya.net (mail.gedalya.net [170.39.119.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F4F3E3159
	for <linux-xfs@vger.kernel.org>; Mon,  4 May 2026 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.39.119.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777914554; cv=none; b=d5MWwEdV467BXfcobXjMy6+gNLfVQyevMQhhSu0lO9zA8wvwB9PR5h40TuCYgptlsQ4RfGod/RPML9wkWoyZrI5/45R8MdaJOqpDQSf2g+eBYapRtcMnlhpR9F45GgY3hHOfttQbKxukxCf2d7O9wgmmrHgtuo4ctSeupjKCg1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777914554; c=relaxed/simple;
	bh=vHDw9FXiUk0xvaK5eM0IXQnAerv5kNcy1QKQCj9yTL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=rz55TkqUYID7AGOXcvqOU8mpmTWdXCkiZvcmiyaFnqbH5ihGxzKEhqkhUhv+IAyANfMYLazwnPMIbb2E1TkVyl7wp7sMDwt8YIKBpCs7yrdk/btPKlSqwdFFSrLby+Z7mMLVR6pE08lfztuhxmmYADqy1JTgIVeoT1dXkQ/K8LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gedalya.net; spf=pass smtp.mailfrom=gedalya.net; dkim=pass (2048-bit key) header.d=gedalya.net header.i=@gedalya.net header.b=an83VC3r; arc=none smtp.client-ip=170.39.119.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gedalya.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gedalya.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gedalya.net header.i=@gedalya.net header.b="an83VC3r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gedalya.net
	; s=rsa1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Cc:From:
	References:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
	:Content-Description; bh=ciMUWPB71QHLVeZ0kA2lHNkzDlzLi3gbAkk/cYZbOak=; b=an83
	VC3rQ1WA7rqYplpNm8LefzphD5UZGu61GP7umNSlL4+rGkMTREYML9F2HonzugDTV/31VtYvcWdyx
	0MErUWJ+voMSUthpbweRWuB5M6BHbL8Eq1SNOCKAt5d1VDsji3rS1uEGyWz2h6Sl9Hqmk96DURaKr
	6hVv66cE7x8MWHO96K+DnUjlzFGCW9KeIs3RWcGAVL04c+O25crRRuDeu/vRhYnbUWCqEozk7IihU
	UoMAwi/UXhxNxhuL/kvpE/37D4SgT3NQR1s3zRmTpTdxOtbw/w4Nbve6hcZzWaTmawiBh1nFuQ7iu
	MilK3AfUfQiSenuhWUzcshvJUuQkEw==;
Received: from [192.168.9.10]
	by smtp-in-1.gedalya.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <gedalya@gedalya.net>)
	id 1wJwn9-00000004N8s-1nq1;
	Mon, 04 May 2026 17:09:11 +0000
Message-ID: <cfaad083-9820-46da-94d1-28d597021d6e@gedalya.net>
Date: Tue, 5 May 2026 00:09:08 +0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xfs_scrub: UNICRASH_BIDI_MIXED
To: "Darrick J. Wong" <djwong@kernel.org>
References: <8961ee4a-3830-498b-a432-5545695db599@gedalya.net>
 <20260504164937.GG7751@frogsfrogsfrogs>
Content-Language: en-US
From: Gedalya <gedalya@gedalya.net>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260504164937.GG7751@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/4/26 11:49 PM, Darrick J. Wong wrote:
> # touch 'עברית.pdf'
> # xfs_scrub -dTvn /home/
> Phase 1: Find filesystem geometry.
> /home/: using 8 threads to scrub.
> Phase 2: Check internal metadata.
> Phase 3: Scan all inodes.
> Phase 5: Check directory tree.
> Info: inode 128 (0/128): Unicode name "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa.pdf" in directory mixes bidirectional characters.
> Phase 7: Check summary counters.
> 321.1MiB data used;  346 inodes used.
> 209.7MiB data found; 347 inodes found.
> 347 inodes counted; 345 inodes checked.
> Phase 8: Trim filesystem storage.
>
> Soooo... in byte order, the filename is:
>
> 	AYIN BET RESH YOD TAV FULLSTOP P D F
>
> and AFAICT (because I don't know Hebrew, sadly) that's supposed to
> display as:
>
> 	TAV YOD RESH BET AYIN FULLSTOP P D F
>
> correct?
Yes
> KDE's file picker renders that as tav-yod-resh-bet-ayin-fullstop-p-d-f.
>
> GNOME's does p-d-f-fullstop-tav-yod-resh-bet-ayin.
Ah well, I use XFCE
> The raw console just garbles the whole thing and renders nonsense, but I
> can't say I'm surprised by that.

Umm, xfce4-terminal (libvte-based) and bash running within handles all sorts of unicode filenames just fine, including Hebrew, Chinese and Arabic.

But yeah the linux console doesn't work. Never thought of trying.

> The motivation for all the bidirectional naming warnings is to flag
> names that abuse RTL sequences, such as:
>
> 	myfile<RTL OVERRIDE>txt.exe
>
> because some file pickers don't notice the override and render that as:
>
> 	myfileexe.txt
>
> which can mislead users into thinking they're opening a text file, when
> instead it launches a program!  A similar attack exists for source code:
> https://en.wikipedia.org/wiki/Trojan_Source
>
> That said, the sample filename you gave me contains five HEBREW LETTER
> ____ codepoints.  There's no override codepoint here, just the five
> letters with RTL bidirectional classification followed by four letters
> with LTR bidi classification.

As you have seen between Gnome and KDE, BIDI algorithms aren't implemented uniformly, sometimes not implemented at all.

I'm not a big unicode expert but as far as I know, ordinary text just contains the characters - letters, digits (LTR but not considered so by this test), latin letters, parentheses and brackets and so on, and the application is somehow supposed to make sense of it. How to display it, how to handle walking the cursor through it, or selecting through it.

Even when you have software that does the best handling, there's a bit of a learning curve for the user.

But as far as I know, control characters are not typically involved in ordinary text - neither manually nor automatically generated.

I typed this in the xfce's mousepad editor, and pasted here:

שמעתי ביצוע מדהים של השיר Let it be הידוע

it should display, in right to left order, 

שמעתי ביצוע מדהים של השיר

Let it be

הידוע

The BIDI flow works correctly in mousepad, not in Thunderbird (a very, verrrrrry old issue)

>> Perhaps it can be entirely removed. If not, then perhaps it should be
>> possible to disable it, or perhaps it can be disabled by default.
> According to UTR 36, the Unicode consortium says it's not good practice
> to mix bidi characters.  From section 2.5 ("Bidirectional text
> spoofing") of https://www.unicode.org/reports/tr36/tr36-15.html
>
> "Recommendations:
>
>   * Never allow bidi override characters.
>
>   * As much as possible, avoid mixing right-to-left and left-to-right
>     characters in a single name.
>
>   * When right-to-left characters are used, limit the usage of
>     left-to-right characters to well-known cases such as TLD names and
>     URL scheme names (such as http, ftp, mailto, and so on).
>
>   * Minimize the use of digits in host names and other components of
>     IRIs containing right-to-left characters.
>
>   * Keep IRIs containing bidi content simple to read.
>
>   * Use reverse-bidi (visual order -> storage order) to detect possible
>     bidi spoofs. That is, one can apply bidi, then reverse bidi: if the
>     result does not match the original storage order, then the visual
>     reading is ambiguous and the string can be rejected. This is,
>     however, subject to false positives, so this should probably be
>     presented to users for confirmation."
>
> It's the second bullet point that inspired me to add this warning.
> However, it's clear to me now that it's trivial for users to make names
> like this.
>
> Seeing as the confusing rendering attack relies on bidi override
> codepoints in a name and not just mixing codepoints with different bidi
> directions in a name, I think I'll take your suggestion and remove the
> "Unicode name \"...\" in XXX mixes bidirectional characters" warning.
>
> How does that sound?

So, yeah sounds great. I'm pretty sure that would allow pretty much all ordinary, non-malicious file names.

Thanks! Much appreciated,

Gedalya


