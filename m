Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793734887;
	b=5WpCJCt2kCFclHgO0kyMSVTu1KhH0bDAQqJFzvqXU+2pztHo77co/rgo/3ws5Nq8PmmC
	 Nz1vX/gaYngLvu1MQGThw1FYso+/YWAg8TB7NaudPfiboI+/q4Dsh1pKTH4TaGAMSt6L8
	 3wkEgz0CFesxOE+OEQKUjVj2+6XoIsKALt/bWNA4eSPk2zgXJJqqFC56FzAMmlvrjxKuS
	 yEk96YxuBIx4Y5O5zf5lOva2krrZo4twRRyJos3sIfeB+S4J+0tDEYqJSUxOcQkzhxBZq
	 0R3xMjqsVbKdNudB07/eduTHw8SJCmbmmrT45A/uG6GQo9MkKrPaSEDhYUIsLgjf6vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793734887;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=A+2oooR63ntJ+mhy+UmGT/+ZoyF9rk7xPcPGVCAUHwk=;
	b=gys2zuWTKnXAssxwhqHrZkXRS7LRqnzsL2f1uf5yMkxnBNsDv82GAN9dvg1YR877OLTD
	 m+UF7bGqTXq2xfIqcDnQ0al/Zoj6TdS8LeZXhhu5n29HIRUj4qJedFKNT56OgckVMGggj
	 UdRAeJwTppAWUbb30unZnZWB2Du+bL9wWhDEu/LwXr8VRPSl29lm6OxK29ssJMXYTSOFK
	 W3VqdIjz6l71PnyxBM7kmgVchOx0c7AL8hYw7PC02X75tqLi1sOg4CVdTrZqk6+3LaEj0
	 r3ljBYuoPn6Nr5KKKmHgGGRC16JMG7haJlOSRvc5JBOYVVDJzc+kezcZ4H2y+kYQEoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UsFGGqDp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7C1606A31B;
	Tue,  3 Nov 2026 19:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UsFGGqDp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2847E1F000C1;
	Tue,  3 Nov 2026 19:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793734886;
	bh=A+2oooR63ntJ+mhy+UmGT/+ZoyF9rk7xPcPGVCAUHwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UsFGGqDpjPjvZEw7fXQdLlsRlVg04d4OD7XJZklLdEtYLJJgbwAwyX2Ww8aHNrCVL
	 zbG06cqINkyc8ffen/TKkmGIzL7CBtFnH6HA/LqIFL0y1uxVqIyQvBA9k8ZrSQw+XC
	 Vj6qrS999FOrJ2RK/Gdf/n3MdJRPg/OLruaw83Zv/x6i5kPbEuzQbRpCPpJl7sJCj+
	 /PFS10mksIJEu+oQntF6hAUk5h077B0zZfNO+8gyYMPzJn/m2EVCWH9Dqx7ghFZZgP
	 DMi7nDh5L1NkeTn0YNhqoaofbbpATxKWqRXhur3VTumOOqG0+uvgt6DQK85GWPomZX
	 p4CA1EvewLdSg==
Date: Wed, 4 Nov 2026 03:41:21 +0800
From: Zorro Lang <zlang@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/619: fix mistyped seqres.full variable
Message-ID: <aunRXNH3r71XLZIx@zlang-mailbox>
Mail-Followup-To: Andrey Albershteyn <aalbersh@kernel.org>, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20261102081156.640279-2-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102081156.640279-2-aalbersh@kernel.org>

On Mon, Nov 02, 2026 at 09:11:57AM +0100, Andrey Albershteyn wrote:
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  tests/xfs/619 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/619 b/tests/xfs/619
> index 7e542f705e60..583be7160be2 100755
> --- a/tests/xfs/619
> +++ b/tests/xfs/619
> @@ -36,7 +36,7 @@ file1 ---755 3 1 /dev/null
>  $
>  EOF
>  
> -_scratch_mkfs -f -n parent=1 -p $protofile >>$seqresres.full 2>&1 \
> +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \

Haha, so simple static checks still have their value :)

  $ shellcheck -x -P . -P common -e SC2086,SC2004 -f gcc tests/xfs/619
  tests/xfs/619:39:46: warning: seqresres is referenced but not assigned. [SC2154]

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  	|| _fail "mkfs failed"
>  _check_scratch_fs
>  
> -- 
> 2.54.0
> 
