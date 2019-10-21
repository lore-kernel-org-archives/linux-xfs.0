Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCBACA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3C54214B2
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AUnTybkx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfJUMrU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:47:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54575 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727256AbfJUMrU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 08:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571662038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RKHtGa+7o6veB4goQhcyI44D1dGAucRHPuf2qVv2swk=;
        b=AUnTybkxogXFOjaRsRErlE+PiQrFI0eVDRkbLPhSTSvxxPMEWPoxDSAL34P8tPDwxyjKaa
        NbSXNs/1ejoyb50X8liGmIZdyjiRtMAEXzXncDuwzlM1osaE6hrpSLOb5Hab1BEhb2Aesb
        vSZ9Tg1RuahW+AiuwAUzvPgl0QZ9jzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-L6bEVNFyN-WBaEooEN31Jw-1; Mon, 21 Oct 2019 08:47:17 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DEA81800E00;
        Mon, 21 Oct 2019 12:47:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E162F60BE2;
        Mon, 21 Oct 2019 12:47:15 +0000 (UTC)
Date:   Mon, 21 Oct 2019 08:47:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     vbendel@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: xfs_buftarg_isolate(): "Correctly invert xfs_buftarg LRU
 isolation logic"
Message-ID: <20191021124714.GA26105@bfoster>
References: <CC133B1B9D9B46AFAB2D35A366BF7DC4@alyakaslap>
MIME-Version: 1.0
In-Reply-To: <CC133B1B9D9B46AFAB2D35A366BF7DC4@alyakaslap>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: L6bEVNFyN-WBaEooEN31Jw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 20, 2019 at 05:54:03PM +0300, Alex Lyakas wrote:
> Hello Vratislav, Brian,
>=20
> This is with regards to commit "xfs: Correctly invert xfs_buftarg LRU
> isolation logic" [1].
>=20
> I am hitting this issue in kernel 4.14. However, after some debugging, I =
do
> not fully agree with the commit message, describing the effect of this
> defect.
>=20
> In case b_lru_ref > 1, then indeed this xfs_buf will be taken off the LRU
> list, and immediately added back to it, with b_lru_ref being lesser by 1
> now.
>=20
> In case b_lru_ref=3D=3D1, then this xfs_buf will be similarly isolated (d=
ue to a
> bug), and xfs_buf_rele() will be called on it. But now its b_lru_ref=3D=
=3D0. In
> this case, xfs_buf_rele() will free the buffer, rather than re-adding it
> back to the LRU. This is a problem, because we intended for this buffer t=
o
> have another trip on the LRU. Only when b_lru_ref=3D=3D0 upon entry to
> xfs_buftarg_isolate(), we want to free the buffer. So we are freeing the
> buffer one trip too early in this case.
>=20
> In case b_lru_ref=3D=3D0 (somehow), then due to a bug, this xfs_buf will =
not be
> removed off the LRU. It will remain sitting in the LRU with b_lru_ref=3D=
=3D0. On
> next shrinker call, this xfs_buff will also remain on the LRU, due to the
> same bug. So this xfs_buf will be freed only on unmount or if
> xfs_buf_stale() is called on it.
>=20
> Do you agree with the above?
>=20

I'm not really sure how you're inferring what cases free the buffer vs.
what don't based on ->b_lru_ref. A buffer is freed when its reference
count (->b_hold) drops to zero unless ->b_lru_ref is non-zero, at which
point the buffer goes on the LRU and the LRU itself takes a ->b_hold
reference to keep the buffer from being freed. This reference is not
associated with how many cycles through the LRU a buffer is allowed
before it is dropped from the LRU, which is what ->b_lru_ref tracks.

Since the LRU holds a (single) reference to the buffer just like any
other user of the buffer, it doesn't make any direct decision on when to
free a buffer or not. In other words, the bug fixed by this patch is
related to when we decide to drop the buffer from the LRU based on the
LRU ref count. If the LRU ->b_hold reference happens to be the last on
the buffer when it is dropped from the LRU, then the buffer is freed.

> If so, I think this fix should be backported to stable kernels.
>=20

Seems reasonable to me. Feel free to post a patch. :)

Brian

> Thanks,
> Alex.
>=20
> [1]
> commit 19957a181608d25c8f4136652d0ea00b3738972d
> Author: Vratislav Bendel <vbendel@redhat.com>
> Date:   Tue Mar 6 17:07:44 2018 -0800
>=20
>    xfs: Correctly invert xfs_buftarg LRU isolation logic
>=20
>    Due to an inverted logic mistake in xfs_buftarg_isolate()
>    the xfs_buffers with zero b_lru_ref will take another trip
>    around LRU, while isolating buffers with non-zero b_lru_ref.
>=20
>    Additionally those isolated buffers end up right back on the LRU
>    once they are released, because b_lru_ref remains elevated.
>=20
>    Fix that circuitous route by leaving them on the LRU
>    as originally intended.
>=20
>    Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
>    Reviewed-by: Brian Foster <bfoster@redhat.com>
>    Reviewed-by: Christoph Hellwig <hch@lst.de>
>    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>=20

