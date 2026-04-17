Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF91B19E819
	for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 02:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776392354; cv=none; b=Bwglz/+UBKNMwZawUOt+yZ8tkSAnKk8K8+uNwdXlVhzkyx85D8TaAGPBc/Gh2+abX9iP9ScaniYrzbTQT1a657aH58eQO+v0khF4rGAP7aqbZWM4fuHeq2oxLzomNp+eRYCmaU1DnX5hD1KoURPgL1ROm+j3VlF6loaHfXu+ft8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776392354; c=relaxed/simple;
	bh=jrx+4xUmZU1x4pUeKQda1573iTcGiPF/RQQ5ZPhuFx4=;
	h=To:Cc:Subject:From:Mime-Version:References:In-Reply-To:Message-Id:
	 Content-Type:Date; b=uTjU1j5jxuzvlIOG4qFggaf0q5DS1zXdOgxTnNVoElsSHqYTXML6N5ap/ascDK1snBV3Kykl6Uu6YtRsL4rbGSI1qrRBuM2YXiFWx7LfbCyU6k017rfOMjMWHBDtlSyi6yN7vcVRqxr8b5yNZmVVPRpbWMEXXGIeNjdGIOj8LN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=kRbGWf64; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="kRbGWf64"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1776392345; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=jrx+4xUmZU1x4pUeKQda1573iTcGiPF/RQQ5ZPhuFx4=;
 b=kRbGWf64Lk45TRaEgh5+GmJk5xSMyi0v6UBDwTZzG3/J301fCwpy4vA46u/Jop3fXVfJGD
 3R91/Y3CuWX5DxqpKne+soU4NGojZESs3N00FPDWoudn/tJqXGj+66HgoharCnBG5Zf+/w
 TuJuStcIFEbAFV8mnfdLS93L+bqNng4+YKyAICNjikNzINV7v21fYirfPXcdJUYmiLSv+M
 m4UHhcH+ixldNmET8+YX0ZIzg8yLp6ER8fbv4qNV0JnfDL8yhRhX0Z65C2ZZVFF8mgshGG
 vPA2Xu1ntZAeWyB5pOglbbkP+gp4khyWAw3uz7rn05QS8lgJf7jLoHO2iwHVag==
To: "Mateusz Guzik" <mjguzik@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	"Brian Foster" <bfoster@redhat.com>, 
	"Fengnan Chang" <fengnanchang@gmail.com>, <brauner@kernel.org>, 
	<hch@infradead.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<lidiangang@bytedance.com>
Subject: Re: [PATCH] iomap: avoid memset iomap when iter is done
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260416030642.26744-1-changfengnan@bytedance.com> <aeDjui2LGSidEHcJ@bfoster> <20260416152705.GC114239@frogsfrogsfrogs>
	<hgug5jbkwk352zrwcngdofwiy2hq4nk7eq7yvzi6nru5zyebd2@fe64yziutvlk>
In-Reply-To: <hgug5jbkwk352zrwcngdofwiy2hq4nk7eq7yvzi6nru5zyebd2@fe64yziutvlk>
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.1dc3ba4b.a0f6.420b.a9f2.f3d89396b545@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+169e19897+7df5c7+vger.kernel.org+changfengnan@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Apr 2026 10:19:00 +0800


> From: "Mateusz Guzik"<mjguzik@gmail.com>
> Date:=C2=A0 Fri, Apr 17, 2026, 07:21
> Subject:=C2=A0 Re: [PATCH] iomap: avoid memset iomap when iter is done
> To: "Darrick J. Wong"<djwong@kernel.org>
> Cc: "Brian Foster"<bfoster@redhat.com>, "Fengnan Chang"<fengnanchang@gmai=
l.com>, <brauner@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.o=
rg>, <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <lidian=
gang@bytedance.com>, "Fengnan Chang"<changfengnan@bytedance.com>
> On Thu, Apr 16, 2026 at 08:27:05AM -0700, Darrick J. Wong wrote:
> > What kind of computer is this where there's a 5% hit to iops from a
> > memset of ~150 bytes?
> >=C2=A0
>=C2=A0
> Such a memset is not free in its own right, but here the real problem is
> *how* it is done: by default gcc emits inlined 'rep stosq' which has
> utterly horrid performance (same as 'rep movsq') and in this particular
> case the 2 memsets in the source code result in 2 separate 'rep movsq'
> invocations.
Yes,=C2=A0 two 'rep stosq'.
>=C2=A0
> I complained about it numerous times, see this to get a taste:
> https://lore.kernel.org/all/20250605164733.737543-1-mjguzik@gmail.com/
>=C2=A0
> Also see
> https://lore.kernel.org/all/202504181042.54ea2b8a-lkp@intel.com/
>=C2=A0
> If memory serves right gcc is going to fix it, so this is largely going
> to clear itself down the road.
Sounds good, I believe there are other similar issues that haven't been
discovered yet. In this case, removing `memset` is the best option, since
we don't need it.

>=C2=A0
