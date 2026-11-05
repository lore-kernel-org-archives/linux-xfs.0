Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793890465;
	b=xVnUu/JMaaqWt7kG5Y8mXxxQ3FBAuiVTnlQGlNYyUfYyI6mFOK71fjKYBQpYhptAf91c
	 E0J1NWJNjaSt2BRvBdvb80NaKHCb16yDP1aXu9nxZ2NuQU9xsQOTqNm1fQgHPvcDyI/Kh
	 F/lbTwrTid7zByVjRqgZX3+hCZ9HW4p8mDSdukE3TCTHZNBoAllJT55CqKwujsDLMhnAc
	 WO/bUnbCZZq5v8843f2NYOaK3aqPLEzE2pkiv+KUz2v98X0SDdUE9KqG5ddIj0PCdCcAK
	 erOKCC+uuv30NN0Cc+Et6ruHNUzxiqI7lTr3QXgoAMvOGOYNhNv6t2V0jM0ah6IoKDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890465;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=KJPlPhq79+b9C9yPuPu41fXqD9fPpfLVCJFpJFt1K7M=;
	b=U7td/1qI3His5raJBToTInkZAPUMsr3wNn9G4HRwG5Ipd0tP5QfuWk+A2RI9NYQxcZqY
	 hY5HpxBHjjpElCMQoVisB7WSwqK9ouZH9oHE6EmvPSBPPHBKqsjRVQH/OHKqzfjjEuDbN
	 6u+nMmkLqjuNrjYZ6lAgRff+ZJYjs1YWP0SEOiIBaqE3t0UaOw/W3tlQ8/p+a4/kyULH6
	 2gPHMeGmjCiP9mZ7sy75OMjjBv6ZBq0899dNF/JsPi4Dc9LF8eprYChBbs1XpnGCE6RIx
	 9bNm3wjOzZ2r38QaaMSsjYYP1Tf4VSJHbhT7Eu3GHU/5DeeT6pGRNjiPEJwz2jYmqjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=afMF8JJO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F362606A31B;
	Thu,  5 Nov 2026 14:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=afMF8JJO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E721F000C1;
	Thu,  5 Nov 2026 14:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793890464;
	bh=KJPlPhq79+b9C9yPuPu41fXqD9fPpfLVCJFpJFt1K7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=afMF8JJOC+UA6TQNS8vHz3S3z8SzLypee6cECWIy2xmvtig1ivltLi4r6fVdH5VtC
	 xqta1RKw1EGV7RRAcOlz91Xy9JopnWH47UqA1JtALmg3PuH6AjN/3T3Et+/eIWK5Ew
	 PovxF3eQkTbKnpa/4YAnrJ3U/D9nxvkj1q5Jq/PUV+DbqjJL9Vgc81JiAN/nU8A00v
	 NUQxcgotx+l66L2UgI9DowS5p0hzZvB+7Omxh/2izbr6+8F0JPbBUddAOIuNktXmv5
	 0uG39y3bwJbNMFiG7WZNt+aROzCd6UCpUm1Ldfq7jucqh/XYQHSyxeJwx9Wn7n7mSJ
	 6vf8UzvgjzPOA==
Date: Thu, 5 Nov 2026 15:54:20 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Zheng Shuhao <viennaoffh@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix slab-use-after-free in xrep_newbt_free()
Message-ID: <auyV6giI3jljW4QX@nidhogg.toxiclabs.cc>
References: <20261016085536.591-1-viennaoffh@gmail.com>
 <atL8bTDPVGlpZ0LB@nidhogg.toxiclabs.cc>
 <1793882752.followup@viennaoffh.gmail.com>
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
In-Reply-To: <1793882752.followup@viennaoffh.gmail.com>

On Thu, Nov 05, 2026 at 08:45:52PM +0800, Zheng Shuhao wrote:
> Hi Carlos,
> 
> I have to admit I was not sure how to reply to your last message, or
> whether I should reply at all. You said to wait until the patch gets
> reviewed before sending a V2, so I did not want to push or send noise to
> the list. On the other hand, it has now been a few weeks without any
> further review or comment, and staying silent did not seem right either.

It's fine to ask for status once in a while, don't worry about it.
Common sense applies here of course. I.e. don't ask ever other day about
status :)

> So I am sending this short status note; if you would rather I simply
> wait, please say so and I will do that.
> 
> I also wanted to close the two items you asked about earlier, since I
> promised them and then went quiet.
> 
> > Yes, sharing the reproducer (and potentially hooking it up into
> > xfstests) is a good thing, specially giving the syzbot doesn't seem
> > to have a reproducer for it yet.
> 
> The reproducer is a standalone harness, not a syzkaller program. It
> mounts a scratch XFS with rmapbt and reflink, starts an online repair
> that rebuilds a btree-format inode fork, and then issues
> XFS_IOC_GOINGDOWN (LOGFLUSH and NOLOGFLUSH) from 1 to 8 helper threads
> at 0-100 ms after the xfs_defer_item_pause tracepoint.

Ok, this sounds as a good candidate for a xfstests case.

> 
> On the unpatched kernel this produces the reported KASAN
> slab-use-after-free in xrep_newbt_free() -> xfs_defer_item_unpause()
> on every run. With the patch applied, the scrub ioctl returns -EIO, the
> shutdown path unwinds, the log replays on remount, the free block count
> is unchanged, file data reads back intact, and xfs_repair -n is clean.
> Healthy forced rebuilds still take the normal pause/unpause path.
> 
> I can send the harness and logs, but I did not want to attach a large
> tarball to the list without asking first.

you don't usually need to send the logs. If you have the reproducer,
just attach it to the message in text/plain with instructions how to
run. So we can try locally.

> 
> > I'm also interested if you actually passed your patch through xfstests
> > before submitting it. There is no good fixing a bug if you create a
> > handful of others. Specialy agains scrub, online_repair (and maybe
> > fsstress_scrub) groups.
> 
> I ran the patched kernel against the scrub and online-repair fuzzer
> cases, plus fsstress_scrub. To be precise about the coverage:
> 
>  - Completed with a real verdict: xfs/351, 353, 355, 357, 359, 361,
>    363, 365, 367, 369, 371, 373, 375, 377, 379, 381, 383, 385, 399,
>    401, 403, 405, 411, 413, 415, 417, 426, 428, 430, 497, 730, 733,
>    736, 786.
>  - xfs/387, 389, 391, 393, 395, 397 were started but hit my per-test
>    timeout before reaching a verdict. They are long directory/xattr
>    walks; I am not counting them as passes.

This is a good start, but as I'm suggesting everybody sending patches,
please ensure at least it passes -g auto group in xfstests. Not sure
what specific timeout you're talking about, but you can even run it
locally on your machine, for example with virtme-ng.

> 
> No KASAN report was produced by the patched kernel. The failures I did
> see are all reproducible on the unpatched baseline as well, so they are
> pre-existing and not introduced by this patch:
> 
>  - xfs_btree.c:1814 in xfs_btree_decrement (xfs/361, and also xfs/373)
>  - xfs_buf.c:389 stale-buffer assertion (xfs/363, 365, 367)
>  - xfs_log_cil.c:546 empty-transaction assertion (xfs/369)
>  - xfs_attr_leaf.c:168 attribute-leaf assertion (xfs/401)
>  - null-ptr-deref in xfs_btree_simple_query_range, reached from
>    xrep_dinode_count_rtgroup_rmaps (xfs/375, 377, 379, 385, 399, 413,
>    415, 417). This one reproduces identically on the baseline kernel.
> 
> > You'll need to send a V2. But wait until your patch gets reviewed, you
> > don't need to send it right now.
> 
> Understood. I am holding the V2 until there is review feedback. When I
> send it, it will use the correct identity:
> 
>     From: Zheng Shuhao <viennaoffh@gmail.com>
>     Signed-off-by: Zheng Shuhao <viennaoffh@gmail.com>
> 
> Is there anything you would like changed in the patch itself, or any
> additional data you want before I send the V2? If it is more useful, I
> can also send the reproducer and the per-test logs now, separately from
> the patch.

Ok, please send a V2 then, and we'll continue from there
