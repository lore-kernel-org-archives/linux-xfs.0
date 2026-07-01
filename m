Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271ED34678C
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 20:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782939082; cv=pass; b=AJxeKOhx2zQsMjPzcPk+SaCnr2hSJyGY6EejcaO4NCwa8tjco9jBBk5H36JR3AgIUo9XhiB+k2Ky68waLjTs0caFCO1fur0OiM9Rg2V7n8fIaUyKIaeXfexKlUJOVKioUfyLQwNmO8tpSuHdHOt7J3nfSfm+Sbe7zTrHAMCQNos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782939082; c=relaxed/simple;
	bh=CXbyE5jAZaxhOqn1wsrHntSB48IwpOuSpEKralUyb4c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=URuOWBOC42k6MYsFndTCoHLIrOX/p10JNcL17/62+CpO23nLwYaNIlBkrwBMb8j2k1/PzkYtTSVlEOieYl9PQdmj27HO94AmUiH8GEz02aU4gkRw5pdBtXB+F97xnpNK+MWPs3XwvhSp/H8flvy+mrWS2CcqDsw+hl+wMSVvqvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M8d67CwD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=q9NIEAjb; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M8d67CwD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="q9NIEAjb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782939079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=XF81/sKTmZ1AnlJSj3x2T7mD8T/hF0ps/9K/nqtvitg=;
	b=M8d67CwDGJgWwxhIubBTlpkFwjw7Fz+LyeDmRbAtbDgDKJ7unua66X0YgfLWXcSg4O/Bmo
	oYcmbo0g/MCWAwGgJteUXeTDW09mZ2YWbtj8GUSiqhklvqfMNVwbYkIcFRHdmostnV2u0m
	WN7ignq9bbi1+9h7gUTTBY2y0K6U8b8=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-fiRqSRe_M9amSDGNTl0mpw-1; Wed, 01 Jul 2026 16:51:18 -0400
X-MC-Unique: fiRqSRe_M9amSDGNTl0mpw-1
X-Mimecast-MFC-AGG-ID: fiRqSRe_M9amSDGNTl0mpw_1782939077
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-664d0ac7dd7so2890272d50.2
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2026 13:51:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782939077; cv=none;
        d=google.com; s=arc-20260327;
        b=B/AOMeH9XkZuYCmGryf+kwoOuhI4hfGn1ze7RdcPxGXs3uywaVP9XOIlIHrt6hc/jz
         p1gH52emF8ntXKFEZ7n1SYdiM+vASbDUtLnzxigGJ+B8AIkNcB5hiwXmAwbMIB5BADlA
         sSyE0bMJICFgMKsO3pwkcp914r/2qY5bx+/Bm14hlFxXZG+ZHXqxhxt9sw4gGKvtpGpg
         7HRTEB9KwIrXfFEeJN4CKiazqMNsc+qQRc6PyE1GdTyp3SXcDlXlZbMZdrmrn+8M/qEc
         pe/XNbQ6gaGF3vSMWd+qaDSKhMGlssmqa6YpP7XIMnM4bCYxPC/a0PlUakKsMqlrvU2Y
         eFNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=XF81/sKTmZ1AnlJSj3x2T7mD8T/hF0ps/9K/nqtvitg=;
        fh=90z1hI90tvGHXf/61ilQFU/6cOGypzW2LKTYD1HUiPQ=;
        b=ZOBQxUfxIJma3oQaP23f1hbsS6F0Ff9Ni1axfAYA/S70a4pSnOwOxD8VGGcZFSaJNO
         eMmwhuIdXAOxcMODcmZIXRaLqaqXdKZFALXt3aI9atdyIXKlyK19v9hrTfNlByZkivvh
         czYLVC9/HozHGp3pRQ30ONSR9Jv4241WMbqddQzxlQwK1tK8EHHwys0eifh4ON+8UIU5
         HlRqpSF43fIX1S5nJ3DLVdhXUvvhQXm6/YqONf9o9dA9VEMv6BSK2Mz2192ybvIHWEet
         2+ezoZhpVEAHcU79gd70TUBh1fuiF4IpHUU87GqAbNnXIEyMZijDp7o6YEBMzjIpFhTz
         cEUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1782939077; x=1783543877; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XF81/sKTmZ1AnlJSj3x2T7mD8T/hF0ps/9K/nqtvitg=;
        b=q9NIEAjb6+TdqQ42s6Y0+6ts4LICBOJ2adkS/Jj5pVmCeoKUfJ82VUTmUB/yhBBHEe
         D1cGWIpaHm+x1Kg16qUUMJGrgIH11vJJ6UW3BwUC+9xx2NDPVMMLqi4H9+T72ziQOno7
         GGZg2uP4NPTwY7nhkhH/CPWYteewDtSYDwEvQCM9ZWAof9wc3jQeXYhwaNejpau/TZkY
         JBUzUJu7aXJCzWVf3ziiZ2Eah4jvI5kUfCU4GntFpP5ubjwnI8K+NAMDJDAm42uos3bg
         KUrM9GhHeH7PQl8HurS1e73jAA9bCtRLe9YM9/bmW8n30TOBLr9HwLHjOHdeN/y5xce1
         1szQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782939077; x=1783543877;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XF81/sKTmZ1AnlJSj3x2T7mD8T/hF0ps/9K/nqtvitg=;
        b=BZ+Y5XBDEdCm9D4Siyw3mPu1JiakNmIPkOCcOM7PqsY0auAHU9mGCdRGDoATUQOkAY
         hRdQhmoHcN8vfSAXTN13tVqyhUz3ExLBDaCdgayyQmXpzJxSPJlolGJlL+3EIV/7MjLl
         G80henUIuM8miY97uEN1hSSk+lqD286ncKx0jTP5GeCSZvov5i1QpTEx/lIqmmEzyRzq
         ZFA9sq9qsWYl1FRCgYgAS+F5odWwBTCbPTn5Nu1EWt/FmrKIQKQToMCGi1eJrNGXsTDS
         gxJmWf1ZsgwCkYDlJcgYkGHQrwLgiceyz5DXjOyZvdhhnMkwa4ES9+2h9si1101iR7GK
         o/eg==
X-Forwarded-Encrypted: i=1; AHgh+Rp448ZCZju4n80t1phUML9kUQJ+zLmvKBZfZ4lyO6Xshq6RQCn9/d7R/jQVRaSBjzEfjTD0cV9jzM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZWxHAyDqi278+h1eG718jQ9Pn/2YwnqbehKD3U5XtFA2Ep+m5
	dN9IQBrwFGoPisBA5fcWve5P4u9U3THhYX4dPBeWVEiIdo04l0sqV9yqEZLr+gjCd95RPkCInDr
	PxjhqFfRLY/y1rHXGqoJi5AQPxqKzjHrwwLvZDDN84gdl4WY0vUEkI8nBVKtv23nRqFpGraIMJK
	VMLC6UQVYMlrl4nUrap/bCGe7Rff0YH0O2ES/J
X-Gm-Gg: AfdE7clr+PGrvEHVFNdoKbyQIg1nQKDs37eD2KCsH2CGAPXTNO0tx9XBHaH6H+57iAV
	1cScbrcgmeNesy2fDmCThwL2jAK1TCDWH0hLh6AFQeWJ+tILJm+T1hHhITOkMy1bo8uqvX/ffaU
	auTNOQtJQxGH60yPEVTgDSDbNuHEhRP/EcOOQpJXOFxGpligh8W9TNkbgiIRDyE5S7ZSxkFEgoe
	D4au9Ntp+6vOR20+VzoZ7KMMUBz9IZoPzRVWltun8ZyDovP4M9CLGg=
X-Received: by 2002:a53:ac88:0:b0:666:2480:2b0a with SMTP id 956f58d0204a3-66624802c95mr562173d50.50.1782939077554;
        Wed, 01 Jul 2026 13:51:17 -0700 (PDT)
X-Received: by 2002:a53:ac88:0:b0:666:2480:2b0a with SMTP id
 956f58d0204a3-66624802c95mr562129d50.50.1782939077080; Wed, 01 Jul 2026
 13:51:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 1 Jul 2026 22:51:06 +0200
X-Gm-Features: AVVi8CfsV3cGOgb6Svx2JkIRUFiPC3HXmSBXTyt1juuiIVniLQt7WCc-miACenM
Message-ID: <CAHc6FU4tz8-HmEf2_XKT0NT8N=rv5OMcY79PxTACkXAVLOAUpg@mail.gmail.com>
Subject: iomap_writepages WARN_ON_ONCE(PF_MEMALLOC)
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, gfs2 <gfs2@lists.linux.dev>, 
	linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Christoph,

I'm running into a problem with the following check in
iomap_writepages() on gfs2 in RHEL-8:

        /*
         * Writeback from reclaim context should never happen except in the case
         * of a VM regression so warn about it and refuse to write the data.
         */
        if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC | PF_KSWAPD)) ==
                        PF_MEMALLOC))
                return -EIO;

In my case, reclaim is triggered by the following command:

  echo anything > /sys/fs/cgroup/memory/.../memory.force_empty

And we end up on this code path:

mem_cgroup_force_empty_write -> mem_cgroup_force_empty ->
try_to_free_mem_cgroup_pages -> do_try_to_free_pages ->
shrink_zones -> shrink_node -> shrink_node_memcgs -> shrink_slab ->
do_shrink_slab -> super_cache_scan -> prune_icache_sb -> dispose_list ->
evict -> gfs2_evict_inode -> evict_linked_inode -> gfs2_log_flush ->
gfs2_ordered_write -> filemap_fdatawrite -> __filemap_fdatawrite ->
__filemap_fdatawrite_range -> do_writepages -> gfs2_writepages ->
iomap_writepages

The PF_MEMALLOC flag is set in try_to_free_mem_cgroup_pages() before
calling do_try_to_free_pages(). We end up in gfs2_evict_inode(), and
the filesystem is required to evict the inode. At that point, gfs2 has
no way of recovering from an -EIO error from iomap_writepages().

That WARN_ON_ONCE() was originally added to xfs in commit 070ecdca54dd
("xfs: skip writeback from reclaim context") and later modified to
allow kswapd writerback in commit d4f7a5cbd544 ("xfs: allow writeback
from kswapd").

Before commit c2dc7e5589a1 ("iomap: move the PF_MEMALLOC check to
iomap_writepages"), the comment above the WARN_ON_ONCE() indicated
that the reason for rejecting the write was to prevent stack
overflows. But this code path triggers reclaim right at the top of the
stack, so that's certainly not an issue here.

Do you have any suggestions?

The above is on RHEL-8, but a similar code path exists in cgroups v2,
triggered via:

  echo reclaim_amount > /sys/fs/cgroup/.../memory.reclaim

That code path starts with:

memory_reclaim -> user_proactive_reclaim -> try_to_free_mem_cgroup_pages ->

Thanks,
Andreas

