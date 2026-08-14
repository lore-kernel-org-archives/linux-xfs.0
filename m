Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD84413D891
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786723377; cv=none; b=nuJAPOwOnqKuSLgVaFD4sbLcfyL5KTeG5OVXx5faD2tjnLPExRGNp6vR5iwbgscNp8py3/xKByd/2pg69L/RzJqVeVNF+9bKzg3XqbLuWNuXIVsmhbvAvhnabDPBQpJFttFnjSaZTubkpVVCiBIrcyTu2ut2kU8Ht0RDjPS1mTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786723377; c=relaxed/simple;
	bh=OielwmkfvQ/bGfDZL2YiyHSRRz6V73nx+EJ4g4kMIIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z6VTuwK4gBQMJagor764dKqzi9TVS20dijMIjj/GFU1330QkVhN8sj1nAJ5TtgLzi6hERvtulJ6sWq0pld8ad/C45Fjdph+QihDPmYx4/HzRCw/J2bU0D521dkONUQGlxgdmKZmrABOSQOREf6cmLcG1w2VZRGcE12CAhIILVzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=M546g2yL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WuuhVAHU; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="M546g2yL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WuuhVAHU"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BBD7314000E7;
	Fri, 14 Aug 2026 12:02:54 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 14 Aug 2026 12:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786723374;
	 x=1786809774; bh=QYhgrRzRiIDaFxWxjzhuwe8vWvGHjICrQiW1FTBvt1o=; b=
	M546g2yLPQlqws0FGycFZwSzWMP8IqAAd/HbHHbXF2k3AawrOcXQ0Qv7TUaNQ8YV
	370FQH7SPZMVMzX+5qawmLIgYtmXvOApmH0Co7uF2sRRXxeTufp7rSo5uTRON8gK
	4HFyGgRk+YCEWvXgpJw/Hox9J/WBZk+GVz1LsNgMKPLe8mC7xmbj/ajPeu5iPNxa
	gY9o7z8GZNgb5muL01NgDksMVIpS5U1rh02M5+x8UpsZCFTsgOOmNRqr72ZhRzAt
	7Nt645kjl8YeIpV2GdQvOHDul2otdnfSOOwxfyAU5z8JJ/mWM1U85bKDLF5d6J2w
	WUZUUWZlO4szMPSFQhMghQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786723374; x=
	1786809774; bh=QYhgrRzRiIDaFxWxjzhuwe8vWvGHjICrQiW1FTBvt1o=; b=W
	uuhVAHUoYNMDK/0sGCf/BtQeWReCtDKjbhfXOMwfvKzvWQoFborrItm+eMKPW4YZ
	ZI3N5g/JFGxYSH7vbZcOzcuOwHsBX25ST8XDEIXPhNnWz7mIq4c4+xzl+2StTj7j
	Qz40GwamCc/WEMctr8XlWnaMkdAMJbZTU2zgOKs5+UGXO80pKC62Y42Cnnp8oZ35
	+ZAyeGQnp4vOZHUKN0y7BMuMpQvX9JV/kKZWpMHOqpg+5QbCS2xHHPVQ4S1qBFqD
	TjILwczbg6d0t755CfrY6DkadWH6HuZOQOkJLu23DAVLVDQ4ZlUMfjU5OzuGKPER
	iejwQ0/sacIHMUZkCzh3g==
X-ME-Sender: <xms:LTx_ajZ6FpZMX5Y1ecqtdIwZL3zoMELPlDUVrEp_I8eqcE6cBDUCcQ>
    <xme:LTx_amHOl46YznMCvDUGdPmvI-2Qk213W0cAMP1YDvOqK9-nOFirD-D_TbbXxueGW
    9ECSjIM_SG9WmD-nc3jSpGZwr4dl6Q8w6bk93817I5DSFuIUXEeYYY>
X-ME-Received: <xmr:LTx_avxfPcIJG3CatH2CeApsrKVAfPTV7BdfJQD8Ux5ZB9wBpcjkbga60LzlzFEBXIMoI7mvrDiyJIx_mdZHKVjN>
X-ME-Proxy-Cause: dmFkZTEC8hCadkRPHQJjEAY44A1Gs3XQA2yBp0wEpE+gH+Ek/olIlWLwulayq+FXgWuxUL
    jX7Y+AoEWkVUAgkUIbuyNiUUzCoGfHhAP9bDJHn94KrJ3cbFQ/0FIWmdq/AUqqN0o6nyPj
    7sjEEDHIpHZd66OBspZd7tjWc2VtEHfNcp+u7iQ+SLbW/wf0ng6VKnGhMVfoHA6FVabTtT
    lhlSjdTMaWL4zlQmm1MRWXPfX7LcjM30nr48cx7jIdkdi6Z7DMSIHa4Or5oxGj6LkZnnOF
    L72jHk921KmBzYLle+dr2NjVyFGLdmGcKjrigNRY0fvSEL5EwqfC0NKiSAQq40QQAIAcMf
    qEGRi2k329UdM8FJmITYpJDlDSbae60ECXdgaLOgir7ErC/TtpYgvfCkWIhukktw6Q1xAZ
    qVfPQ1ROdiHxY6MvidEd+pHoMo1zkCuZUyUh4VnYLpjGE3XoyTLzeSbVK4s5jhnRxFdwqu
    gOIJTkabgaysPvyDBGOzIGYHNPXaEqpcJyCQcmnx/aqhDSnhQ67hIJlsLQMXCT8YK57SHW
    lFyWvGk8QFYVyGd3mxw5VZFzZrH+iQCxqcC+pQOjthK7+F5lL66faH/Gu23DKvq0UKwwV6
    yGARW7W1rzeWRDkEXbDPozWwroc/y9/+Jpv9M/LpL7tvibv1IbtVOaW3UGDA
X-ME-Proxy: <xmx:LTx_agm2m8DkDoJaNBEEhbKSSO612BA-aDYRT2tNEaFmydiNUSoFrg>
    <xmx:LTx_aglnmuxfW9T4J0aAkvBU3NCyp8-K0ae5KuQ5KdScfX0F9zEyLA>
    <xmx:LTx_aqwTzM-OH8iPXAr7wz9GmAbOCMxJwSDF5qiLBpn5FVzl2EdHFA>
    <xmx:LTx_atpeKSwEAGMIBuAQJ9HInaDR0_pnpCkQoqSFAULcwYPiQksvCA>
    <xmx:Ljx_ascGYhi6V-y5gyiBka_dUbY8gDR5XLo-UVr-utb36f6PDbxCPDur>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 12:02:52 -0400 (EDT)
Message-ID: <afa1e118-954d-4cec-9417-a0f48474fe76@sandeen.net>
Date: Fri, 14 Aug 2026 11:02:52 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs: count folio alloc'd xfs_buf items in
 NR_KERNEL_MISC_RECLAIMABLE
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 Vlastimil Babka <vbabka@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20260813204929.2253988-1-sandeen@redhat.com>
 <20260813204929.2253988-3-sandeen@redhat.com>
 <an7C0L2PT-Ous0hn@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <an7C0L2PT-Ous0hn@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/14/26 2:25 AM, Christoph Hellwig wrote:
> On Thu, Aug 13, 2026 at 03:40:53PM -0500, Eric Sandeen wrote:
>> xfs_buf allocations via xfs_buf_alloc_folio are actually reclaimable,
>> but are not accounted for as such. NR_KERNEL_MISC_RECLAIMABLE seems
>> made for this purpose, although AFAICT there are no users today.
>>
>> To achieve this, add a new flag _XBF_PAGES to track what we have
>> allocated this way, increment the NR_KERNEL_MISC_RECLAIMABLE
>> count when we do, and then do the reverse when they are freed.
> 
> I don't see why we'd need the flag.  All buffers are either allocated
> using vmalloc, kmalloc or as folios.  So it should always be set for
> folio allocations (and is misnamed since it now covers folios as well).

Hmm ok I think you're right. And using PAGES is misnamed, yeah.
>>
>> These allocations now show up under nr_kernel_misc_reclaimable in
>> /proc/vmstat when allocations are active, which in turn makes
>> MemAvailable more accurate in /proc/meminfo.
> 
> Adding linux-mm and a few people that touched this counter for
> opinions.  I guess the counter is only for full folios, and we
> should not set it for the small than page kmalloc allocations?
> But even with that, why not set it for the vmalloc allocations?
I hesitated based on node accounting but dchinner sounded unconcerned:
"If it gets accounted to the node of the first folio,
then it will at least always be consistently accounted, if not
always 100% accurate for the vmalloc case."

I fixed those up but won't resend just yet, thanks.

And I promise to use more columns next time ;)

-Eric
