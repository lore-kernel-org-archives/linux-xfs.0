Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25FF16A935
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 12:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724070321; cv=none; b=AwHZ4U0kRPo0Tou6h0nIuf29kXEbg3A2ce9IYD0mwwia1RgYTCvwbeZHzZ5E8jidbCK/LA2fcJ6DDPAii93sQTcnVgE3Hha230MI/Gu+u+Y2W8T00AHx//Gb3KVyx5nviDm8oAw21TPbG0EYmHjhbCq2T/7fhtvdzx5aZ5RTeIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724070321; c=relaxed/simple;
	bh=UQxmvj7TlR5VISdPEwl6/bZra05gJhRUm0F5BS7kOho=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Tgkg3hscbsW4Fi7avLaS3Mcis/CdNQ43wVDx4pasOuU65WvAc0VoMvc2EPjYP7vIUes/Dxbfp+L/wZm4uU35OGmi0zZ6DVi3NBr6WylqIBZOXCUwuZNItuFvBAVB09HDB1q8mXD29s4ippC6nhgwJvBhAl1k7mr6sc2P7C/3W0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K6NRwKsT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K6NRwKsT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724070318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jn1DvOrWmKBpilai8HNN4+kVlfjx6rb9s0iUzARN26I=;
	b=K6NRwKsTP52Gv3d8lAm0Kd9diwLdBKOcnrSlcIQU2VU+xm6pjRHX52nzdMxH8Ybd1FGT43
	SnxOmRAdbVVzVLIbLHabHfSNiYdbN+ZODFJvuOoriOwKoYZuw68q/Jd5u9AW4sVbBGLZrd
	74tjeTZhBp2XLLpvKYMw5mfHtN84X2o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-jpvrPuE3PBWM5CJ5MOxA6g-1; Mon,
 19 Aug 2024 08:25:15 -0400
X-MC-Unique: jpvrPuE3PBWM5CJ5MOxA6g-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F2F7A1955BFE;
	Mon, 19 Aug 2024 12:25:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 323B930001A1;
	Mon, 19 Aug 2024 12:25:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <df26beed-97c7-44e4-b380-2260b8331ea9@suse.de>
References: <df26beed-97c7-44e4-b380-2260b8331ea9@suse.de> <20240818165124.7jrop5sgtv5pjd3g@quentin> <20240815090849.972355-1-kernel@pankajraghav.com> <2924797.1723836663@warthog.procyon.org.uk> <3141777.1724012176@warthog.procyon.org.uk>
To: Hannes Reinecke <hare@suse.de>
Cc: dhowells@redhat.com,
    "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
    brauner@kernel.org, akpm@linux-foundation.org,
    chandan.babu@oracle.com, linux-fsdevel@vger.kernel.org,
    djwong@kernel.org, gost.dev@samsung.com, linux-xfs@vger.kernel.org,
    hch@lst.de, david@fromorbit.com, Zi Yan <ziy@nvidia.com>,
    yang@os.amperecomputing.com, linux-kernel@vger.kernel.org,
    linux-mm@kvack.org, willy@infradead.org, john.g.garry@oracle.com,
    cl@os.amperecomputing.com, p.raghav@samsung.com, mcgrof@kernel.org,
    ryan.roberts@arm.com
Subject: Re: [PATCH v12 00/10] enable bs > ps in XFS
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3407980.1724070304.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Aug 2024 13:25:05 +0100
Message-ID: <3407981.1724070305@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hannes Reinecke <hare@suse.de> wrote:

> IE you essentially nail AFS to use PAGE_SIZE.
> Not sure how you would tell AFS to use a different block size;
> maybe a mount option?

As far as I know:

        sb->s_blocksize         =3D PAGE_SIZE;
        sb->s_blocksize_bits    =3D PAGE_SHIFT;

isn't used by the VM.

> Hmm. I'd rather fix the obvious places in afs first; just do a quick
> grep for 'PAGE_', that'll give you a good impression of places to look a=
t.

Sure:

   fs/afs/dir.c:   nr_pages =3D (i_size + PAGE_SIZE - 1) / PAGE_SIZE;
   fs/afs/dir.c:   req->len =3D nr_pages * PAGE_SIZE; /* We can ask for mo=
re than there is */
   fs/afs/dir.c:           task_io_account_read(PAGE_SIZE * req->nr_pages)=
;
   fs/afs/dir.c:           folio =3D __filemap_get_folio(dir->i_mapping, c=
tx->pos / PAGE_SIZE,
   fs/afs/xdr_fs.h:#define AFS_DIR_BLOCKS_PER_PAGE (PAGE_SIZE / AFS_DIR_BL=
OCK_SIZE)

Those only affect directories.

   fs/afs/mntpt.c:         if (size < 2 || size > PAGE_SIZE - 1)

That only affects mountpoint symlinks.

   fs/afs/super.c: sb->s_blocksize         =3D PAGE_SIZE;

This is the only thing (and sb->s_blocksize_bits) that might affect files.=
  I
checked, and doubling this and adding 1 to bits does not alter the outcome=
.

Now, the VM wrangling is offloaded to netfslib, and most of that is to do =
with
converting between indices and file positions.  Going through the usages o=
f
PAGE_SIZE there:

   fs/netfs/buffered_read.c:               size +=3D PAGE_SIZE << order;

That was recording the size of a folio readahead allocated.

   fs/netfs/buffered_read.c:       size_t nr_bvec =3D flen / PAGE_SIZE + 2=
;
   fs/netfs/buffered_read.c:               part =3D min_t(size_t, to - off=
, PAGE_SIZE);

Those two are used to fill in the gaps around a partial page - but that di=
dn't
appear in the logs.

   fs/netfs/buffered_write.c:      pgoff_t index =3D pos / PAGE_SIZE;
   fs/netfs/buffered_write.c:              fgp_flags |=3D fgf_set_order(po=
s % PAGE_SIZE + part);

Those two are used when asking __filemap_get_folio() to allocate a folio t=
o
write into.  I got a folio of the right size and index, so that's not the
problem.

   fs/netfs/fscache_io.c:  pgoff_t first =3D start / PAGE_SIZE;
   fs/netfs/fscache_io.c:  pgoff_t last =3D (start + len - 1) / PAGE_SIZE;

Caching is not enabled at the moment, so these don't happen.

   fs/netfs/iterator.c:            cur_npages =3D DIV_ROUND_UP(ret, PAGE_S=
IZE);
   fs/netfs/iterator.c:                    len =3D ret > PAGE_SIZE ? PAGE_=
SIZE : ret;

I'm not doing DIO, so these aren't used.

   fs/netfs/iterator.c:    pgoff_t index =3D pos / PAGE_SIZE;

I'm not using an ITER_XARRAY iterator, so this doesn't happen.

   fs/netfs/misc.c:        rreq->io_iter.count +=3D PAGE_SIZE << order;

This is just multiplying up the folio size to add to the byte count.

   fs/netfs/read_collect.c:        fsize =3D PAGE_SIZE << subreq->curr_fol=
io_order;
   fs/netfs/read_collect.c:            WARN_ON_ONCE(folioq_folio(folioq, s=
lot)->index !=3D fpos / PAGE_SIZE)) {

These two are converting between a file pos and an index - but only during
read, and I can see from wireshark that we're writing the wrong data to th=
e
server before we get this far.

And that's all the PAGE_SIZE usages in afs and netfslib.

David

