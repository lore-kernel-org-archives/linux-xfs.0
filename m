Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793046856;
	b=dHyUaFjmGm4XxucMpf9gYTq+zP1xsuwwHtmOkOZNv87Q54jO7kdSES1ip1CoL0a/E4/D
	 OEJyq/SoCDIcCWmZxz33lpcRjfywGdbz12TyZWuXbET/DDeQe/B2pODQqhSti4ecgrywf
	 M+5fS92BJkPGLIeojTI+mCkMY6KtCQLCrwsIIfsWKEUIJT922kgoaOe+Y2hMcDaoK8wfW
	 dGRNozZdnyCLEZe4IykJl10psc4+vXYguPIwexO8oC43xHT3+h+i4098m/xmR9PqziUH5
	 7dtxzHXhkYoPmK/zhDEWoVh+r5DR+C90yKRhiQdrNmXF8reejDwJAYvo0hhpU0QXrRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793046856;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ybmHfZJ4xoYj4IN8SIK+cABBhm70WhyzSBcAsHeLSco=;
	b=A2zPjfm106dvNNq/T3optplYKOL3h5wz5XkK6+2oF7ylQaryU/gv54gYMqigoYXxXdV/
	 FoWu+3ORyAPoKrF42VZj54R9lMDmEuLbaxbnTmYaiO4Eidk8wkqcZba8Kt/wiqhaNImuc
	 Js98eUIgq3Ur5ng0jjSSNnpKO+NUkvH0PMgMloWaQ9AKn3oz2YWxUTVWXEKVk1Ap7Uf9i
	 yucDeAQa7RjC2jC/P5UJL1UAdB/hzagHAE7WawdfVUlWGGSr6chfXgNfLRPklB4YJ1WFu
	 Hlj7NeBxMPPx0WWyuVsnBJahCpKfl7rdFaWAnANIIiZfBWx9xC3EhRhZTsaDqH1//4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b37OneXa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D565606A31A;
	Mon, 26 Oct 2026 20:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b37OneXa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F300E1F01825;
	Mon, 26 Oct 2026 20:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793046856;
	bh=ybmHfZJ4xoYj4IN8SIK+cABBhm70WhyzSBcAsHeLSco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b37OneXakjjRT73u3jnJ0R88hFTlC5SHC0DdTYoAjuhiEsELkbcXq1aXgDlrX09CI
	 xZAqndbcxit50XYw/PW2/whVy4zYEqc98QgieG9KDzERwmBjfj/BvZ/TwDAqUC0r4H
	 XW8DxaW03RUUfvVUCAmi1pGIsEkRCF/xkZY/8SI8LWca9fLd7I0gvDz6WpHX88rzN3
	 keNTlHffuuO54He20U7BxmpDZO7lUB4lEKsWIk42B5BOIJ9Dt1YpalALHLMlYWdj/S
	 U+bQk2nUASI2p3NWLfpK+FepUKOLPZaEW3K92Uvch0JSrEJhEhE4SCDYlIhZH05duJ
	 PKycefYVDoZnw==
Date: Tue, 27 Oct 2026 07:34:07 +1100
From: Dave Chinner <dgc@kernel.org>
To: Ivan <ivan.vin.ctf@gmail.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, yangguikun@tju.edu.cn,
	syzkaller@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: task hung in xlog_grant_head_check - still reproducible on
 7.2-rc7 (2018 report went dormant) - and on 5.15.216-stable, with a
 cascading inodegc victim profile
Message-ID: <at-5P0zTrQY0jcbh@dread>
References: <CA+hZKYK7M9EB2HmVTQtccuztYeSSrygnN_20g07e7C+mQPRMnA@mail.gmail.com>
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
In-Reply-To: <CA+hZKYK7M9EB2HmVTQtccuztYeSSrygnN_20g07e7C+mQPRMnA@mail.gmail.com>

On Mon, Oct 26, 2026 at 11:19:38AM -0700, Ivan wrote:
> Hi,
> 
> Picking up Yang Guikun's August report [1] with independent evidence from
> our fuzzing fleet -- we agree with the analysis and would like to help get
> this unstuck, because the history of this bug now looks like the pre-history
> of CVE-2026-109618 (PHP2Shell): a known issue sitting on hard trade-offs
> until it becomes an emergency.
> 
> INDEPENDENT CONFIRMATION (5.15.216, KASAN, syzkaller):
> 
> Our focused XFS campaign reproduces the same hang with a different image
> generation and an extra victim profile:
> 
>   1. syz_mount_image$xfs -- crafted V4 image (small log)

"Doctor, it hurts when I punch myself in the face!"

> Same root cause as described in [1]: a transaction reservation larger than
> the usable log size can never be granted, so xlog_grant_head_wait() is an
> unbounded wait -- no amount of log tail pushing can satisfy it.

The root cause is that the journal was intentionally corrupted to
make an empty journal appear full. The normal mechanisms to free
journal space for transaction reservations or return space after
recovery don't work because -there is nothing to free-. V5
filesystems detect this specific issues and error out; v4
filesystems only warn.

IOWs, this hang has nothing to do with transaction reservation or
log sizes, and everything to do with passing the filesystem a
carefully crafted image with corrupted index values that will never
actually happen in the real world....

> THE RECORD (why we are pushing now):
> 
> - syzbot's main tracker: first report 2018-05-21, open 3079 days,
>   1471 crashes, 0 of 29 patches merged, last crash within the last day.
> - Sister trackers all open with C repros: linux-4.14 (2450 days),
>   linux-4.19 (1412 days), linux-5.15 (1311 days), linux-6.1 (1302 days,
>   394 crashes), linux-6.6 (Dec 2025, corrupt-fs images).
> - August's report included a concrete, low-risk fix direction (sanity-check
>   the reservation against usable log size -> clean -ENOSPC instead of an
>   unkillable hang). Neighbor fixes over the years (integer overflow in
>   xlog_grant_head_check, the nowait case, ioend log exhaustion) never
> closed the unbounded-wait itself.
> 
> WHAT WE ARE ASKING FOR:
> 
> 1. Either accept a reservation-size sanity check (we are happy to test
>    patches against our fleet and provide before/after traces), or
> 2. record an explicit decision (even "won't fix, requires crafted image")
>    so that the dormancy becomes a documented choice rather than silence.

Deeds speak louder than words. If you want it fixed, fix it and
propose the fix for inclusion.

As I said in 2018 about this specific v4 fuzzer "issue":

| And this comes back to my repeated comments about fuzzers needing
| to fuzz properly made V5 filesystems as we catch and error out on
| things like this. Fuzzing random collections of v4 filesystem
| fragments will continue to trip over problems we've avoided with v5
| filesystems, and this is further evidence to point to that.
| 
| I'd suggest that at this point, syzbot XFS reports should be
| redirected to /dev/null. It's not worth our time to triage
| unreviewed bot generated bug reports until the syzbot developers
| start listening and acting on what we have been telling them
| about fuzzing filesystems and reproducing bugs that are meaningful
| and useful to us.

It should be pretty obvious that in 2018 we weren't fixing this sort
of stuff in v4 filesystems because the default v5 format catches
them and errors out correctly.

Now it's 2026, v4 format is officially deprecated, we don't build v4
support by default, and V4 support is officially going to be removed
in 2030. We're not going to fix this.

> We would rather spend our cycles testing your patch than re-reporting this
> for the 30th time in 2028.

I welcome your 2028 report. You'll get the same answer.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
