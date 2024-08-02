Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE526A955
	for <linux-xfs@vger.kernel.org>; Fri,  2 Aug 2024 00:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722558334; cv=none; b=fEJprxk9lpPreXD18a6MQ0nNkyUNU/Lzjvm9YTz/Gv545hjURx2wRkKr+jS4QhWdoyNsPSLfCJLKamk8OHbLIzYfLenlVjlrrIoaDTHngesp4cXzshxojPQpRDJGChYFdtX3gvAWiV5UT85eG3/XOk3LKvl+HGzRU+1icwCE2WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722558334; c=relaxed/simple;
	bh=qkQF8z9xJSAZTyiFDKkwlHBav2ndAd9he96/5Utl6gI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZTtBXxHLbcZFZie33yh7WjUU+9Ge1ikbCIgrLvavlsvm5WrkXhCEGyWqaump2bKfECJWmlcDojKXo8y0U8sTluO99QyAqGFdeiR4jbuSUX6hzDs0qatjLBGMzctS9qaKXXvyrlXCGPdpN41CnRrn8c8MgiSecLX2tXb0r9z/x1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ZB9TLTNd; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ZB9TLTNd"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fd9e6189d5so61302025ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 01 Aug 2024 17:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722558331; x=1723163131; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OC1ukB2w4z59Sl4oRfu4W5bPTeRUrGf30STkirXn8Ok=;
        b=ZB9TLTNdI8qA7Bv0NOGXXNrNswE5/f+RQxXfsH9EytDghtNhCKWROhJNKCkFIeZtWE
         59Mx2zkbBFAcScwYJc7vgUEU906liijFTFR9mcuh9bJBZgxThtjiw6kAri39qtlIbH13
         J1dcyiG4UrcgkGmn92Q3uuu7eNQwokLUliOHRkQmKZqY6bnDXRdOPTWwkSYo8la9+y3G
         6CyRDX3U/bR2S6x6yaYVMeZKcBoLnje7E0Q2nLJ1GcckZJ6YXoMKX0BKFHyJAA1w7MZG
         CSYaUous7ctaTextxcMWnfwpltXxm7cIB+bidFvHslzRnjAsNSouFYoS9MQDimkls7PQ
         G/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722558331; x=1723163131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OC1ukB2w4z59Sl4oRfu4W5bPTeRUrGf30STkirXn8Ok=;
        b=oYrBLfpe/RVXp7ItQSyWQbmjdV0NhMxHWy8SkVYrFrCW8guDd3+vNtz5ZsJcKN9Tpd
         P+L4v/8O82C8lOIiHpJn3anblANLhmT6hKaLSSIqP3A+MwMV54C6UF3ej+bM0Cfo1RW/
         JhjIiJAHyntoyDfPMwLGrDgFkrMwR4jj3TVri8xiE94V+EEmRm8+Rb83nyEG0XeZXGP8
         FoUsD6wKVo4u59yR6Lzt/7Qe6vX3JY+E9Te+63v40d333IWj374cHaWf2RFOEOaiBLHR
         2AyVm78xFD6Wsf0gmv4qzPPokM4+HherGp12xLSqnoxRQsGATivA+Zlit7tjAJjF4gcK
         4Vrg==
X-Forwarded-Encrypted: i=1; AJvYcCVOGkPERknW5xOYUTVc55tGI2QuO0bJO8PPkB1cVMDb9rQnVhsJe8VeJuIW6nRuoOvqKNhsg5+nmoKKwP/wio1AX0OXwzg4LUQ9
X-Gm-Message-State: AOJu0Yyw67e7LCHJSgxVL11Z7znmQuaAdoIMGA54ciGIuhq2c5zJSTZi
	yLLBzg4yFepWq094nh3XhdyJQ/I48kSrpSQnFAqldCjh8QbZrAvvmNAS/hBf+4A=
X-Google-Smtp-Source: AGHT+IE7zeYPjKFvg23j40yaBkhBsJWoU4437qBb0REThpLfwILMLwaIVlPw79b+KC30DzQUV2SxrQ==
X-Received: by 2002:a17:902:f686:b0:1fb:6294:2e35 with SMTP id d9443c01a7336-1ff5743b563mr27357385ad.50.1722558330965;
        Thu, 01 Aug 2024 17:25:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff5928f518sm4833365ad.234.2024.08.01.17.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 17:25:30 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sZg6q-0024Cx-0R;
	Fri, 02 Aug 2024 10:25:28 +1000
Date: Fri, 2 Aug 2024 10:25:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_property: add a new tool to administer fs
 properties
Message-ID: <ZqwneN77aO3zoICz@dread.disaster.area>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940678.1543753.11215656166264361855.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172230940678.1543753.11215656166264361855.stgit@frogsfrogsfrogs>

On Mon, Jul 29, 2024 at 08:21:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a tool to list, get, set, and remove filesystem properties.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  man/man8/xfs_property.8 |   52 ++++++++++++++++++++++++++++++++
>  spaceman/Makefile       |    3 +-
>  spaceman/xfs_property   |   77 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 131 insertions(+), 1 deletion(-)
>  create mode 100644 man/man8/xfs_property.8
>  create mode 100755 spaceman/xfs_property

Ah, there's the admin wrapper. :)

I should have read the whole patch set before commenting.

> diff --git a/man/man8/xfs_property.8 b/man/man8/xfs_property.8
> new file mode 100644
> index 000000000000..63245331bd86
> --- /dev/null
> +++ b/man/man8/xfs_property.8
> @@ -0,0 +1,52 @@
> +.TH xfs_property 8
> +.SH NAME
> +xfs_property \- examine and edit properties about an XFS filesystem
> +.SH SYNOPSIS
> +.B xfs_property
> +.I target
> +.B get
> +.IR name ...
> +.br
> +.B xfs_property
> +.I target
> +.B list [ \-v ]
> +.br
> +.B xfs_property
> +.I target
> +.B set
> +.IR name=value ...
> +.br
> +.B xfs_property
> +.I target
> +.B remove
> +.IR name ...
> +.br
> +.B xfs_property \-V
> +.SH DESCRIPTION
> +.B xfs_property
> +retrieves, lists, sets, or removes properties of an XFS filesystem.
> +Filesystem properties are root-controlled attributes set on the root directory
> +of the filesystem to enable the system administrator to coordinate with
> +userspace programs.
> +
> +.SH COMMANDS
> +.TP
> +.B get
> +.IR name ...
> +Prints the values of the given filesystem properties.
> +.TP
> +.B list
> +Lists the names of all filesystem properties.
> +If the
> +.B -v
> +flag is specified, prints the values as well.
> +.TP
> +.B set
> +.IR name = value ...
> +Sets the given filesystem properties to the specified values and prints what
> +was set.
> +.TP
> +.B
> +remove
> +.IR name ...
> +Unsets the given filesystem properties.

What does the -V option do? It's documented as existing, but not
explained.

Otherwise looks fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
