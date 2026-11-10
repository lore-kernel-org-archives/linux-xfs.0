Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794326216;
	b=MOYpTTFkpLhD4YXAq7QP+c1g8U8NnXNe1SGYtzi7jG5FOeU3O+xK+Oh2kVb1dyfxtO6x
	 fz5iktH3pxsbTy/mvhgst8IeMj4/FEH+JvrQ33nsvlP6WzfZy3usY/B3nKXnj/07H7MeO
	 8MMhdxljV4MEv9USe6wKbmDr2F+LQaMZaqJgcst/Ub9eF6HYF81ZkQmQfEXvf1+ysqJLM
	 M7yy8sapJLtS3zk7okLW2ENoixLMa/+aw9HRMcFO2Ge6Bqx6SPR1CEayHCDWxJaUtOoKQ
	 A2Qn0a/ft0N/4qBwoVFaUd8qYsFgeGJSrsxhYF42NIxqpm9yikBIEi74PIopqiOl30Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794326216;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=uB4ZPyH8M47BB2pjBnyq0eBTb6+6n95ofT9carxU2oM=;
	b=K7E9FixdcZx9W9t1UTJBvT4LbZ90cQ6h7OiyKkCojrK1UFH+ycq9yvMMIFDEf5WAXmPm
	 iKmbmkKrddf6a3rNORln1lF77C0gaiuRQiglpYPSf2PnBJeeJAYffpb0wJOUmiuSMv8gp
	 OTUlHPTcqzJZmVfnmPRra+fdGjsCZ3RetWinkan7kIJ0iS4vnTPbXi6p4yItbuMF0q5Nr
	 R8H4mR8vdOU92bDfEVbpmwxTrNegDOYTqaobdNO0q0Wo9qTNGUMwaw5817VrXafAmGFKM
	 BTDAusP7y415ekBn8vCpDiEJPInYXtMTmV6Ve/pESnK7atuH6Ys5VET8ivv6NPTSx5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QO+AKSpF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E6A606A31C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2026 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QO+AKSpF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD33E1F0089F;
	Tue, 10 Nov 2026 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326215;
	bh=uB4ZPyH8M47BB2pjBnyq0eBTb6+6n95ofT9carxU2oM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=QO+AKSpFpc8M4zhecbfk4xb/BtQci9niMOuP8m9V3sOvYLxnr/PAhoyFJJskcOOt6
	 E/wseaYOpZ8iyPK7HLULDk6L1S1bFjJ7tErXX8jxUoIFdJwxXIpOyqOA6Xpe7eKAEt
	 t77TQv+ahR86zLL9AZHmp9gCpW1+PDwAKntpH0oO19R4Ha+tTygIAr/V1ieZh2KboF
	 Xp/tNg5tdH7JP+LUcGfXuXGfcF5f8g2S8uXWnN31jjjmPUsXbAFrWWmWNrjW6q9zon
	 xtKhaaTgtl4tsUoSKevzttqgmteVPv1E8g3rfh4d3AQPJccNOd1cDlWrilSXQa+hHO
	 5XAU/DjI8YgkA==
Received: from stl-compute-04.internal (stl-compute-04.internal [10.204.2.64])
	by mailfauth.stl.internal (Postfix) with ESMTP id 21B28780069;
	Tue, 10 Nov 2026 10:56:55 -0500 (EST)
Received: from stl-imap-13 ([10.204.2.104])
  by stl-compute-04.internal (MEProxy); Tue, 10 Nov 2026 10:56:55 -0500
X-ME-Sender: <xms:xj7zat3QfB_Y710bP3gm9VjMVfNbaiNq9dv47v0iXVCl2NIYXQDfZA>
    <xme:xj7zau5PFpn9XES6-DX0xMjASLRsWvmM0ymryqOMcuSrWon_OX8TsI8IbVPsWKe21
    KwH6bzBQVCZXzdklhK62z9Atu4zyZny3hcSsS36QVzLgZ58RGjhqqBM>
X-ME-Proxy-Cause: dmFkZTGJlPHU5VrQTX9yI0unNWpcmkqD3gb748fD/19fCssP27bJWpwF71DvcxXtuQXrLt
    qtjpS5YAga486307JtiUigZkcTd4RHSJTuHfb5/RSgINNw7/nZod9SR1UW+sKNR06JFB0e
    tL1qoAV1/fHvZVZHuoLZG8SiOUsG1IeEc2hXJsS+DcWqZy2Tod5y/9lGgwvWGM+lRw3LSG
    PC8h4KwfAMvfyG0kM9aC+FfeQ7K95xeXjv7gVHCcPfeX1QQka6hnjHmINdm1eMhjAFysXo
    3Yun+IXws/sbRY5IXsg7GuB91bXsdUVKYRmq8SViiOuv7Qh2PVrrb4LjeP+qyKauRzX2Pi
    9/w0urGMGS5wo08Tzriqw0gTUk0GOJXFGJLfVCxCVBznpUrCWsdSSGWkwadyFrbMBFBbgZ
    6BKQ8nPF8CTecfAfI2Rn+LJ9WdZ+qYieOZEvfB7oNaYvvWMRRiHUbWlmutHhxm1wSMr4K0
    ACzu/oPILx4IxnSZmIydhMCZ1tvoUedBR9WbloU8iMHqNYJGbSPNPLAcVPQJZviFdZPi7c
    dm7+zziZDWhHqGGQLObOjeirRFWNVvjRiJ4/lLWJM+d1kHu6oFeNd19g793PfjgbTT/I3c
    HzINMh8sc2Tsh8ZEJpgU6NdlOQwA7GinFK++vSqjbNzMwlRDuIZ0Quk3jqbA
X-ME-Proxy: <xmx:xz7zaiHp5d0Mi-ClGIRepLZpgSI_S9aBFFuiIL_cdmtQU6tyDMhJ3g>
    <xmx:xz7zajyfZaQqa7ydcy8fTenG93hnqJfxxe7bsLYxt6oyCDjGxy-mkA>
    <xmx:xz7zas2wq-jN6TzuRSAk1nvX8erKbx6unuoJNRS_14OXsd1IY-Kt1g>
    <xmx:xz7zajpcuoxHd1t98jYxsObTOluoNG3IczHeKlz9VTj4C7okUiToww>
    <xmx:xz7zapWZUx_VEgroZeCRR8Y3h2aNpKETy6C8PrYtBiSx2zUrjFxRLauz>
Feedback-ID: iccae4b50:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id B1564F60082; Tue, 10 Nov 2026 10:56:54 -0500 (EST)
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
Date: Tue, 10 Nov 2026 10:56:34 -0500
From: "Chris Mason" <mason@kernel.org>
To: "Carlos Maiolino" <cem@kernel.org>
Cc: "Theodore Tso" <tytso@mit.edu>, "Dave Chinner" <david@fromorbit.com>,
 "Jan Kara" <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>,
 "Josef Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <d17350c0-0b93-4421-8bab-8266419fbd77@app.fastmail.com>
In-Reply-To: <avLnU46F6YZckcbo@nidhogg.toxiclabs.cc>
References: <20261109235111.14129-1-mason@kernel.org>
 <avLnU46F6YZckcbo@nidhogg.toxiclabs.cc>
Subject: Re: [PATCH v6 00/10] reflink and atomic write bugs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Nov 10, 2026, at 4:45 AM, Carlos Maiolino wrote:
> On Mon, Nov 09, 2026 at 06:51:11PM -0500, Chris Mason wrote:
>> Hi everyone,
>> 
>> This series did a few rounds privately, but looks ready for the list
>> now.  Except for Christoph's patch, these were all found and fixed
>> by an LLM.
>> 
>> The meat of the series is fixing reflink corner cases that incorrectly
>> let you write into the source of a reflink.  LLMs also tripped over a
>> few ways to use atomic writes to expose stale blocks on the drive, and a
>> few races with realtime flag manipulations.
>> 
>> Carlos and Christoph ran these through fstests (thanks guys).
>> 
>> Chris Mason (9):
>>   xfs: don't skip the flush before shifting extents
>>   xfs: flush the shifted range before changing the file
>>   xfs: don't change the block map under a dirty folio
>>   iomap: don't punch delalloc under a dirty EOF block
>>   fs: validate atomic writes after O_APPEND and limits
>>   xfs: recheck direct write alignment after write checks
>>   xfs: test for reflink after the dio write checks
>>   xfs: refuse fallocate racing with realtime flag changes
>>   xfs: restart faults racing with realtime flag changes
>> 
>> Christoph Hellwig (1):
>>   xfs: refuse writes to files racing with realtime inode flag changes
>
> Sashiko found a few issues that I believe are worth looking at. If there
> are no objections though, I'll pull in the first 4 patches which are the
> most critical ones so far until we figure out the other ones. If there
> are objections please let me know and I'll revert them back.

I'm generating fixes for the rest of sashiko's comments.  Looks like they
all existed before the series, but might as well fix them while we're here.

For sashiko's complaint about patch 6, the patch intentionally creates
the behavior sashiko mentioned.  We were inconsistently falling back
to buffered before so the behavior is new but the writes are correct.

-chris
