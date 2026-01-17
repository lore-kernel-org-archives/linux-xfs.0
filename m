Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3EC307AE3
	for <linux-xfs@vger.kernel.org>; Sat, 17 Jan 2026 06:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768631374; cv=pass; b=EwIt5BVn/xcaL4DFhgEK50jYXNZUn5Mld222vfX1r9Zyv6NeoB8njVjf9PxJ8BHYc/wkqNzkl+jZGHHWqmq++es8dkx+gXEU8twIEkP3gkfUY2HmNZOV3dSeC9t54/uK+gIuVPz6TBW6AIO61Mas1wHhFUC00Xcegx95uIqhXs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768631374; c=relaxed/simple;
	bh=Uh+O9uykFmwbqY+fIrZzvcD8B5zmDAu4hzpxzXJwQ1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SVvDmDkcCaFod0wY5HPI9PWqeI5JgUrJO1CBDSzanGBdDgkgrnrWUXCsOijP2w/oxUOItis+Ae03ftwVNwARupgrmgH7XUnv3bWsMJUrgfakldHIO+1kXhZmyEuDZNQ2YfVpSQGsoiJW389FgvfMZ2Uo4Afmh0AQJe8yb+ayC34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DbQdmjdq; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DbQdmjdq"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8718e54398so46502066b.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 22:29:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768631372; cv=none;
        d=google.com; s=arc-20240605;
        b=Uq6DBco1KKLJK50YUZoVB9Jvo37Ok8Vi11gL1RC5yo3TIHvfuqG3aiLwGzP4O/jxIH
         22RwXjEAX3TV9wlylKAAsNQ8jQqnRrRLpfgrZWbX/Ydql7MSy8JfFkqXiwYWtoo4PaG2
         RFi1/Sj3/osqwLJXIqVNQt2F1ZU0DI+Lp7Bv26+lPFGbuQrUHhWMWYLqhU1tdvxWb6VR
         luUJC75WPDGL+yWpQh+Bho3tLi48NHuhJlSewkS9Q8FA4xguWdEieY7M67bHEzxRCo6g
         KVak63bMOvlpx/lE/aeH1e0T6gpnfVIFUIpctekaWdvYMzZlhO9QapvHkyGrcZK1Zird
         b29A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TN89t98D3pWFZlU+8JoFo9BX+7kvVnrZc0AVK/xM/Yg=;
        fh=SiQwDDSEdckL208BtiE5wojyyvMGHqfMH/IqeBRgKiQ=;
        b=hMnBzj4jGhU1c51XOtigoBkkZR5RLqaRlOBqs+AS7PG68Mt5oVVYdoPxGJ8Zs3CIrt
         Z0zZFwZY4jjzhpolL8jVySdHBHnVLqYXKFH3rxU2FY0sVh/7g1SzuFkkQQ6hC4b9SaAP
         rXCKk6ghrByziDsr7FxYqNC39jXeIJpPSabre3cSrXrKTdj01l+05jU30I4aho4PEhEk
         Wtyg3qUrPgFOgTc8o48KqQ6tDYwCorjJPSwLpQdzdgXuEloKDNUZfS5jC/0bxuTuATQD
         xs+vTphzf9MBbZSOOG0lGUXod46NMrAI8/SD+W923rtRBLbojGSYEst/yA+7ivHR9CTN
         CjLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768631372; x=1769236172; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TN89t98D3pWFZlU+8JoFo9BX+7kvVnrZc0AVK/xM/Yg=;
        b=DbQdmjdqbtzxR0aJcqavxJU2qazyHa1iFf4+nOb6fqj6AiWjZaEr7eC51K81h8iCN/
         ylzYlCbmo69OAufowqSQtmSD9akJodzlTSpYLmPosv0hUwe7nJBhtZFHWjz1/+gYaNnp
         5OdbcpiFgYB8+aM0l2Sv40eOa3kuVFiMpZISh+FW5rAIthmP8Uw3k7m3rCc4R/pv8T8z
         FOnCsKgqDcC/6KOD2MWvAFTqmqIM3PM8s/gt+ZXjz5SurRx7c57MZL/sfEUtBTjtPmGh
         FgS04dncoCWhdjPOiugszSwOzl2UmL1M1/vikmar6rZvVCwISju+8oB8WjVWgCAACxUM
         Hqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768631372; x=1769236172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TN89t98D3pWFZlU+8JoFo9BX+7kvVnrZc0AVK/xM/Yg=;
        b=IiQoIqbphaQQI/Jx0L4Sob7SmbU6fiangW4QUqsjkRzhqIwY4u4uwOmGSOWivPumc7
         0guhNdcKuW4ABAn5iTVl3MRQam89EzBR3ITmOA2gJFEeau39EEPWL4v3kHWDUrt6pkSO
         Ww7IFa82XWIQfP6E9W8oDUs9Q4wSKtDpUnDIuPmey4b+2BK/HJSi3VqijTsdkgpVN5ZH
         j1DnA5EyrxiqTPhZ88aP8qeRigOd8//LQZQchXFEFpp8o4MfyQe9cWKt2rS5ShAzEEPl
         mBoNv8pDt9aXfvXonIrt9whXXpxVFg7mHc9XjLpVIy9VgFEWQWjygVt11N7aGhJryAiG
         RpSA==
X-Gm-Message-State: AOJu0YweNIFuU9SkBuC1Eyxr3gLa1NCKMqUfhMM7uT9HRVTSLY/9kZNN
	yBt1mkxItO4WDELFfPV2YpoB8WRzDOrol/KuHlwJpBCkdWtbG+DTRp9rpf9fUEDJvCTumgXH5MX
	Ov9ZhF4SK6aajuG3U3j8J+hlPAbonRLO6bHje17wV+Q==
X-Gm-Gg: AY/fxX5XbCQPqbcV/mDrQnTdiqWHubbfwOg1aFNkA4WevEHlqdENdWHspqB76fVa025
	2UHbN1mS9xx2kozZ0f7REABq3wevJGoQZIUjvdcj2whK+odauZlfDjkF3k/pF4jr4NJ0NNljOsk
	ZAfoKTqsfvN+JoE4frdbkTn926M3bqRrISBStan1/QzFuOFd3U0lRA0ZtKt12sNv6cfSW/v7BU7
	jGlhuVwa1s18/gV+U27y6jxpFiqs7VQtlCFz4wcKwuE8uG5HHl5dsngrkAVwgzPhv08VmxbnZYo
	wX9F7qyT/AmUafMAKiGm3Vjdx7LA5nE53J2qAfg=
X-Received: by 2002:a17:907:6d20:b0:b83:1327:5f89 with SMTP id
 a640c23a62f3a-b8792e070b6mr229680866b.2.1768631371533; Fri, 16 Jan 2026
 22:29:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116103807.109738-1-hwenwur@gmail.com> <aWpYhpNFTfMqdh-r@infradead.org>
In-Reply-To: <aWpYhpNFTfMqdh-r@infradead.org>
From: Wenwu Hou <hwenwur@gmail.com>
Date: Sat, 17 Jan 2026 14:29:27 +0800
X-Gm-Features: AZwV_QgGmPe7W2QmzwtpIWFAPnaeRbvFSLQvPOio1SXvBOJko-Op3nNLEZqo4z4
Message-ID: <CAMm06HYWq14NhGS2LpRGTwenyWQ_jOgsse8KC6jdS2+AtNCv0Q@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix incorrect context handling in xfs_trans_roll
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, dchinner@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2026 at 11:25=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Fri, Jan 16, 2026 at 06:38:07PM +0800, Wenwu Hou wrote:
> > The memalloc_nofs_save() and memalloc_nofs_restore() calls are
> > incorrectly paired in xfs_trans_roll.
> >
> > Call path:
> > xfs_trans_alloc()
> >     __xfs_trans_alloc()
> >       // tp->t_pflags =3D memalloc_nofs_save();
> >       xfs_trans_set_context()
> > ...
> > xfs_defer_trans_roll()
> >     xfs_trans_roll()
> >         xfs_trans_dup()
> >             // old_tp->t_pflags =3D 0;
> >             xfs_trans_switch_context()
> >         __xfs_trans_commit()
> >             xfs_trans_free()
> >                 // memalloc_nofs_restore(tp->t_pflags);
> >                 xfs_trans_clear_context()
> >
> > The code passes 0 to memalloc_nofs_restore() when committing the origin=
al
> > transaction, but memalloc_nofs_restore() should always receive the
> > flags returned from the paired memalloc_nofs_save() call.
> >
> > Before commit 3f6d5e6a468d ("mm: introduce memalloc_flags_{save,restore=
}"),
> > calling memalloc_nofs_restore(0) would unset the PF_MEMALLOC_NOFS flag,
> > which could cause memory allocation deadlocks[1].
> > Fortunately, after that commit, memalloc_nofs_restore(0) does nothing,
> > so this issue is currently harmless.
> >
> > Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting tran=
saction recursion")
> > Link: https://lore.kernel.org/linux-xfs/20251104131857.1587584-1-leo.li=
long@huawei.com [1]
> > Signed-off-by: Wenwu Hou <hwenwur@gmail.com>
> > ---
> >  fs/xfs/xfs_trans.c | 3 +--
> >  fs/xfs/xfs_trans.h | 9 ---------
> >  2 files changed, 1 insertion(+), 11 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 474f5a04ec63..d2ab296a52bc 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -124,8 +124,6 @@ xfs_trans_dup(
> >       ntp->t_rtx_res =3D tp->t_rtx_res - tp->t_rtx_res_used;
> >       tp->t_rtx_res =3D tp->t_rtx_res_used;
> >
> > -     xfs_trans_switch_context(tp, ntp);
> > -
> >       /* move deferred ops over to the new tp */
> >       xfs_defer_move(ntp, tp);
> >
> > @@ -1043,6 +1041,7 @@ xfs_trans_roll(
> >        * locked be logged in the prior and the next transactions.
> >        */
> >       tp =3D *tpp;
> > +     xfs_trans_set_context(tp);
>
> It took me a while to understand this, but it looks correct.
>
> Can you add a comment here like:
>
>         /*
>          * __xfs_trans_commit cleared the NOFS flag by calling into
>          * xfs_trans_free.  Set it again here before doing memory
>          * allocations.
>          */

OK, thanks for your review. I will send v2 right now

>
> I also think we'd do better without the xfs_trans_*context helpers
> in their current form, but that's a separate issue I'll look into
> myself.
