Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B980D15A85E
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 22:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723155947; cv=none; b=gL+3taeZaJqYJ1EGxTjZilFL0rlflDBKgTmIWK1TXkEejxWW9r/h5SH7oeLvj9G0TFO2VO8HpKOg/WHYHyKIA5kK2/3HNgkz+3ScwsvAub+lPye89l1dNcLfzSaPmZGeVrEb1GGdHlP9gsbZzxu9aeyjZD6LNS8WVqv5HflO8/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723155947; c=relaxed/simple;
	bh=aMVgWH6CgjMcRWahRlxyqAnxX+lvobaZnWl1HT7R+f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0SrLlYiwJWhJHJzeIHR4jwI64mxTRSnG1yYKEExohwMaYaC7t3ihD5n4pb2EaHv1Xn+i/2GjXH1Dvp8UTYfcs+NmSt9Tdc3au2sA8WFy9Bsh2mUo6RT+V+fT9UpN5mGNW98xvAssVfV+eFBa3eHl4dQojx/q2HU+/DMuApTh68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Y6aptshE; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Y6aptshE"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fda7fa60a9so13823965ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 15:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723155945; x=1723760745; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yBn9Dco3VPq0K74y0husX2N4pdXp7Jht5EpwrnLaTR0=;
        b=Y6aptshEZZHeWy94wqJ7A/UiggkLVACwL0b8mA7wm1ZR6uc+uK0Xl0jkny5+XPJ7Tt
         mD9U6C1cYHOFqbmcBipZrYHEO2TGRSmzi11oq6WjMOy+tFEWUszcvpa3PVsK//2NgDtU
         ZRKEj2Vr7m999IKSHQu9Ht3E2LJnMif/PP/MDpo/8TysL+FiTHq2EM1acRrziTW83DF1
         n01nBblkKh3l/YvU/qbP7gVmkp/9EvVmbLoQ4sXsQ0/1ZzOrbeNqX+l2O/D7vbMh0E9t
         /ucK+hR767bmgAwZEuK5yR/bwhNxs9VQcu0N1WjW7SQIilTXuIyzEB9thMgttn59YYqZ
         H3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723155945; x=1723760745;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBn9Dco3VPq0K74y0husX2N4pdXp7Jht5EpwrnLaTR0=;
        b=EaTOHneDn7votsVr3/ZCW2CaD0p8tns4aSMmHuJZAxkiiZSexSXBNv2gv244D3UjzF
         ZTHkwpVLgbTQHsM27xmddzP3oUQD4orJZ3LouOkNxQOd7xposueIiGCb1HRWY9Bgu2eW
         Xmyo08OoObmG2syuj28uqzJgN3Y2ExJI2KoEBXvQDr18da51c/ejwmL09VsPxhdAAErK
         3N5VTl9EEpxT7I9Zygg3d+Z3loA4UwWxVLX1P3FFcZwuPSo4qGqV9ZRRgUd+2pb8D93n
         1+a3W6hBnoZJQhsHZYJy6fw5NMvKeEWAiBZqwVKZRzd/9RfVcEuo7nGc8Z5i//p3H94i
         sVww==
X-Forwarded-Encrypted: i=1; AJvYcCVxoa/T6Vchpz9jDGdIYdME2SHWgxgkmhW0h7dG3dp6XSvwGsVRfjuxFE8L+XgYHrPdc/MpzLqWKR291Z2bVPdtmkwyDKVfp1B+
X-Gm-Message-State: AOJu0YwhjUUeyShGj0uw2Eo/pUEdrmidkvFxcH/XM4To86Vi+x49WrvN
	KVx8Arq3DTPLC1V5OuzDrNbEqMLREx1/yAVJaqsp9egd1H79ugPGmUzFx1wjilA=
X-Google-Smtp-Source: AGHT+IGJ/qo7JJmgnaV6WCkomrTpeMJKFC/MyaFZQmMdCt6Pi/5/aL7coNL1jTSqNo8KtCmSpj8BuA==
X-Received: by 2002:a17:903:32c9:b0:200:9a4f:19ad with SMTP id d9443c01a7336-2009a4f1ed2mr31534635ad.46.1723155944997;
        Thu, 08 Aug 2024 15:25:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20077167703sm58539125ad.86.2024.08.08.15.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 15:25:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1scBZl-00ADLw-2b;
	Fri, 09 Aug 2024 08:25:41 +1000
Date: Fri, 9 Aug 2024 08:25:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: skip all of xfs_file_release when shut down
Message-ID: <ZrVF5TBZAJBsRF78@dread.disaster.area>
References: <20240808152826.3028421-1-hch@lst.de>
 <20240808152826.3028421-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808152826.3028421-5-hch@lst.de>

On Thu, Aug 08, 2024 at 08:27:30AM -0700, Christoph Hellwig wrote:
> There is no point in trying to free post-EOF blocks when the file system
> is shutdown, as it will just error out ASAP.  Instead return instantly
> when xfs_file_shutdown is called on a shut down file system.
                ^^^^^^^^
       xfs_file_release()

-Dave.
-- 
Dave Chinner
david@fromorbit.com
