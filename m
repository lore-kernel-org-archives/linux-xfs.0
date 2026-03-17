Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A0437FF65
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 08:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773736421; cv=none; b=n3pIK09lxgCUd6erPNKET2rmF8N2xnKGyvgbTFBUd/77zVdeIy4hK2iQy6ekC6SL6TeasciyFoBD2oM5mQMejkn5eO/UESgO3q8TbyhRSv7HyyynR4PXPF3bg9+aiUToKpQ62TfRcV6pk0T+eoH/me3Qsdk2axTszirAdTtIskk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773736421; c=relaxed/simple;
	bh=ouY2DlmxHP8dSdFOfc8RggJly7xAXy6YWI/q1/g6vaI=;
	h=Message-Id:Cc:References:In-Reply-To:Content-Type:Date:To:Subject:
	 From:Mime-Version; b=Bfg6ISh/vutvmY2KRhqVyFQA+khJJyJXD28mCDTfavOMjxqyvkVVOYDQpICP0EXl4MF6fQc+0s6dv8Si/u53A29Sjx1nPUjHJTBDGorStsB0TmaNaTAAU1NiSekfmGO/F91OdxARJsfcJ6nQK3sdUgTYlO92Kk6Zbe1S6OLFpnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=UNdSsuft; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="UNdSsuft"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1773736409; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ouY2DlmxHP8dSdFOfc8RggJly7xAXy6YWI/q1/g6vaI=;
 b=UNdSsuftD9G9ZDe1RiM5S1tQwhHyI8KCu3XHAXVRMcK1kKxpaCne5ibOQUoSEReqUIhzQ5
 Lp1OWbn/Z+Z8nzj6xNDZiqM67IwG4KZCT4DiV9lrD05kkjdhhtmilgxCb1Tq5AeVfGm+H0
 Gaw7fp5Hl+JaqFEQi/EGON2btc2ReFB2mint/9+DLNyo+1XOPxkpG1Zx0Hjm+nrtRN3AqU
 efgVhGd2l+kTqdscuzRWRKO+kACt1NPdWT9/lzeOZMd8khZgZLgxaLHTo+rs/gB1IGUpD3
 K20DbMYJPb2Coe8+FYtS/UZncgvud4L9r9tvqygFx9QuUlh+jRjXC5kras6JUw==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b89f1572.8ddd.443e.a91a.9f6964f1a150@bytedance.com>
Cc: "Dave Chinner" <david@fromorbit.com>, "Harry Yoo" <harry.yoo@oracle.com>, 
	"Hao Li" <hao.li@linux.dev>, "guzebing" <guzebing1612@gmail.com>, 
	<brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <guzebing@bytedance.com>, 
	<syzbot@syzkaller.appspotmail.com>, <linux-mm@kvack.org>
References: <20260115021108.1913695-1-guzebing1612@gmail.com> <aWh06YoiJrR3-J-X@dread.disaster.area> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com> <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
	<abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org>
In-Reply-To: <abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Mar 2026 16:33:24 +0800
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+169b911d7+40f089+vger.kernel.org+changfengnan@bytedance.com>


> From: "Vlastimil Babka (SUSE)"<vbabka@kernel.org>
> Date:=C2=A0 Tue, Mar 17, 2026, 16:28
> Subject:=C2=A0 Re: [PATCH v3] iomap: add allocation cache for iomap_dio
> To: "changfengnan"<changfengnan@bytedance.com>
> Cc: "Dave Chinner"<david@fromorbit.com>, "Harry Yoo"<harry.yoo@oracle.com=
>, "Hao Li"<hao.li@linux.dev>, "guzebing"<guzebing1612@gmail.com>, <brauner=
@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.ker=
nel.org>, <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, =
<guzebing@bytedance.com>, <syzbot@syzkaller.appspotmail.com>, <linux-mm@kva=
ck.org>
> On 3/17/26 08:28, changfengnan wrote:
> >=C2=A0
> >> That suggests in that test you used larger capacity than the automatic=
ally
> >> calculated.
> > The 10% improvement is due to the every cache has sheaves.
> > When I tested 256-byte objects, default sheaf_capacity is 26, allocatin=
g and
> > freeing 32 objects did not show a noticeable difference, but allocating=
 and
> > freeing 128 objects resulted in a significant improvement, about 3-4x i=
n a=C2=A0
> > multithreaded environment.=C2=A0 about 12% improvement in single thread=
.
>=C2=A0
> Great!
>=C2=A0
> >> =C2=A0
> >> > I'm thinking that maybe these improvements may not be significant en=
ough to
> >> > see the effect in the io flow.
> >> > Using a simple list seems to be the most efficient approach.
> >>=C2=A0
> >> I think the question is, what improvement do you now see with your add=
ed
> >> pcpu cache vs kmalloc() when 7.0-rc4 is used as the baseline?
> >=C2=A0
> > On 7.0-rc4, pcpu get 1.20M IOPS , kmalloc get 1.19M IOPS, new cache wit=
h set sheaf_capacity 256, 1.19M IOPS
> > On 6.19, pcpu get 1.20M IOPS,=C2=A0 kmalloc get 1.17M IOPS, new cache w=
ith set sheaf_capacity 256, 1.19M IOPS.
>=C2=A0
> Thanks a lot for that data. My conclusion is that kmalloc before sheaves =
did
> indeed worse and custom pcpu cache improved it relatively more. Kmalloc w=
ith
> sheaves does better, and the improvement of custom pcpu cache is smaller.
> Also the default sheaf capacity seems to be enough for this workload.
Agree.
>=C2=A0
> IO is not my area but getting from 1.19M to 1.20M doesn't look like it's
> worth the custom code? (possibly from 1.17M to 1.20M it also wasn't).
Yes, at least for now, there=E2=80=99s no need for a per-CPU.
It might be better to replace kmalloc with a new cache, but my tests so far
haven=E2=80=99t shown any performance improvements.=C2=A0 I=E2=80=99ll look=
 into it further.

>=C2=A0
