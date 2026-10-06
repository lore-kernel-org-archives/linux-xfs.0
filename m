Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993E73D88E0
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 10:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791283900; cv=none; b=cKklSzmQMntB/FgwP/hTgiKdUgm2xqhdyEbyzYq+FdVNU8ACNBCOF9Jguwy9M1Oqk8Z7bUJDGOd5ZjwPXORUx6aC3QV/e0+aSkmRqrDv+eRrTvmdP46nQ+lec9qaEPG2uiKlruD+hAUwVZwQP5a0lTEz35JXhYNtFmfT7gYGe5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791283900; c=relaxed/simple;
	bh=45D7U5cx2VFU1Z0d16KFr1MZyf9vUkY9xaAVhO3j5uU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTb9GRrg8x7zUtB/QRzPyzbk4SX9tGyhacGtSRqiatCi4v7IVzgk5ZUnWVJd5IKWqm0VlyuOgYt1lGWQ4k75K/gEi3jOxVJ/K1AJMCYYMSLdYMsdGXTVeMdBRcouZmn1Awlnf9N5aISAY2mcG2q+D7cigFb6gun2Yhmq6EyuPQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8mU804U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8mU804U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152041F000FF;
	Tue,  6 Oct 2026 10:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791283899;
	bh=H7ChroeZfT5c948tDV1rUh/3VSZy96Ay+C+c1KYKrpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C8mU804Ur1/Cw+00gdIr5tBTTLwS6J8iQHE54m/Lio8R7xXiBLhqhcdHdlji2vnPc
	 F5p8SFc7TpPNHuT0DGLE/cQUWUlZ3EEuzJlbJS4Pl2+NEjFWWPkeGWVAWINWb64Uy4
	 g3QarUXRgwNOFP+acYMhIDuFMZmpKhME4soPUpmYqW7pANoEoYvInEdUW9zvnrapmX
	 ZMI632HwH3EI9wBM9Edg9z/1U6/7DHz7zWpQt4yQwOfqCTK9Vayt17CEKiX9yVIrBh
	 xP3e7WWjTw5jAj5Zrw/arJL6kV/+n3MRL8to3QNsPj8KaBgXEpbp3urravkzeQ9hRf
	 2OSg5DzCnOB2w==
Date: Tue, 6 Oct 2026 12:51:34 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: linux-xfs@vger.kernel.org, Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [xfsprogs] mkfs: fixup memory leak on exit
Message-ID: <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
References: <20261006101232.357124-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006101232.357124-2-wilfred.opensource@gmail.com>

On Tue, Oct 06, 2026 at 12:12:33PM +0200, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> When running mkfs.xfs with addrsan enabled, the following is reported:
> 
> ```
> ==27832==ERROR: LeakSanitizer: detected memory leaks
> 
> Direct leak of 9 byte(s) in 1 object(s) allocated from:
>     #0 0x7fe6db2e8ac4 in strdup (/lib64/libasan.so.8+0xe8ac4) (BuildId: 5395ec74f54d9ec7bf97c06583dd39a96c230822)
>     #1 0x0000004175ce in getstr <blah>/mkfs/xfs_mkfs.c:1767
> 
> SUMMARY: AddressSanitizer: 9 byte(s) leaked in 1 allocation(s).
> ```
> 
> Thus, gracefully clean up these string allocation on exit to address the above.
> 
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> ---
>  mkfs/xfs_mkfs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 334367b8..fec43987 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -6503,5 +6503,8 @@ main(
>  		exit(1);
>  
>  	libxfs_destroy(&xi);
> +	free(cli.xi->data.name);
> +	free(cli.xi->log.name);
> +	free(cli.xi->rt.name);
>  	return 0;
>  }

Hm, wouldn't perhaps be better to hook this into libxfs_destroy?
Although this would likely need some other extra surgery on xfs_copy.c.

It just sounds weird to me to free the memory here 'after' we already called
libxfs_destroy() here. IIUC: cli.xi == &xi in this place, so freeing up
memory after destroying the struct using it sounds like a time bomb.
