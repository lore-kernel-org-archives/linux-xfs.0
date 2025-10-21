Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ED7231845
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039793; cv=none; b=N5EVyOf8ZzfsashMR9gWKsRuOIVBLeWKXZ77gL4syEyL8XN78Ach9yVGpvY0fe04+WPJx5r4K3ArN3GR8XmHd1RdXYoQM7h12Bhvf0ZGpBETmTy57NxA9vZrJvfZ54mzP6Q7o0NSmeaoP+Gz6r9skTFRLfhoyujl4nRmAOGX5us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039793; c=relaxed/simple;
	bh=nOwp8cKz8Deql2IcFUsEhRS68D3CEK4S8UMwL5e4MMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U80Bs3fAPhOkEGNGID24/272nslKLUx8TyQylNzJb9kc2kcrwGtFYYcC3HDXhSXcdhxDy+4SakDE7KznKSxF3UcbUUO6FxFbxGxedKZYkvCD22/YYqjtwfJtzPVMcMPJ9QMYMhTVhfhsTMvOvjPTojpDydl2NSvHBo2d11XCIsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ChjFVR2y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ChjFVR2y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761039790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7N+UUsWkh/PxB+UVb+bOzD97AQ3e4XfF6EAoBhVIUg4=;
	b=ChjFVR2y9HZ9cHQajqBPGoG7qlv7tjnOGqM88aPRZzkwAJvMimLz7Ul3/BOUmdNmD/PieR
	wjEFPU8yXqZL6qU1cHJPmpGKceZbGXE6lDQJwAfjuhGpGW/oGassF6PK7MFoJZPXVMgHnl
	3Hi1PB++DfdgGSc2IP3Vt1nNcyHL97Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-piCMHDAMOF-95ZitZBekhw-1; Tue, 21 Oct 2025 05:43:09 -0400
X-MC-Unique: piCMHDAMOF-95ZitZBekhw-1
X-Mimecast-MFC-AGG-ID: piCMHDAMOF-95ZitZBekhw_1761039788
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-40fd1b17d2bso3094372f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 02:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761039788; x=1761644588;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7N+UUsWkh/PxB+UVb+bOzD97AQ3e4XfF6EAoBhVIUg4=;
        b=dbOQu6a8JA2mRwz+5WK3mtFa5zboe4afdvfigryO2JFk3ItMlOeQaLE2mg52Ti/ByY
         zoHNCYoZgEp/80M3SOP5bG7tMc4GPD923zr2cms38dsSqESv0FLmKD3vb2gpHDgPTecU
         vc7R5NVUkEbX7aqDCAbQoIoT0Ll1apxbA6SR354iG9ZUzKbHZXng3+PQUWYOaShh0SXU
         x4nzCJv4qgNfT8s7Uw7qvoGruP1NX94/23uaHroWLbDKd2+2Sj7JiR3t2FFQxKD4DSsG
         WOLWFj1DNv8oJnOsejyl7tBQuK3nXA9DiwdGgI9TEwjTRGRdmcRB3mSouEGBNCxDSquO
         ztvw==
X-Forwarded-Encrypted: i=1; AJvYcCV3uOMAQiMibf4iArF4Wd0mAeIy5vBxILFilG2Ssp7ztck8JRVmTQugXoiY4P7y36STC+zvpLQuJ2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwU5IqOdn6pJMe4ROJbHT7+4hSEcXC6IwxqQjBKQ2HJQvdYJHD
	Y6vthCqz8iOF89pzvgFRsY8NTSvajEXB1x/DgCDYXxZ/5ghXoCh/k+mL8gmS/mmAlPpOWmqp3EA
	5IWf6OIy7K7s3J7Di0mFO/N0sgAn7Vc6bewXs6+JdqkgrSCwRU/tm0247W2/ZIg==
X-Gm-Gg: ASbGncuiIi5tyB/pB2Qr7X8kys3dVCdXn++KrFuQI403COcmjMLOeBR/1pEeifbemFI
	Q+e+4qhtdsm95t2ImTXRtTe4+i9VD5kpJCML0t7RlXDzsj2ru7Lv+TVxfesMEbY3LEiG8wWpCny
	5Ifp9J3vaXY1MkIxM/L9C/6CDsEQVTOyxT6Ime4CIuzmoq4SlEs7Pxd4OzMAeivWI9O8ysvoXZH
	EI+QnrXYDGThDTpJQHk8mrHdLsfTMm2qfC6WG1CZKatFfk1h1fQcpGdzuXdEy96GpfvTDtcErzV
	xSrz6w/mQ4oea50G7sbM0Ik1GtrDHGCPnHTEUYKBqo99BgXnWL1Yfvy6MpaYkLv5uNi90YIufxc
	NVmx8UJmx1LKRqphgBOufoJHcSqOHJFir5OvWfgd6ioEtkCoFl3tWcAMZ2tksNRd6hytKV1FwV6
	vtonbEHZUonCVyioRdbC75myWTtFI=
X-Received: by 2002:a05:6000:4024:b0:405:3028:1bf2 with SMTP id ffacd0b85a97d-42704e0eeb3mr10685022f8f.62.1761039787958;
        Tue, 21 Oct 2025 02:43:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKdZ707i2yTNafAh3yeT5ocRi/+Z46tBstB8jxkIB6KoBbNLz4cy9huv2TFyZ6jk4HqWigdQ==
X-Received: by 2002:a05:6000:4024:b0:405:3028:1bf2 with SMTP id ffacd0b85a97d-42704e0eeb3mr10684990f8f.62.1761039787436;
        Tue, 21 Oct 2025 02:43:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce3aesm19874869f8f.48.2025.10.21.02.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 02:43:06 -0700 (PDT)
Message-ID: <b31b7abc-69a2-44cc-9e30-0baf03f45a29@redhat.com>
Date: Tue, 21 Oct 2025 11:43:05 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
 Matthew Wilcox <willy@infradead.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
 <aPc7HVRJYXA1hT8h@infradead.org>
 <32a9b501-742d-4954-9207-bb7d0c08fccb@redhat.com>
 <rizci7wwm7ncrc6uf7ibtiap52rqghe7rt6ecrcoyp22otqwu4@bqksgiaxlc5v>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <rizci7wwm7ncrc6uf7ibtiap52rqghe7rt6ecrcoyp22otqwu4@bqksgiaxlc5v>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.10.25 11:33, Jan Kara wrote:
> On Tue 21-10-25 09:57:08, David Hildenbrand wrote:
>> On 21.10.25 09:49, Christoph Hellwig wrote:
>>> On Mon, Oct 20, 2025 at 09:00:50PM +0200, David Hildenbrand wrote:
>>>> Just FYI, because it might be interesting in this context.
>>>>
>>>> For anonymous memory we have this working by only writing the folio out if
>>>> it is completely unmapped and there are no unexpected folio references/pins
>>>> (see pageout()), and only allowing to write to such a folio ("reuse") if
>>>> SWP_STABLE_WRITES is not set (see do_swap_page()).
>>>>
>>>> So once we start writeback the folio has no writable page table mappings
>>>> (unmapped) and no GUP pins. Consequently, when trying to write to it we can
>>>> just fallback to creating a page copy without causing trouble with GUP pins.
>>>
>>> Yeah.  But anonymous is the easy case, the pain is direct I/O to file
>>> mappings.  Mapping the right answer is to just fail pinning them and fall
>>> back to (dontcache) buffered I/O.
>>
>> Right, I think the rules could likely be
>>
>> a) Don't start writeback to such devices if there may be GUP pins (o
>> writeble PTEs)
>>
>> b) Don't allow FOLL_WRITE GUP pins if there is writeback to such a device
>>
>> Regarding b), I would have thought that GUP would find the PTE to not be
>> writable and consequently trigger a page fault first to make it writable?
>> And I'd have thought that we cannot make such a PTE writable while there is
>> writeback to such a device going on (otherwise the CPU could just cause
>> trouble).
> 
> See some of the cases in my reply to Christoph. It is also stuff like:
> 
> c) Don't allow FOLL_WRITE GUP pins or writeable mapping if there are *any*
> pins to the page.
> 
> And we'd have to write-protect the page in the page tables at the moment we
> obtain the FOLL_WRITE GUP pin to make sure the pin owner is the only thread
> able to modify that page contents while the DIO is running.

Oh that's nasty, but yeah I understood the problem now, thanks.

-- 
Cheers

David / dhildenb

