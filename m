Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146FF1B042D
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jan 2025 22:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737152450; cv=none; b=rZRGhbHOEW4f5mUUWaKpkAeGfxefwFz9rwlbUT8kmdLW0pFUdJXEAHyRN8qzYb5dXAEIK7nSFXecNy8WrDkeV7jr5VmMm5/navVwdkIXYKi96+LWvES7A2gxPVOcV1llSX9GKoaU5TLvfkAy7cRFvLc0Su65eGLtryKh2dO9qys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737152450; c=relaxed/simple;
	bh=S1zKicbqXlV/ATgu8n+aRUZCylDWDZI+or9hHgthmAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYgBM3Y61WJY0V78OfOY4VYYudqzH7XF+nGYohVp23b/549sYNKi/2LJSmXYNvARBzP1dVNZqzDooTlBERB8gtHVo91pMHa9rpFYR/l0LIlJuJzI339bzRnqvRjalRpr+P2FUK34aJY9BNXlw/ePA7YEL/cRp/u2S9KzQHfnULQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=iIdK6rjH; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="iIdK6rjH"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2166f1e589cso66244535ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jan 2025 14:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737152448; x=1737757248; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+UvfbyshMpjq49xRnNRxHHOIBduK4UL6eUEvgrgMgDg=;
        b=iIdK6rjHRXhqiwLfXl9BFhSs7I5UHSYs5cXkCJ4Aggcs/vG33sBPgpFgJAA+lwcRNv
         RWBi349hIsi10MrzXXX3YxQTZp5BuZxEUs6Q1QCJ2BMAafoozvxpu7el6b9MfQ1nsZx4
         39nLLNETQlels8nGdePFXfKMYN/cUp9MhmPPVWeYOk9UlauOaNOxoivGkbRNy+nwf1NZ
         pDKddeN4z2920ITB0t6zQlDg5GTh3oFSJ8d7I1/iocqA0QFzZVDJVrD+V2sKRpUbQHaQ
         0vmYOkm8/bb8Y3A7lcdhelcEwc6d9Yf8vYcXgbbinap9/ikelHTyW2ejdmeRvWa81LR7
         HWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737152448; x=1737757248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+UvfbyshMpjq49xRnNRxHHOIBduK4UL6eUEvgrgMgDg=;
        b=LtZo52jodpwK8y6k8G1t6dqX0mYRveRiJGrYuWqYeTvaghiYA3SFknpU9dKjPrhBs2
         GXdFAMslGQVKFXxwJWqAVpgCq2kXkKGGIkPJyF8+xTyYkj8o3qtnlMzWaYKPxoTam4sS
         VAGuHlrlDikoUjWZczH70fRQFLdx8NT0Kj7HRaPJEFL2/ZuFkhOymvPaaE5EKeKF5pJY
         3tHUcVyYFpKvrW4lPrCX6WPoT77nXcoq/d173dY85kKZXEjBu60mw6TCnZnNhTIodN9k
         FJqNE1rcgVGqqJQMOHzE/cKWwCx4g1JHD/uAvkgoTder5rW1LkdqQA+tzmb7Vd0nDXHA
         JN7g==
X-Forwarded-Encrypted: i=1; AJvYcCWh7Tlk5JL/igBZKG+sRVaWOFYm3kbX8nt4cqO1eFH7HiV42asos6N6V8QAQOyP7CNqjw2qMRN/wKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YygkBewWtIHdZqYC32NWFvKbjjhZhvnnpiJ/8P8F36bNdccJJuG
	C8TQzk1uMmp6LmX2gDAgC30YvKqI69jRUbtnt2wf23idgW8BWab5fh/riu9qdN4=
X-Gm-Gg: ASbGncsMXCY/CbrOFYDhMwOCDDpvxjrV4dyxbjIloBeL6P8i+uK9WZ+yWoxqMjbq/om
	6L4HrmQWiZ4JOczkb4tbZVdJ+kN1fpUXB/kQh7p7HMSVzPFqNyKIIB/IOxGx7OytlkYWXi6YpFh
	t61HglhEoIJMU/3Oj0bWd5BaM59kR1xW7mWy1d5gNVhQ7q4XWDFj5gxRsXt9BpZdjV1u9wIfCx9
	P8+m5fiASb/VXYtJ9TfEigGYzJ8IcjeeoaBykLzhhLVkhDWZjYi2nSMXw8tXGet3sJinjOyrClq
	oisOENsJ9WP4kSOCW3q0ngHOZ6+wPyhr5tQ=
X-Google-Smtp-Source: AGHT+IHzLnjLl+lx1SZTSRx+LbZ8zk/wyNSJfNQyh5luY9Pn0UzSaf8cbFhTg1LP7e/Wa14Xnby1ZA==
X-Received: by 2002:a17:903:11c3:b0:216:2138:3ed1 with SMTP id d9443c01a7336-21c355c77cemr61602355ad.19.1737152448318;
        Fri, 17 Jan 2025 14:20:48 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bbd0274besm2413894a12.0.2025.01.17.14.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 14:20:47 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tYuho-00000007B3Q-2sjw;
	Sat, 18 Jan 2025 09:20:44 +1100
Date: Sat, 18 Jan 2025 09:20:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chi Zhiling <chizhiling@163.com>,
	Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z4rXvPr9Yw7ldyIB@dread.disaster.area>
References: <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
 <Z4iM4IJj53g-mbGV@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4iM4IJj53g-mbGV@infradead.org>

On Wed, Jan 15, 2025 at 08:36:48PM -0800, Christoph Hellwig wrote:
> On Thu, Jan 16, 2025 at 08:41:21AM +1100, Dave Chinner wrote:
> > > I don't really have time to turn this hand waving into, but maybe we 
> > > should think if it's worthwhile or if I'm missing something important.
> > 
> > If people are OK with XFS moving to exclusive buffered or DIO
> > submission model, then I can find some time to work on the
> > converting the IO path locking to use a two-state shared lock in
> > preparation for the batched folio stuff that will allow concurrent
> > buffered writes...
> 
> This does sound fine to me, but it's hard to judge without seeing
> a prototype and results based on it.

OK, the consensus seems to be to run with this for the moment and
see how clean it ends up being. I'll look into it over the next
couple of weeks then.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
