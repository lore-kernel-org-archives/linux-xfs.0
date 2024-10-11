Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB34E198840
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728664695; cv=none; b=bbyfMxifvidcN238oCv4wv98zmQHTGYFx4r7tIFjiiAvtpluAazdrBOsw8J3hQcfRwmJChl/6pSHINbwZpOirjUfKYMeDoNpUKbFN7ZULIUNFqGKEnv57gxWTYNpd0wYtsTnwkb6lAKDCYVAymogE9U08i0AedbkUXpFZDpRQnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728664695; c=relaxed/simple;
	bh=CP9f4tlXOypP9jhkMdi8l0+836zT6kMr/0EMkBEWNwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IltXKOXJ35mwKDZCfkC0d7oXrkxNrqOB5FyIeuZTxmtEzIgk5Fza2c3MoLAkTOBkr4WTOPaKHPeJ9CaPWnNfxe7d6dJqujWFqUJgvJ1zNzpSzOrBIfpRO/erNeOBg7czPbxClsh8Ivn5AlGRFWiQYY7o7ds/lYF0LRwk49T5NnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lo13HIKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lo13HIKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4341CC4CEC3;
	Fri, 11 Oct 2024 16:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728664695;
	bh=CP9f4tlXOypP9jhkMdi8l0+836zT6kMr/0EMkBEWNwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lo13HIKUTyE6hIkb7S+uoS0+0nKQe5eHXbzGQkS1+Y9+yoi1xramymLTKJ5eqIfy1
	 vrfjwnXmlxJIGHHFwo0vSZfkxln+WtvyDLVuRXjZL75oY2iIInJNiYomGUfqqK8Ow+
	 rMAqEvcVEc4tyEQrqXQYC3AocHikzQ6qLu+fOca1IT+rWbGEHRj6BhXL2As0PtVc20
	 wmNirrktgs6ZGpprmfViNFB1p032S/vfFHX9qDtEc5gf7M22pMMP10ugyog9AY7ugF
	 eYK2UXLOB9vl+C375dHtLqBlSDIoungeg9zEGf4hXX6gVaJt4nWHDKA7PIn2j+No60
	 7+Vbyel4+jBkQ==
Date: Fri, 11 Oct 2024 09:38:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: =?utf-8?B?UMOhZGVyIFJlenPFkQ==?= <rezso@rezso.net>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfsprogs build: missing hard dependency?
Message-ID: <20241011163814.GW21853@frogsfrogsfrogs>
References: <20241011141522.36415e20@rezso>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241011141522.36415e20@rezso>

On Fri, Oct 11, 2024 at 02:15:22PM +0200, Páder Rezső wrote:
> Hello,
> 
> 
> I tried to compile now the xfsprogs 6.10.1 release, but it failed:
> 
> 
> /bin/ld: fsproperties.o: in function `fileio_to_fsprops_handle':
> /var/uhubuild/work/compile/io/fsproperties.c:63:(.text+0x155): undefined reference to `fsprops_open_handle'
> /bin/ld: fsproperties.o: in function `print_fsprop':
> /var/uhubuild/work/compile/io/fsproperties.c:99:(.text+0x26d): undefined reference to `fsprops_get'
> /bin/ld: fsproperties.o: in function `listfsprops_f':
> /var/uhubuild/work/compile/io/fsproperties.c:133:(.text+0x380): undefined reference to `fsprops_walk_names'
> /bin/ld: /var/uhubuild/work/compile/io/fsproperties.c:139:(.text+0x390): undefined reference to `fsprops_free_handle'
> /bin/ld: fsproperties.o: in function `removefsprops_f':
> /var/uhubuild/work/compile/io/fsproperties.c:331:(.text+0x48f): undefined reference to `fsprops_remove'
> /bin/ld: /var/uhubuild/work/compile/io/fsproperties.c:339:(.text+0x4a8): undefined reference to `fsprops_free_handle'
> /bin/ld: fsproperties.o: in function `getfsprops_f':
> /var/uhubuild/work/compile/io/fsproperties.c:189:(.text+0x5b6): undefined reference to `fsprops_get'
> /bin/ld: /var/uhubuild/work/compile/io/fsproperties.c:199:(.text+0x5e3): undefined reference to `fsprops_free_handle'
> /bin/ld: fsproperties.o: in function `setfsprops_f':
> /var/uhubuild/work/compile/io/fsproperties.c:271:(.text+0x6d4): undefined reference to `fsprops_set'
> /bin/ld: /var/uhubuild/work/compile/io/fsproperties.c:284:(.text+0x74f): undefined reference to `fsprops_free_handle'
> collect2: error: ld returned 1 exit status
> 
> These functions are defined in libfrog/fsprops.h, but this is included
> only if the libattr is exists.
> 
> After adding libattr to build dependencies, the build is succesful, so
> I think, the libattr always needed for this source.

I already removed the libattr dependencies:
https://lore.kernel.org/linux-xfs/172783101339.4035924.6880384393728950920.stgit@frogsfrogsfrogs/

(xfsprogs 6.11 will probably be out soonish...)

--D

> -- 
> Bestr regards.
> 
> Rezso
> 
