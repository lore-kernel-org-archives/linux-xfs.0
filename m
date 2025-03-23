Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404E52E3367
	for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 15:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742745117; cv=none; b=Yb8uF8zxYl6CrfISCF4Uy0+KzW0B2HpG1ZAVwclNSONTgKfgFqkmEUoFg1OFdrceV521Lo2jpmeFNuS6tfvO/SVZ20Q+m4/JdqyWBR89JjnmvLSd2CWCsKzQRdzj04IE3NrT203Rm9/c8s6X8v4SJxktBt+sX3D721jc2XRZsmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742745117; c=relaxed/simple;
	bh=GTM7Y+qwazLFio+J0sKVzgVuwQy0rQSL8bhKGABbHf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WzB3GaLMXUJuw/HuPYC4Hu1GkOyxKD+te4fR34vMCOrt2fne9AbADaBEhyTGmpzCUm7c5onqaFlpP+/svB8JVQMKN8OOQpFkvcomocykoYK7P/CJ40xiEoJvk1YQVSE4nq5tO2+vXG9gWr4OowJ616x3oyCkYBy991dhLoXJeUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=cVXK/7s5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UuFvm717; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="cVXK/7s5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UuFvm717"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 2ECA21380A62;
	Sun, 23 Mar 2025 11:51:54 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sun, 23 Mar 2025 11:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1742745114;
	 x=1742831514; bh=6RYFLLMAo/lELP9AEp/14aq+b2e01aGipvaPLUFiFRQ=; b=
	cVXK/7s5vE4jWZIMryISJQW9SN/bu23svhzC1Sdx/U5hKaEBJEDMmqpgo8/7Apvf
	uIYfsM1MnXHaEG19tcpWT9x5iOHlcGqDNZAtx1Cc2vSmyfeBYH2ocdbhqXq5QuxX
	IIEcZw2v15h1mnSZah3E2u/HUt2knP61abXMldKYHdFIGIZ6/NlqW0EOkfXlogF3
	P8+ZgMWC7jYbceSV4wGtrme+vdjhfqGtN/DFk4G5zneWGX8O+1VgIoiLrZA65nth
	HtOEW+xoOav37qvUOiSrtziKY9KrrjOIayedLA3ISPTojIIL8KGG/dOAaKP71ns/
	Pg5Gq1a7umrRDDiqUoE6hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1742745114; x=
	1742831514; bh=6RYFLLMAo/lELP9AEp/14aq+b2e01aGipvaPLUFiFRQ=; b=U
	uFvm7177YGJ4hK1piZaFbfc3k4y49HhBAebraOJdQwwljbGoWXC+10G0asGpiIxc
	1dbAa4X1A3KabxyRxDeUrvkaNUU3c5NdW4+wLPj/f3aDJwFzuupgO2udcCM7VdG8
	fWToF07yzhNMA01m5hs4oLBqLqAJ0QaS3AAvgPLuXXYK73j+ZGxuWtvy2xb9lRnt
	y2geB7E+GZFHoRPfrreapblwvsGtdCIRL+AD2v2tJUVURh/j2DqU7ojTyu2zuez8
	hKmXb/QEHlC2rhsXlvBGb22WZ0i2alILQO9FjLxbsbaas/XaodDplI2iTdLXTIoV
	D+CMgQ55bVF3WBrMDzZDg==
X-ME-Sender: <xms:GS7gZ2x6_Uw7Hj5902ulOCeiOIcJt8r00_BLRdfjZEIJxo2ueJJRKA>
    <xme:GS7gZyREcE-KXbgdJsaDS7kI0B9EkMqWzmMGpamqiU-lKBBuKyo6h2lsDkq-a1ET0
    h-7i1M_K2dyvCez93s>
X-ME-Received: <xmr:GS7gZ4WzlbClDGosofiXsqF4aPpt5ufQ_QcpnoQDX5hzux5XtBMPMzDHCIjL-JA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduheejvdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepgfhrihgtucfurghnuggv
    vghnuceoshgrnhguvggvnhesshgrnhguvggvnhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveeikeeuteefueejtdehfeefvdegffeivdejjeelfffhgeegjeeutdejueelhfdvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrnhguvg
    gvnhesshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepsghoughonhhnvghlsehrvgguhhgrthdrtghomhdprhgtph
    htthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehhtghhsehinhhfrh
    gruggvrggurdhorhhg
X-ME-Proxy: <xmx:GS7gZ8hZhsgPUq69AzGvubmALQBY7sble1CnyUhs_HCWu5jY2AhrzA>
    <xmx:GS7gZ4CugYaQi0073xfpY_UCTJ6-YBAJMbbFIBCwzPAKXMUUmYV8vw>
    <xmx:GS7gZ9Lo5Calmnbj55qDvQHTq2Hj4mfk5hFG2GGbngt1-Kb8QohpSg>
    <xmx:GS7gZ_Be2WhFn0p3UShsbbpWzeMffCAIq2oZz8FRee9hOIWxjv4muQ>
    <xmx:Gi7gZ7_bnaOXH50F5HdqAhBXfimutZrNdUshzNguF29nFxjpkVrgiG6Y>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 23 Mar 2025 11:51:53 -0400 (EDT)
Message-ID: <19fbe9e4-c898-40b3-a4b5-5347f78e31d5@sandeen.net>
Date: Sun, 23 Mar 2025 10:51:52 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs_repair: handling a block with bad crc, bad uuid,
 and bad magic number needs fixing
To: bodonnel@redhat.com, linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@infradead.org
References: <20250321220532.691118-4-bodonnel@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250321220532.691118-4-bodonnel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/25 5:05 PM, bodonnel@redhat.com wrote:
> From: Bill O'Donnell <bodonnel@redhat.com>
> 
> In certain cases, if a block is so messed up that crc, uuid and magic
> number are all bad, we need to not only detect in phase3 but fix it
> properly in phase6. In the current code, the mechanism doesn't work
> in that it only pays attention to one of the parameters.
> 
> Note: in this case, the nlink inode link count drops to 1, but
> re-running xfs_repair fixes it back to 2. This is a side effect that
> should probably be handled in update_inode_nlinks() with separate patch.
> Regardless, running xfs_repair twice, with this patch applied
> fixes the issue. Recognize that this patch is a fix for xfs v5.

The reason this fix leaves the inode nlinks in an inconsistent state
is because the dir is (was) a longform directory (XFS_DIR2_FMT_BLOCK),
and we go down this path with your patch in place:

                /* check v5 metadata */
                if (xfs_has_crc(mp)) {
                        error = check_dir3_header(mp, bp, ino);
                        if (error) {
                                fixit++;
                                if (fmt == XFS_DIR2_FMT_BLOCK) { <==== true
                                        goto out_fix;	<=== goto
                                }

                                libxfs_buf_relse(bp);
                                bp = NULL;
                                continue;
                        }
                }

                longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
                                irec, ino_offset, bp, hashtab,
                                &freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
...

out_fix:

        if (!no_modify && (fixit || dotdot_update)) {
                longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);


longform_dir2_rebuild tries to rebuild the directory from the entries found
via longform_dir2_entry_check_data() and placed in hashtab, but because we never
called longform_dir2_entry_check_data(), hashtab is empty. This is why all
entries in the problematic dir end up in lost+found.

That also means that longform_dir2_rebuild completes without adding any entries
at all, and so the directory is now shortform. Because shortform directories 
have no explicit "." entry, I think it would need an extra ref added at this
point.

But I wonder - why not call longform_dir2_entry_check_data() before we check
the header? That way it /will/ populate hashtab with any found entries in the
block, and when the header is found to be corrupt, it will rebuild it with all
entries intact, and leave nothing in lost+found.


Thoughts?
-Eric



