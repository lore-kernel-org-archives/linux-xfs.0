Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7885672
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227917; cv=none; b=knx4L2Bu2/oao4BIgtbpD7terRmUUcs+0G5jzXFEgbtrSSMGkBzPXjXvtkPP6E6FK2eohU5iiU3JCcxi+bCYI9EIVN7s3Tis4ICeGEarzERNLNY3/4oGYzp3s6Bi/XFNH1x0w/OObvVzg1AED/6s+Qm8Jvuo/IMyz7UkTnt++3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227917; c=relaxed/simple;
	bh=dc9dA5NdQ13/K9eHnCq30C+tP6EjBvSop/ORGagmo6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAcWNa7SR3/HFhPwx0FxraEBU/2TNXGWX1QGLLiTYIoXqCp51FRq2Du151Qh3Gfnsm1YyvqZRxMF4qI4DxBYbudJZUJXrkberPS5jT4CUBy5/UKbRoUboi8HL4ObJLd3sURTQtzNDnCw+AOd3GLA54Ph/iydgb1i9V9ltgtkRcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AUhVBAhk; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AUhVBAhk"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e424bd30fbso29828565ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 17:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1713227915; x=1713832715; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+uPxeLvDVKYCZrOKW6u2+nRaNbiMj7tI5S27MxtGaAM=;
        b=AUhVBAhkDqk33oSij1a+Rh/W5kKVrn/Q6miKv8RUI0o4iIUyzGf/48ACLywpqqPLfi
         MLWGjvlLaWuXNL7+gvDk1l2oNsLwd86iSg1t75NwAGTR+O4B3ERzDTG8Tn66+CxpL6hN
         O3BabZ8M4K9y1UHJuZiIynzEThYwfDscCLmeCVtiJR23h7iW7w2NTexNub1zQ/tqWa5o
         OqHBp07q/5/nFGf/GtOPA9RXnkPb+FP2ei7QJY6B1Bpv+KKqUvIB8jOa4W2oqcX6HfrZ
         HZBHQ5vFd8TNgSkocytFgg08QjHf0zQA09W388XWm8Wo4qxNV9A0clY8eLvCp3KHe+fb
         1ZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713227915; x=1713832715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+uPxeLvDVKYCZrOKW6u2+nRaNbiMj7tI5S27MxtGaAM=;
        b=pPqFZAiWBxZP9Mp5WjxwO5PkSJqaj26+jVJ/37VtDx0fJI7FKUh6kwZySrVtR5/GRh
         OghNgivM99eTqrJKEQ17zTHWr3uq3Buk3BWFoT9+Nd5U5/7NeODxyJuTCS06Mg0Wfxv2
         2lTSnejUTNgZa7+lkDzKJntb77sDuAhW5rzSpW6IbcpOcyGlplbnohuZ6B2Cep+xANZf
         fAJS8Z0Gl8PXhwZQpwFi42NIGy4IwLGZuItpqO9EJb9vEFlkD6u/C2Wa4za8Bmtg3lJr
         bhLNtjK4rpFByKMglYlg6mBYQKpnOBqCiGZv/HOTiQaUoDZMiZWivcUEBkcOOx+b6zyv
         mpfQ==
X-Gm-Message-State: AOJu0YyebPD6VeXDcKACDfU3grRA6iNS7cECTrTxeXdKOwGNCswLNyTf
	Cfk8YISzRebWGaRzcU86EgwxRvUqfDnlt1Xx05EUa8tFU6OM/K2+qiG5Ygh0vzI=
X-Google-Smtp-Source: AGHT+IH+quLWEhvlZR42iJKRrEjYNsl7yAGk2DPyAALcaTGa/bhTd0pgtElZ7bqPvVpv9Dx6ES9dww==
X-Received: by 2002:a17:903:584:b0:1e2:7717:d34e with SMTP id jv4-20020a170903058400b001e27717d34emr11492091plb.58.1713227915187;
        Mon, 15 Apr 2024 17:38:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902e74b00b001e3c77db2aesm8507005plf.88.2024.04.15.17.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 17:38:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rwWqF-00H24t-3D;
	Tue, 16 Apr 2024 10:38:32 +1000
Date: Tue, 16 Apr 2024 10:38:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5] xfs: allocation alignment for forced alignment
Message-ID: <Zh3Ih/T7jqOHGQF/@dread.disaster.area>
References: <20240402233006.1210262-1-david@fromorbit.com>
 <205661cb-6d7a-46e6-96fc-a4ac9480bebf@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <205661cb-6d7a-46e6-96fc-a4ac9480bebf@oracle.com>

On Wed, Apr 10, 2024 at 01:44:47PM +0100, John Garry wrote:
> On 03/04/2024 00:28, Dave Chinner wrote:
> 
> Hi Dave,
> 
> Can we come up with some merging strategy here?
> 
> This feature is blocking me sending an updated version of my XFS support for
> block atomic writes series.

So just add the patches to the start of your series until they are
merged...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
