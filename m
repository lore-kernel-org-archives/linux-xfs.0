Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD5E2DEA89
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 07:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776843771; cv=pass; b=klD5bEoO+pvFVdxaIDs/HFohHweWfcqo9d4Zdy75GRuy3AijpiMGUjhnm5NrygSncuzDqKgiI63lCdFI4avoGgtGQjXBHxk5fN7Ts3e27PyGZCvNK5hFSLaQCsWsCPeYfr/eql6bV7FF8t7lhnhjc6zp9Ifqao3cQ+BeKleH7E4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776843771; c=relaxed/simple;
	bh=vF7GFQjFiLQixPDnP5Oed+7TTmdjzfIGex6cBPqoVjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rvHutTiArpbHPu8X9TwK5M5Z2EcT5MoS1yGwcIgwYRTF6LVoDZ9n5nIN1jDVszsR8K0+uHseY5vReOAddUx/U7Abm8Pwx4KgeSonzntNnv1L1ZPcDSiaGxGJ2TnXZBHmEJcyXcLPnUMeHOzeOrYBuAQi/w5dvGoGl1uf84n1l1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FfiuHZ8h; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ddVENzxx; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FfiuHZ8h";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ddVENzxx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776843769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R7pqyOAjUCUgv3uLiehuAJiB25itYZP57ABnNLwlQcg=;
	b=FfiuHZ8hroVl/7xg7HIRncUoVdgH/HJ2Sq9lCQnKMtsxzzi53bPvZcWDbe4Z4VSf9WJwkx
	v4kfGWig+qOvnTJ7wXI8o059FQy96zf+afBwEBofRmHLf7WbJRLHJIshje2CgiOUZC1jud
	Akieg0evBpu5pdUScqQwJYVzx0bIn7M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-mMj8x417ME-zvP9X6elmFg-1; Wed, 22 Apr 2026 03:42:48 -0400
X-MC-Unique: mMj8x417ME-zvP9X6elmFg-1
X-Mimecast-MFC-AGG-ID: mMj8x417ME-zvP9X6elmFg_1776843767
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b8ff07df5e4so401094066b.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 00:42:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776843767; cv=none;
        d=google.com; s=arc-20240605;
        b=RNcVViN9+FjM2jExVR3Se4z7Kox0YPL34jlff2ijMeHTtd/KD30JGnyTpdwoNMSp8H
         fHiAlBDOAuqRjDeCkczM/11w0qrtTbYO/q7OeMxOMXKSsKBr1SJU0HVD++XjiQWyJ/Pn
         HfFulOGwPfmNTbd66oU4O+hu5Dht/5QNBXHOA8ulA4pISqRlRbAND3RdC6vLmI0dMbBR
         I9HCdWj09yz3u6UBNqJoZihHsn+jtn7MtWwo7GC6SrOBtQgbNsFRJMM5suZqrGoMGVP3
         IVlvMFfqQ6qFNr14X4CxhU3rwOVpQVHPinWyJyZlhGAfDmescfnFFhPMBNz8gbD4F/e5
         l7mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R7pqyOAjUCUgv3uLiehuAJiB25itYZP57ABnNLwlQcg=;
        fh=clwkdnuvt6MfNmx4IuNEBXt+jxiS+Mutcf4dJKVBWiU=;
        b=lRgufoRkLDXtdj+nIUnWcXMY5ZcdoUeQ7y4yIMtlGPErUAFTyquTYRLCAQ+i3jP6ws
         JWIQKGAg/rx+PiEia1MXsd05dKLBg50g1AlvTGzXjMFJKDYuYBBqvfItPhtsvXfsEHgT
         BY5QmYVZFcmbhrg1Cf0p9zJ07s0smxdLAhhdlHZG+q4V2rJOoaVxSW47wQLbest6i+Ld
         cFaWQtYLDBkRwVZUFDieJXqfTd/pWNxf+J67uGL3neXRGE/g2+9qv2A8NVKIEi1f6PjZ
         CmAso6L/Wdpouul4jDMcVPLDBSEK7Cuh6puw0F0NGb1xKD7HlbBJnYU3W0Wp5h0MXX9F
         lRIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776843767; x=1777448567; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R7pqyOAjUCUgv3uLiehuAJiB25itYZP57ABnNLwlQcg=;
        b=ddVENzxxGxYbqxcxIgSTm2xCQNjhOvRNCBnpUjSlbCr6zjbATCfmTUDhS5szHSSJw5
         m3V7Z3M5Y1tyOjIhazJSbwtRzJTH3EgE1Lk29ZoyVnEmixWp9oaLedrYfETAHpzFl644
         txJBwyWtcI54D87d7Anu80lii/Qb732xDrC8Jy5tO6Y1FH41KxirLwXl89YBhJSvPiIg
         hfjYxh1qRpVFtgP1RR1/hbKzDM9NIVEbx5AOP8tsurxfcDY3IR18csEA3EdT71vPWIl6
         Z+1H5WLjZ/Wd4AyjQUo5wPRQQOdnyQl5b0w4VfHvgFeLweuUvTxI665cUwI6mbrFHInq
         +4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776843767; x=1777448567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R7pqyOAjUCUgv3uLiehuAJiB25itYZP57ABnNLwlQcg=;
        b=ClxPp1jPwK8E1v3lEAsmZBFkozFIDYNcpzrc/JdyZ5qfGMR/NtmE4FNSCVIwDokFRu
         CCRrbJCoc1zO+Ga1Wd59antzsiSGUODJFMO44U+rffGlEv+pJViNwWAqFR+kNkq2s41G
         SS0oVyOMUGe3hhmSjiHA7XJnz4qloMSx74qLCqPmlon5TFosjIkfw7jWSejHHxDCKn5O
         wRj8QeQRCVcqciUTMKhugvgdFeu0u724+fjoVcHVjry1INPNl0hBtqFAuhOGoIOttX2K
         oleHaQnzB6XY1e2DK+JvPWgO/cUp+Hief2xbO/6AjIV3kEEogJuZmtUOCb4S+akZRoJm
         4uUA==
X-Gm-Message-State: AOJu0Yz/MTzt68uYpbV5aXUFovQRh1MSS2zNe97+CgRAuF+Bwn+UpU5C
	QV8hbar2heppnuhgslC6EfRp4DJ7P0IjgEBJzSR0foVUIAJesm4Kv6TF9+d/P6x57pCDZU9RetC
	rRFkN+PPEX/SrSih/0ZcXN9Ab5sLD2y/imrYCUsfEkKRrEcLSbI4aXIeyZ5cpN4RX21FmlK+kid
	ukKxuqbUNt6z2Q7U+uhB/TkJhIv5A3sjz1hpzJ
X-Gm-Gg: AeBDieseCCh9sV+sIW6Mq83YCV1c/TPgCS6DgtY7PVgzv9lexUZUCHJzW2QVmVukQfN
	gkztMHa3SAd/x1moNrsKSqLhCh38uPZvVWMGeBJEbmNMkjizWM6LodlkLMUXiyC4Sj1WFG71kqm
	TLzm3hXkkdvq/Im+S4Yfv2/Gqbp0WIB03eEZrJPDv4rIhUZ2JEjDOtlr6RvJScP9qCXMHj5S+LD
	kMtWprJTS+HOEKxtXXOL2pH7LwkAXqoTdg7i1Ic+yKZSBmg+g==
X-Received: by 2002:a17:907:2d9f:b0:bab:9151:62a1 with SMTP id a640c23a62f3a-bab91516324mr5609966b.23.1776843766880;
        Wed, 22 Apr 2026 00:42:46 -0700 (PDT)
X-Received: by 2002:a17:907:2d9f:b0:bab:9151:62a1 with SMTP id
 a640c23a62f3a-bab91516324mr5607666b.23.1776843766284; Wed, 22 Apr 2026
 00:42:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aeBv_xvDTmuzEhV1@infradead.org> <20260420100637.3584-1-ravising@redhat.com>
 <aehqUzvOHUoyLqvc@infradead.org>
In-Reply-To: <aehqUzvOHUoyLqvc@infradead.org>
From: Ravi Singh <ravising@redhat.com>
Date: Wed, 22 Apr 2026 13:12:34 +0530
X-Gm-Features: AQROBzAP74E-Qp-aIgk3t7Xdv4nHz2B53Q0bjR2_vTiec7DIITxhSJ5YPw7woRw
Message-ID: <CAF-d4OvKr103QWZDwN-d2jdgZN9KpO7E5UOHo30zwP3in3vZZQ@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: flush delalloc blocks on ENOSPC in xfs_trans_alloc_icreate
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, dchinner@redhat.com, esandeen@redhat.com, cem@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 12:02=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> Note: posting the v2 as a reply is a good way to lose track of it,
> don't do that.
>

Understood, will post v3 as a new thread.


> > + * If the block reservation fails with ENOSPC, flush all delalloc bloc=
ks to
> > + * reclaim space from speculative preallocation and retry.  This is si=
milar to
> > + * the quota retry but targets FS-wide ENOSPC.
>
> Can you move this code to sit above the code that implements the
> logic?  It is much more helpful there than at the top of the file.
>
> Otherwise this looks good.
>
>
Thanks. v3 coming shortly with the comment moved.

Thanks,
Ravi

