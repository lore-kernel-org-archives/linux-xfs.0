Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9204AEF5;
	Thu,  3 Oct 2024 08:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727944214; cv=none; b=KUebA3RvDp2u/0VZ9rQ5Ct/EMVtKkczEEzG7+RH4Hp0WSUVfbZRXXIjvd11NYL9qezsUp4WCt8eGyNo42JQwtXyNUDTLLqDsT5ni5eqKBIE++hVhUk01+Zgv2/0nA9tdqHy97I5EKDMsYBU8/08ZulhgUJbbK/yYDmEQuVcvLDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727944214; c=relaxed/simple;
	bh=C4YjVWwucQlnFc3Bdyk1mQx7bTga0KsdWJhPjx/3d+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cNYoQi7YFkRDWChbDN0TMXmZEk5hh1BxPdA1olb4JT1g6TIWwKqlo0PfRCuKRzLskX/0meuqJ+gucUZoNP0qtp/xrGuCzEjFNR2ytJOWvQ1/hy7TsjjCrfzw4EnwId2gRPbFe3SJMZemQjrCmJUZ5yYhhXnuq+7PmrXTXWbucVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3mY8x/Z; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3mY8x/Z"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37cd0b5515fso417630f8f.2;
        Thu, 03 Oct 2024 01:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727944211; x=1728549011; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KgYlSRPdGNueMfiTMqgmWS1pTsWnaZpjKo5fJ+jS3mg=;
        b=Z3mY8x/Zr1Qt1o7oX3krQqfq/+J0dTxKLzlEoFw5BSlyhsCXY8PGJmudEVcOGUsgY1
         YCGvTT1MEDR08hIeYfefb81u3NbraqtHl+QkyrWQ0PlMhVkgB+0uEovm6q0/zDzTVIVx
         sIj9Lz+xaLE8sa8nd7A2DFu8JAQlSFMInvgJ/rm4i5aukpErCJvGtl0Kn0aFa3w21YpK
         M/X+PmGMtLh43JIpDrKjNYOFFrZ7CJuex9A8xd6PCQ00yvhAg9VAdOTfNlQYJXdGf4wi
         yitHwyrYc1318/YetOKSuHdn3ftzMUy88wzM83jSlbyviKRw1Dyr+7dyCPKYNQUQHc0l
         hiQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727944211; x=1728549011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KgYlSRPdGNueMfiTMqgmWS1pTsWnaZpjKo5fJ+jS3mg=;
        b=FCBfE9nFPaq25fXZVnQTZffw5fbtuzn/6yp7248bj23IPx3rMBI/GwNVr0OJ+FSPUE
         3bVRN11QOL0KyfnmvFV5JRvdEm6HT4isQip04YIptpPNHrDwWvPd26oOA+rDXTOn2kAU
         9IJiRpBxp6PWUVMfWieahHi4Rot0lDVnmXGTLS5YOp5uZ7fzrUZxhJahdwiWkvB5KGRu
         lqndvzSRtVizUb7KPSJxg4IQeysRKoGhumhsLvSdG8LGS7yrYJyxqGdFNPUbo3k6ny8Y
         yAXtuVVRoGqOMoYcZHjSvzAG4SqwCZHZXlLru9OPPG92U1w4OPZnbI/Dday0yNaZ9F+0
         kl/A==
X-Forwarded-Encrypted: i=1; AJvYcCU2i2sHRcNmX7zwgvlbY6fNSym2dk/5qZ7OtySxPIIA6Eg4d09zYsI2LuPqNK2f72XcopI9BtuYWflu@vger.kernel.org, AJvYcCUx0TIpPBo0if8zWrQJ9s4f6kU9i1wWS1aWCxlkxiQ1PzUjetFoM2g/kSkLEV5sbGAkxf2Yk7lLjH02gA0g@vger.kernel.org, AJvYcCXfzqH8ElxQGIFTCn35W4RIDixauE53MCr7FJb9glcX7WyNybxqwBeFrcxNJQq4EsBQOTo+8u9sIBkieEQcrK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJEwOyaXGCUewSyFPSXOI1ZGQUky9YAySyaJ53fBJNrszmcpCD
	p0s4amisPSsD5g/OzzKIeVgZ0uHRbn4/FvRMg+15NSqUnlmwFbP7cOQ5FzAI
X-Google-Smtp-Source: AGHT+IF8npkmOhbojp5KXFi8cInd8zqhM4R+86JiZ/fJ268SNIVJdHBDzgQCRAJIvhOjCnLqlbpAug==
X-Received: by 2002:adf:fc49:0:b0:37c:c9b9:3732 with SMTP id ffacd0b85a97d-37cfb8b58d9mr3700396f8f.21.1727944210905;
        Thu, 03 Oct 2024 01:30:10 -0700 (PDT)
Received: from void.void ([31.210.180.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d081f70b1sm735887f8f.22.2024.10.03.01.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 01:30:10 -0700 (PDT)
Date: Thu, 3 Oct 2024 11:30:07 +0300
From: Andrew Kreimer <algonell@gmail.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a typo
Message-ID: <Zv5WD6z0uHtcS6wd@void.void>
References: <20241002211948.10919-1-algonell@gmail.com>
 <1fe2c97a-fbb3-42bd-941a-c2538eefab0a@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fe2c97a-fbb3-42bd-941a-c2538eefab0a@stanley.mountain>

On Thu, Oct 03, 2024 at 08:59:42AM +0300, Dan Carpenter wrote:
> On Thu, Oct 03, 2024 at 12:19:48AM +0300, Andrew Kreimer wrote:
> > Fix a typo in comments.
> > 
> 
> Could you explain what the typos are in the commit message so that we can spot
> it more easily?  It saves a little review time.

Noted, thank you.
