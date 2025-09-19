Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8147224DD17
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 10:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758279174; cv=none; b=In7h5N8gMunrsSP1cPx3jooGxnH/WmXOdBrCAw4vaBhwqc9UOtUxdo531kUmtZ1qusP73+A80s3d3Z3+gE1hzont6iLccsC4KvvTxAZXtfW6MCSC6VXtzEKwS02xSO3xCYbm4X4Bb+82xUCrXMWJAoUOnioJuUD0tsEGGSz5feE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758279174; c=relaxed/simple;
	bh=zms+CFHDnD6DyokMYcNj2GculdXkbrTnZW9327SbaCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GRVI6xy9Y+UJmT9RVatFGkY6vzGoesMxrtLLZhxe8NjWevE9clw4HMVfOpwa+Zbg0pv9d7vKxhp/42mdgTXQcM5i04TJI/SJsKAuC+3nu5Tb19bTFY7h0vgHAwOLG0RebNmhnreJs3PyqZbYTkyS3gDAFyLruB2jaev2wwkJhrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b4Mg1GTN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b4Mg1GTN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758279171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QV/w/WQb29TZE7UDB95MLx1Ocda6W5c63foGwvA5ObQ=;
	b=b4Mg1GTNYRPP7+jCQM2OzvjQi4Qwrjkz2sk3JgyunaQVKUUomNSJfjLmAe8ZjTPnSMQxRn
	0tPd+O/DynATIdZwJhSXlAdohPr+G3RC8JdoJO9Akk+sjmO0kYtqzmwlT3Z/bj4ib64nC+
	6ZO6V+dIAtnHdN0ahF+yaFCAzmNJ1yw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-DYb0whWmPl6ImB2sz1_5Ow-1; Fri, 19 Sep 2025 06:52:50 -0400
X-MC-Unique: DYb0whWmPl6ImB2sz1_5Ow-1
X-Mimecast-MFC-AGG-ID: DYb0whWmPl6ImB2sz1_5Ow_1758279169
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3efa77de998so278704f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 03:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758279169; x=1758883969;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QV/w/WQb29TZE7UDB95MLx1Ocda6W5c63foGwvA5ObQ=;
        b=gKPgOhWHlsIIB3kxoS+rQtKI46SvJoFPOyO71iRyRXmO/bXFVHjLmi7eNVub0qgCAj
         Ihmq3A3tHfjRuj97/kClU0mcjIFwICZNWsoqRHpFYRG/oWTDTmnGPto8J28aYHrfdkVx
         LLZM+HGTxBbWVv7Yn7MVtvRfzISyzOuCXhp65qbigNjKWVMtFZ7JjqqbxUx/A75zD7ID
         igD8ibLhXaqjzvSf5gsW9SAnC4jdGYfbAfWV2Q6AJX4za7MxvresjSaVq1tcuORZyhUm
         1rjlcqhJqiieHmL22FolNZHeuK6R20+EXnW1ZQpAH/w500mVVIrPhoeK0wF0/ZuEbZOS
         jNYw==
X-Forwarded-Encrypted: i=1; AJvYcCWFH9AqY2I6tpoHdtsCsS8EBtJnu7s2We7Uttv0GludZHsOcw5QxCZFLtVVQl0sODrS8oVuioSJugk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVhvyrHzplDM1YstmQNogdFkA8QTqt7naryuzPHGZlyQjhp2NY
	YmfHhNO8dLZCcKrpG+mqoX/X0sY0ktsdGoAJNWf2gAuwg8NaXp9lAKon01V0QQoQaAnB5KOIgWa
	EisDsheLn6wnFWwkwcMKa5BrR0X+vwWB1EupazT/ERBLx2FFTVzLvopxwKl9fHNvmIA8q31w=
X-Gm-Gg: ASbGnctOsH7S7awpHeI3Oq9eC1hm5G7FXoanKe9wrqojVa8gjajwYymaBlSPJmh9K/z
	z007HFByWEfsEo2OdHxLX59o5+EoqOg+M8FAZZp849w30dUHgKqqXXzmcZCEAyzFeP9Yjnav450
	3r1NwbuZc3WeKEs5rlWYvdXX1WmHWX75VoIxEMupWDkaVgifkxxUzEASBHJdjyy4DHljPi4Jc2U
	xnSOezJ+XF6GlA+wlbMayZ/3qMYsO3PJiMI7i3SMq5Po359MEcbZrpMa+fF9AvqC16lw4AmrHD+
	XBuaO6rPtc+GNs9k63XrmON7/cU4SQHZ
X-Received: by 2002:a05:6000:40da:b0:3e4:64b0:a75d with SMTP id ffacd0b85a97d-3ee83d9ff66mr1617826f8f.30.1758279168576;
        Fri, 19 Sep 2025 03:52:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEsaQIecdmQMsOMwbLlwsXlnvV6tejv00DrUiaP/wWcAdkNdHwLnoXF2ZAgi633KuYkPwjLJw==
X-Received: by 2002:a05:6000:40da:b0:3e4:64b0:a75d with SMTP id ffacd0b85a97d-3ee83d9ff66mr1617776f8f.30.1758279168024;
        Fri, 19 Sep 2025 03:52:48 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm7635129f8f.37.2025.09.19.03.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 03:52:47 -0700 (PDT)
Date: Fri, 19 Sep 2025 12:52:46 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "A. Wilcox" <AWilcox@wilcox-tech.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: Use POSIX-conformant strerror_r
Message-ID: <sgkgqvif3vdcmgd357pvupw7uqiyirtpp55gq6t2adb2csbltm@5tbqs6ilgmvn>
References: <20250906081222.64798-1-AWilcox@Wilcox-Tech.com>
 <20250912150044.GN8096@frogsfrogsfrogs>
 <20250918162744.GI8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250918162744.GI8096@frogsfrogsfrogs>

On 2025-09-18 09:27:44, Darrick J. Wong wrote:
> On Fri, Sep 12, 2025 at 08:00:44AM -0700, Darrick J. Wong wrote:
> > On Sat, Sep 06, 2025 at 03:12:07AM -0500, A. Wilcox wrote:
> > > When building xfsprogs with musl libc, strerror_r returns int as
> > > specified in POSIX.  This differs from the glibc extension that returns
> > > char*.  Successful calls will return 0, which will be dereferenced as a
> > > NULL pointer by (v)fprintf.
> > > 
> > > Signed-off-by: A. Wilcox <AWilcox@Wilcox-Tech.com>
> > 
> > Isn't C fun?
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Ohh yes it is, this patch broke the build for me:

do you build gcc + musl?

- Andrey

> 
> common.c: In function ‘__str_out’:
> common.c:129:17: error: ignoring return value of ‘strerror_r’ declared with attribute ‘warn_unused_result’ [-Werror=unused-result]
>   129 |                 strerror_r(error, buf, DESCR_BUFSZ);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> <sigh> xfsprogs can't get the XSI version because it defines GNU_SOURCE,
> and you can't shut up gcc by casting the whole expression to void.
> 
> Do you folks remove the -D_GNU_SOURCE from builddefs.in when building
> against musl?  Or do you leave the definition alone, taking advantage of
> the fact that #define'ing a symbol is not a guarantee of functionality?
> 
> --D
> 
> > --D
> > 
> > > ---
> > >  scrub/common.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/scrub/common.c b/scrub/common.c
> > > index 14cd677b..9437d0ab 100644
> > > --- a/scrub/common.c
> > > +++ b/scrub/common.c
> > > @@ -126,7 +126,8 @@ __str_out(
> > >  	fprintf(stream, "%s%s: %s: ", stream_start(stream),
> > >  			_(err_levels[level].string), descr);
> > >  	if (error) {
> > > -		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
> > > +		strerror_r(error, buf, DESCR_BUFSZ);
> > > +		fprintf(stream, _("%s."), buf);
> > >  	} else {
> > >  		va_start(args, format);
> > >  		vfprintf(stream, format, args);
> > > -- 
> > > 2.49.0
> > > 
> > > 
> > 
> 

