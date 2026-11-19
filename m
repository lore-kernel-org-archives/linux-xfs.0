Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795047181;
	b=PkTU50v6zuZ8FoXz0qjkUJ7fFsvhQmqvnMiXfZWIIU6AhVNgqwinmEmI8w0T8dOSwflm
	 0F73aRKswdKjyj/t1WRlh26p/HhL+hAJi7AKrYnxamBC8WSXg8+677G+5rsBHx3RmiXaq
	 Bi/bsamgv5r5hNZxD1MRzAfVysUQCk8UcSM9W7tSsdx/cXbl2lio6aHWig33pF8PHwHCT
	 xCVs4AYXwVGs1FjLFNB3jabWqyPsGtfk0i6lWtL83A7B3lNzkwi/5ArP3zmojgjI5URUp
	 LXZvwKzJNziT5aZicr5V+BHMOPJyyaXLdiD85RYWkdQu0PtoDBqmbVaNKTffW9A40EQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047181;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=077/TizvhH3iQcetqO0vvepvTnfIkqb5hqSDa7XFIt8=;
	b=ifYD66awqwYQSiVgyTxDyFStCw+7hH/NAjl3wXOG/AkAcIIG6prddbu1NZmLeOv4qnHh
	 yUHwjtgJ/Po74YeM9pFSv/UchDUWCKpHq9crcfg5bBSkIwo6u0CpMaRsOgErwFId73nd1
	 IPn6+YoLAevFMjy480ndcfiQ93NLIB8/EflLWCrLykj4UEEFJ6eFnDurUgcgGSyYeo3JR
	 Dz15JoYMC5r3653UWldg4EGA+/A2v8Nqo8k26xPNPoTMqzfXUI+Um6zrBSAO14PcFKgd4
	 cNiVB/Z0MEcA4qzpK4/9B4P89OkMphP8G4+My++3qEX3hDHY1r/SxKa/ZSJrT+HfAjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DkK0PJGZ;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=gUck6dLA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FF1606A332
	for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 00:13:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12FF1606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DkK0PJGZ;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=gUck6dLA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795047180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=077/TizvhH3iQcetqO0vvepvTnfIkqb5hqSDa7XFIt8=;
	b=DkK0PJGZuU6xjETr8IRYKlcNarjz50cFTcBVw20h8LQ8DbaJqNlOkLygouqeiVQ6f9BAMj
	hlYkXzCB5swKDdnXWJS9JX5e2ITrFTcvHgf++ruGyd2Z7eCOMQtCTwwievMnz3V803ec/q
	h8sgZGiWP9NInZCCic8F2tddi1D6QTY=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-BkHV9lBdMfKIVlO10oTxIw-1; Wed, 18 Nov 2026 19:12:58 -0500
X-MC-Unique: BkHV9lBdMfKIVlO10oTxIw-1
X-Mimecast-MFC-AGG-ID: BkHV9lBdMfKIVlO10oTxIw_1795047178
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-8b37869f851so24720197b3.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 16:12:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795047178; cv=none;
        d=google.com; s=arc-20260327;
        b=TDY9C0RDxNSkQVQU3KFRW3qHty//s/erssSQQli8yzuCdwvopu/Fx5vuXi+1oCmpKP
         H5XcF3NCJwbwTEEVjNYVReHxn9acimIPLQbexRui31smtF0ohzrgOqEWpHD7tmiPkScg
         enCtCEIzxBC/3jMbZ8NPI/ijY4qXZk1hR5EcC7B98NkxPxeqrdRf05RlNwsBbMWfcE/e
         nEdFGPhxHYQi9ay5qltF4VRxCefCpE8RPsnIGXrCuw9T8WCfgkJ1tuZaghVo340bV1Tv
         c84cZLs/EAlhIxqCXqxuTSbaHr9EPWu77i1zIb1bmb8BS6D7+kYy1rYV0PCmqxFFLauD
         o8qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=077/TizvhH3iQcetqO0vvepvTnfIkqb5hqSDa7XFIt8=;
        fh=Z9sXs9yH3/suXM9MrlyDTaF+O4Wps3RxmgBBnycY/E0=;
        b=a7s6pIwBAFoV/8WcTQuNPioTkBqF5UsFSr4E2+vxfgxgizKD9ceL6+JbI5wrna7awK
         kKPpB6qckjNkdosVH2XC1LZZJfAaAm2ShThkkqgJzLR/vQ0C/fIqhtjGnXH1ctL++FhJ
         heqXKvA1vYeriGYa+i7qMmOxAt/tD1MS1f7I7h+GXOsOrrNxx8y6NFsE87dkBQqiGTR1
         Fj461DeewprQQ7YEXgVVePdTrqF7uCPtq7/nDZrXGf49/nD/I36M+TR6PRUeQ4F3Talr
         zPdy+0nw7VEZy2B/AdwBjqofioozhmcXc6iiWaODmH29cLqSzSHw73pP5cOPeF+1+43h
         QSqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795047178; x=1795651978; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=077/TizvhH3iQcetqO0vvepvTnfIkqb5hqSDa7XFIt8=;
        b=gUck6dLAwdhYR60Buifwx95UYkvNlKNRmPnyo7USrjas+FkHH6q0XlA8zMbJUAOSEc
         4esQdx6pFabYHTtqUnRAbnqHQA+DgcA1v9Z8q382bLMxM7p546hudO1FBCaRByt15IEm
         /5vyT5BVDmw2cAmmuJOGyhMjBm6Z38q8chTcv+ssHh/G49YDGn4gHaXvGAwNX+jSP5Bt
         Y6dNlXK3huhbk8odG0lKZoxQMQgtT0ra6l6EpuazzBV6saVVp3imwrgtOTJyno51uUmc
         6zZmOUm07V1gdA8XhQX9VKm6Mrqa2q5yZBP+0CYfzheFkQJZm4upXymWAt8SIYWCbdr8
         DWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795047178; x=1795651978;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=077/TizvhH3iQcetqO0vvepvTnfIkqb5hqSDa7XFIt8=;
        b=dWns7rB2DS50wgTalA4pORIaCCQOJ+n/IoplzG30URPgmROElmwk+omaOYxFGy7lGp
         whXldoAv6SKS0A7opBNQDSr74Rp1Y/QDsL1QvwkNMqL5ITPWrDbQots4LCykqQ+aORnk
         tqVCvM9X9NbaIBkyovrFRIchpyqo0Imx8AphcTILFI2P6lMRuSooAJKnj+PE4XtFnLUK
         rpheQw9czU8D52BiUkivcdKH+V1dgb6m4kskUXFHZCkImKNai7oLLiKJpy9JHI7U/odx
         TC0XEzxSNq45tap3hUeYno7W1xe+KQ/p2JMaBCQfpeNRI3XwDXsO3hqGXG8kXa8aN/ej
         rSUg==
X-Forwarded-Encrypted: i=1; AL+hErFBDXZ5dUkjtCRp9gxobN6d3Jogg8/WeUddi6+FVJx1zwz5T1VSWP18sLtxzodVgMAnO+gYDHpe/xg=@vger.kernel.org
X-Gm-Message-State: APuU4Z8lZqfqf85wbS11YCRF3rRE8HBpqopZUgIZluubGy0Xm01iFyM9
	LlZtQ7GgDG/fCGK1zKS/mSBFbT+Lunzb+S0Fl986K+iW+ouZ/msskzXgxTA7g1Lw1Zb0JLAXIow
	6C3GLemM1L1SQP84Fw2PqVnYBdjMkIDmZOR0lmkYsQL+msRZ/hSZCdLsDKXnxJ69T1V77R0chbJ
	w++m9Kl4OAVHA6mW8HH7XCwcn0NOyesGcvjPPp
X-Gm-Gg: AZFdTZeKWqcUqvL1Dkrb0yYzyZNPWvMl+bxxF/fuMjeV/DtyN5jAdwGRK6W6RV/cs4/
	rmw8Y+OzuHJfTiiOtx1jXUKk/WhcpSfTF/x9tN/qbKywtvrb81yBdwIYuGdscjY7FHOQeTLI7Kn
	8nxXclHzSMRTGIjFy8JfvxwAK5u6svRSXhttxE80EJ8f7f7iI3tbPybt0cHaeHKtF63SdsvDND1
	XG99pbnhuEyEMsnnlqKt8kbaVpfs9h8Jg+5q4BpiHW9Ag==
X-Received: by 2002:a05:690e:1907:b0:67d:b34c:9f19 with SMTP id 956f58d0204a3-67dd3fdcc80mr1565913d50.106.1795047177772;
        Wed, 18 Nov 2026 16:12:57 -0800 (PST)
X-Received: by 2002:a05:690e:1907:b0:67d:b34c:9f19 with SMTP id
 956f58d0204a3-67dd3fdcc80mr1565894d50.106.1795047177150; Wed, 18 Nov 2026
 16:12:57 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116171044.6938-1-jack@suse.cz> <20261118145941.1063127-22-jack@suse.cz>
In-Reply-To: <20261118145941.1063127-22-jack@suse.cz>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 19 Nov 2026 01:12:45 +0100
X-Gm-Features: AclHuK8R-2iEv0c9btS3snfH7Yzq75Yl9vf1mN1FPuSVCWTRM2Ut7aYcwFy-L9Y
Message-ID: <CAHc6FU4+FV=A2UK1oPejHSt5XQ2Ox+CyvZfT4Q17YaceJ+NJ1w@mail.gmail.com>
Subject: Re: [PATCH 09/13] gfs2: Fix dirtiness checks in gfs2_write_inode()
 and evict_linked_inode()
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, devel@lists.orangefs.org, 
	Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	linux-afs@lists.infradead.org, Miklos Szeredi <miklos@szeredi.hu>, 
	fuse-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ja,


thanks for catching this.

On Wed, Nov 18, 2026 at 4:00=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> The checks are bogus because they check against inode->i_flags instead
> of inode->i_state. Use the inode_or_folios_dirty() helper which actually
> checks what was intended.
>
> Fixes: 957a7acd46e6 ("gfs2: Remove inode from ordered write list in gfs2_=
write_inode()")
> Fixes: bd67f17718cc ("gfs2: Fix data loss during inode evict")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/gfs2/super.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> index 04bb4cf787d4..9b723dd591a5 100644
> --- a/fs/gfs2/super.c
> +++ b/fs/gfs2/super.c
> @@ -460,7 +460,7 @@ static int gfs2_write_inode(struct inode *inode, stru=
ct writeback_control *wbc)
>                 mark_inode_dirty_sync(inode);
>         else {
>                 spin_lock(&inode->i_lock);
> -               if (!(inode->i_flags & I_DIRTY))
> +               if (!inode_or_folios_dirty(inode))
>                         gfs2_ordered_del_inode(ip);
>                 spin_unlock(&inode->i_lock);
>         }
> @@ -1418,7 +1418,8 @@ static int evict_linked_inode(struct inode *inode, =
struct gfs2_holder *gh)
>         struct address_space *metamapping =3D gfs2_glock2aspace(gl);
>         int ret;
>
> -       if (!(test_bit(GLF_DIRTY, &gl->gl_flags) || inode->i_flags & I_DI=
RTY))
> +       if (!(test_bit(GLF_DIRTY, &gl->gl_flags) ||
> +             inode_or_folios_dirty(inode)))
>                 goto clean;
>
>         /* The inode glock must be held exclusively and be instantiated. =
*/
> --
> 2.53.0
>

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

Andreas

