Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8272146C4A7
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787836804; cv=none; b=rGl7+P1288clhyO6L1d/to5M1Z9cF+qrWNL/H3LX+LYXKnmOzRP/sgWCio3M6H8fnqVaPIpoLoGhV/YX9vme95HP+HfU86hLjg3mMoFkz4oz9L37PCdraqZKMpGHvzQwWQbxTDp3SOr6wGWCbbNPN6RtJ9CIEHV44oEuxjuwRNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787836804; c=relaxed/simple;
	bh=Y2tFkUDFUDbxIaSSONW1kn2wVkuj9WFDCeFUOPMj0ec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jmxrCiv+59YUkTTW+ZSgSQb+57Rd01N7wwrE65QWkDyWpYZNqpOsSrSCe4obP0s52vjtVfOj1S8Eau0oUd5lNKWs7TNHNY4oom3/r5nY0OwzwevBGezz7eInTJSk91nH47Ejn/6PYjXu2yK5SjcNjlC2Q7PwCe4tXcdgeO/Wuvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=RZP72RE6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kV566Uk4; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="RZP72RE6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kV566Uk4"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0DC18140012F;
	Thu, 27 Aug 2026 09:19:54 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 27 Aug 2026 09:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1787836794;
	 x=1787923194; bh=0UapnC/dOJ7hm6o+Vhu5fAgTo1RHYMDCYy1A1oWJUGY=; b=
	RZP72RE6gLyo1RNJSSUaAMLxYC7MTNStbcUevPx/fXCXPLJpgOYCS/259aPkRCAv
	aaNFMehsLhLiH39kXSEaSEfI/jADeq8T4SuqnVAgkMp8CMpQtREKAlK63VbpWZ4Q
	aJN0B9nEtq59xieUOSgorYLGTgusrf6PDWnqwxEauYobRhXo+YnOeBcMWfAzt0RN
	ap1WBpII2oR2Q2FjUq5FDARMuKNWC0qpdXcM2RqOVjRrivD3NctJIugZqKXmjLjy
	yHKfBFCehc2ReKAuadvlQ5Y5hZODpt2Sc5tF11OlEVlvmaCAleO5PnpR0pRU2Pgm
	X4m2t//sdiy4d1s0xvnWyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787836794; x=
	1787923194; bh=0UapnC/dOJ7hm6o+Vhu5fAgTo1RHYMDCYy1A1oWJUGY=; b=k
	V566Uk4YO1UNmjWaYW0OK6hoffCbApLBUT+qSl3gWnpaCDPivgqDao/GjEyHe2RA
	ks26AklpDwK/l1jdyUb7kLHwP4I+LFmQm+J41jBWzRihCJ00f15yeSP/eMEGBN29
	v/N4qytlSG/cYYIYoSfHoe540+ny+r+nCrp/ZjEiP0ZUmyJS+DMsBuZ4MDytNClO
	zIweTxLgCf9v22kCv+H9RljbjM0qOUi+DKQkm3h0yU2q78g2/59MdsKloJbp8rPJ
	WohNYd1YAfoBJgw75WGwqzRw/UXLkHdeauoHs9ekEfAsLiXjrUYvtNWDISnxSYLF
	+v326ZfTAx6EDqcL53GGw==
X-ME-Sender: <xms:eTmQamJClFRZVXcKGGphqLf7vlP-udMannga9IosMZ_dPTx9zF0UJg>
    <xme:eTmQallH7hZp4Jz6RAAStQ2MUKn89koLrbWLvEK_9OarCP2icm87DzpsW61v1IbEJ
    J8eNXihElUw4x2m9AL2Dak11d4fdxc2CihjOh2ijfQZbhX4VInpevE>
X-ME-Received: <xmr:eTmQakFfGACqeVSLUV9gSu_huADxosFee6G70A7O2wlIbmYFtLpBrjd3V_PsqWTbwUMpAxOL3vu9KU8gaO8vkPDc>
X-ME-Proxy-Cause: dmFkZTFenPoNkmErbDECoqV9lkQA5xjJ+uiESHXeOkvtnFjK0QpcDx0nTXT9IacZqnnRKf
    pmyOW/A3uZ+Mv5YpjrcBOuRqtiHza/RO28F98mJKZzbwTklPf8EV8HUd9EQMhCaFO0Ywl+
    4vsFux4XhmpdFiwR6PlVMCBbO4xZUcSqJ3rDJG054wvNORp5nMcbRs6cRgNGJTj7/+vyf6
    4CyMLypfa1Ec3Vy1ZHqs8OXHsaUOOjVpL1FWL1HP0VBVEm3i3k8OpElZMfopeucBEcgyRG
    kC1KRU/gk4sT2VzBMUYLx0WLO38o8Uep2/4DKWtef9yUfaL8DXBP6RvxiOebE8WJhWS0F9
    Hc9axO7T8q5LJXv95sGeO6HRRgytZKBshzK4M0y3LKCLfjSdLk3/7H0vB0hYcixREKXDb4
    6FwPDxtPkgfG2ZAy3eM+u/Y2BIM2PuzAt3Tjr7pRWb16EDKIhjo+py5ZLJ/QuHavFTEwQX
    Ck3iDNcch2OBnPPtyuvM85oDzhsRDD1+mCVnMgngzrEXhPBwF93bsktWLYvSWhXfn9bcHV
    Iy8M+Ka9PRfZ9qtAndaIv4cotacGkM3FPiVJ1c07efrVu5sLj29dwbj8NhREguIsGEGNOV
    xTcLRNufBPBJDfFrEnEH1YndMMFBQB84Y/oLIDzbJSH4nFtsuRVs/RoVqTDw
X-ME-Proxy: <xmx:eTmQalF4qwaNldElMabUeTsy7Wo-fUmgFf1bNiCU0K2SbNXFWZzXEA>
    <xmx:eTmQahN8KHjjn7TfhBXRpSvvodvG8yJ1VLm-8zUZexYRdxzrHrNC_w>
    <xmx:eTmQakFny26ASe_I_OY4bAtueJjn1b5YnqQ51nxCXe5Am1CHZXyWbA>
    <xmx:eTmQaoNmHuc4N42nAMVc6RP0BLXiDXbMFH94Go0uJ8w4VawxKOIHew>
    <xmx:ejmQaoWTwUhvjg6iQt1T-96v3Guo2txt-Qw_DEYP19S6IB7tviZIdjXu>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 09:19:53 -0400 (EDT)
Message-ID: <8d2e6c40-0d22-4eda-8f7f-be2678b53d2d@sandeen.net>
Date: Thu, 27 Aug 2026 08:19:52 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mkfs: Emit a clearer message if too-small log is due
 to AG geometry
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <20260827034228.938740-1-sandeen@redhat.com>
 <a1864929-f3df-4c0a-ae47-019cda875c99@sandeen.net>
 <20260827050119.GA6072@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260827050119.GA6072@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/26 12:01 AM, Darrick J. Wong wrote:
> On Wed, Aug 26, 2026 at 10:49:38PM -0500, Eric Sandeen wrote:
>> There is a constraint in mkfs.xfs that logs must not be smaller than
>> 64MiB. We can arrive at a too-small log without specifying its size,
>> though, if we specify so many AGs (or such small AGs) that a single
>> AG cannot hold the minimum-sized log. This leads to confusing output:
>>
>> $ truncate --size=500m testfile
>> $ mkfs.xfs -dagcount=10 testfile
>> Log size must be at least 64MiB.
>> Usage: mkfs.xfs
>> ...
>>
>> because the user did not specify the log size at all! If this error
>> occurs due to the AG geometry specification, make that clear with a
>> better error message.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  mkfs/xfs_mkfs.c | 19 ++++++++++++++++++-
>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> V2: Ugh as soon as I sent this I realized I forgot to restrict this to internal
>> logs. An external log may be too small all on its own, unrelated to AG size.
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index a4864c37..4f11c9de 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -3456,8 +3456,25 @@ validate_supported(
>>  	 */
>>  	if (mp->m_sb.sb_logblocks <
>>  			XFS_MIN_REALISTIC_LOG_BLOCKS(mp->m_sb.sb_blocklog)) {
>> -		fprintf(stderr,
>> +		/*
>> +		 * An internal log must fit within a single allocation group.
>> +		 * If the user specified the AG geometry but didn't ask for a
>> +		 * specific log size, the undersized log is due to allocation
>> +		 * groups that are too small, not a log size the user chose.
>> +		 */
>> +		if (cli->loginternal &&
>> +		    !cli_opt_set(&lopts, L_SIZE) &&
>> +		    (cli_opt_set(&dopts, D_AGCOUNT) ||
>> +		     cli_opt_set(&dopts, D_AGSIZE))) {
>> +			fprintf(stderr,
>> + _("Allocation group size (%lld MiB) is too small to hold the minimum 64MiB log.\n"
>> +   "Specify fewer or larger allocation groups, or use a larger data device.\n"),
> 
> I like this!  With a couple of comments:
> 
> Can the warning message be more targeted to the option?  e.g.
> 
> 	if (loginternal && !set(L_SIZE)) {
> 		if (set(D_AGCOUNT))
> 			fprintf("Specify fewer AGs or a larger data device...");
> 		else
> 			fprintf("Specify larger allocation groups...");
> 	}

And if the user specified both size and count? I'm not really convinced
that we need to go that far, I guess. All the logic in that block is
kind of eye-bleeding already IMHO.

> Also, what do you think about not hardcoding 64MiB?
> 
> printf("Log size must be at least %uMiB\n",
> 		XFS_MIN_REALISTIC_LOG_BLOCKS(20));

That give blocks, not MiB I think, right? 
> (separate change obviously)

Yeah I noticed that but was just following djwong's lead from the existing
printf. ;) 

#define XFS_MIN_REALISTIC_LOG_BLOCKS(blog)      (MEGABLOCKS(64, (blog)))

Maybe we'd need:

#define XFS_MIN_REALISTIC_LOG_MB	64

and then

#define XFS_MIN_REALISTIC_LOG_BLOCKS(blog)      (MEGABLOCKS(XFS_MIN_REALISTIC_LOG_MB, (blog)))

and then

printf("Log size must be at least %uMiB\n", XFS_MIN_REALISTIC_LOG_MB);

or something?

-Eric

> --D
> 
>> +				(long long)XFS_FSB_TO_B(mp,
>> +					mp->m_sb.sb_agblocks) >> 20);
>> +		} else {
>> +			fprintf(stderr,
>>   _("Log size must be at least 64MiB.\n"));
>> +		}
>>  		usage();
>>  	}
>>  
>> -- 
>> 2.55.0
>>
>>
> 

