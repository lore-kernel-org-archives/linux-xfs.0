Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9CA37E
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 17:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723571922; cv=none; b=S50N4VfhzPc+qFmEoxSKSMI3UYSedfW8osDWVlm5fTLyy7P3o+S8ma878mMwHn40YQB4k70JP3hdZw0uFHiea5zCCtbNk+MUZDB4rmxV9fAkmWvOI+NFBSmWeQqmYp13ZKP5E3OYkPSZQL+4whzyQJy6u77oDmXOdstfezqFOhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723571922; c=relaxed/simple;
	bh=vPibw0/WwLwhftb6ujkzmDKyRX0C6F2WpobBlXjdZ3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SCW7ALqdZp93YZYu/56MGCCq0YeuwjAqhkG2wcT61jNzBdnpgKyaGR9T9xoo56KYo6euyoMLK2QxRCp14pVfCaNKzcSA498tvhA3nGSCDFKmNEUh8BAjU5FI/LvILS8HEPZCCtOQRj/5JFtJ86B2Rad0/pCq6rjPSd1zOJKUUr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=elqqmqPO; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="elqqmqPO"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7CB265CC2E1;
	Tue, 13 Aug 2024 12:58:33 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 7CB265CC2E1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1723571913;
	bh=NEko1EOqmyY5OSdR3VC4TMEI9U82VrfgkzNpRtRWIrQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=elqqmqPO4aSairmzINWvitnNTFC70o1CecNslSpOj62gXM0jacc89zTCzJIfEPosc
	 0DyJbnAWYAro6btM5Af7bElCUSuF7hSU9PxnSRVU5sPsTgcI2UE2B5RHRLwj+hJ307
	 yCjK8/HV9X5Ys/G1NuINK+qbVyBQsO9OZWWzKIfFV84kmAkFgfyaqcgROSRef3SAgR
	 Z+SZApO/J7zSUAsWGsmyoGSpOAYEBGH29m8OaAXd/9z0rvOjVGeDrwo/kn0Ah0bk6v
	 5r2WBd/GynqULdMehNLAKhCVn/1ID1sAfKATFzYPW2zPL9xEHY+DYnHcZev2oyfJ3q
	 6IeNjA20Oze2Q==
Message-ID: <798fae34-87a0-4a10-9fa7-c8219bc5caaf@sandeen.net>
Date: Tue, 13 Aug 2024 12:58:32 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] xfs_db: release ip resource before returning from
 get_next_unlinked()
To: Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, cem@kernel.org
References: <20240809171541.360496-2-bodonnel@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20240809171541.360496-2-bodonnel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/9/24 12:15 PM, Bill O'Donnell wrote:
> Fix potential memory leak in function get_next_unlinked(). Call
> libxfs_irele(ip) before exiting.
> 
> Details:
> Error: RESOURCE_LEAK (CWE-772):
> xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
> xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
> xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
> #   74|   	libxfs_buf_relse(ino_bp);
> #   75|
> #   76|-> 	return ret;
> #   77|   bad:
> #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

I think this looks ok now. I might have added a new irele: target
and goto irele; so it's not mixing unwinding styles, but I think that's
just personal preference in this relatively simple function.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v2: cover error case.
> v3: fix coverage to not release unitialized variable.
> v4: add logic to cover error case when ip is not attained.
> v5: no need to release a NULL tp in the first error case.
> ---
>  db/iunlink.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/db/iunlink.c b/db/iunlink.c
> index d87562e3..35dbc3a0 100644
> --- a/db/iunlink.c
> +++ b/db/iunlink.c
> @@ -66,12 +66,15 @@ get_next_unlinked(
>  	}
>  
>  	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
> -	if (error)
> +	if (error) {
> +		libxfs_irele(ip);
>  		goto bad;
> +	}
>  
>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
>  	ret = be32_to_cpu(dip->di_next_unlinked);
>  	libxfs_buf_relse(ino_bp);
> +	libxfs_irele(ip);
>  
>  	return ret;
>  bad:

