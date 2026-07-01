Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6D93BED7B
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 21:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782942236; cv=none; b=HLyq6e1opkivZ5xOUM2Ezmpo7FyfEullrZlRf5aUORBHqd1TNub1hgC8yj3Apvc5ucaYBOo4hIIkN0bDVG4QMEyKm84F1NgkAZ9Pg33t9HKF+LFsxBirv75a2WJhmh53QTZDtMAuZ3iKfxk21kEDECRt4GJSgMkHdxzA1xf4hew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782942236; c=relaxed/simple;
	bh=3+uHlXfUx6tcXPUJSCj6rdmUoZv9ICI8ZvLKZyQND08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWeK7BRkEtG/aebEuBBTgYJbUq86AQ7IZy8jNPED+7C05U79yDnrnBbUEXxdjKwB+BGGUQgax5Zgjuh/ic88qR6PqO5O2jHjJFzDG/E5TZ3v3GoP/XWJIv3Af3PqlxBAR2fnzCwToO4kgbI7PZgnqi98LAHw3Xi82Jepxo+jeGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9rSNTQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9rSNTQw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A01A51F00A3A;
	Wed,  1 Jul 2026 21:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782942234;
	bh=BZXZwWhj5eZrx0qeeoZo04I7BvNHcQ95MS94yYBB8KM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a9rSNTQwSCy6cpU683oYLbpf4oZ/mo0VWC46iYbiFGJ5hMLtTgghv34u06B0NiChk
	 FcjDj46dlMAz5UKqcrI2qXduiGqCSjxbrmGJFm2kbWQ9FO173fSwjOCerGKjIRdA8T
	 g1jvJm/WIdlCGn1QhyMt3r7aH2ESSufdVMYaHYu6jhMj5LzhCcTPbLf5ge+ZWYtA0D
	 mAGCtm2yPSdJbNDzC9KNiB55jgrKJrSQu6HKy7vkN3YtCD1tpIPGVyNLI4J4yTK7RE
	 Ocwa3DGHP38EbZq4/PS2QfDUzGX+r/lKQREFcl6PdwWlUVA1TD0ZIliYOiq1mB9f0K
	 zybAKjCMYZ+OA==
Date: Wed, 1 Jul 2026 14:43:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2 2/3] xfs: splice unsorted log items back to the
 transaction after the loop
Message-ID: <20260701214354.GH6526@frogsfrogsfrogs>
References: <20260701153833.3155514-2-bestswngs@gmail.com>
 <20260701153833.3155514-4-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701153833.3155514-4-bestswngs@gmail.com>

On Wed, Jul 01, 2026 at 08:38:32AM -0700, Weiming Shi wrote:
> On error, xlog_recover_reorder_trans() splices the leftover sort_list
> items back to trans->r_itemq inside the loop before breaking out.  The
> loop tail already splices the per-fate lists back, so do sort_list there
> too, guarded by the assert that used to sit after the loop.
> 
> No functional change.  It drops the duplicated splice so the next patch
> can add another error case without repeating it.
> 
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  fs/xfs/xfs_log_recover.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a1b373c68f0e..5347f6a5ec42 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1912,12 +1912,6 @@ xlog_recover_reorder_trans(
>  			xfs_warn(log->l_mp,
>  				"%s: unrecognized type of log operation (%d)",
>  				__func__, ITEM_TYPE(item));
> -			/*
> -			 * return the remaining items back to the transaction
> -			 * item list so they can be freed in caller.
> -			 */
> -			if (!list_empty(&sort_list))
> -				list_splice_init(&sort_list, &trans->r_itemq);
>  			error = -EFSCORRUPTED;
>  			break;
>  		}
> @@ -1945,7 +1939,15 @@ xlog_recover_reorder_trans(
>  		}
>  	}
>  
> -	ASSERT(list_empty(&sort_list));
> +	/*
> +	 * Return the remaining items back to the transaction item list so they
> +	 * can be freed in caller.  This should only happen when we encountered

s/encountered/encounter/

(same verb tense across a sentence)

> +	 * an error.
> +	 */
> +	if (!list_empty(&sort_list)) {
> +		ASSERT(error);

This otherwise looks fine to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		list_splice_init(&sort_list, &trans->r_itemq);
> +	}
>  	if (!list_empty(&buffer_list))
>  		list_splice(&buffer_list, &trans->r_itemq);
>  	if (!list_empty(&item_list))
> -- 
> 2.43.0
> 
> 
