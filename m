Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742AF205E3E
	for <linux-xfs@vger.kernel.org>; Tue, 20 May 2025 23:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747783902; cv=none; b=qTXogIToq5VAfQxaZNQ75HuaA4S6OY0CZ0qxU+5NdN/8TAFtQcjBTRoM92l+hm6WibyglfxwjDAaciPOzXD94VyJ1nFWK914c48DwSZeCE6gecklNJDXGdUoFKD321rgptGSnzICDZzm0c/50aYMoLDjBxdtwwdDEuPTeKDwq/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747783902; c=relaxed/simple;
	bh=b8XgE9OlyrmHMQZSDZMNj3oW7tUew6Qw/Jov+Gfma+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lm86OK0wA/V1A+Nq/CdcO3Gfnn2M58PwSj86aTzAReDyv5na7ZkneKCOS7V3jl3x8KLOGlPvZAav5neY+ocuxHQldQE5NdhW8h8Qd1a50DJGqXjm5wr5M7JOcW1CT3dS1EKxAgOkto+qiKpXIVHmusyTMmhnpgp6RVa4Bh27CYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=B5WZsILc; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="B5WZsILc"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2321c38a948so36412505ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 20 May 2025 16:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1747783900; x=1748388700; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=raeU9/iSwSH3dVD4TK1KXg4TW/IO69ywKHFHlZBC8gc=;
        b=B5WZsILcPGTPMIBsACeYNEGf/UvWsMiYU7PvoDdXrUa4PZMVJ2WqB/XH0PK0NKGFa5
         obiSXyoJPmZAGVCXQoboY3dZDetYqoWDv3w1PhvH1d0Vbb2DFOTEewGCVcfI8222gJeV
         MkR8IFw17dGE3txVGJAjwG8XdhPJS/zTju1QLNS/k9Og65HecEbylv1pem36VQ9KXqRP
         45Kw8RDg7ZtRDXwiOgbd0B8pwFz9OpZcOXS73AzaWLomibym3NJm465mf3lqNme007bC
         H65kcAVs6H5QMeqnUDzj1LcYAit+eclnSASvsR/UM47XMm/gLDOe+ulcyHt08RguMj0w
         AyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747783900; x=1748388700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=raeU9/iSwSH3dVD4TK1KXg4TW/IO69ywKHFHlZBC8gc=;
        b=P5w2A81KAIgqpsvIs8gYb4n/CuKzzInh18nx09DSWwE6I7DXh55UxKk+iHbQGfB1qd
         q0Dq8mtLkkI8Fx5cWJj46w6O/pglsljlCOJS6zi92ghoM/Els8+qNTzYxoSQNj/SWGyY
         ffBD51VWQc3FldAXYRbSLtKcSad87jo28oAisglIn3yI4Ff2E8PNHYbi2C1G80jDQ2ML
         /rNqBf3aeqONw016cPhJR+XAsyLWwo2ihz8n96nVp/qgaCZY8z6QA3t/0jXVYY3k4VRz
         yTgAtXkKq3H19UbLQu2eUzz/hfiC6Lqxv9OymUmiVZ4tnSDYV4YCCdXRzquMDys10sPk
         baPg==
X-Forwarded-Encrypted: i=1; AJvYcCWxZPqfLpV1I6xAuIzk5sGt0cQTULKR0NDSSfrSHXzl5ZRPhj/v7H178CeKgBc759vNc3Py3s54vIs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3okNwcRkJQzE/erRQOu3SDM5HdvlKCV5e/gO2zHqLvBCFqoGM
	fJEwfX4DAevsz0lXb1zjgMZ46JwhFwKftks4U1gZslYFuWst9YUusiWuvkYyS3BhDPo=
X-Gm-Gg: ASbGncvjHMombFPZcM28N+1eXZV7wDBvZKnKOJ4JoSrFI5mh51Km0fGSOpOWR40dV9r
	BpTGTDS/EcSSJTumqbrSZYZh3g6t4lvw24r1/anv3/LtFva0jSsndDR8PS3PQYJwwO6o1O/jj5E
	c+H+vm2C9bgTj+Iq8JapWcECe/7hxT8s4rVWfi28vnbNSs0Odv9GzyZFyS37hF0AQqsS56ur7m5
	hx3YcXPsKXCDXIP0RHp9r1D1X+00tWhbafhv7kRitYz8+NGB9u/lW4aUShIoQ6daMJ/DPFGWbcd
	VmoIp2XweEJQMjvw2JV76tnPfax0jJdY/ORPkA4C/4/bj90pPY1rNrlbqGhB421F8UtbWVKwib3
	iC1j2EXS4AJTTKUcURijAM3KFbwU=
X-Google-Smtp-Source: AGHT+IFohQp+DunNaW8Kj0BVCvcpMWTtFY/d7N401JRKMlw1+W74uZylrxvcop0Hae2G2aE7jNwAvg==
X-Received: by 2002:a17:903:2582:b0:223:f408:c3e2 with SMTP id d9443c01a7336-231de35f14amr207654535ad.14.1747783899597;
        Tue, 20 May 2025 16:31:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ac9261sm82262585ad.1.2025.05.20.16.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 16:31:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uHWQq-000000065Jf-13TW;
	Wed, 21 May 2025 09:31:36 +1000
Date: Wed, 21 May 2025 09:31:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH v2 1/2] new: Add a new parameter (name/emailid) in the
 "new" script
Message-ID: <aC0Q2HIesHMXqVLG@dread.disaster.area>
References: <cover.1747306604.git.nirjhar.roy.lists@gmail.com>
 <2df3e3af8eb607025707e120c1b824879e254a01.1747306604.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2df3e3af8eb607025707e120c1b824879e254a01.1747306604.git.nirjhar.roy.lists@gmail.com>

On Thu, May 15, 2025 at 11:00:16AM +0000, Nirjhar Roy (IBM) wrote:
> This patch another optional interactive prompt to enter the
> author name and email id for each new test file that is
> created using the "new" file.
> 
> The sample output looks like something like the following:
> 
> ./new selftest
> Next test id is 007
> Append a name to the ID? Test name will be 007-$name. y,[n]:
> Creating test file '007'
> Add to group(s) [auto] (separate by space, ? for list): selftest quick
> Enter <author_name> <email-id>: Nirjhar Roy <nirjhar.roy.lists@gmail.com>
> Creating skeletal script for you to edit ...
>  done.
> 
> ...
> ...
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  new | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/new b/new
> index 6b50ffed..636648e2 100755
> --- a/new
> +++ b/new
> @@ -136,6 +136,9 @@ else
>  	check_groups "${new_groups[@]}" || exit 1
>  fi
>  
> +read -p "Enter <author_name>: " -r
> +author_name="${REPLY:=YOUR NAME HERE}"
> +
>  echo -n "Creating skeletal script for you to edit ..."
>  
>  year=`date +%Y`
> @@ -143,7 +146,7 @@ year=`date +%Y`
>  cat <<End-of-File >$tdir/$id
>  #! /bin/bash
>  # SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) $year YOUR NAME HERE.  All Rights Reserved.
> +# Copyright (c) $year $author_name.  All Rights Reserved.

In many cases, this is incorrect.

For people who are corporate employees, copyright for the code they
write is typically owned by their employer, not the employee who
wrote the code. i.e. this field generally contains something like
"Red Hat, Inc", "Oracle, Inc", "IBM Corporation", etc in these
cases, not the employee's name.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
