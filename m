Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938402B9A6
	for <linux-xfs@vger.kernel.org>; Sun, 10 Nov 2024 16:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731257365; cv=none; b=QnGP8Ndhzw6PZoOB1YJQNWZQqWK//AmrUG9HXCkENrjg6kUMOopNxOzv4XcWnK4aJo2hOJFDhYJqN4IHNzyuiJjf0ocYgwjhgJlwEspKykduwPd/vTqCJ7q8Ayg6WdZtFIxMFtaqal4pGDbddp9NWvRt4BHlAIUbxi8qKNFR5N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731257365; c=relaxed/simple;
	bh=ei6RdRUUS/vWwBqEeErM6BQV+M+wp3Gm2Ddcb06QnKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5IxGm/nucygoCBNQHAEsjZVZTXYB+MW2/2KX5UXYoQXo1UMY3URU4xIosHdjysplPuK3QhuUXTvDTgWeavv+SWlF71eSFuDo+vob/t57dJa/g1sIFfV3UiZERxzz4Utfa0Kn06GlfQUp+yamqx2ZAguKfRzRxKu6uJXLkB334k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X9AamJdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9AamJdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3A1C4CED2;
	Sun, 10 Nov 2024 16:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731257365;
	bh=ei6RdRUUS/vWwBqEeErM6BQV+M+wp3Gm2Ddcb06QnKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X9AamJdA4W0ATa3VR7vRI2pbJ0y4hOQYe0zK4283/3lZl04/P1cwgXO0myLR8lUVY
	 oxHuBb6LpZILlPX8dSwv+3iBIYezdYpOr569JwqI9P8zvXnyD0xvWyy/LbDg1WaGC+
	 XbynYQ98tm0R9c9QLOGhwLgGecytI3yAZgNlRT1bJ8r6qIfxDakwxEdPIj+zg8C6fD
	 6qp82Q1KNBHCaMClQsLa0Exdcbm9TfY052M3Efu7UiYYjBQEamALkO1AdDan07j/hz
	 WHYoBawltpoTvd0VsbV6O0Ukb12t7RVuKsFcDsRagALsBI2nmYNg2qAAbtaHUkLnwT
	 Yq8Ii4BWhX1lA==
Date: Sun, 10 Nov 2024 08:49:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 59b723cd2adb
Message-ID: <20241110164924.GC9438@frogsfrogsfrogs>
References: <jzhvk2rvqcvf34emik4l7oio52t45qgomrklxt47t3gycqoklf@blsegvox5wz3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jzhvk2rvqcvf34emik4l7oio52t45qgomrklxt47t3gycqoklf@blsegvox5wz3>

On Thu, Nov 07, 2024 at 02:54:08PM +0100, Carlos Maiolino wrote:
> Hello,
> 
> this is just a heads up the for-next branch located at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> 
> has been updated.
> 
> This contains no new xfs-patches, but synchronizes the branch to
> Linux v6.12-rc6.
> 
> At this point, unless any urgent bug appears, there will be no more
> fixes to 6.12.
> 
> Next patches shall be included in 6.13 Merge Window.
> 
> Any questions, let me know.

Yeah -- are you going to take the pull requests that I sent you for
6.13?  Those need to go to for-next asap since we're about to hit -rc7.

--D

> Carlos
> 
