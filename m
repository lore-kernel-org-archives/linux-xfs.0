Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC43C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 942A52063A
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593466878;
	bh=fbNV2p8AknATNCvchaixaZk7J1gfSAuksWkmaOa87ec=;
	h=Date:In-Reply-To:References:Subject:To:CC:From:List-ID:From;
	b=Vylo6+KZYRUP1GShgiaDT3C9ok1uGuqJwqAtzz1YiZcYkBGZOx4VriIE4femoZxs/
	 W+4H4Wtp55hRzSyZ0qRGDiilacUo2aCEmPApAne4N5qyK+3MSiIntWy7WUeWEZ130h
	 gDCjVhPppz3L+rczYAAGC9VfZbEZm8B4DrSJf8xI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgF2VlR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgF2SkU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:20 -0400
Received: from [10.56.182.155] (unknown [2.55.133.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 966E123B06;
        Mon, 29 Jun 2020 13:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593438323;
        bh=fbNV2p8AknATNCvchaixaZk7J1gfSAuksWkmaOa87ec=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=rIJqavQGtKdDnlgH17SXo4lT2EuWXNLVpkw36+4fLHQ8xavualOqCc/Ck325eOUP4
         T6UtQ8bd6poUsB+upMM3i3e7JAMyx/cHy79ZP65sGoWQxmU0HpOCbo6LWjBK+yfvxQ
         96jSvpY1gUv1qWQtZ4Eur6wDToh2ek3ph+aiMBu4=
Date:   Mon, 29 Jun 2020 16:45:14 +0300
User-Agent: K-9 Mail for Android
In-Reply-To: <20200629125231.GJ32461@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org> <20200625113122.7540-7-willy@infradead.org> <20200629050851.GC1492837@kernel.org> <20200629121816.GC25523@casper.infradead.org> <20200629125231.GJ32461@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
To:     Michal Hocko <mhocko@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
CC:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
From:   Mike Rapoport <rppt@kernel.org>
Message-ID: <6421BC93-CF2F-4697-B5CB-5ECDAA9FCB37@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On June 29, 2020 3:52:31 PM GMT+03:00, Michal Hocko <mhocko@kernel=2Eorg> =
wrote:
>On Mon 29-06-20 13:18:16, Matthew Wilcox wrote:
>> On Mon, Jun 29, 2020 at 08:08:51AM +0300, Mike Rapoport wrote:
>> > > @@ -886,8 +868,12 @@ static struct dm_buffer
>*__alloc_buffer_wait_no_callback(struct dm_bufio_client
>> > >  			return NULL;
>> > > =20
>> > >  		if (dm_bufio_cache_size_latch !=3D 1 && !tried_noio_alloc) {
>> > > +			unsigned noio_flag;
>> > > +
>> > >  			dm_bufio_unlock(c);
>> > > -			b =3D alloc_buffer(c, GFP_NOIO | __GFP_NORETRY |
>__GFP_NOMEMALLOC | __GFP_NOWARN);
>> > > +			noio_flag =3D memalloc_noio_save();
>> >=20
>> > I've read the series twice and I'm still missing the definition of
>> > memalloc_noio_save()=2E
>> >=20
>> > And also it would be nice to have a paragraph about it in
>> > Documentation/core-api/memory-allocation=2Erst
>>=20
>>
>Documentation/core-api/gfp_mask-from-fs-io=2Erst:``memalloc_nofs_save``,
>``memalloc_nofs_restore`` respectively ``memalloc_noio_save``,
>> Documentation/core-api/gfp_mask-from-fs-io=2Erst:   :functions:
>memalloc_noio_save memalloc_noio_restore
>> Documentation/core-api/gfp_mask-from-fs-io=2Erst:allows nesting so it
>is safe to call ``memalloc_noio_save`` or
>=20
>The patch is adding memalloc_nowait* and I suspect Mike had that in
>mind, which would be a fair request=2E=20

Right, sorry misprinted that=2E

> Btw=2E we are missing
>memalloc_nocma*
>documentation either - I was just reminded of its existence today=2E=2E
--=20
Sincerely yours,
Mike
