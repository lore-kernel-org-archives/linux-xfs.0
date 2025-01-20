Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1DE1B4235
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 10:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737370756; cv=none; b=aVM7kOq4zV5mByLG5lkfx+k3j6mR5Uq6ym5AX4EaDajUAPQ36psTF7NjFDTQzrbww2I7M8fzEfGMY6qadiThk/z7gOxO17boJcnkrQyG5N9FxqA25v/omrQyXkaUDGhExRir6mwjJF/i3xcCTEdEzcOoZDf20w5a5wRub0hyzfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737370756; c=relaxed/simple;
	bh=xwU/qlhlOYwGOwETQ1c6ySpx2T0wh5897onkMViNW1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOZAnwmU3XS7YkspBdrudZ8RcRIcBJd33SXgML4Po6uW9U5e3R1PC7zT2lPSnTcqnJZg6CUAG5bThD5kjiNp/Bz+ODAdwWxJ7sULskl2wk3T4Kb01faPA4Wt+BtTlIjHeiKw0Ac+awLe9xF1T5n7O4/zYB+Y2wJQmvThLAlDXT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PZo7+awu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PZo7+awu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737370754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dn3G0nhu5Jge2myUsbIDKRZroMBXQZoXud5HFE/C958=;
	b=PZo7+awu6AWShe0OAT1DCXACcfyfNBryk5MlpPVABN+ixIg6AUzuGkWtRf6syXNkEyskNL
	seyQ+fnLlDKXH9sURsjbIBsCgsQ/PmtDJlvVHVQnrorHBAKEXL9aPLbBI0CEnjF1RjB5Vq
	iRc0MtkDics1dnd+PioMFTxtyD50y4E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-UGu_WXCBOlGchjfR0sjs8Q-1; Mon, 20 Jan 2025 05:59:12 -0500
X-MC-Unique: UGu_WXCBOlGchjfR0sjs8Q-1
X-Mimecast-MFC-AGG-ID: UGu_WXCBOlGchjfR0sjs8Q
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361b090d23so22617635e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 02:59:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737370751; x=1737975551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dn3G0nhu5Jge2myUsbIDKRZroMBXQZoXud5HFE/C958=;
        b=c959eyR+QZOcAeJivx+k5kVSNV0Qv+GKsJ+WEkQ395IlwUYRQUOe8kaS+Q2fIj6DPu
         QKGkT+3DD2PP799738YGHCI1PkOVnhVM6fF/6dM+GqR/BzOziD/qromOJdi4Too/B8eV
         33YxcPS9xr+5O49nagQACJYamlTwuXXBNi1APZWj4dhSh+bPQHSucCGdb9YWts9gRLBv
         p9G7ylwVAaiGQUSsd69Y6bBuZnXL6431kVYdyNDY4WzNU25JKSVBpNHyddBJoRALW9Af
         yOAnoH1HA7UaZHYzA2CVikRo9eU84CXfACWrF6TBxGOAWbKFsbMup4kelSvjs5NlLOFh
         n8Iw==
X-Gm-Message-State: AOJu0YzzueDYvjMfk6QlsQHRxtc6jAtRg8lF+gdtJAAbNsXudTC+tmWf
	aBXtTx78LB+NzCAseIAusxVuWM7B4+ScaSeepzJDXU9Jcbshj1eDU722ZC0tvXvLSgUR87UebNv
	dTcLBvz68iroGZOWXCCfeCznanejNkhyKgaPs6sq3xxr2wWes5f7M8cAcXFGW4mZ/
X-Gm-Gg: ASbGncsfIQ6v+POuADr5DkqI/wWh1KYaaSFp+ZaoW59CHFgdn7mgARQ4GalRh/i1CbF
	Gpx7ndv9W6cIeU1YCJcUl2xWBC5j2FlGM6HsLNFKu8U+FBK/A0/IJTQ+84Gzh/T4mCcWJHfd3LO
	iRFShj74cP9q8qbiHU/CtGTEDiOOJ2wHm61OcyPjMm2XKg7h1nzeiFPJPyBP2ThzhM7XoL69LSl
	wYchwMiyJUjnHQIooTZqnEqcAe8xZafu723PKpUuIADBTExWZpQiPMydWkEucY1GYfBt497jbP9
	3+kofJsMRFI9rw==
X-Received: by 2002:a5d:64a1:0:b0:38b:da32:4f40 with SMTP id ffacd0b85a97d-38bf566e69cmr11014812f8f.2.1737370751025;
        Mon, 20 Jan 2025 02:59:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEl/SaisQ5+4tZ2VgXuveaKEcONANEvM3Gk/JwVtGtzBgIigsuWXe9pD6e3aVwfiJuT85qz5w==
X-Received: by 2002:a5d:64a1:0:b0:38b:da32:4f40 with SMTP id ffacd0b85a97d-38bf566e69cmr11014783f8f.2.1737370750484;
        Mon, 20 Jan 2025 02:59:10 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3275562sm10287418f8f.66.2025.01.20.02.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 02:59:10 -0800 (PST)
Date: Mon, 20 Jan 2025 11:59:08 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 2/4] release.sh: add --kup to upload release tarball to
 kernel.org
Message-ID: <d2fojoqzzjget5ni3jg5i3vafhwjx2welhj7dybe6ew46yknkc@t2t4vftsl4og>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
 <20250110-update-release-v1-2-61e40b8ffbac@kernel.org>
 <20250116222227.GD1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116222227.GD1611770@frogsfrogsfrogs>

On 2025-01-16 14:22:27, Darrick J. Wong wrote:
> On Fri, Jan 10, 2025 at 12:05:07PM +0100, Andrey Albershteyn wrote:
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  release.sh | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> > 
> > diff --git a/release.sh b/release.sh
> > index b15ed610082f34928827ab0547db944cf559cef4..a23adc47efa5163b4e0082050c266481e4051bfb 100755
> > --- a/release.sh
> > +++ b/release.sh
> > @@ -16,6 +16,30 @@ set -e
> >  version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
> >  date=`date +"%-d %B %Y"`
> >  
> > +KUP=0
> > +
> > +help() {
> > +	echo "$(basename) - create xfsprogs release"
> > +	printf "\t[--kup|-k] upload final tarball with KUP\n"
> > +}
> > +
> > +while [ $# -gt 0 ]; do
> > +	case "$1" in
> > +		--kup|-k)
> > +			KUP=1
> > +			;;
> > +		--help|-h)
> > +			help
> > +			exit 0
> > +			;;
> > +		*)
> > +			>&2 printf "Error: Invalid argument\n"
> > +			exit 1
> > +			;;
> > +		esac
> > +	shift
> > +done
> > +
> >  echo "Cleaning up"
> >  make realclean
> >  rm -rf "xfsprogs-${version}.tar" \
> > @@ -52,4 +76,11 @@ gpg \
> >  
> >  mv "xfsprogs-${version}.tar.asc" "xfsprogs-${version}.tar.sign"
> >  
> > +if [ $KUP -eq 1 ]; then
> > +	kup put \
> > +		xfsprogs-${version}.tar.gz \
> > +		xfsprogs-${version}.tar.sign \
> > +		pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz
> 
> Shouldn't this last argument be "pub/linux/utils/fs/xfs/xfsprogs/" ?

aha, it should (according to --help). But seems to works with
filename. I will change it to path

> 
> also you might want to put a sentence in the commit log for why you
> want this, e.g. "Add kup support so that the maintainer can push the
> newly formed release taballs to kernel.org."

sure

-- 
- Andrey

