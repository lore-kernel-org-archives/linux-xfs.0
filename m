Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9D623D2A1
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 19:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744744356; cv=none; b=hFxnnyFOi/APVk2eow9F8aPTVfiJxwtfUp1A+pO4Jq+tcJdUFPqpuH1A2o2qU/vz0pG8/4kZ54H8WjybxWPhdBFn7bOmL3z9FkNI2vqnhaLP+uv0W4YnLLwDzuVdmCztXvj6Yb8sqa0ty+9z6xRiS/3WmxngiV6qHZBuVQkE2Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744744356; c=relaxed/simple;
	bh=vxqqC/6VTzAUDiaAuR3qlpnUMwpT6X/wKp0EbT24+sE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MyDrgHFjhPnRi7TjS7wJjwEmSA9xbM4bBZpI6Wq/RFO2v00Kjo1Z0WVYjAOy/zfhixTtCZynC4jP3AQoGmgmfkJ2Nzu6xT1l7R3QWBV5KCYjCcg5GPxOz5j3JDqeD/JYh5PlH0US3oVXkq/PfTe2i6+Tzj1JM70gLBxplUKazmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=OyWbPZkM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sp8zXJ4l; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="OyWbPZkM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sp8zXJ4l"
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 16A8F2000C7;
	Tue, 15 Apr 2025 15:12:33 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 15 Apr 2025 15:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1744744353;
	 x=1744751553; bh=X+UR+0He1th18qX9aSU73XgEee35cvY/dquAcdCWhh4=; b=
	OyWbPZkM2FV0l6RsV57Vp2DuKlfPD87ZjJAKvBXb1YmRWleMDSABWE1yKlwDMX5i
	2m2yXG59nIpTjL/sza+oNfL2LF2XtXzr6OZXfinnMdwfb95+P35wLa9JoaSs9KAt
	lqsnp9cJHZyVGiJleD4BF756NAHXZ+onkb3XRRevnJr36k9kBuDmcHgK/bySsFzD
	0VJWWyfoatJY+/06DFZtfA4o37/tuRMOYcnn6d9AbU6eUXN+poMqpuX4tLUXAbHk
	fUPmEjCgvoGOWvZUqsqejEXU4bUT5v7KCoA2icV/uptz/Jt/u6KF71srzz0+Qwd1
	d93Swc1DoqAl/yhyup+GvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1744744353; x=
	1744751553; bh=X+UR+0He1th18qX9aSU73XgEee35cvY/dquAcdCWhh4=; b=s
	p8zXJ4lqEc2n3LnTHhCakqPXwUtJ64u+ASZsljWUSlRJPQrZHq9x2pz4/cXeerqP
	upJHcEVvNkj47tLrMGzfcWje4tZHs3gkFC1dPYj0cabW0RhOY8XaX07ip8vT4dad
	tW7fNaulkxXRQADbxLeIvlBVBKEZlleeUbhqfv1E+D6TJ2Tnc9fIWkmGk1sbBzKU
	pZf9dzuX9wiwdsXktMqKR+fMhNyuFGZr3pquyqqlOna3Zk8QAxhm92dKoxvJgjYc
	9USZxsOUCTu+NHPS3VS0Zs6F43UDqNj0HhnH9hKvZ+47xmWh0HFng7FWa6qmzlnl
	vxWwDm3PPYZVo/exDy7Sw==
X-ME-Sender: <xms:oK_-Z3AtA9CgG2sLfyNasgU41E-btc8Qvl0nh_VKD7oZgf-kjsU_FQ>
    <xme:oK_-Z9gUY7dDeqr_kU8ajD3awvy1c7_EK6v_GpOLg6ggG7SymUlb1N46378CHQS8f
    pQDImhcZfIzSkK0Sg0>
X-ME-Received: <xmr:oK_-ZylIapgviDE1vt5KLLIXE3UMzljghyVq7pR013I3jE8kl3-OUWpV3g0LYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvvdegfedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepgfhrihgtucfurghnuggv
    vghnuceoshgrnhguvggvnhesshgrnhguvggvnhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveeikeeuteefueejtdehfeefvdegffeivdejjeelfffhgeegjeeutdejueelhfdvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrnhguvg
    gvnhesshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepsghoughonhhnvghlsehrvgguhhgrthdrtghomhdprhgtph
    htthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrghlsggvrhhshh
    eskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:oK_-Z5z7xLpP-CnH0Q0UeZS710-SnyYL9_AnmdfMHeKUt3b3dwsR_Q>
    <xmx:oK_-Z8QNAfhBwq3n2mGQJRGQZ8SiXaN-vsrkudJnVxmc5WIGZQq25Q>
    <xmx:oK_-Z8aQZ7Qpbng1fbf_1SbVCO03rMUoL7-WECYNXe1JKFZA97HMEA>
    <xmx:oK_-Z9QZUHkcmsOoIHLKXCnRtW44lMNxKUAEhETDe3lXyylrpXC7tQ>
    <xmx:oa_-Z2DnXUt94JVmti9sr93iWYLwCNd-rLyMqF2z_zrx3SraWwecV644>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Apr 2025 15:12:32 -0400 (EDT)
Message-ID: <d20ee07d-bdcc-48b4-9e35-7228187d69e7@sandeen.net>
Date: Tue, 15 Apr 2025 14:12:31 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs_repair: fix link counts update following repair of
 a bad block
To: bodonnel@redhat.com, linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, aalbersh@kernel.org
References: <20250415184847.92172-3-bodonnel@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250415184847.92172-3-bodonnel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/15/25 1:48 PM, bodonnel@redhat.com wrote:
> From: Bill O'Donnell <bodonnel@redhat.com>
> 
> Updating nlinks, following repair of a bad block needs a bit of work.
> In unique cases, 2 runs of xfs_repair is needed to adjust the count to
> the proper value. This patch modifies location of longform_dir2_entry_check,
> to handle both longform and shortform directory cases. 

This is not accurate; short form directories are not generally in play here.
They only arise due to the directory rebuild orphaning all entries without
the prior scan, yielding an empty directory.

> This results in the
> hashtab to be correctly filled and those entries don't end up in lost+found,
> and nlinks is properly adjusted on the first xfs_repair pass.

Changelog suggestion:

xfs_repair: phase6: scan longform entries before header check

In longform_dir2_entry_check, if check_dir3_header() fails for v5
metadata, we immediately go to out_fix: and try to rebuild the directory
via longform_dir2_rebuild. But because we haven't yet called
longform_dir2_entry_check_data, the *hashtab used to rebuild the
directory is empty, which results in all existing entries getting
moved to lost+found, and an empty rebuilt directory. On top of that,
the empty directory is now short form, so its nlinks come out wrong
and this requires another repair run to fix.

Scan the entries before checking the header, so that we have a decent
chance of properly rebuilding the dir if the header is corrupt, rather
than orphaning all the entries and moving them to lost+found.

> Suggested-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

Other than the commit log, 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> 
> v3: fix logic to cover the shortform directory case, and fix the description
> v2: attempt to cover the case where header indicates shortform directory
> v1:
> 
> 
> 
>  repair/phase6.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index dbc090a54139..4a3fafab3522 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2424,6 +2424,11 @@ longform_dir2_entry_check(
>  			continue;
>  		}
>  
> +		/* salvage any dirents that look ok */
> +		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
> +				irec, ino_offset, bp, hashtab,
> +				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
> +
>  		/* check v5 metadata */
>  		if (xfs_has_crc(mp)) {
>  			error = check_dir3_header(mp, bp, ino);
> @@ -2438,9 +2443,6 @@ longform_dir2_entry_check(
>  			}
>  		}
>  
> -		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
> -				irec, ino_offset, bp, hashtab,
> -				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
>  		if (fmt == XFS_DIR2_FMT_BLOCK)
>  			break;
>  

