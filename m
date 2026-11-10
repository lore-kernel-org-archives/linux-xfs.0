Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794328393;
	b=Bug+OVMKJTqaSr4Ek45ZvXBB2C443Yezmv0XWxiHeh2fipPZjRWAND7AWfzdgU7yr9bR
	 tTvTpAOXpmISoyMXSv93sBrKZYmzwkEIF5Gn+uKUWM7f0GGVEfvs5JNAoTMdIlK92WiPh
	 ox0n7n9RNdMp59rnRskchDTlAKmw1NgGL7jVqcV6Gf2HonvyE7O4XU62IjLwkDg1dJX1N
	 cjK4TEg7uuYsR+B2MRzlBPoGgV+pj54JDrREMxdDSmVly5Y/UnJutQPNl6xhnrHba730k
	 IaEoo7JbRkp5q2lxf7/MNgu3fG6A8jm9bsCOjqeUukVuohXV7pywDfnHndk9ntb02pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794328393;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=AJ5izWwEcghLnwFB0rq0l2TOCwIQeTAsERFK0CERwEc=;
	b=Ji1MjPzL1+nFDxxjmwnxhxIqjxjTcuFJ/VpbTwa6aoSZfbz3a6SHQM6RfPmlS0Vti3xb
	 eKe3cVzpswW1XtGEWwIPDpDEiHzlJO0XfTGQ3kjqolNKPP4DWoOxNPfI85lNMIb/b9dAI
	 8Q2Tq1Uv5a3t320YGkKb4GsDba3keRRoLWQOw5yQp9kkl0AtEpL3+E0rn3z8V3GfdBeeo
	 hj2B9jLxLlV7bO6pjUv6pl/5cZiqvPqrkWIg9tQibhbiiHmjcrhIiqgJRw3Kb6WBUtg7z
	 ilTH3HbqGzd/TLqTB9KmNGSaYtDetvhu9a+t95jjJyypFj0mWY1N2GANRZEZWpd7NRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QCU1XqxN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B41606A228;
	Tue, 10 Nov 2026 16:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QCU1XqxN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC451F008A2;
	Tue, 10 Nov 2026 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794328392;
	bh=AJ5izWwEcghLnwFB0rq0l2TOCwIQeTAsERFK0CERwEc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=QCU1XqxNnBDD+4G8vgc9C84PODlEPcvy40zY0Je3WRyjHXluW/GTCX7wgVc00A2NC
	 EX10ISVu1XvkCA7BhB9SXiDjq8+0znFmISFrbTFxuBdHjnGBIsG5i4BY7+anZ8hf+C
	 NWNBcEK7Qtx8sgBorBv4sANf9bHkVvBybAoJtqq1cpORpPpnWPxb3ImPekWO5RDNJH
	 WZyIyBK959e7pV9JyVigJxQs+UyNR23X+Fi1P4YGj1K7f7fTSeuQrYUPEpm/FGVZAg
	 SU4PnJJpXiRpi5/LwgXZ4YF6+IrajUvyz7buJdj5Di9/RfC13+/kJPmdl7UyaZa6ad
	 11Y0NkAmjL+hA==
Received: from stl-compute-04.internal (stl-compute-04.internal [10.204.2.64])
	by mailfauth.stl.internal (Postfix) with ESMTP id C5915780043;
	Tue, 10 Nov 2026 11:33:11 -0500 (EST)
Received: from stl-imap-13 ([10.204.2.104])
  by stl-compute-04.internal (MEProxy); Tue, 10 Nov 2026 11:33:11 -0500
X-ME-Sender: <xms:R0fzatIo4SKoLqCBVRS65Y4l8ROu234W9Gnkr8WB-fH2Cgiic049Wg>
    <xme:R0fzaj_hsb0uSaCA8oJVXsa5cmkpvLoa6xZ9_EIz9hpacjTwAxTyKR4vYYti9oWcd
    02Re9cdPddxi4hpw0oSEZPizGF4YQIIbDlmijk6BtGQYG7SwcTR1sY6>
X-ME-Proxy-Cause: dmFkZTEiOEjn35+erx13C0qM6OnUluF3rZwvBY/fe9xOpotiIOC41DGTOibGmFH26g0mmR
    gHclO16+bwtDmvs/1P5rckqhtRBAQzdqxku7aZa8ATmM1mhuw/J+7Ebn5fb/o4/trApXVm
    zhS43RXXXApTUiCC9ayIVCBv3f9j6Qk3VZngSrR2qQQwxQEo4ekEjkT2EO5uIkhbxO/XA9
    p6y9HNUKd+cuYa3bDoPiSFLrEocCbP1x0830SoxqIwX+HddIZAsIxcUyOQEbVB0TWxA7mz
    ahan1HEpjm8X43czwgwY9PQUx46Szctb8WW9AWtgWuy7s58m7tXLhaVoTKKuaGnPFBq5mM
    Cn/RPackoz45B7jsHFTpMYcgqZXd0CWlNLM3/6g18UyP6DUp7ZklNl0tAJtPG6PCaq2nLv
    555AzKEflGlV1vIpNkda/orjzmGs+uwdG7uGLohmLvK4xhJ3tjSbprP+o2xIDoLLOKfIZd
    eC9UWsehcRLNh2KhR3mse9+U0Yb0bn/ul2PUrmvED36OnvJX0z/F4LVsnVIYA7iZkwbqjq
    y/Tve6bgzG9XGgSbpzAHr6kxt6HkoSl/cpEKjKnRQRuqTIq3chd3hwER3faIjG7eyrY5iN
    xKwhQx2yuKXWltpOeOEkRwctT9p8u7Ko6tPYiyswsXvbtoA26+HV3YHexH8Q
X-ME-Proxy: <xmx:R0fzasaIv3xdB49GWosqaHKnAz_VSf5rUPHZikL_zNAnuLsxBPYMzw>
    <xmx:R0fzan3WmA6KhdFQjN85TNg70e1cAS--nfOrLTxHvz20sVahoD_8fw>
    <xmx:R0fzanqdCnKKPISHMge0lWnAxPSvCCg7pgAC2q8WGTwlxcJUex_PsQ>
    <xmx:R0fzauOPRIhPmoW23COVL7HYUvWv6eYUmGcIVJ1q1yFBIv4CfJ6Vaw>
    <xmx:R0fzaopuYZG3dJSlTOueMgn8TLU1wmhoc6Mgc3MTOm8zNjlvw7dynA1F>
Feedback-ID: iccae4b50:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id 69C62F60082; Tue, 10 Nov 2026 11:33:11 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AeoJN5SNNGX3
Date: Tue, 10 Nov 2026 11:32:51 -0500
From: "Chris Mason" <mason@kernel.org>
To: "Carlos Maiolino" <cem@kernel.org>
Cc: "Theodore Tso" <tytso@mit.edu>, "Dave Chinner" <david@fromorbit.com>,
 "Jan Kara" <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>,
 "Josef Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <5bf88df7-a231-4013-9127-156b58241094@app.fastmail.com>
In-Reply-To: <avNEiPY9D2ItmEMu@nidhogg.toxiclabs.cc>
References: <20261109235111.14129-1-mason@kernel.org>
 <avLnU46F6YZckcbo@nidhogg.toxiclabs.cc>
 <d17350c0-0b93-4421-8bab-8266419fbd77@app.fastmail.com>
 <avNEiPY9D2ItmEMu@nidhogg.toxiclabs.cc>
Subject: Re: [PATCH v6 00/10] reflink and atomic write bugs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Nov 10, 2026, at 11:22 AM, Carlos Maiolino wrote:
> On Tue, Nov 10, 2026 at 10:56:34AM -0500, Chris Mason wrote:
>> On Tue, Nov 10, 2026, at 4:45 AM, Carlos Maiolino wrote:
>> > On Mon, Nov 09, 2026 at 06:51:11PM -0500, Chris Mason wrote:
>> >> Hi everyone,
>> >> 
>> >> This series did a few rounds privately, but looks ready for the list
>> >> now.  Except for Christoph's patch, these were all found and fixed
>> >> by an LLM.
>> >> 
>> >> The meat of the series is fixing reflink corner cases that incorrectly
>> >> let you write into the source of a reflink.  LLMs also tripped over a
>> >> few ways to use atomic writes to expose stale blocks on the drive, and a
>> >> few races with realtime flag manipulations.
>> >> 
>> >> Carlos and Christoph ran these through fstests (thanks guys).
>> >> 
>> >> Chris Mason (9):
>> >>   xfs: don't skip the flush before shifting extents
>> >>   xfs: flush the shifted range before changing the file
>> >>   xfs: don't change the block map under a dirty folio
>> >>   iomap: don't punch delalloc under a dirty EOF block
>> >>   fs: validate atomic writes after O_APPEND and limits
>> >>   xfs: recheck direct write alignment after write checks
>> >>   xfs: test for reflink after the dio write checks
>> >>   xfs: refuse fallocate racing with realtime flag changes
>> >>   xfs: restart faults racing with realtime flag changes
>> >> 
>> >> Christoph Hellwig (1):
>> >>   xfs: refuse writes to files racing with realtime inode flag changes
>> >
>> > Sashiko found a few issues that I believe are worth looking at. If there
>> > are no objections though, I'll pull in the first 4 patches which are the
>> > most critical ones so far until we figure out the other ones. If there
>> > are objections please let me know and I'll revert them back.
>> 
>> I'm generating fixes for the rest of sashiko's comments.  Looks like they
>> all existed before the series, but might as well fix them while we're here.
>> 
>> For sashiko's complaint about patch 6, the patch intentionally creates
>> the behavior sashiko mentioned.  We were inconsistently falling back
>> to buffered before so the behavior is new but the writes are correct.
>
> FWIW, I pushed the initial 4 patches to xfs-linux/xfs-7.4-fixes, of
> course I didn't push them yet to for-next as it depends on you if you
> are ok with me pulling them first before you deal with Sashiko failures.

Thanks, taking the first 4 for now works for me.  I'll keep them unchanged
in the next version just so things keep applying, but will assume they are
all set.

-chris
