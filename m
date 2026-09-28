Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205814D37CB
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 15:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790608067; cv=none; b=MwKCPQ8wS6Qa86N2AAQ03z80B+vJhkvGj6TZXIrzffbSOtfO5/7FuFoBmbeg5tcMuVjYpYncKyo0wpdqKRqnT9hxFFrCyJIZPzDgO+Zy9bfSpZ66wtO2IVdtBUrFzB8SqGGJ2QHh7WXcEw5JRPF9SoAkjhywI0iOMSJi0Q4zYmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790608067; c=relaxed/simple;
	bh=CI6ZsUDZRyFAY21xbRXo12PFZkj7iO5LL1hzr5Nf1C8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T9822EIG9Ih/XRApJ3nSHNHa62d6EsYs19SNkb//Jz66F1K5be6uLCYTVAdTB2aVn5TMUw1aJ4yvyq+hyOCUipxF1PetXb+rR1E3F+MxpPlg+FQUw8nG6/PnhVLyxEAMMi2gZF8sYCSj+V9OjUjiGrUAdo528NZVQqb5/9B/xBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=ZuEpkcuH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=di5j6YqK; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="ZuEpkcuH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="di5j6YqK"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 4BC281D000D6;
	Mon, 28 Sep 2026 11:07:45 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Mon, 28 Sep 2026 11:07:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790608065;
	 x=1790694465; bh=Fp87JteHmkVGXNoeOSgJvETp3hjOx0lF/6Eiudx83Sw=; b=
	ZuEpkcuHeCPMvbGCsw2FA/DcZ777eB6lWoOQY18a+NSHXUFtPRRIof04kpTGzTGE
	AGgbHhNp9dSIxHFBI5LLbnCkZDwvDSq1CzzCP7G3w+gWPS12RlPTz/d8H+7HFSgM
	tWgqvJFN+MRgEuAZVDDHlEt+VE2gsFDr9LaM77nfGIlL71txcOQT0NU7hfcl9Dtj
	4iC603L+EfH64j9jAxT5rpci8Sh5cgSHdcETSlJFo8FzOstVe3FQ1FtxbyTyLdA5
	4wBScBNZ1MqepzeFyP3QhYjgAumcAiLBvm4mSt6nYkwVlOKLjIhdNMP4w6PVVWqW
	p6vwPDSSyBfJzDoFCw5lkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790608065; x=
	1790694465; bh=Fp87JteHmkVGXNoeOSgJvETp3hjOx0lF/6Eiudx83Sw=; b=d
	i5j6YqKArQ+nBFmlyrAYiagFgon3sI7DUs578pJq0hSRRmTlnzMwwZXNdw76AXuu
	u+aTI4Yrl5qTlm1fsfxUthEtrcggKjpEvKkdkuMowf3X6O0aEW8PmoNZ+fYpWznm
	zNO9dORLpuef9r/6NOfs10L0q/zSSq6e2YAdH/m8Auu24k4fBZTFMuB0tqB3Qezy
	xxFrBZ3sz843jZsUGsGbG/0sSG12IT4orYn+FScqumoy3UpEAMS47rjBOitCSUyT
	+GSn6xDhf8pgqFP/lX/hZ0g2T0ocHHVMrvR3iLUklbKK73ReMik7FHoFJjdFcvAT
	SsTH3DQaxerVs5IbxI7GA==
X-ME-Sender: <xms:wYK6an0Bfw_Wc2_F9Yl2Zlmjw7mpsmXojaz7D4oEhBHmkFC4nbht6g>
    <xme:wYK6atGw1NyLhtftPQXOjAC4l5SVjDKgCQC_7wXGTl-cokBIlvw_XJU1BDd35_Hju
    qfnH0_kKNG8ybwGGLAW3ZwoiF7qyIz6p6ss6uzYNG8szNnSa410>
X-ME-Received: <xmr:wYK6as4cAcr321O96MDFr4vcyB13iikIwrl06fGxikepOsVu92NG64xokElK0KXPe6-Vfjw3PMm68fxVceHEV_m4DUuRGw>
X-ME-Proxy-Cause: dmFkZTFKs+NnxBWVgMvByCY6f7zpveQKUyVZvOkjxkiE+xOVJMcWINSWt/mFim0NnNRzFA
    TzbTXghgrnkVU5fbTmL0/dEuLJd9MLjU7MtdfaZ/U9lxFnNUd82kAQH6ej3RvdIPCMPpJv
    qEkjroQXJY2KLezD9V+iyACFy9pffTMUSfULiYw3WwhlZQBY3/GhTuGGc/mKBy038A8pmh
    cuRkzjYC6RTJ6vgOJAh0L71hmtuN7on1yCM6jbfT/aFV73S8aYyNqPiddFDSC7mMtwJMQz
    SFddINDvUx4QcIQR85aJWAj8dWhD9e2ByVGMkitSFa8xSoJnz8k/paHn+/tYUXE3lMrim5
    n7qhf6+l4MUlnKKUsmWMpsh74TKUgQ0hV3kq3n+Dy1qYz4qEAJeQOqAaqzaT1chPL/nCFI
    2LCSw2DZLNRBjrNDZvWWh9NjeAQFXytB6PDzXAK3a7iZrmHPQq8o1i7q2MtP0M2wuKcdra
    9iFUV7yqr48U4xer374hnvTDE8IbfgFC74GiXZBSgDt4yeTuduxJ99eSNBcDRQf3cXoXar
    GQxQz2v6fJ0+A7sZLS4K0ym6VZIHjiuQTyaMZk8+g0CVIq7g30xH2SCSfLLdlrw7yIONHl
    gKlxl5ahsK6Uiqf+BEWruM9qvX4DC2b67mixMRTqKUaKVHua/Sis/NyERg8w
X-ME-Proxy: <xmx:wYK6artlYg051IpULKaS8eb4iqqzrgsAQ0yjOFAP5d2w-ItmjNS-zg>
    <xmx:wYK6al6I8LmpbcERHP-6WmeTpkz0RAihmCJumkPDFjNMWvekde5Opw>
    <xmx:wYK6auXRLM9wVrRi44owysmoDi5cll0i_10hShSqVLuyVzTYFG5fMQ>
    <xmx:wYK6av8vsBetvTNK3jN8GTCv3sLTl_UTKsDdeeEk8Wd16Cbtx5iIlQ>
    <xmx:wYK6aqLkdB2DGUb1dYyNM4wa5ErmytiAnm_N5MwPXw-ciCtOqDYSITio>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 11:07:44 -0400 (EDT)
Message-ID: <ad490fb9-d21b-4019-8910-190dce6950da@sandeen.net>
Date: Mon, 28 Sep 2026 10:07:44 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] libxfs: Return -ENOMEM on actual cache node
 allocation failures
To: "Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
References: <20260925194535.397036-1-sandeen@redhat.com>
 <20260925194535.397036-3-sandeen@redhat.com>
 <20260925225847.GC2705364@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260925225847.GC2705364@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/25/26 5:58 PM, Darrick J. Wong wrote:
> On Fri, Sep 25, 2026 at 02:41:44PM -0500, Eric Sandeen wrote:
>> Today, if we get an underlying ENOMEM from an actual cache node
>> allocation attempt, it's indistinguishable from "current cache size
>> is filled" and we'll keep doubling cache size to no avail until the
>> size itself overflows.
>>
>> This patch differentiates "no node returned" between the "cache full;
>> grow it" case and the "underlying allocation actually got ENOMEM" case
>> so that the caller can do the right thing, and return true ENOMEM
>> up the stack for callers to handle.
>>
>> Finally, actually check this returned error at the cache_node_get
>> callsite (in __cache_lookup).

...

>> @@ -464,8 +466,8 @@ next_object:
>>  		/*
>>  		 * not found, allocate a new entry
>>  		 */
>> -		cache_node_allocate(cache, key, &node);
>> -		if (node)
>> +		error = cache_node_allocate(cache, key, &node);
>> +		if (error > 0)
> 
> I think you could keep the node nullness check, though in the end it
> doesn't make much difference.  It's not like you can return
> Result<struct cache_node> or anything. :)

Hm, yeah, that would be nicer / more clear. If Andrey wants to merge this
version of the series, maybe it can be changed on merge.

Or maybe we just drop this whole thing and move on to more useful work. :)

> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks,
-Eric

> --D
