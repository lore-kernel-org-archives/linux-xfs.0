Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EADC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 16:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CA04208C7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 16:40:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cdm6RrH1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbgFRQkd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 12:40:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36327 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731969AbgFRQkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 12:40:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592498430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+ZmXo1VT3DgmlBxctO5wOawFr9Ym28t9PdelfkR48g=;
        b=cdm6RrH1NpWejVPngNSf517l/h1SpZ+fivdFekEw1Tn2FRtYit2i3cc6VMnszQ5eKnfPOA
        NlJjO2VVvJU1J0oDvazQ62XrDMo78nqLgdlQrZNYaPAArwfxonJBKCiMb9EJ9D92PshR/h
        FJ/TUNIXe63syEtT8yes1Gd6caokSI0=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-N2SnDs-ZN_qlSBFaVsmn6g-1; Thu, 18 Jun 2020 12:40:28 -0400
X-MC-Unique: N2SnDs-ZN_qlSBFaVsmn6g-1
Received: by mail-oo1-f72.google.com with SMTP id y24so3017890ool.14
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2020 09:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K+ZmXo1VT3DgmlBxctO5wOawFr9Ym28t9PdelfkR48g=;
        b=XIEoBkUbepV6IGnHWVXxxdjaWkcjt1dDMACErfgBAmkCClgnZvHoGeI3b9XUtgW2Jk
         fZDLKB4j0cvamcucyBUPsyRRpIH4eCoyp8lUqKpYEKUs9/FjvrJYn6XbI4ECmn0tKCgB
         F6q3+Lh6boQIPsdmX0MOHlSOXy3p/K+gBRLIrqYGy9vnM3L1djsbhcFwoxaaHoAFoGqc
         vNCUVHerZM5mpjC90x9N76W3isTWrhsxPrSB3sLtL3vkOepfbKWQo3socYjI74jhYIYk
         qWXE2U3MI3vo0gVCPXZgOm4di/WsPKwGhbSGiGa9nTDJYf6uFUU5CaR3P2qLgwwlHElg
         7rOw==
X-Gm-Message-State: AOAM533TwvChfxK9E40eMjbx0EPYnWOdxCnQrhjnhshaBCZkXnCVSQ+I
        3T4Mi5IvKh0WvOtq13Ysj1W9weTJYgKlP8+FlUSU3np66T1rn5hUNk+3DcHW4XAR2NeIDSsZO8n
        9/kqpUUUa7fHtwa61Bhf1fb0NclgUNyPd66ta
X-Received: by 2002:a05:6830:10c8:: with SMTP id z8mr4000186oto.95.1592498427401;
        Thu, 18 Jun 2020 09:40:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE8nhb2Q0d4GxQpaInRB14NGapvcWpYnTg96Ky3B2ltZU9DxgAABVkj/Ptn9PHhgl8mMoH1G9lpq5ufccfhow=
X-Received: by 2002:a05:6830:10c8:: with SMTP id z8mr4000168oto.95.1592498427103;
 Thu, 18 Jun 2020 09:40:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200414150233.24495-1-willy@infradead.org> <20200414150233.24495-17-willy@infradead.org>
 <CAHc6FU4m1M7Tv4scX0UxSiVBqkL=Vcw_z-R7SufL8k7Bw=qPOw@mail.gmail.com>
 <20200617003216.GC8681@bombadil.infradead.org> <CAHpGcMK6Yu0p-FO8CciiySqh+qcWLG-t3hEaUg-rqJnS=2uhqg@mail.gmail.com>
 <20200617022157.GF8681@bombadil.infradead.org> <CAHc6FU7NLRHKRJJ6c2kQT0ig8ed1n+3qR-YcSCWzXOeJCUsLbA@mail.gmail.com>
 <20200618150309.GP8681@bombadil.infradead.org>
In-Reply-To: <20200618150309.GP8681@bombadil.infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 18 Jun 2020 18:40:15 +0200
Message-ID: <CAHc6FU6TYTiQ0a0GkN1dhh3VeQKVKrL+eALvuYzZ8nq5jvNHjg@mail.gmail.com>
Subject: Re: [Cluster-devel] [PATCH v11 16/25] fs: Convert mpage_readpages to mpage_readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        William Kucharski <william.kucharski@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        John Hubbard <jhubbard@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel <cluster-devel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, ocfs2-devel@oss.oracle.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>,
        linux-btrfs@vger.kernel.org,
        Steven Whitehouse <swhiteho@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 5:03 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Jun 18, 2020 at 02:46:03PM +0200, Andreas Gruenbacher wrote:
> > On Wed, Jun 17, 2020 at 4:22 AM Matthew Wilcox <willy@infradead.org> wr=
ote:
> > > On Wed, Jun 17, 2020 at 02:57:14AM +0200, Andreas Gr=C3=83=C2=BCnbach=
er wrote:
> > > > Right, the approach from the following thread might fix this:
> > > >
> > > > https://lore.kernel.org/linux-fsdevel/20191122235324.17245-1-agruen=
ba@redhat.com/T/#t
> > >
> > > In general, I think this is a sound approach.
> > >
> > > Specifically, I think FAULT_FLAG_CACHED can go away.  map_pages()
> > > will bring in the pages which are in the page cache, so when we get t=
o
> > > gfs2_fault(), we know there's a reason to acquire the glock.
> >
> > We'd still be grabbing a glock while holding a dependent page lock.
> > Another process could be holding the glock and could try to grab the
> > same page lock (i.e., a concurrent writer), leading to the same kind
> > of deadlock.
>
> What I'm saying is that gfs2_fault should just be:
>
> +static vm_fault_t gfs2_fault(struct vm_fault *vmf)
> +{
> +       struct inode *inode =3D file_inode(vmf->vma->vm_file);
> +       struct gfs2_inode *ip =3D GFS2_I(inode);
> +       struct gfs2_holder gh;
> +       vm_fault_t ret;
> +       int err;
> +
> +       gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
> +       err =3D gfs2_glock_nq(&gh);
> +       if (err) {
> +               ret =3D block_page_mkwrite_return(err);
> +               goto out_uninit;
> +       }
> +       ret =3D filemap_fault(vmf);
> +       gfs2_glock_dq(&gh);
> +out_uninit:
> +       gfs2_holder_uninit(&gh);
> +       return ret;
> +}
>
> because by the time gfs2_fault() is called, map_pages() has already been
> called and has failed to insert the necessary page, so we should just
> acquire the glock now instead of trying again to look for the page in
> the page cache.

Okay, that's great.

Thanks,
Andreas

