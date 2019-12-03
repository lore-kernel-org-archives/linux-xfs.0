Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62BEC432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 14:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B4AE206EC
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 14:09:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NXodihu0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLCOJu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 09:09:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29001 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbfLCOJu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 09:09:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575382189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kJqJhQ7GYHkK2UfyImqqd3plr3sBM5AsWSOU5GUmWD0=;
        b=NXodihu0i+HQzg+oLsd5drTl7w2JuWe9sa2Ss0FSrtqtqNz4YI8oAd6kwDyzII/7C1QsJ6
        9raaPRcPNrIlj+fJ+IIZ9/xDacbvVYPf60erqQiSdIf5brHwpuksFMjbiaxypYPPJWiPxT
        p+y7Ieyu5Q5blaJXduBOumQO/LRULqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-_WdAC45VNk683yO4Dlv9BQ-1; Tue, 03 Dec 2019 09:09:47 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E9381005512
        for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2019 14:09:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 190515D6A7
        for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2019 14:09:46 +0000 (UTC)
Date:   Tue, 3 Dec 2019 09:09:45 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix mount failure crash on invalid iclog memory
 access
Message-ID: <20191203140945.GD18418@bfoster>
References: <20191203140524.36043-1-bfoster@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191203140524.36043-1-bfoster@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: _WdAC45VNk683yO4Dlv9BQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 03, 2019 at 09:05:24AM -0500, Brian Foster wrote:
> syzbot (via KASAN) reports a use-after-free in the error path of
> xlog_alloc_log(). Specifically, the iclog freeing loop doesn't
> handle the case of a fully initialized ->l_iclog linked list.
> Instead, it assumes that the list is partially constructed and NULL
> terminated.
>=20
> This bug manifested because there was no possible error scenario
> after iclog list setup when the original code was added.  Subsequent
> code and associated error conditions were added some time later,
> while the original error handling code was never updated. Fix up the
> error loop to terminate either on a NULL iclog or reaching the end
> of the list.
>=20
> Reported-by: syzbot+c732f8644185de340492@syzkaller.appspotmail.com
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---

Hmm.. I didn't realize Hillf Danton already replied to the original
thread with this same fix until I looked at the ML archive. His reply
isn't in my mailbox for some reason. Anyways, feel free to skip this
patch in favor of that one..

Brian

>  fs/xfs/xfs_log.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6a147c63a8a6..f6006d94a581 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1542,6 +1542,8 @@ xlog_alloc_log(
>  =09=09prev_iclog =3D iclog->ic_next;
>  =09=09kmem_free(iclog->ic_data);
>  =09=09kmem_free(iclog);
> +=09=09if (prev_iclog =3D=3D log->l_iclog)
> +=09=09=09break;
>  =09}
>  out_free_log:
>  =09kmem_free(log);
> --=20
> 2.20.1
>=20

