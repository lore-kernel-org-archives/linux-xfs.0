Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4B01103
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 07:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="XOiHHUGT"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5988e377264so1139781eaf.3
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 23:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1704957861; x=1705562661; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dbLoVxmP6hhl6odGB1818Ic0HbzXPSVbKoTJczT9uDw=;
        b=XOiHHUGT+VqiBiQtwuXaGo9onPZOXjvDKI9qveDbTTEF3x7P+jteRymmhz7T8R8Wdu
         QFVniBa6NjXOPIjTrmhbBf7IPXA17yORZ282DIbRDKF/XmHPDddLR606EcDO5ewyVA/K
         1tiWlzdwOK3E1sp7Cvg2zOMs/kRXc65jfZypIHOQM7BmGEF2M/1efLmr4txXaRKInKhX
         xJPeRVt3apbtcy4JW/ZMQxk7hb/cM8Jai1LnPv9DTgKKKfv2UlFLao8jzXUcVj9krNGz
         RkHbJw38ysJZVp3KQB1evRiJyUyU2MbrDiIJD/ZGvSuzq4aaq8dJOnSgk/4MKGm0Z+fU
         dvGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704957861; x=1705562661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dbLoVxmP6hhl6odGB1818Ic0HbzXPSVbKoTJczT9uDw=;
        b=OiagLvRPHI95DffhA2iyOoPngWPV27Fsjs3MyYJON22LeREgEe+EZNpOsmYMRf1Oc/
         r/ZSj0PGphABcEDch+GS2eTicMRKwik+opwykfqzRC8BFBvPAJ59sAvUsLPDRO8rRwbR
         s/f7J6phK1V2Slrv9T8XpRURRYRL7H1kuzaCRtcCaxOIN6zoIfzR5eFmUc+UFycS7/xr
         bAZu6ayPwXeSBjTomauWbXBbqNow6l7o2A0PUZIJh44+Z/ClQEywKT75QtcpxxhgJXpk
         2T2PqVAqulnPKeIW1JQCgZUL0QDEM2zWdHR/BOTqGr2Kpf7RW1dqDRbsziVppxKqOuwK
         tvjA==
X-Gm-Message-State: AOJu0Ywfm76cUx0nRMnS7V/ooqz+XZLSQtHH2iktWjlH48pFZTriCJAz
	pevo/CxEc0KWs/Hrv5g0Xk5iaPLYyc3Fgg==
X-Google-Smtp-Source: AGHT+IEvyBUBGaEye/mtqN+1bldHR5hfBCUKpTE2PiTi3cPSMdr9BAo+bRei2RRLOxj398clyNDIVw==
X-Received: by 2002:a05:6358:7504:b0:175:95bc:17f2 with SMTP id k4-20020a056358750400b0017595bc17f2mr702828rwg.62.1704957861285;
        Wed, 10 Jan 2024 23:24:21 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id sc4-20020a17090b510400b0028cefda6fa2sm682298pjb.24.2024.01.10.23.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 23:24:20 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rNpQI-008qvC-1c;
	Thu, 11 Jan 2024 18:24:18 +1100
Date: Thu, 11 Jan 2024 18:24:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jian Wen <wenjianhn@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de,
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH v4] xfs: improve handling of prjquot ENOSPC
Message-ID: <ZZ+XonwCt/5oSAQu@dread.disaster.area>
References: <20231216153522.52767-1-wenjianhn@gmail.com>
 <20240104062248.3245102-1-wenjian1@xiaomi.com>
 <ZZtDRe+jzM72Y8mY@dread.disaster.area>
 <20240109061442.GD722975@frogsfrogsfrogs>
 <ZZzp2ARmwf3FrkUV@dread.disaster.area>
 <20240111014204.GM722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111014204.GM722975@frogsfrogsfrogs>

On Wed, Jan 10, 2024 at 05:42:04PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 09, 2024 at 05:38:16PM +1100, Dave Chinner wrote:
> > On Mon, Jan 08, 2024 at 10:14:42PM -0800, Darrick J. Wong wrote:
> > > In that case, perhaps it makes more sense to have
> > > xfs_trans_dqresv return an unusual errno for "project quota over limits"
> > > so that callers can trap that magic value and translate it into ENOSPC?
> > 
> > Sure, that's another option, but it means we have to trap EDQUOT,
> > ENOSPC and the new special EDQUOT-but-really-means-ENOSPC return
> > errors. I'm not sure it will improve the code a great deal, but if
> > there's a clean way to implement such error handling it may make
> > more sense. Have you prototyped how such error handling would look
> > in these cases?
> > 
> > Which also makes me wonder if we should actually be returning what
> > quota limit failed, not EDQUOT. To take the correct flush action, we
> > really need to know if we failed on data blocks, inode count or rt
> > extents. e.g. flushing data won't help alleviate an inode count
> > overrun...
> 
> Yeah.  If it's an rtbcount, then it only makes sense to flush realtime
> files; if it's a bcount, we flush nonrt files, and if it's an inode
> count then I guess we push inodegc?

Yes, that sounds like a reasonable set of actions to take for the
different failure modes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
