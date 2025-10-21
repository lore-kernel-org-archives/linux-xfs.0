Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4341C2E7659
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039751; cv=none; b=kuhabFuw341mAIj+BiUwT0XWmoJI4ezij2oMXLQbJVY3EXbqltTO29ZOkLEvuyE/qTyGlIpLmfDY0M+ITuy1ddSsdMZj5dvPkEadW/xqsN0LOl3c2uPbusy6EDis2el/igRQ0GwGKJvOQzBNNCyolHTWObEGw18Xq0THTifrWGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039751; c=relaxed/simple;
	bh=D3BP5uIwpg3xO+TccJrXiMXlQvsPbJofIF9rLyHAHug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfTeqFANe6DFBHAWqk3DoxTET4EtgdsrghR3N6no3W/BWn3FNL0a8480NnPOvowh1op0NjOZS7pvXv7RXJbB4FjJ4aNurAQIGDqcqGHTI1YcqU8jpF0sv392xubsSThMkPp4l2XODLWQT7pmKunmOcFglG4puRHuEsM/LyceXag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N1fcUccX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N1fcUccX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761039749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4yj562WwoiR5XY5KcNNse2uDUnbcLO323U1/FNFk9Vs=;
	b=N1fcUccXDjjjdXWyQXreSzURpKYB403K7JTHu7S8QjXoN5ReUP5gAROhVbf+byPpK0BAtB
	+4zbhts4doIo4Ra/lBKFeHVvTTPK5omBEW2OrPZTnQYTarrn7hbGOPqgpMF/Ky87QkZ6rP
	6Jg4nIYTNMAWV1NonyPA3hHXGXB193k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-5PdtarfZOSqm9vQgoT__WA-1; Tue, 21 Oct 2025 05:42:27 -0400
X-MC-Unique: 5PdtarfZOSqm9vQgoT__WA-1
X-Mimecast-MFC-AGG-ID: 5PdtarfZOSqm9vQgoT__WA_1761039747
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42814749a6fso1568623f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 02:42:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761039746; x=1761644546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yj562WwoiR5XY5KcNNse2uDUnbcLO323U1/FNFk9Vs=;
        b=CVZ8eKbmyqYk0G3sGwKcBq4Llz0asEu8pASUfrkI5PzsDtc+hDd1ahpz2om4Em66zH
         YKfGT8z7oRjcVFfNd9mGoeGSPrpRN5k+lRU4IFwj+REfEi4jq6fmyTYG4eQrXNc8oVyb
         NecGbnYyX6h7SiYgsgQ/F/L/xHrmJw0xmEc1mtwuYq7ZaOvEO+F7tpqmGGBRUGfF/goD
         maAVhL2Qd4MFzQRxV+Sqc+xNseS79BoIkKuvsjf1pAysjOURgXmg2/AnQY6YX3bzgGLu
         SEck6EdpYBL3964xrBXp3dQEF5ixfSgYIb7Z1zu9Unim2N3W1Ch+Nvbc2XmctLTT8gnS
         D2qw==
X-Gm-Message-State: AOJu0Yw7ON1Nfb9hKZoGPtQjEeIGmWZDTXWz4pZx29/LlCYGge6BTZbx
	aXclKcKSitkL74hg5YBl8zgMb1uCxxVwlWlEWAcggfc1ASMjWZ9xtov7yC9HrkmNTCNjhwFp8YJ
	Ya7OKeQbivioqydIhgYfbfHFONYnD6+YIJG6+g18rDpgcBKudIGoso8tYubUb/R4fDGkm
X-Gm-Gg: ASbGnctvmr2chxVMIav3pQgb7vJR2BIl3Q4ohpdwCOGcNkNqy83L1R+XOFT0jlun0PQ
	0cUPKKKSeVq5oMdalulDMv8n0VwM+g53KdgtEci/h4FThkiGiBTRhwjKhJrecszKyAZX39O06dK
	B7YojzNM6jBrwKfBW35uGNxjrMSAA2xljf7lHUumiOpjQw7X43TjZx+1bTJi4nobHPT4+hBTnfx
	QAL3APrfdH7ZIWDNiPqrFamPuNPFagewJw4lvj5aaPLp3ICxN4AGLEPlrOVY1Xd9RNYdfQK8LUc
	fkMtFhDoDm1o+oBv9OdouaIkZDu9cwH088EHyIAfmYKL7rAylr0nGuk0s12KUQ0NCDdjN4tW5WY
	nOz77EEo5Ox6D0ivZfh8=
X-Received: by 2002:a05:600c:800f:b0:471:700:f281 with SMTP id 5b1f17b1804b1-471179041b6mr121036415e9.25.1761039746111;
        Tue, 21 Oct 2025 02:42:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBHJPz5HBTwifjrXaKnSeeRQppAfGpsux0e+OVdcJS/6IrolUrnIWfgQ20MfbQvb09UnueJA==
X-Received: by 2002:a05:600c:800f:b0:471:700:f281 with SMTP id 5b1f17b1804b1-471179041b6mr121036145e9.25.1761039745571;
        Tue, 21 Oct 2025 02:42:25 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47114423862sm276085265e9.1.2025.10.21.02.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 02:42:25 -0700 (PDT)
Date: Tue, 21 Oct 2025 11:42:23 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, zlang@redhat.com, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 1/3] common/filter: add missing file attribute
Message-ID: <xut2jk6z5ykoakmnnpeereg5fjxxlwinoxknraaktiimrgoyya@xjbahoc7nfll>
References: <20251020135530.1391193-1-aalbersh@kernel.org>
 <20251020135530.1391193-2-aalbersh@kernel.org>
 <20251020164624.GP6178@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020164624.GP6178@frogsfrogsfrogs>

On 2025-10-20 09:46:24, Darrick J. Wong wrote:
> On Mon, Oct 20, 2025 at 03:55:28PM +0200, Andrey Albershteyn wrote:
> > Add n (nosymlinks) char according to xfsprogs io/attr.c
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> 
> The updated version of "common/filter: fix _filter_file_attributes to
> handle xfs file flags" that I'm about to send will fix this up by
> documenting that _filter_file_attributes only handles xfs attrs and then
> making it handle all the known flags.

I see, thanks, I will drop this one then

> 
> --D
> 
> > ---
> >  common/filter | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/common/filter b/common/filter
> > index c3a751dd0c39..28048b4b601b 100644
> > --- a/common/filter
> > +++ b/common/filter
> > @@ -692,7 +692,7 @@ _filter_sysfs_error()
> >  _filter_file_attributes()
> >  {
> >  	if [[ $1 == ~* ]]; then
> > -		regex=$(echo "[aAcCdDeEfFijmNpPsrStTuxVX]" | tr -d "$1")
> > +		regex=$(echo "[aAcCdDeEfFijmnNpPrsStTuVxX]" | tr -d "$1")
> >  	else
> >  		regex="$1"
> >  	fi
> > -- 
> > 2.50.1
> > 
> > 
> 

-- 
- Andrey

