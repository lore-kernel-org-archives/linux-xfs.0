Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B300F380FC2
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 09:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783070570; cv=none; b=Mk15hJ0OG135dl8Jo4EPtkmu2oD9VwAToLJgZVtc48JRVjKAMyq7tIJiEaYZZx/TDmxdynFyB2AcR8V9IURb72HJ26pot7PM0vbmKA0tPlz2969zB08BwzRcGEYUxHGPdFQLuQRRG4AiPBqedFMg2nBWQVIDMgCdWzb0ui0OgEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783070570; c=relaxed/simple;
	bh=yWDpuz+OrxrNIPFaAdNOgzJ/2wuC/ofxRI2DyA0D3CI=;
	h=Cc:From:Mime-Version:In-Reply-To:Date:Message-Id:To:Subject:
	 References:Content-Type; b=FowVyUFxXDFjqpYqn2usZHZa/ZaxHDzutA8adZ58crgxD3Bnv2xzplcjJAu07SSfiiI4w/Cq+vLMMJ8kJHfY/qh/di9DE83DMlRfGeJk4WRO381ajgBBKXt4/ERymdx+hSRvxbgTtOcId1LdXKjUC2/g/jvvfpd54GRk+LkddRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ZtTpD3uw; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ZtTpD3uw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783070559; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=yWDpuz+OrxrNIPFaAdNOgzJ/2wuC/ofxRI2DyA0D3CI=;
 b=ZtTpD3uwjV+sP4gyo1dfsnOjf8oG+cpo/fJ0kFGYd8nbxUmWmZ4AmDiKmqEXPkip3spL0I
 RMpuzSdWPA1SsBY+vzNYn1ci5C3enimj//fb8rkXltuSZRGey/3dZNW9fZEG3H4UXs/kZI
 LHFyiMwsywiEq4LJOQ74EUZnHuO4lWzFhSRUGt7QvQ8+WV8ZWJDE/paRrAj9aKK7VwwWq9
 REJES1kWatGzgOkUqxVNRmZ+1B1TOD0izI88uqfi0fA3UnpQJnOE54sycXjp2TX4Zecq8+
 sMEz+fmo76FkDMkdMTepWmJQ+hPGe+CAEMfQZUr0PGApRL+RjMNanXzMvDjlSQ==
Cc: "Christoph Hellwig" <hch@infradead.org>, <brauner@kernel.org>, 
	<djwong@kernel.org>, <ojaswin@linux.ibm.com>, <dgc@kernel.org>, 
	<linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, 
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<lidiangang@bytedance.com>, <pankaj.raghav@linux.dev>, 
	"Brian Foster" <bfoster@redhat.com>
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+16a477f5d+276d11+vger.kernel.org+changfengnan@bytedance.com>
In-Reply-To: <CAJnrk1ZijiWYU8YOmRf24xxwX0kH6vCe3ta89LfoX7v7j_JYLQ@mail.gmail.com>
Date: Fri, 03 Jul 2026 17:22:34 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.7b25fd67.6c65.451f.9032.1966d6350531@bytedance.com>
To: "Joanne Koong" <joannelkoong@gmail.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
References: <20260701033253.46420-1-changfengnan@bytedance.com> <20260701033253.46420-4-changfengnan@bytedance.com> <akT4tJzFSfrBxqdq@infradead.org> <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com> <akZ3GErzJSTtOn-H@infradead.org>
	<CAJnrk1ZijiWYU8YOmRf24xxwX0kH6vCe3ta89LfoX7v7j_JYLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> From: "Joanne Koong"<joannelkoong@gmail.com>
> Date:=C2=A0 Fri, Jul 3, 2026, 11:06
> Subject:=C2=A0 Re: [PATCH v6 3/3] iomap: add simple dio path for small di=
rect I/O
> To: "Christoph Hellwig"<hch@infradead.org>
> Cc: "Fengnan Chang"<changfengnan@bytedance.com>, <brauner@kernel.org>, <d=
jwong@kernel.org>, <ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vg=
er.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.or=
g>, <linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, <pankaj.rag=
hav@linux.dev>, "Brian Foster"<bfoster@redhat.com>
> On Thu, Jul 2, 2026 at 7:35=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
> >
> > On Wed, Jul 01, 2026 at 12:35:24PM -0700, Joanne Koong wrote:
> > > I think it ends up being pretty simple to get it integrated since
> > > ->iomap_next already contains the logic to only begin the mapping at
> > > the start and only finish the mapping when the iter has been fully
> > > consumed, eg
> >
> > I wonder if this adds overhead that the simple path removed.
>=C2=A0
> Ah I see now, the whole point of Fengnan's series is to k eep the
> logic minimal...
>=C2=A0
> Fengnan, I think you had mentioned earlier [1] that enabling
> iomap_next brought the simple-read gain down from 10% to 7%? Thanks
> for running those numbers. Would you be able to share the changes you
> made to iomap_dio_rw to support iomap_next for those benchmarks you
> ran?

Hi Joanne:
My previous change was to pass `xfs_read_iomap_begin` and
`ext4_iomap_begin` from ext4/xfs directly to `iomap_dio_simple`, since
`iomap_begin` was still present in `struct iomap_ops` at the time.
You can ignore my previous patch; let=E2=80=99s continue the analysis based=
 on
your patch now.

>=C2=A0
> Thanks,
> Joanne
>=C2=A0
> [1] https://lore.kernel.org/linux-fsdevel/e85e73bd-5fbe-4d11-89ba-7b42c23=
7dd34@bytedance.com/
>=C2=A0
