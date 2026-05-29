Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACDD372B50;
	Fri, 29 May 2026 04:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028954; cv=none; b=cW6bzNbMYqgV7I7uohOdaaXkJ//PfAwZ0godP6JZWZT9WY6sIkSSNspVl2YdxnU40tF94abXb4MozZ3Yrt8M+ZoZLCX/xkL8+7gVmNzlbvYYXgxH8u/g9qE9FMQzNJZQ8W50qw1lWnr416Vkbd8vDjd7gusfPsqFJgIKNqI4KYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028954; c=relaxed/simple;
	bh=vAOdHSn1utCLpu0bVBeMedbjLCW6m+EvfL5MqZuFD5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fNDshG8P7hlgHDEog9ogJMJlC/bmED9vA6mUluz011R75zav2hGzfYk3c4lBwipRBYfAoDPInnOU7URE0vAuBQY+c1ThrAvUlGmnJE9JO+bSLXFDxejZNQRbDLUXe7Y+rPPbk4+MdMaeqV6yQo5ZJNt3pp9HXA2ELaE2sHm1R7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gl7gBDJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gl7gBDJ7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DAB0E1F00893;
	Fri, 29 May 2026 04:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780028953;
	bh=sQlw2nJ084KxpFPHg1dQ82Zop2BRwpAcGQ67bXNtRjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gl7gBDJ7AHzDDFDAQLxMPgwzbuOnDPbPj/KFIJbx8YgNZOIbid8uSIHwimlAtObDZ
	 vahxsD7DqPSQmi/cjf6rZ/07TGe9kslh3V6p2Nelbqzqk/X6dWALVIEKMlZxhh0dQB
	 V0Yt959lqbbjN0BYc56YzQsfVZCvzlsVnkOza3Vo3H1zztfvNInWlsorWwdJdlEZCH
	 phJqma5eosqMj7kTgm2BRqC63yIR4Q2/zHXx3OHCWrvZfRVj25PRBumKy6m7ZY8y5C
	 uK27N0FmJAqz8HzbPJOMGgpRxggoTWrcOIULwndGTRNYgAr1WdtVo3x6p58y/Qv1/L
	 3oIG6TM5fn7sg==
Date: Thu, 28 May 2026 21:29:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v6 03/11] fstests: add FSNOTIFYWAIT_PROG
Message-ID: <20260529042912.GD6070@frogsfrogsfrogs>
References: <cover.1779939330.git.asj@kernel.org>
 <f4dc9d5af00133834acf97e1c72232d2a9b34ac6.1779939330.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4dc9d5af00133834acf97e1c72232d2a9b34ac6.1779939330.git.asj@kernel.org>

On Thu, May 28, 2026 at 12:05:34PM +0800, Anand Jain wrote:
> Define `FSNOTIFYWAIT_PROG` for an upcoming test case that uses `fsnotifywait`.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>

Seems fine to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/config | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/common/config b/common/config
> index d5299d5b926f..5661fa0ec310 100644
> --- a/common/config
> +++ b/common/config
> @@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
>  export PARTED_PROG="$(type -P parted)"
>  export XFS_PROPERTY_PROG="$(type -P xfs_property)"
>  export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
> +export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"
>  
>  # udev wait functions.
>  #
> -- 
> 2.43.0
> 
> 
