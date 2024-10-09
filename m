Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D866B383
	for <linux-xfs@vger.kernel.org>; Wed,  9 Oct 2024 00:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728432218; cv=none; b=MCcXCTThc2nSo88VFAQNCbE/MvAUUQbj87dpuIs3Ab76tf19yxM68CwMbQ5PaXNI9OI5ls7+WdYHcLTNSaj36S+79LCffB5TnfKPv2mbJfRPPpbYoXeowj9Z2YvlweuYcXnMKxBzDoyGqdZ9w7OcOHIxH3CsbD8NKm3czqNQagU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728432218; c=relaxed/simple;
	bh=4isKTSnGZnWy2IfXN7gS5dEf0YoojasjmIgkuR4XjEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlj6MZqyq0tuW67ieN3UumaVY2Ox2BrWzvn4jRmbUmAdZGHqLFbENTe7f1qOBUuUhqj96LYH46ItKuyV02GUeurzUDwi31PnYFncFZepFZm+HqizZlCYK/KBPlcVAxAOVGNfAnrNqsepAr8g2/Zm8FzEzRdTjo6iSvnRsOn6ZjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=FeFgJHR8; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FeFgJHR8"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20bb39d97d1so54170645ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 08 Oct 2024 17:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728432216; x=1729037016; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1fWH9enmlhfqAT3vWvYvl8tJAKSdliXa4XjK8FeqbOo=;
        b=FeFgJHR84nfGCSj8Vpar+qujcLKobmHYkyesBB83YqzH6yqunE6zzdqd/W70LkqDKy
         /qsLtjMkp3vuXstQPMAF+RTVQqZBmypAgXfPHYTTI+aoHjJCMw9mpVxjjQWwtooWkIoS
         Az6uoMfLXWWjnbuLIt0Z7Cpc0hU1usy34TeJFo8c1m74/hx/odlFLIaTKvbYrAYmxcZf
         6QtlOtkF+q90chGDDTvUMaXk0KPddnFaplsgeDidlO8DL0tZgB+xwhMFDaq092iAxPR0
         6m6InlDY/RIffeNHzw9H+kTQ66GgXMqErkcANN9AOybUd0weIODjblsUjQdCQVJhPN62
         mfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728432216; x=1729037016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fWH9enmlhfqAT3vWvYvl8tJAKSdliXa4XjK8FeqbOo=;
        b=kyTjbCf3CiJTFhej1E+zq68iDtAxMSHL5rpUTiQlVB+LC6dgeira/5/vmhTC5xDKGO
         w9jfkJhMZIHDaMI0oqwC8vkj5bAczbcCgtmyiEjbdUChUHpOkgz/PqPFh6B73kJ2eIqk
         CsM4Cf5liscrUpR6aemqgOBUY+O4dCnxqn38WeZg3DHvZjygT+545smsBaYhPi1njRJe
         iGMm6rmZ5VvDp8XcJU78OGETMJkEvo+3ciOOJoT5OSQ0g2ZgF/K9+nUmqjTz4GfYb1wf
         ItDw1RmCyJNnsT/RufxhNfH+2IgJUrPxA7qBYBd5LYpGmtKfPpVZe8mAckaO/EjvBxfa
         mq2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUn3rW749VmFu7NFQLnq9qK8+1ZnOesuoOHUfGND2W4mDynO4vfOZYjhIfUT5TaGql34bz/AV8SMXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YylEqv4F82H/k1dtzAwU2yq6nRJdKUCjXrsADOwnpRWTOfU8UhN
	UzirVoexh51w3IOH9+uvwIwSycieOaHSJQknuHABg+fjRtiCZyLZIJNh+DSON3s=
X-Google-Smtp-Source: AGHT+IG3HQtugnX7cL0c229gRqowrq0NHWN1EMQPefxreF1oIsepqnEwQBhkCpq1bsv0lkRKJD9/Mw==
X-Received: by 2002:a17:902:e743:b0:20b:96b6:9fc2 with SMTP id d9443c01a7336-20c63746f29mr11451615ad.10.1728432216227;
        Tue, 08 Oct 2024 17:03:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c139391e5sm60763765ad.133.2024.10.08.17.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 17:03:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1syKAv-00Fo9C-0y;
	Wed, 09 Oct 2024 11:03:33 +1100
Date: Wed, 9 Oct 2024 11:03:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, kent.overstreet@linux.dev,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
	Jann Horn <jannh@google.com>, Serge Hallyn <serge@hallyn.com>,
	Kees Cook <keescook@chromium.org>,
	linux-security-module@vger.kernel.org
Subject: Re: lsm sb_delete hook, was Re: [PATCH 4/7] vfs: Convert
 sb->s_inodes iteration to super_iter_inodes()
Message-ID: <ZwXIVRzMfKV04DfS@dread.disaster.area>
References: <20241002014017.3801899-1-david@fromorbit.com>
 <20241002014017.3801899-5-david@fromorbit.com>
 <Zv5GfY1WS_aaczZM@infradead.org>
 <Zv5J3VTGqdjUAu1J@infradead.org>
 <20241003115721.kg2caqgj2xxinnth@quack3>
 <CAHk-=whg7HXYPV4wNO90j22VLKz4RJ2miCe=s0C8ZRc0RKv9Og@mail.gmail.com>
 <ZwRvshM65rxXTwxd@dread.disaster.area>
 <CAOQ4uxgzPM4e=Wc=UVe=rpuug=yaWwu5zEtLJmukJf6d7MUJow@mail.gmail.com>
 <20241008112344.mzi2qjpaszrkrsxg@quack3>
 <20241008-kanuten-tangente-8a7f35f58031@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008-kanuten-tangente-8a7f35f58031@brauner>

On Tue, Oct 08, 2024 at 02:16:04PM +0200, Christian Brauner wrote:
> I still maintain that we don't need to solve the fsnotify and lsm rework
> as part of this particular series.

Sure, I heard you the first time. :)

However, the patchset I posted was just a means to start the
discussion with a concrete proposal. Now I'm trying to work out how
all the pieces of the bigger puzzle go together as people think
about what it means, not polish the first little step.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
