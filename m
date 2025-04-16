Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3015207E0C
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 20:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744836658; cv=none; b=tntW9qyDjmQyN+IRta8LtKUMz5jfYh8B92lHQLQpoIDmLwGaky+E6XLruxzpqmF0LSpDyGViCNNGnw44OVKJcOLDbc+3NtqXWPNHIIzRlxF7hNcu9ylom+T1cVnxZFMJZPpeKl9xq6+KMx0zYhARfg6r6N6XnsYAjO5QX/uxGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744836658; c=relaxed/simple;
	bh=9X+ldxpwI7mjM8BAndD6bOzVG7msqIT95VP7hnNoqfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J41P1G7cT93nOtb1ycPd+k13rAsTUlDjCcVBScVZA52UxADGi/Dx1EEYNBMOyB0SZCW770y6Sboj+lrZyHFI6wilBnHWPKs3tmXdplNhu012+LrD7cOMThSD7cn3qhc77rx/mTH49weKkoi1ckclq7mVJBGmjieGaTjHkRWud1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=smWTF4hL; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="smWTF4hL"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-224191d92e4so1148295ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 13:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1744836655; x=1745441455; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oMssVsRnucpQR7VUysa3FpPRBu9OqCGpRWchPdGUx/E=;
        b=smWTF4hLhaJSC4WuXpAlEOYEq5ECrXrhDBJD/Qs2a5Mre7kQtfx7v+7C0TXurj0thX
         vYIlQTp4t9iPBtLGn1Pb853+hj42NtlJJyEE7CvJhI7awJHA6/u0DfHUG85K6ZNVxdQJ
         lXCb+mdLEksAOlSOWvYvkNzOk6cXPoQL1wwKlze//BMPJAEsZz6dzrFS6JwjkWl2sISb
         hEgT8uNBzVhA6CRNsu+DcWorOE1btNg22WTZ02BNFoYnjt9Z5kPBX0pOLAJdqCzHkMww
         5Z7ULdyC6Y5NdHwPXO//dGKvkm4W/r3Rbq8YfPJZyDQs6y3bjCaNxIulLxd3ah2fuMWj
         e8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744836655; x=1745441455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMssVsRnucpQR7VUysa3FpPRBu9OqCGpRWchPdGUx/E=;
        b=i4Ai7w8AdKPVwXsFpJ9XTiJxALJGqCHitsRQYVB9o1jzsjP6gH90DlcnWiljyFg+g2
         0AcqUYs9eRpZGVrhj00vxHig+cTuEmqEQBqr7NrsQI4ABenBeSo83ygFyZWuadFvASsc
         bVSngAcWwQW/OD5IutbizdS492oMdrTU1wZJ6dX0CBjpR+q0vATButT0ksAWkLMxhLGs
         RgyUsf53zrFpjIYp5UD7srNyxSuf2NwAksvwwbnjRXQjLLpUvdR+IfnKvp9L2eY5wVan
         UuTr1gQH4DxUoucoUI0xs7K6bucgximqs4m3T5wvmDenrUSPWKGOSnPCH10ymZ5O54/W
         0CIA==
X-Forwarded-Encrypted: i=1; AJvYcCXZedMa8Ed1X7osEvfDwrxoIxANL/YvzkopbS6swJ0gbRj9IxIgerYaTWZTSDiQT7NTYOBBTiq7pD0=@vger.kernel.org
X-Gm-Message-State: AOJu0YybSV3JrbruBtnwO4YOvaVzhdYwEXeGzLfnPIPQseOwHzaWbRzb
	W//AFq7sXIfe65atCRorP/9o8Lqyy7TQUptFXYfWbqHHBdGc3S720oBEbkWiawalg+UL9PsSylO
	E
X-Gm-Gg: ASbGncvYI6losOf8ntZtC4iefvmnJ0aZLdHlQoRjPHVpX1fHjPGWDWozoEJmpO0Hked
	/3p0aMKWggNm/JdIDjtqVYH/gZvg8ugd/+GOfAxAbxwiedVFz/7mUZz6kHM2Y6A5/nmAP2GPC0k
	d0Qj6RBIko+/MnjfVffe0ygpNuDANFc+SNUco2EoKYMMfo4csKJgD7A5rbJfhXf7PwEdsByyDg4
	pxJw/jiqDxMUouk0IJhaWaC/Wj0CKklRZDV+lHubUm7Cp2GZGp7JHVufAYbaFSxoW20nHSZdcUX
	+7SsXDEpQMQJgcW26hcoABhn33856CuqXnPIZ1ytpFpEtsx/mKA6H/IqHZ3eLcAn/UEylPgAZyL
	xIdK2KASU1grltA==
X-Google-Smtp-Source: AGHT+IF3X6K0MFFrPrPyEm58xxYMkajjc1zUqexHWNgAA9RKIHUkR3Ti4TiOtnd2jRtincY0dE70Jw==
X-Received: by 2002:a17:902:dac6:b0:223:628c:199 with SMTP id d9443c01a7336-22c359ac500mr52649475ad.52.1744836654870;
        Wed, 16 Apr 2025 13:50:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c33fac055sm18893805ad.107.2025.04.16.13.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 13:50:54 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1u59id-00000009RUm-21Bm;
	Thu, 17 Apr 2025 06:50:51 +1000
Date: Thu, 17 Apr 2025 06:50:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [6.15-rc2 regression] xfs: null pointer in the dax fault code
Message-ID: <aAAYK_Fl2U5CJBGB@dread.disaster.area>
References: <20250416174358.GM25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416174358.GM25675@frogsfrogsfrogs>

On Wed, Apr 16, 2025 at 10:43:58AM -0700, Darrick J. Wong wrote:
> Hi folks,
> 
> After upgrading to 6.15-rc2, I see the following crash in (I think?) the
> DAX code on xfs/593 (which is a fairly boring fsck test).
> 
> MKFS_OPTIONS=" -m metadir=1,autofsck=1,uquota,gquota,pquota, -d daxinherit=1,"
> MOUNT_OPTIONS=""
> 
> Any ideas?  Does this stack trace ring a bell for anyone?

That looks like the stack trace in this patch posted to -fsdevel a
week ago:

https://lore.kernel.org/linux-fsdevel/20250410091020.119116-1-david@redhat.com/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
