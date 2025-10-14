Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7CC1D8E10
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 07:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760426864; cv=none; b=jNtmsjn/k0jipJRjC5E1nLiqDVELevt+ERkWxPN2IO/SIizJv9y1Ysjb7+3ra23tbFlsZZuP2a3TfG6aQnMnBdRlDTwFqDukWyVAO71WSnY0IL2zJo6ez649NpItHXfdoEJU9P8fF4bi3n4TMgEo3U+fYqJKSrog7Zoq5GEsUhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760426864; c=relaxed/simple;
	bh=1E0jqETKs7S09qVb7mMQoG0HjXUqOKiXkpQxuYTV29k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ik9GaNYbsjLMrvlDGtx7FpUmwNJmwdlqFcRPY7dBMkcTF2HHhPZU+2C4qT9wClJt5ncxKtGj7tzuM6363bIsS9r5t1Aasiq0BQulr9ZFURjj+RHO5aJmAJOhUDjxlBZGDuC8tLsfA9OTXIHJsQ7yvu7OSXrrWgM2N/E8Y/B4MZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/O3nZHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/O3nZHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C94C4CEE7;
	Tue, 14 Oct 2025 07:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760426863;
	bh=1E0jqETKs7S09qVb7mMQoG0HjXUqOKiXkpQxuYTV29k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O/O3nZHeGaULowuR4Pc7vGWyoR5KKAJLmHOKF3PCjeMsy2Mip1ksECfSMZpsZrb6S
	 fyHupZWtWiM8AvKmaSHEYBgL7bZ/E71USrTQpeRHJPueGpT0bR/ppxTIibTIiIXsPz
	 RKTGvQ5TLPoFc4mg9lBpfeFsQXln/JuA3ugjTTBIiv36dOEvhq2FTTfoQq54PP8bDg
	 oQSdotjizWwwGPzSAhKKOckW3l2mIv4UuC8BGDnL/X6kyjJrEcQpgkPeeQjTX+3fkw
	 IcuCzGL71eoYfufSgWUl5MqaPxL7gFAp9u2Kn8c3GobyKP/IF7Yp+KJ81k3dCya0rc
	 PuO89r/I6WZOw==
Date: Tue, 14 Oct 2025 09:27:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Torsten Rupp <torsten.rupp@gmx.net>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Double alloc/free of cache item
Message-ID: <mbnwwz3ie2sh2xq5ib2yzo4snn2mxxmimljcrvyrqlpmwrr3mx@trqj6tpwevw6>
References: <2yL7RbS2HGnFO9yJP_YwXFol0RVjGKEvff7qRCJ5j2GvAAVFpdm0cqPPChDkkjiOpcHrpqxRjPNTNhz36DxtxA==@protonmail.internalid>
 <f45c9b48-eb0d-4314-aeb0-6b5e75c54a8e@gmx.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f45c9b48-eb0d-4314-aeb0-6b5e75c54a8e@gmx.net>

On Tue, Oct 14, 2025 at 08:51:12AM +0200, Torsten Rupp wrote:
> Dear XFS developers,
> 
> there is a double alloc/free of the cache item "xfs_extfree_item_cache"
> in xfsprogs 6.16.0. If the environment variable LIBXFS_LEAK_CHECK is set
> this also cause a segmenation fault due to a NULL pointer access (the
> cache item is already freed). Please find attached a patch which fix
> this issue.

The patch looks fine as the same cache is created/destroyed also through
the xfs_defer_{init,destroy}. However I'd suggest re-sending the patch
the proper way as attaching patches to emails make maintainers life
harder. But that's up to the maintainer to decide.

For the patch itself:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> I discussed this issue and the fix already with Darrick.
> 
> Thank you for your work on xfsprogs!
> 
> Best regards,
> 
> Torsten


