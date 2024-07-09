Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B72612E1E9
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 21:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720559307; cv=none; b=GPoz9xGxqujKGks4kL3oep7i45APiGXeXGHSZCxTYpZIlLyqyvl1hitAFVgNpBcSC7vgIEpo7pnXqsh0No5rCLEpB74V6GGG/sDwSGA1Oc9EZc7a8a9c6llWebk+L7XLbT6RFH1hcryl2mnTTm6M3RszGiBaucBIzXfENnNMNXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720559307; c=relaxed/simple;
	bh=O5Fi1uV0SfZ4nOuL6QTu0wPhdMX4HxIrHon/qe08mVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mVCSxBFD6ku3Vhi8BRSqelEkQ/6SQ4gsDEy/TD1ihsLZSCTlwJDgyemjp+yCGp69modB6iaLFBuS98cOf3OAgvos0xUlzfo7PMQ7G3q4+iyymudcPL+ieZtsGrncxPUDhBdOkL0lv80SNfEXCgoGHE1rULdmmIpBgKlBJ+4d/uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+iCDCzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+iCDCzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4FBC3277B;
	Tue,  9 Jul 2024 21:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720559306;
	bh=O5Fi1uV0SfZ4nOuL6QTu0wPhdMX4HxIrHon/qe08mVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O+iCDCzJVuWP8T5b8fH0KiJYsuq+Ss5FNrfZ4mY0QwHP6pBsiYfBM78ha53D4NEYC
	 NcHgp8g2TGjgu7c1jK8dUHprY5tMV2BkAY32UhvviBISLHIHDHWPLXX4UXelC5sQr8
	 IKzxNOxc4joi4DX66NI/Xg0eZLLZ41JBTtPa1swTFuxN7fqEayjv+Y1s5wK06u0LX1
	 298nsqFY/P04V+YYEMeh+4TYuFersS8T/gPykuo9E2tMUBvn0AdXjgDdzlOvcwC8y6
	 eNLlt1ry0f7Nt7ViE/kRFb9hSjU26v7AWyq6HYIuKK2Ohh3NcIciJop/VZRCmwoOqJ
	 kkuujGMM8APlw==
Date: Tue, 9 Jul 2024 14:08:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] spaceman/defrag: ctrl-c handler
Message-ID: <20240709210826.GX612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-5-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-5-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:23PM -0700, Wengang Wang wrote:
> Add this handler to break the defrag better, so it has
> 1. the stats reporting
> 2. remove the temporary file
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/defrag.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> index 9f11e36b..61e47a43 100644
> --- a/spaceman/defrag.c
> +++ b/spaceman/defrag.c
> @@ -297,6 +297,13 @@ get_time_delta_us(struct timeval *pre_time, struct timeval *cur_time)
>  	return us;
>  }
>  
> +static volatile bool usedKilled = false;
> +void defrag_sigint_handler(int dummy)
> +{
> +	usedKilled = true;

Not sure why some of these variables are camelCase and others not.
Or why this global variable doesn't have a g_ prefix like the others?

> +	printf("Please wait until current segment is defragmented\n");

Is it actually safe to call printf from a signal handler?  Handlers must
be very careful about what they call -- regreSSHion was a result of
openssh not getting this right.

(Granted spaceman isn't as critical...)

Also would you rather SIGINT merely terminate the spaceman process?  I
think the file locks drop on termination, right?

--D

> +};
> +
>  /*
>   * defragment a file
>   * return 0 if successfully done, 1 otherwise
> @@ -345,6 +352,8 @@ defrag_xfs_defrag(char *file_path) {
>  		goto out;
>  	}
>  
> +	signal(SIGINT, defrag_sigint_handler);
> +
>  	do {
>  		struct timeval t_clone, t_unshare, t_punch_hole;
>  		struct defrag_segment segment;
> @@ -434,7 +443,7 @@ defrag_xfs_defrag(char *file_path) {
>  		if (time_delta > max_punch_us)
>  			max_punch_us = time_delta;
>  
> -		if (stop)
> +		if (stop || usedKilled)
>  			break;
>  	} while (true);
>  out:
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
