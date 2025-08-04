Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B1D215793
	for <linux-xfs@vger.kernel.org>; Mon,  4 Aug 2025 11:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754307290; cv=none; b=SWjIE+p2n7sy8ymYFM3i+Fk7kfaaWFy73mHehOsOVqgJghH5XVjRtmLWIx1Qo2ScQVu3UYTnJ8aVQkYFJnhY4oR5lCu7f3wqL620DR6ftKSwUC9D+fVZWxqttQBQItTH7yqkuCgTGq2FtnSHRTq2Tmr0nv4HSgPQgvGK/snRxmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754307290; c=relaxed/simple;
	bh=ulhD4ZkuDAK3k2qDQl0X7/UyqpKU+NyG3I0TjP00sss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MA3dPxEo+E4tVHMwzTH5ZGtliViIfblN3+8Sh/DH/QPxVk+7WobxhdEWj38J5V7OElt8UC8J3EAu5Xp96CB+qQ2uzRKwgQb2iezldxIP+ov13yS23gDAf4ExsB85rA6HR6IMQpdWqp1cBeIgdo0TfdnSbG+bgLyDSuNacwfVtK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WJsKnsNU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WJsKnsNU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754307286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3V1T20G7TfHh7dK0HImr9yuZ74iE23wyw4ljPa6v4iQ=;
	b=WJsKnsNUcPz6UO4TkAB21UigK36qjuEAwtEXhEJxgQxrvIvqXvlnUPp0KyLZj2uKlMTtOu
	4Dj4Jg5GbE106gQTgNa88ZfaE0pMXnMPdOlSWipAJSktT4CZHhlSiujqHoTEMlKkYjHLhA
	kMqy4Lg7dPEj7SeQBfR5yFn7Do+tXfI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-yJS1yXwKPMSGxPCX3ovGdA-1; Mon, 04 Aug 2025 07:34:45 -0400
X-MC-Unique: yJS1yXwKPMSGxPCX3ovGdA-1
X-Mimecast-MFC-AGG-ID: yJS1yXwKPMSGxPCX3ovGdA_1754307284
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7889c8d2bso1691607f8f.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Aug 2025 04:34:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754307284; x=1754912084;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3V1T20G7TfHh7dK0HImr9yuZ74iE23wyw4ljPa6v4iQ=;
        b=Mi++jw9YqZXRZ43XrW5rkf79+WNMl2WpFjoo1j3fXZsvxdbiqkslMf7bsaKtqI0jKd
         RNw5HpTWtTW3Ge3yGmrDmbC1k4n6LSRKB9t6TI2ZQ8sp/kdyN26cA6Nxm6oTC9j6Cec8
         CCCddwhKSI26vg2Phe8FVk2aWtlHP/w2LKfX7/PeM4y1jR4G2MZuvfdXUOxAntp9jybx
         mNmVPFAcXrHafhiIGf3Bn99Zl8DdNujykK4pFIb04Y1k577yk5kTfFndhUd37xhMtSCu
         D7CYWZCtJPWlyDNotrlvZ4AFL3EdBETupvXp20o9vIz5dOWYWJyTqOau0DW2YzAhuwXw
         YKtA==
X-Forwarded-Encrypted: i=1; AJvYcCW7Wcgu3eLvXk8F5xgrh5SbjwoZxfJTL0633nPXMbL5g4YTg+H5Bdj3Sx4Q0OfJJLUxQDizy/L+16Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ7nkXVZlL8QVBKJY6LhLwxv13FSLaZrfOvAzWxkozFkKfHyqA
	0KJxhVxc3e0XY6gdrKs5i6N1bwA0yLsOVR557/8oOpzzvFIqtq2/YVPPXdmAQgF0X1Dwdas43Ef
	V54DuHXBa44xjuvNwO4REcIPvc+MLUzOcO82TiYO66fVKWet4G5+K3yWULwIG
X-Gm-Gg: ASbGnctMLRF6jN3zVYLIoAXMvhM3Y+xlsQR8pz1Ger9oca+DA+ZWDK2xr/vgqynIYBF
	+fskC/cguP2EYw8F463ZyD2SroZpmiYIU0uyCpzlpDU/UfthpufPA7H4y2zW4lajF5Q354sAyGM
	XhoHtdXb6Tlmu1cBe7MetS/P51HNvWk5keuOc4EJs8WiIXtSZNy628kdjzC3MZAj+lWjmdwHXtp
	KiQYO878ibA+5OXu/bZLM2HrSTxEx2ZVdFnkRxtHcO/scc7zPBAgXxgMhT34d5IDKvuNuh3Y6ad
	j324cDeia06NYZnfwQXytZ+BUTOJZbaAVIh8ZJxWGhfkd9A651utKT6p840=
X-Received: by 2002:a05:6000:4308:b0:3b7:9af4:9c75 with SMTP id ffacd0b85a97d-3b8d94b5f5cmr5721831f8f.30.1754307283907;
        Mon, 04 Aug 2025 04:34:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECSNlAqX2SbDaV4025aA/QtAgxGcECmwvMzo9vl9cLxYwe+gfIm+JQX3+RGKTbSCjXQi1ysQ==
X-Received: by 2002:a05:6000:4308:b0:3b7:9af4:9c75 with SMTP id ffacd0b85a97d-3b8d94b5f5cmr5721809f8f.30.1754307283439;
        Mon, 04 Aug 2025 04:34:43 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ad803sm15173444f8f.6.2025.08.04.04.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 04:34:43 -0700 (PDT)
Date: Mon, 4 Aug 2025 13:34:41 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, ebiggers@kernel.org, 
	hch@lst.de, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 01/29] iomap: add iomap_writepages_unbound() to write
 beyond EOF
Message-ID: <nusz22lytklhy2qlc6ihpp3onpwckbvpo5lohmcsfyjbgnprqm@mi6u5fleplah>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
 <20250728-fsverity-v1-1-9e5443af0e34@kernel.org>
 <CAJnrk1ambrfq-bMdTSgj=pPrGW6GA1Jgwjvx8=sy8SVR67=bJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ambrfq-bMdTSgj=pPrGW6GA1Jgwjvx8=sy8SVR67=bJA@mail.gmail.com>

On 2025-07-31 11:43:52, Joanne Koong wrote:
> On Mon, Jul 28, 2025 at 1:31 PM Andrey Albershteyn <aalbersh@redhat.com> wrote:
> >
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> >
> > Add iomap_writepages_unbound() without limit in form of EOF. XFS
> > will use this to write metadata (fs-verity Merkle tree) in range far
> > beyond EOF.
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/iomap/buffered-io.c | 51 +++++++++++++++++++++++++++++++++++++++-----------
> >  include/linux/iomap.h  |  3 +++
> >  2 files changed, 43 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 3729391a18f3..7bef232254a3 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -1881,18 +1881,10 @@ static int iomap_writepage_map(struct iomap_writepage_ctx *wpc,
> >         int error = 0;
> >         u32 rlen;
> >
> > -       WARN_ON_ONCE(!folio_test_locked(folio));
> > -       WARN_ON_ONCE(folio_test_dirty(folio));
> > -       WARN_ON_ONCE(folio_test_writeback(folio));
> > -
> > -       trace_iomap_writepage(inode, pos, folio_size(folio));
> > -
> > -       if (!iomap_writepage_handle_eof(folio, inode, &end_pos)) {
> > -               folio_unlock(folio);
> > -               return 0;
> > -       }
> >         WARN_ON_ONCE(end_pos <= pos);
> >
> > +       trace_iomap_writepage(inode, pos, folio_size(folio));
> > +
> >         if (i_blocks_per_folio(inode, folio) > 1) {
> >                 if (!ifs) {
> >                         ifs = ifs_alloc(inode, folio, 0);
> > @@ -1956,6 +1948,23 @@ static int iomap_writepage_map(struct iomap_writepage_ctx *wpc,
> >         return error;
> >  }
> >
> > +/* Map pages bound by EOF */
> > +static int iomap_writepage_map_eof(struct iomap_writepage_ctx *wpc,
> > +               struct writeback_control *wbc, struct folio *folio)
> > +{
> > +       int error;
> > +       struct inode *inode = folio->mapping->host;
> > +       u64 end_pos = folio_pos(folio) + folio_size(folio);
> > +
> > +       if (!iomap_writepage_handle_eof(folio, inode, &end_pos)) {
> > +               folio_unlock(folio);
> > +               return 0;
> > +       }
> > +
> > +       error = iomap_writepage_map(wpc, wbc, folio);
> > +       return error;
> > +}
> > +
> >  int
> >  iomap_writepages(struct address_space *mapping, struct writeback_control *wbc,
> >                 struct iomap_writepage_ctx *wpc,
> > @@ -1972,9 +1981,29 @@ iomap_writepages(struct address_space *mapping, struct writeback_control *wbc,
> >                         PF_MEMALLOC))
> >                 return -EIO;
> >
> > +       wpc->ops = ops;
> > +       while ((folio = writeback_iter(mapping, wbc, folio, &error))) {
> > +               WARN_ON_ONCE(!folio_test_locked(folio));
> > +               WARN_ON_ONCE(folio_test_dirty(folio));
> > +               WARN_ON_ONCE(folio_test_writeback(folio));
> > +
> > +               error = iomap_writepage_map_eof(wpc, wbc, folio);
> > +       }
> > +       return iomap_submit_ioend(wpc, error);
> > +}
> > +EXPORT_SYMBOL_GPL(iomap_writepages);
> > +
> > +int
> > +iomap_writepages_unbound(struct address_space *mapping, struct writeback_control *wbc,
> > +               struct iomap_writepage_ctx *wpc,
> > +               const struct iomap_writeback_ops *ops)
> > +{
> > +       struct folio *folio = NULL;
> > +       int error;
> > +
> >         wpc->ops = ops;
> >         while ((folio = writeback_iter(mapping, wbc, folio, &error)))
> >                 error = iomap_writepage_map(wpc, wbc, folio);
> >         return iomap_submit_ioend(wpc, error);
> >  }
> > -EXPORT_SYMBOL_GPL(iomap_writepages);
> > +EXPORT_SYMBOL_GPL(iomap_writepages_unbound);
> > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > index 522644d62f30..4a0b5ebb79e9 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> > @@ -464,6 +464,9 @@ void iomap_sort_ioends(struct list_head *ioend_list);
> >  int iomap_writepages(struct address_space *mapping,
> >                 struct writeback_control *wbc, struct iomap_writepage_ctx *wpc,
> >                 const struct iomap_writeback_ops *ops);
> > +int iomap_writepages_unbound(struct address_space *mapping,
> > +               struct writeback_control *wbc, struct iomap_writepage_ctx *wpc,
> > +               const struct iomap_writeback_ops *ops);
> >
> 
> Just curious, instead of having a new api for
> iomap_writepages_unbound, does adding a bitfield for unbound to the
> iomap_writepage_ctx struct suffice? afaict, the logic between the two
> paths is identical except for the iomap_writepage_handle_eof() call
> and some WARN_ONs - if that gets gated behind the bitfield check, then
> it seems like it does the same thing logically but imo is more
> straightforward to follow the code flow of. But maybe I"m missing some
> reason why this wouldn't work?

Yeah, that's another option. If others also prefer flag then I can
change it.

-- 
- Andrey

