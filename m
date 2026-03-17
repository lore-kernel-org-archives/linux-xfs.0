Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A9735E93B
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 09:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739173; cv=none; b=dNfh5tPKW24Ub4Ml5rMRmeGKCQPiftyeGOR1B4aLp/MYIqpEEsHb3iuEbfPQ2Jcsj9WkW+YOmuJgW94SsPAszgtoNdhZ8jx1gNXlb8rL0Dstbo6CEjZ2sDA0yaCgt6pTQ0/UQwYbFZvQadt+O693ob3BFu3IciVmsrwBLx9nNfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739173; c=relaxed/simple;
	bh=eunUM8JQ172NyXvs2GMpTXA1jV7Ng7SV2a6H7K+qqos=;
	h=Message-Id:From:References:In-Reply-To:Content-Type:Date:To:Cc:
	 Subject:Mime-Version; b=YcjoOqXLExRoayMxia+xoctjSS+3kVd4q5Vk+cV9OB0It9hVR/grxyHATSe65j55y0E8gwdY4VtevuCsdRKzbMYy7Q7CGcpHvag6xE9C3z5QSTenF8O4mtlvbo55yoYejgFI8syk8v0qSDNG/kQWNMQELlGUWXTgbiZlXSXdemA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=p/gkbFuK; arc=none smtp.client-ip=209.127.230.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="p/gkbFuK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1773739159; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=eunUM8JQ172NyXvs2GMpTXA1jV7Ng7SV2a6H7K+qqos=;
 b=p/gkbFuKTFo5OjOtKB7SZOwwE8OQ40gBqwNAOscKo8TEwC8dlIoPlJR7ft6kIo3/XSEEiU
 b+g15YoKAOk5NfLViLB3wRqHT+WN8K+3jnS7jtgMSUPmjU5SHIFUn1s1MUEv8Z4JWg05/P
 sUgqL8vHdKr77yyWvOjwY7pif99PXh1axr+MyCSdFYPpFc5YdlVMIRR0AhYSwTZzsxlRv6
 9I5uoJhZvDyMD18/PRqCIU3HG1NOZnG34mKgyVSBIK0CtJ3irAO5YZnaUVigmIeVxM8YLn
 eOYK89PTIuSx84H/pt0JROjj3wx3NHGfTbR0hmiwIE4Wduo7OEFz6UrX7Nnd2g==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.4fcab3f9.8b94.4220.83af.caf2cffbcaa2@bytedance.com>
From: "changfengnan" <changfengnan@bytedance.com>
References: <20260115021108.1913695-1-guzebing1612@gmail.com> <aWh06YoiJrR3-J-X@dread.disaster.area> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com> <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com> <abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b89f1572.8ddd.443e.a91a.9f6964f1a150@bytedance.com>
	<abkbE_zh79iCd5zs@infradead.org>
In-Reply-To: <abkbE_zh79iCd5zs@infradead.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Mar 2026 17:19:14 +0800
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	"Dave Chinner" <david@fromorbit.com>, "Harry Yoo" <harry.yoo@oracle.com>, 
	"Hao Li" <hao.li@linux.dev>, "guzebing" <guzebing1612@gmail.com>, 
	<brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <guzebing@bytedance.com>, 
	<syzbot@syzkaller.appspotmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+169b91c95+e060ac+vger.kernel.org+changfengnan@bytedance.com>
Content-Transfer-Encoding: quoted-printable


> From: "Christoph Hellwig"<hch@infradead.org>
> Date:=C2=A0 Tue, Mar 17, 2026, 17:13
> Subject:=C2=A0 Re: [PATCH v3] iomap: add allocation cache for iomap_dio
> To: "changfengnan"<changfengnan@bytedance.com>
> Cc: "Vlastimil Babka (SUSE)"<vbabka@kernel.org>, "Dave Chinner"<david@fro=
morbit.com>, "Harry Yoo"<harry.yoo@oracle.com>, "Hao Li"<hao.li@linux.dev>,=
 "guzebing"<guzebing1612@gmail.com>, <brauner@kernel.org>, <djwong@kernel.o=
rg>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.=
kernel.org>, <linux-kernel@vger.kernel.org>, <guzebing@bytedance.com>, <syz=
bot@syzkaller.appspotmail.com>, <linux-mm@kvack.org>
> On Tue, Mar 17, 2026 at 04:33:24PM +0800, changfengnan wrote:
> > > IO is not my area but getting from 1.19M to 1.20M doesn't look like i=
t's
> > > worth the custom code? (possibly from 1.17M to 1.20M it also wasn't).
> > Yes, at least for now, there=E2=80=99s no need for a per-CPU.
> > It might be better to replace kmalloc with a new cache, but my tests so=
 far
> > haven=E2=80=99t shown any performance improvements.=C2=A0 I=E2=80=99ll =
look into it further.
>=C2=A0
> Does using a kmem_cache help? =C2=A0That should generally be a nice win
> anyway due to keeping the objects together.
For now, my test case is just run ./t/io_uring and fio, no other process, n=
ot show
any performance improvements, test case is simple and no other user try to
kmalloc same size object, I think maybe there will be improvements in more
complex case. In theory, yes. I=E2=80=99ll run some tests to verify that.
>=C2=A0
