Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B55226861
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 18:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764613976; cv=none; b=cXQIIXKLedlOyoE/vKLdBySttF6gwwFp+p8dajg+DzoKGg6AApKg89wk4XNt/QIqbviuyjwYew0d+LvXG7IL7tw+Mn1oQvK2fQWJmbYAUNEVxnGwS6Llx5XMx3pdwZWHKErrU+azRt3Fbi3F5Or6LasokogPSHVaHIgDRXbOjow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764613976; c=relaxed/simple;
	bh=L09SF8JZrHjWxwx3UZpQIBcPM/O6hX3FpDPB8Jb1c2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unLp/hpx+Gm5epsgDy0mILX9OSe+GKQcHDaNqo7tmSF1K6uV8PL/h5a03oJ8yoE2+m2+Lk4QpLENH3R4MdiuRBGXAaQSKRgR3i2x/RKlWI1YKcpYSb0vTd6rJWK7MDJ0cCr6ig3E23ciTvsT/X3fpPam5Y+L7kmGHuzy7U9cR8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DBabkEHi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lI7NB3vb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DBabkEHi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lI7NB3vb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764613974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XVOucITvrte89ussoTAEBzLnbBwH7xo+vpQWRKo3zz4=;
	b=DBabkEHif7su+bGtJjOBuosOCWBDXv9L5wnk8qUDELKTjfbB/BeIb7Q2fxeZp9euyJ0zoG
	YM0Q7vC/XYthADld4HTqumab29whuzvb/vbRxTmJdeb4iHt1qQtAPCoDUIpasSG0M8RqiA
	9SLETeg5fU/CTJF7HOLmKO9WVd0XsTc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-wddYVBwcMVeqL-C7_AikiQ-1; Mon, 01 Dec 2025 13:32:52 -0500
X-MC-Unique: wddYVBwcMVeqL-C7_AikiQ-1
X-Mimecast-MFC-AGG-ID: wddYVBwcMVeqL-C7_AikiQ_1764613971
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477771366cbso28052535e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 10:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764613970; x=1765218770; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XVOucITvrte89ussoTAEBzLnbBwH7xo+vpQWRKo3zz4=;
        b=lI7NB3vbWg70QmAxKRpAxkXuCpVCzBTqqxdwHycnQmA4pGpfPZKvUX3ybGPekrxyB/
         mwGE2ypFC+jRR87+vu/lVPJVH/f38rzv/x9Zms5tVDPH9ScemPURPyD8EmjXaG1H75XI
         2JI3lFGDB8li/i48WIJfmOJKZzJe6zw3TQN1eDWKAMxJHraGf8s2AWFxozN/w5wOORc+
         q6j+4iPQNFZ5pR4CIe5Uwr4u5J3ZX6HpSBmecSuDwo28mHkTChz5+fwkzoNoYk7FUOAx
         FWbuZmDKRp3q8IWs2OgsKH4+mihvWyNC6XQdDllbqsvCq32efQtEhDpEHaBptYqSbxGc
         Q/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764613970; x=1765218770;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVOucITvrte89ussoTAEBzLnbBwH7xo+vpQWRKo3zz4=;
        b=iyM1tQqjHYoDWB8j1vyePiTyg8Wrp0g1vTqH2onMnBf4b7ZF1kjCrlOhOiH3H2ftcN
         VeiZdhoHHJVOl1vvEMhlCmdNOgtirWeE0wjHxVGRvTcpAnTNS5LoeB+9u9yG8HCOl/LG
         9ixrnFSME16YIOaz83L8xLB4N1MG58s+kERksTWsjWghee5UxtTvUql6/fI139dymiw2
         HkoVSrLCSnsn2l4Ogvb0NfMNREtBaz4Ay9LRsyJOPeo344fEzOK54M9PNDt0+oCUqcgS
         zGjGV1uGYnXehFDjTAGDO4u9rcRe7bYLaoYeME1gZwbWdj/jnMkth08vQEmIfK26ciWx
         Z5OA==
X-Forwarded-Encrypted: i=1; AJvYcCXRld3BhMTSzxgUCK1hpD4WpwgkUGReiM28t+aVd9/9GL3rRnCJrptBSyrzVC8c4AFvrTbHJ9iuaYg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrbgtRVeo3MTHrzMXsA1W1o07WJ8DG0QnAuBsCNkHi/IlqboUa
	/DUCh8pJVhMtm5iytBCS881HJutJ3nLzx6bHzjaFrejdR125Z/9RMmVijW/KanBQuFTsJV8AurM
	wwofqD98/8QraYWtomhfR0KAIqGi4OuYi/DME9ni9eb1Ua9g6nKkbGXwzA0f/
X-Gm-Gg: ASbGncum3bTSCF4FEN/TR8MBHp4Nwnq1mRXQwzxYoE5gfXWeO77/tL6d9Z8sCM16ydC
	fX9Vy55VEH2gtNKZVfgiQsKmkXqVv460SuZ+mZRabNk5FbNMNhH4mzyCliEDql0X+aq8Y5HA4e8
	9rVW1KUUqpXrJtlRorLI864g0pnEcQTels7scE4cbLXRn/BKm4bIPRYH5U4Zv/SBaCaOx5KJFam
	g0n75YeBoSuclGAZ+PTkuz9MoukEn/Ci/orIZqnSY8nMAPN3tMJdTzgegiDvvRVRzYj5pIMyfdz
	I4lOt4LGKJ5l3bIVsfjm/61Vgb3yPpcaP+YtWFE1Wfp3xKlaNBelQuQN0eHlChFbNhK8MsIEVFs
	=
X-Received: by 2002:a05:600c:4f88:b0:477:af07:dd17 with SMTP id 5b1f17b1804b1-477c01c3721mr461901375e9.24.1764613970267;
        Mon, 01 Dec 2025 10:32:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH8z3rPllm5PqOOXE/tujMiBe+R91mYXSQslmtTYdUSPkQMBGoqZVxwBqj24rrfnZEKaz2UNA==
X-Received: by 2002:a05:600c:4f88:b0:477:af07:dd17 with SMTP id 5b1f17b1804b1-477c01c3721mr461901155e9.24.1764613969824;
        Mon, 01 Dec 2025 10:32:49 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1ca8bae9sm26774766f8f.33.2025.12.01.10.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 10:32:49 -0800 (PST)
Date: Mon, 1 Dec 2025 19:32:18 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/25] logprint: move xfs_inode_item_format_convert up
Message-ID: <xn4vun7i6b4af5erbnao3bbskoogicgf22tc27fqprpio7b47c@6y3eewehvcyx>
References: <20251128063007.1495036-1-hch@lst.de>
 <20251128063007.1495036-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128063007.1495036-12-hch@lst.de>

On 2025-11-28 07:29:48, Christoph Hellwig wrote:
> Toward the caller.  And reindent it while we're at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  logprint/log_misc.c | 80 +++++++++++++++++++++++----------------------
>  1 file changed, 41 insertions(+), 39 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index a3aa4a323193..274d25e94bbd 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -527,6 +527,39 @@ xlog_print_trans_qoff(
>  	return 0;
>  }
>  
> +/*
> + * if necessary, convert an xfs_inode_log_format struct from the old 32bit version
> + * (which can have different field alignments) to the native 64 bit version
> + */
> +struct xfs_inode_log_format *
> +xfs_inode_item_format_convert(
> +	char			*src_buf,
> +	uint			len,
> +	struct xfs_inode_log_format *in_f)

one more tab here will also align with in_f32 declaration

> +{
> +	struct xfs_inode_log_format_32	*in_f32;
> +
> +	/* if we have native format then just return buf without copying data */
> +	if (len == sizeof(struct xfs_inode_log_format))
> +		return (struct xfs_inode_log_format *)src_buf;
> +
> +	in_f32 = (struct xfs_inode_log_format_32 *)src_buf;
> +	in_f->ilf_type = in_f32->ilf_type;
> +	in_f->ilf_size = in_f32->ilf_size;
> +	in_f->ilf_fields = in_f32->ilf_fields;
> +	in_f->ilf_asize = in_f32->ilf_asize;
> +	in_f->ilf_dsize = in_f32->ilf_dsize;
> +	in_f->ilf_ino = in_f32->ilf_ino;
> +	/* copy biggest field of ilf_u */
> +	memcpy(&in_f->ilf_u.__pad, &in_f32->ilf_u.__pad,
> +					sizeof(in_f->ilf_u.__pad));
> +	in_f->ilf_blkno = in_f32->ilf_blkno;
> +	in_f->ilf_len = in_f32->ilf_len;
> +	in_f->ilf_boffset = in_f32->ilf_boffset;
> +
> +	return in_f;
> +}
> +
>  static void
>  xlog_print_trans_inode_core(
>  	struct xfs_log_dinode	*ip)
> @@ -588,14 +621,14 @@ xlog_print_trans_inode(
>  	int			num_ops,
>  	int			continued)
>  {
> -    struct xfs_log_dinode	dino;
> -    struct xlog_op_header	*op_head;
> -    struct xfs_inode_log_format	dst_lbuf;
> -    struct xfs_inode_log_format	src_lbuf;
> -    struct xfs_inode_log_format *f;
> -    int				mode;
> -    int				size;
> -    int				skip_count;
> +	struct xfs_log_dinode	dino;
> +	struct xlog_op_header	*op_head;
> +	struct xfs_inode_log_format dst_lbuf;
> +	struct xfs_inode_log_format src_lbuf;
> +	struct xfs_inode_log_format *f;

Maybe make it one column with arguments then? (seems like one more
tab will align everything)

> +	int				mode;
> +	int				size;
> +	int				skip_count;
>  
>      /*
>       * print inode type header region
> @@ -1582,34 +1615,3 @@ end:
>      printf(_("%s: logical end of log\n"), progname);
>      print_xlog_record_line();
>  }
> -
> -/*
> - * if necessary, convert an xfs_inode_log_format struct from the old 32bit version
> - * (which can have different field alignments) to the native 64 bit version
> - */
> -struct xfs_inode_log_format *
> -xfs_inode_item_format_convert(char *src_buf, uint len, struct xfs_inode_log_format *in_f)
> -{
> -	struct xfs_inode_log_format_32	*in_f32;
> -
> -	/* if we have native format then just return buf without copying data */
> -	if (len == sizeof(struct xfs_inode_log_format)) {
> -		return (struct xfs_inode_log_format *)src_buf;
> -	}
> -
> -	in_f32 = (struct xfs_inode_log_format_32 *)src_buf;
> -	in_f->ilf_type = in_f32->ilf_type;
> -	in_f->ilf_size = in_f32->ilf_size;
> -	in_f->ilf_fields = in_f32->ilf_fields;
> -	in_f->ilf_asize = in_f32->ilf_asize;
> -	in_f->ilf_dsize = in_f32->ilf_dsize;
> -	in_f->ilf_ino = in_f32->ilf_ino;
> -	/* copy biggest field of ilf_u */
> -	memcpy(&in_f->ilf_u.__pad, &in_f32->ilf_u.__pad,
> -					sizeof(in_f->ilf_u.__pad));
> -	in_f->ilf_blkno = in_f32->ilf_blkno;
> -	in_f->ilf_len = in_f32->ilf_len;
> -	in_f->ilf_boffset = in_f32->ilf_boffset;
> -
> -	return in_f;
> -}
> -- 
> 2.47.3
> 
> 

-- 
- Andrey

