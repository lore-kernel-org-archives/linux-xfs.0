Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC90C36E497
	for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 09:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776417324; cv=none; b=hInuXCL+jyjS58qZpKIJwMuHzKFGSr5yWl4sls7QHlwkpyVKIueVddrlBgSZn03sXbHaSn4v8NlgHlbpO1fD4PsWDb4HEQrpv14fe0mgFGaKULce6igS39wOKTRb/nBvB3a2ox+5Azi1mSW5Z1IcVYuTRfB9rVk74curaMqBNkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776417324; c=relaxed/simple;
	bh=CqshMXJjuIbz2v7/b24OZQcMbf5U1FYx6B8PTiLWvmc=;
	h=To:From:References:Mime-Version:In-Reply-To:Content-Type:Date:
	 Message-Id:Cc:Subject; b=Hf4u5oCA6oTg449X0hxMS8YY1cSb2nSyp/5ezjcYl7MTtLoMPc7/ebd+tDnjkwa3fxgpy/tXDCYsDf7wwwed6cCWB1OPz9BXngrhtjvaNCqy9R5HkmybnDwA1UJgIsUrzzzMKu5NVJa5xPWUq79korOSJQQ+5EC822H+V7r/zsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=YudM9mG/; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="YudM9mG/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1776417311; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=CqshMXJjuIbz2v7/b24OZQcMbf5U1FYx6B8PTiLWvmc=;
 b=YudM9mG/nt44XotOro2JbRCryULVPUkvb4oWsOXKRawvXbO+JH4LOMO3ZbzeQedoEYWphS
 dG5+ZyWiks9fDl+biByWZILRn8k91Q834vaKco7DRHHNe61dx1bzKAQzfoViSLBswTUv9y
 hazQ4zkw4BXk+ike5nG3hpPTfIaWxIznEy6B+2I0aQm97dtBjV0v9ShvyU7YDYQgOwdZ8+
 8FYOkCSOvWa2laAIXseEK2mnnZ2MjnAfk8NHvopszWI6GvLdabHa9jxeTJ81PmqREpIvz8
 jhCaSm/gFroUXTTbofewvyr5tVeHfKpwhwHXfHOHV9pwrDzLfpLD1F3u5JtVvg==
To: "Christoph Hellwig" <hch@infradead.org>
From: "changfengnan" <changfengnan@bytedance.com>
References: <20260416030642.26744-1-changfengnan@bytedance.com> <aeDjui2LGSidEHcJ@bfoster>
	<aeHg4hUsVTxzm66I@infradead.org>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <aeHg4hUsVTxzm66I@infradead.org>
X-Lms-Return-Path: <lba+169e1fa1d+f4f600+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Apr 2026 17:15:06 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.d8707dd1.2ba2.4aae.83a0.8f7870c373ec@bytedance.com>
Cc: "Brian Foster" <bfoster@redhat.com>, 
	"Fengnan Chang" <fengnanchang@gmail.com>, <brauner@kernel.org>, 
	<djwong@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<lidiangang@bytedance.com>
Subject: Re: [PATCH] iomap: avoid memset iomap when iter is done


> From: "Christoph Hellwig"<hch@infradead.org>
> Date:=C2=A0 Fri, Apr 17, 2026, 15:27
> Subject:=C2=A0 Re: [PATCH] iomap: avoid memset iomap when iter is done
> To: "Brian Foster"<bfoster@redhat.com>
> Cc: "Fengnan Chang"<fengnanchang@gmail.com>, <brauner@kernel.org>, <djwon=
g@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>, <linux-fsd=
evel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <lidiangang@bytedance.=
com>, "Fengnan Chang"<changfengnan@bytedance.com>
> On Thu, Apr 16, 2026 at 09:27:22AM -0400, Brian Foster wrote:
> > This seems reasonable to me in principle, but it feels a little odd to
> > leave a reset helper that doesn't really do a "reset."
>=C2=A0
> Agreed.
>=C2=A0
> > I wonder if this
> > should be refactored into an iomap_iter_complete() (i.e. "complete an
> > iteration") helper that includes the ret assignment logic just above th=
e
> > reset call and returns it, and then maybe leave a oneline comment above
> > the memset so somebody doesn't blindly fold it back in the future. So
> > for example:
>=C2=A0
> What about just killing iomap_iter_reset_iomap in it's current form
> instead? =C2=A0Move the batch reset logic into a little helper if we care=
,
> and just inline the rest into the only claler to side-step the issue.
Sounds good, move iter->status out, and then rename=C2=A0
iomap_iter_reset_iomap to iomap_iter_clean_folio_batch.
>=C2=A0
