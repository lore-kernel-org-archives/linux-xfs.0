Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.87
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795434567;
	b=zrTpkLt0j0Q1w6z5jBad8Bq0+zr87CR9ByKZSemuzZzAC4hjdqABsKbpTn362LZVpcpW
	 GH5ps2KMFmD21oDGcSMMPCT2rGfA0oY72C9FuWWlKhKgKKe58jBWMbj4pRKqcf450o/0O
	 V+ENNPWLJL7T925qfGIaaqDtqth1UYdAud+ZweEHlV13f3m3pW1n3GwbMoB9QxMbqDmLg
	 QSTVKzug1Ae6bZEgAImc8hqe1luTCoT3WzNZMrgTNciBpfvjVjaEkksy6+SLoOvCDJZnJ
	 TOn406A5UAjwNpmsfxvuhDUF3GK8Ke/oT5Xbq62MLKzUN1dPTVrlevUSkLqCtNyTvPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795434567;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=4mcWx4B5hNOWc0CvbPlF1Pfl8ZJq5VPMduXg+dco1fA=;
	b=Y7fHgU5bkWnWO+25qAyEv8o5Ftca91B+wAN/CYSokC3bdZ76F77UozfPohUE6eRnap2Z
	 tNaddH1qMdhu4gIbAXUSmrf9VN/VCdAtPQ2hclgWKUs0ceWbgNdW7IiACOk5545KuO4o4
	 0cL9/zpf8ECflW0qDWwhPaqY3sPerHFBUfQjMGZAK70siIyp3EyXzzla77G6yVfv7fZFO
	 u5umAxhWipOcLrptOR/Qc+t4yq2VLR6ogJBSAKohTSUrsQrdJ7qVhXzCzp/3jnK/8GSjU
	 oDHuWwOnjCMS8nwaLUWIreI+Qsfk2YXbHjLVwkLvn5CjeDlgdCCHp5hCIFjqxB06myg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QxD7SIjR;
	arc=none smtp.remote-ip=91.218.175.87
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DAC606A321
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 11:49:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3DAC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QxD7SIjR
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4mcWx4B5hNOWc0CvbPlF1Pfl8ZJq5VPMduXg+dco1fA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795434564; v=1; x=1796039364;
 b=QxD7SIjRVXFFP4RzHlrnqMavDEzMF6fnCRdHqcQO/tWoPQt78U0EDmuD7O/BbS8KYlExK5os
 gn+vHNMbMfyQUocqO7fjKWv8S61+cZ1vlUS5KF+yBaJ+ynxtdgCqUd8+XNJnJwunnaM/Z4CDzMi
 4S/rqm0TCTyPg0FwoGSe4Pro=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 8b004dcf881e4ca3;
	Mon, 23 Nov 2026 11:49:24 +0000
X-Mizu-Trace-ID: 8b004dcf881e4ca3
X-Migadu-Flow: FLOW_OUT
Message-ID: <00615772-859f-4948-bd21-6a70c714e01d@linux.dev>
Date: Mon, 23 Nov 2026 11:49:21 +0000
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
Subject: Re: [PATCH 10/59] xfs: check the atomic write reservation against the
 current log size
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
References: <20261116231707.3625263-1-dgc@kernel.org>
 <20261116231707.3625263-11-dgc@kernel.org> <awB3cl3D4MKNfXak@infradead.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <awB3cl3D4MKNfXak@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/26 16:38, Christoph Hellwig wrote:
> Please split this out to a standalone patch and include John and
> the folks have the other atomic reservation patches out right now.

thanks

And @Dave, just to check, does this address the following:
https://lore.kernel.org/linux-xfs/avtmYUPn6BMB56AX@dread/

I doubt it since it "fixes" a different commit.

Thanks,
John
