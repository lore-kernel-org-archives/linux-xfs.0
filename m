Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8181F200DB;
	Fri, 28 Jun 2024 16:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719591914; cv=none; b=VMbrZ1MEXtUq/NoG3DwTQCeh/FOxqsMdVkf6TrAFfYWaL5nuO5fo0zsFBGvFXdx3fWvmFa3OTr9X28CE0wOc2AYjLrdxj1MmAWseaeVypxXaliRi6nVQuZUnCFYr7W+ryjBbheXgWlLV9r1m5mY5y0dgRz6LXJc2eGWOLQ760os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719591914; c=relaxed/simple;
	bh=yoV6qQEjWR6NWRRquyzf69XxufXWEai1naKJ/4/9xl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OImNzRmC477lDZqdUqn0RjziHE/b/Y7p3CdQ8McemhBkL/UbbYlWNgRUsDpisuR13xpfl+vLKFGX3d9dGTkXryoafOY2Ka7r9mT9jh/TrHo03cyjrFpaJwnc78ghrBIOHEPeeAu8jRDSRv7MNo7DAKJDQY8elyjgkUkbzWW/048=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=Jh6kP/Cs; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="Jh6kP/Cs"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5D575479AE7;
	Fri, 28 Jun 2024 11:25:11 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 5D575479AE7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1719591911;
	bh=SKdeSdH4I0mJpAbGkHWk1V/+hqgHojNNih/Rhp5USkg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jh6kP/CsvyH7Ruhd87t2V8L+gb5hHo5BBCfzGDgxzfKQq+OfeS5t6JlLXWmldz0fe
	 jmqw/NmYiae56ygjaKPs6YZlkMLZX9U6y88p3Fimd6MMXmFeVU9U0F/kE4kE8ETltx
	 VMaU1l2ZoyrAlJDn5ZGJje/kggVHvRQ/shM47m/IeNrs4i49cyD3MsJ+DIH+3uMcb4
	 ITYSZzPxWSdZgS6Q6PJIcUs83R7hkMghm86c2p5xieMswLTVkR4kOfhfmdfEuZW/0J
	 r8txHOg8QuOymbM4Px74s3ho01l0H0uCqwLcqBVy37MKFKJ5Hy32+mALr6sGf2XCpK
	 tRPiwWazEz7dw==
Message-ID: <9b8357bf-a1bf-43d0-b617-030882540b34@sandeen.net>
Date: Fri, 28 Jun 2024 11:25:10 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: add __GFP_NOLOCKDEP when allocating memory in
 xfs_attr_shortform_list()
To: Jiwei Sun <sunjw10@outlook.com>, chandan.babu@oracle.com,
 djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 sunjw10@lenovo.com, ahuang12@lenovo.com, yi.zhang@redhat.com
References: <SEZPR01MB45270BCD2BC28813FCB39AEDA8D72@SEZPR01MB4527.apcprd01.prod.exchangelabs.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <SEZPR01MB45270BCD2BC28813FCB39AEDA8D72@SEZPR01MB4527.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 8:12 AM, Jiwei Sun wrote:
> From: Jiwei Sun <sunjw10@lenovo.com>
> 
> If the following configuration is set
> CONFIG_LOCKDEP=y
> 
> The following warning log appears,

Was just about to send this. :)

I had talked to dchinner about this and he also suggested that this was 
missed in the series that removed GFP_NOFS, i.e.

[PATCH 00/12] xfs: remove remaining kmem interfaces and GFP_NOFS usage
at https://lore.kernel.org/linux-mm/20240622094411.GA830005@ceph-admin/T/

So, I think this could also use one or both of:

Fixes: 204fae32d5f7 ("xfs: clean up remaining GFP_NOFS users")
Fixes: 94a69db2367e ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")

...

> This is a false positive. If a node is getting reclaimed, it cannot be
> the target of a flistxattr operation. Commit 6dcde60efd94 ("xfs: more
> lockdep whackamole with kmem_alloc*") has the similar root cause.
> 
> Fix the issue by adding __GFP_NOLOCKDEP in order to shut up lockdep.
> 
> Signed-off-by: Jiwei Sun <sunjw10@lenovo.com>
> Suggested-by: Adrian Huang <ahuang12@lenovo.com>
> ---
>  fs/xfs/xfs_attr_list.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 5c947e5ce8b8..506ade0befa4 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -114,7 +114,8 @@ xfs_attr_shortform_list(
>  	 * It didn't all fit, so we have to sort everything on hashval.
>  	 */
>  	sbsize = sf->count * sizeof(*sbuf);
> -	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
> +	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL |
> +			     __GFP_NOLOCKDEP);

Minor nitpick, style-wise we seem to do:

        sbp = sbuf = kmalloc(sbsize,
                        GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);

in most other places, and not split the flags onto 2 lines, since you need
to add a line anyway.

Otherwise,

Acked-by: Eric Sandeen <sandeen@redhat.com>
  
>  	/*
>  	 * Scan the attribute list for the rest of the entries, storing

