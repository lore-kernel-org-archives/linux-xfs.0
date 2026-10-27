Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793121005;
	b=VLZFrNVt2lz4unWoKiPFbH+dl+wNWRWepKJd9k/yb9eJyYTk4SEhTw+5XALYlas7dfX+
	 1jbEKcbAd0UUMAObbSoxoU+/zuzQGBmc61E149APg+rYytRqjHU68EOUq/FjOVAHnQhKK
	 cueQv8qJqg+FhFs+gNyiAMq+IQ1hMMrVZDBvf0Vwk0njHcS00rIEpTpdouR+F9JtjGlDD
	 n9t0D/q/Mw+oCOg1BPMbWusbefBWu0QMz9CPV7ZJyET5SUwqDsB4/lv8pL5T6Y59Hrwrb
	 20pYBOvNfJu/QLSwbxHL6RbCPHLog09IFIGUHj6ehHfikgkBvK3oOG5a4P7kKnmm9QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793121005;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=90FlMOX79LEfuq7kZhMD7ib32TCZ7wCgLVe2izpHiPM=;
	b=TFVv972Wic2Ova28TQ7D4Fdotul1XawHyhl0HcHIwjMAbXeMuEohhBm9HLoByHu83Ldm
	 KeyIkstJj3q4WQtxKSaiUIF0O/JgWHmxBI57x+8S632YzJIYwCtmMdLgMlfwBUxlRIk4J
	 R2BdV8FPg4wxSoqm4gyYuWE9SKEZqC1ZrqMaJ9sYI8+a//xTumKGccEpKcjgK/dvmdMHZ
	 fFwB+F0TM6b8uOG2Va59RLzeSOvhC6HWQtVzjtpspeI0oPk1xqso7j/4f2YmW6QcYziIq
	 I9pPgTLhqOeEkgyfTEFmbioY47xcsJjsVbqUOYiqfsu7T9IWQdSDajW4doYv+J6Oiiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm2 header.b=ehtw4ROe;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=bI8Q7awW;
	arc=none smtp.remote-ip=103.168.172.154
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF0E606A31D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 17:10:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDF0E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm2 header.b=ehtw4ROe;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=bI8Q7awW
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id EE204140006C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 13:10:03 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 27 Oct 2026 13:10:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793121003;
	 x=1793207403; bh=90FlMOX79LEfuq7kZhMD7ib32TCZ7wCgLVe2izpHiPM=; b=
	ehtw4ROeCmCyMGLjkwyebvx2+X3A5s9ZqHyral44Ox80pNBdUlazRGokGB9QHOF2
	v0RkQm1Ig5oYitz1j4lWAdC8YjEH4ZRn4gNNr8xSLQ6bFDCWpkWmL1FtKFg9UbWm
	VK8N2OzPbZl3n6ll31qhujFkTfeE6l//mLHGBoiu2+3bkFkl7Sasp2AX1LUaJgm2
	OTcHjws8cBlpnN5O4c7ImQ1Dxn8YAbcdPnVkTWtgasoCiuG5s7nwrswl5LYRHeAb
	IamoaXwMK91Xu9EBf8uY8Ah2BOBNCkruNUtQ70XXktt2Y5RvyKEJv0hztFhoHvMi
	KlgJMGoBXbIPtd9wM7sjUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793121003; x=1793207403; bh=9
	0FlMOX79LEfuq7kZhMD7ib32TCZ7wCgLVe2izpHiPM=; b=bI8Q7awWZDWsyy00z
	Tpz3okpy8Mnxb7zxggvFbgPMc9mCuxMTxtuZAAomTrBNKfmt6+Iemayot3SgvH0F
	TGemjFiSpkB9X9KopbJuhoYnF6IWk28KfsHqkJBmOABP+xiXCpImkM5bEJY57iQy
	erkn8CZazcLbpm/a+iq/VhT+yOjuV4+sGNOdN+MVKlxFHXYvkb5+0exPo6viraoD
	p37HOEXS9jxikffbQqt4xTrFT6s2otXF4mviYV3wm2OMelhZx8rQIgeSecTe+O+z
	f22QtDAoqC580hOiCJNwxlFhlD6Wxme1noICk/+sgaNngoxSLSMnQFnVfFJmCmeJ
	Nr/bg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793121003; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:iiWCgmvbyEUvGzMBRHtlBF8kIOHIijNpKNGRiaNwlGyNFxO
	OQQOH8vq03ITkGJ4xHr3Ie4amUcyrmIs2eCaORLyCcEE/tcLSqsEUz+WRlwNepnY
	vLdq8nYNUdDWKPp4zAodT3ijiJ0PxjHHYcao4EfmAd022l7kWBy0YPOQ0v0+5syl
	5+seopOgAJBSYDB++8HJBfDzNSpC434NuFygj76trQvPD2LvVmQgzKW4ZE95mfrX
	qPZUvGj2DcL53EXRMgr1j+5zYPbbAIlIpFAyDMDblEIbt6Wpxek/dakUS75ova7e
	ioQ0UkDNAJEMoNtIsVZtgG1iBYz3fsVLLhArAbg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:n5YnuZ2eaMlbN8w7VdTj0udj/6sv71j4t+9nQNPS8vs=:GZVQh4Mq/QPS4S9YLCAJCZrgsoLdM7rM3Qi3Lr06g7Y=;
X-ME-Sender: <xms:69rgasvh8sZSohClhEBLJoT3zITPWK8mAs7qasyKc98Nhh3DxRbHJw>
    <xme:69rgagaaCsQjIpknv6XElt-rOWyH8e21L-KFOXvsL2CSFvcDeXiVlbvlTAHtCJ8_n
    NrhtUaGQtNN0GDSXJk2Y1Kb2tKgnLFgy5WLtc67QxVIuNpAjthZv38>
X-ME-Received: <xmr:69rgatZjj6wvPyUidI8Ea9OMKHJF6ZRtYYE_Wh4Z2akjMgzeiz-PjFKYsRyXOcjqFTQQNyj30TdwdVKTw6768pW9SppYlQ>
X-ME-Proxy-Cause: dmFkZTGOLu2QtsHzXcAEV7RFKnbMG6EV2mNDDjRsmHQylc/0ojNEN+OclInGWm9W7GEGyY
    uVBGsuHC9D8K/O3ifrT1ePOdOBlAB553LlExhw2+4C6szwjkptW57tz85+LOGo0MabI2fz
    c5OONq0vwjkI4yPwzI8QFjkMyJ3/5NxsLi/+VcpfBqWAZHTsNLrF9bX+QenA+E70NmTF2r
    xt8bbE28zatJGR+gOFDRN97+8Lni+Gq9gUSkv8h6pr0a2iG2yjJyXxyayJ8J39hQfK/5v9
    wkguc2RbrBDo+LaD09M7UDixjzSb5tGmEebh3WeiR1rNbZQxvfUrnqZbPg7UU1QlqSo1AI
    FF6YWiAo66p2mGxscb3Bmxmw8PZXSQOKyY1fa81qapOIit81Uy6sHQKGve/b4sKMTXzswX
    OGDTrFgnD5BIB/ZQddrtN9KZXkVQ1MgsH/sQqWfYe+Dkpxz3Y8dxZYXawcRgU7AF9qymII
    W8RsPnS0ACW6pPzG5efGoJcaW0LUGnfnYGLvtDyriPhG92oTBxgZxtbA7cgIwukFLaj8nu
    9xLw6s2CuI//XD+qlZz+GAe7GrGNQ+4YXljxu/gRASkkV+hBui21fG7Sj10lakGJDNBSIK
    H3fntUIGLRkOHqGnXy4UXdsZNUIBIkutsj2xqJwVmGcRxQdrfJptYErvsIHw
X-ME-Proxy: <xmx:69rgakVHfVJBz_IQ3g1c0tPk-zen0JFivqiE3L-TjUJNayHuvxZlJw>
    <xmx:69rgas1LINgzsvuPI61ANo-2xlBZzuFSLhQl6BwNGWGBaMON7ghLCw>
    <xmx:69rgajZhgXJXSI_ZaPkZAqv_GqvPdQb7JMPIjIQWxHFdT42g-3LPtA>
    <xmx:69rganrxM3-LXMTmsB4m_pCWiCB5V5SBkbXKvO18W7k8YEgNu2yJxw>
    <xmx:69rgavfxlXlICoFiKzahe5drlsxMmrhMkDbxSdnCZpC0ka6B70719Hk6>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 13:10:03 -0400 (EDT)
Message-ID: <a130ebd4-2b0b-40f9-8c16-d0b4d5bbf6ce@sandeen.net>
Date: Tue, 27 Oct 2026 12:10:02 -0500
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: fix wrong compat fields in
 xfs_ioctl32_bstat_copyin()
To: linux-xfs@vger.kernel.org
References: <20261027161748.2760321-1-skibletz@gmail.com>
 <20261027164911.578ef6e7@pumpkin>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20261027164911.578ef6e7@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/27/26 11:49 AM, David Laight wrote:
> On Tue, 27 Oct 2026 12:17:48 -0400
> Reid Downing <skibletz@gmail.com> wrote:
> 
>> bs_blocks and bs_xflags were both read from bstat32->bs_size.
>> Read each one from its own field instead.
> 
> It would be much better to do a single copy_from_user() of the entire
> compat structure and copy the fields to the standard one.
> 
> The function would need to be 'noinline_for_stack'.

I'm leaning that way too, but I think the simple, direct fix for the
current code makes sense to merge first, then evaluate better options
for all this.

Thanks,
-Eric

> David
>  
>>
>> Fixes: e94fc4a43e5c39 ("[XFS] Add compat handlers for swapext ioctl")
>> Cc: <stable@vger.kernel.org> # v2.6.29
>> Signed-off-by: Reid Downing <skibletz@gmail.com>
>> ---
>> v2:
>>  - Also fix bs_blocks (spotted by Eric Sandeen)
>>
>>  fs/xfs/xfs_ioctl32.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>> index f6875a2cc70..77bc936bf0d 100644
>> --- a/fs/xfs/xfs_ioctl32.c
>> +++ b/fs/xfs/xfs_ioctl32.c
>> @@ -143,8 +143,8 @@ xfs_ioctl32_bstat_copyin(
>>  	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
>>  	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
>>  	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
>> -	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
>> -	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
>> +	    get_user(bstat->bs_blocks,	&bstat32->bs_blocks)	||
>> +	    get_user(bstat->bs_xflags,	&bstat32->bs_xflags)	||
>>  	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
>>  	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
>>  	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
> 
> 

