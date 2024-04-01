Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1206B4683
	for <linux-xfs@vger.kernel.org>; Mon,  1 Apr 2024 22:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712009583; cv=none; b=U0zteaMHdY8jNgOsUlsUk1koxUWtrDppjswo5YWRU0MTVpHqmQxXDIzxDqTFa6SSEltp7hsLeW7gc33/MUuWEW7wuBmK4f14uJhfUNxkDcARx2a2N3Lh+YNyuqvc+Qd++uzWWLIALhiQZrMnjrnTjQ/VWYR3bdKkd1HRrC/bwuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712009583; c=relaxed/simple;
	bh=0UpXspg4fGfYZpEouZhNiyt8HWjdJMUluTpK+q5wobo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hy06tO5VSEThhLY+zMOyVxlRZZakQ4lAHGELkbfHu0lxDaF/mH5vM4tI6UDjSZr4cJFiM/reQ844NDCabwHenSa5wP8X6GQ6miEGiP+JEUFo/gUQjYn+6udYKyRJNQgjQdjpNYK3XnOf31YoXcOpVMDVUbEPCxY5TNWejEz7sU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rVb108P0; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rVb108P0"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e782e955adso4298577b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2024 15:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712009581; x=1712614381; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UHseugE4uxxYp/7oDwY4HmyAwOynEI9Qqf33NNfPDEc=;
        b=rVb108P0AH7RRnbfX6slNfN2dyCp0CI8YAbSIKdJWQuJaACxifkX88jrFEDSRhmKYl
         ANy0wgzMRVFkZVjITayGVHR4q2QwWmNu+QlSXFPW11fL/T/pcNyIBwb/4qwoXbmsKJXL
         xv6/Ib2IosRZsGKzyFunHiOU3GYYtpzmINuKjm6bGt1XeXy5C5rrdg0OYSNzG5QyO/D/
         n8XT8lQScUYPW7udSbDLid19N6NC0Q3t1eCFBS7K0/LojdhNXJp2utKuCWC8IcfH5oQN
         qHklbOqwVG7cOwKilinqrfwQX/q2KeKE/+KWop1mqyDVCqTyB+oRBIq0VguBWEVUSKQP
         TElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712009581; x=1712614381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UHseugE4uxxYp/7oDwY4HmyAwOynEI9Qqf33NNfPDEc=;
        b=cg5Lswe14/n64q0dJpPEYguDXrU9bpLpqsKankqCZUmc3kIqX87lBC+GL96TWIcOJt
         zOkedWnGy2UzVnmtfzX7D4Zw8VhGqdISrz2rBUm7GZxjdzr9RI4e9ErLFYE40ai5dlTJ
         Y5jW85P59WGD8vKU/BcGaTYZU6pMY+1YmZaN87uTThii4CK3Mvl3CDRMAyEDSoS4QAVd
         sRvJ39OJSMeMvt9LPFWCUbxCgUje9xVtZaO18nxSN3ebyH2hEFIWD1O9zBcy0kT7Xakp
         +V6RYxQoO2swO4Q0dUVjlQTcgEAshXXn500oTmw+TipooE1g2O15kJetddqJFGxK0PCP
         IgNw==
X-Gm-Message-State: AOJu0Yz0FEO8kszve+N1OAIhY1bsKyBexfups8sGei7XkW9AyqOTgEkY
	ly7zaV3O5W8Y3UXvm8RSW0nb8OuX4sigawhRD4G/o+J6mNqzKwpp6dclSCo3XPSUk0gdBlQ73lh
	r
X-Google-Smtp-Source: AGHT+IGyGtpIHb/Czw1Afi90Dkwf3nxenKT7Jfm2dUTR9imRqbZDh71IRRiHKpQLO4WASMV+h2JuxA==
X-Received: by 2002:a05:6a20:5485:b0:1a5:6943:5c96 with SMTP id i5-20020a056a20548500b001a569435c96mr13103711pzk.39.1712009581096;
        Mon, 01 Apr 2024 15:13:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id n19-20020aa78a53000000b006e6c16179dbsm8409742pfa.24.2024.04.01.15.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 15:13:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rrPth-000e9B-1W;
	Tue, 02 Apr 2024 09:12:57 +1100
Date: Tue, 2 Apr 2024 09:12:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix severe performance problems when fstrimming
 a subset of an AG
Message-ID: <ZgsxaZe2sBFeKUS8@dread.disaster.area>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
 <ZgSaffJmGXBiXwKZ@dread.disaster.area>
 <20240329225149.GR6390@frogsfrogsfrogs>
 <ZgiJWxVcVwag0fIP@dread.disaster.area>
 <20240331224445.GX6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240331224445.GX6390@frogsfrogsfrogs>

On Sun, Mar 31, 2024 at 03:44:45PM -0700, Darrick J. Wong wrote:
> 
> How's this for a replacement patch, then?

Looks OK to me.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
