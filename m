Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE3420458B
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 08:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742287258; cv=none; b=qp7V+OSjEyJaWNeLtjvKA1LwG409mowqpjCME4Hat3WhW+wMwiwwkHtpz+u66adYnqnpPgZnch+vBsJOl732O9FNnPXxxIJbzv2u4Olp62HWT4QQDRNdYZpqDJV4L7CLrk27PIDDwENbyRsfPOoq5zgGehIJ8ceSJ5yQHT/wq3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742287258; c=relaxed/simple;
	bh=pzHaAabohs4Fja3f3JPqsREqU2+QhDnOgWv7KHPC2qs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oo9lFSS8Ii5ytXMX0X1ffLRftzgg9ZGLpz4QheNwPv/gK0IVVREJ+b7w80EeLVhZt9eMD8yvl6v1rBWeQXD0g6jU1QRO2rFk8e0w6XOrdI5sUqVoLPAle9r0TXORjsdm946tHdfeptGizxPYU5qts5HiEvxyhKj7R52qFsKrcds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wPwgYQui; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wPwgYQui"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3996af42857so645426f8f.0
        for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 01:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742287251; x=1742892051; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=inD5pHu5qMMlvuxQfd6TiD7o5WePGE80JqF1oY0H9aw=;
        b=wPwgYQuiWhvQau+H0Cl1ej46jwvsJRj7aSTgjF6Fw36ITGb2lqsqX9qauJGXUu6D02
         dSOJKqgLQ2OcHPmHDj75WUEhhAY7UkYx6VLEK6AxFHQM5JTHMU0fTQC1OXNMArZgNhNu
         0d67zmcgBQgFn0McqMzAs0VQcSdagliGJ4aRs6+5dVBvs7cFl/uIdKllnMkDXdkh5yqR
         zX6LXZCBQvuqBXsRP7OVS7OswzI19x6DXaZen0l1zJCYi/N1Mru9119l1QYfoDsAcUI2
         9kTd8DS1nIXz6j5U9Uia65BhUHxYPxoHMlLfDzNVbr5IisgOg8q1beNkT6AESu+A55RB
         u/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742287251; x=1742892051;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=inD5pHu5qMMlvuxQfd6TiD7o5WePGE80JqF1oY0H9aw=;
        b=BNnRwRl8qv3nDCZ8+zuAk9JtUpmf8iQwNZ4/Dpp8wARRjb+xaM7lnNf2DYh+yKTiMD
         NqsJ7nSnbB9tUpXvq/zSh2GNv3LfxE5LLowLRdW5YggkoJeqZUsdkPvDzgH+8eSJeRwp
         NzgWIFDFUeLrrNR4U9I6/IxApDR4Tjsw6Jnp2LwquTVYccZmfnAYmG/MzrD/jlq1a7mM
         WHx8LUu8glUJPOI6GcddVeghvtd/dJC+ceFDDd+CO0AzHm7jjX2qwqsHSAlMx828WSoq
         QHcplgCTMGPDkgBekLn9BfcVqsLJxfAwLIrhnrQdQV9dJgVpmvUce18IM6+TBcxIwdBB
         wkLg==
X-Gm-Message-State: AOJu0Yz8Ahm2w5eRNyK3/Td02cV3/lN32Xz4jLCy54SIVtLiSNcBxU0s
	wBq40xQebjwpk/hJwNZCipUnDi/L5XfDQG1MqfQavWESAS3R588VdJdw3aFWhAs=
X-Gm-Gg: ASbGncu/8aVNoMakZTwekS7vHKnL7QUbT4fxA4EIt/DpILWUqJDPAXw6iVw4fIu+jWV
	ud+rRbNXZPvGhZD39f09nVkj/MEJ9OuR3kPkzDQCexRHahpahnIZxCk5WWl6gzNUW8c6I8SvHUo
	wR/jY/R0uf7DOW5BA09QfnsaUDgwcl3xTmCrgZVl47mbFcGtEYciE7pZKp7gDVBDPRcxX2GxmiS
	s69tt7bug+FiHoWK2Tfs6RLNxdXwJ4iWC89VTWt4Bh07ufH/2pQ0VNM7fKlEPoo5Q6NmQAUVk+M
	RY0Z7/r09T8Tn4cVFutgIAkK2aow2MtTh8jhnqArGb1tJInWNH7Akbx3/twl
X-Google-Smtp-Source: AGHT+IH5dZwh6YkCMjBlQnZsifWC6PVKA54dDrLP3GaGMHMLPOLgnD3oGSaoiVgDn2EkQHNBMlhYSg==
X-Received: by 2002:a05:6000:2aa:b0:391:b93:c971 with SMTP id ffacd0b85a97d-3996bb774b6mr1730382f8f.20.1742287251336;
        Tue, 18 Mar 2025 01:40:51 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43d1fe2a263sm128908345e9.22.2025.03.18.01.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 01:40:51 -0700 (PDT)
Date: Tue, 18 Mar 2025 11:40:47 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: [bug report] xfs: use vmalloc instead of vm_map_area for buffer
 backing memory
Message-ID: <91be50b2-1c02-4952-8603-6803dd64f42d@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Christoph Hellwig,

Commit e2874632a621 ("xfs: use vmalloc instead of vm_map_area for
buffer backing memory") from Mar 10, 2025 (linux-next), leads to the
following Smatch static checker warning:

	fs/xfs/xfs_buf.c:210 xfs_buf_free()
	warn: sleeping in atomic context

fs/xfs/xfs_buf.c
    196 static void
    197 xfs_buf_free(
    198         struct xfs_buf                *bp)
    199 {
    200         unsigned int                size = BBTOB(bp->b_length);
    201 
    202         trace_xfs_buf_free(bp, _RET_IP_);
    203 
    204         ASSERT(list_empty(&bp->b_lru));
    205 
    206         if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
    207                 mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
    208 
    209         if (is_vmalloc_addr(bp->b_addr))
--> 210                 vfree(bp->b_addr);

vfree() can sleep.  Although it's fine to call it in interrupt context.

    211         else if (bp->b_flags & _XBF_KMEM)
    212                 kfree(bp->b_addr);
    213         else
    214                 folio_put(virt_to_folio(bp->b_addr));
    215 
    216         call_rcu(&bp->b_rcu, xfs_buf_free_callback);
    217 }

These warnings tend to have a lot of false positives because the call
tree is long.  There are two functions which call xfs_clear_li_failed()
while holding a spinlock.  These are the call trees.

xfs_trans_ail_delete() <- disables preempt
xfs_qm_dqflush_done() <- disables preempt
-> xfs_clear_li_failed()
   -> xfs_buf_rele()
      -> xfs_buf_rele_uncached()
         -> xfs_buf_free()

regards,
dan carpenter
