Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863AA3FB0E
	for <linux-xfs@vger.kernel.org>; Thu, 22 May 2025 00:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747875072; cv=none; b=L5rlNWSJ1Fl/F9YI4wTuh0N5lnIbGLSO98y9UQx8489k0vafv81uQJux3Q6iCU5LJCDUztoEcSpFiAJFUwCUdKGblB+K++w/bucYu9gvZOwxPslh0N08DsfxiyhDfGGMH9dE7S5XuQtryEspeZbaZRIdSgN6VR3hG9pdG/S6H60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747875072; c=relaxed/simple;
	bh=Rj6K4ROrMnzGhkR+BEROkzwz0ATU+50+nOs4dIgSHIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dV8THLLqLiSyuPnsIQM63jSBZilXRRVG4dkjnc/QQtNIFZXvlN1fGTw2FEGfPZc+/U2qmJoLEb86UlmUxtPjuZhzS7/ScsHiiC/5CKu6LUEXT/m7+4LVgaXmLcRadKDGXXVkjWhFweof+MAxwxTV3PY7FQCmK383kbqEOXRIJcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=X9R2BNBP; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="X9R2BNBP"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3108d4a8c6dso1112366a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 21 May 2025 17:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1747875069; x=1748479869; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W9s0Ocr/rcF17F3DaJ0nz5ajfwkc6fT/gYdoWUk+45Q=;
        b=X9R2BNBPPXMoENAmPna2fvi7CwxquWjYwfQ6Qxv7SZ/mLMDmMj2PXb5UShXGOkXzjd
         0SyjIJw/tiD1qdTqYW3N51r7kh9eo82vMcJcqgByjF5RLPE3W1iu3EQGti5eLME7hl1d
         cfIfNbE56MtekEdz0RBpZqrP4N39Zw2cF8FGmIvV2k0+e9H8GlDrSOIG6gYAM+H8wYCG
         oXliTn6pGWsaDupoph0CveQH8eVF52RKc+gw2CAXm59K/eVIpCtVVbBzfK1G6UvjHiKl
         daYanrpnQgV680IqpCPmNhgDeqHusYKwnJwY/zGTq3ojf5EySOfCGFWR4v65bCpNWjCc
         ngsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747875069; x=1748479869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9s0Ocr/rcF17F3DaJ0nz5ajfwkc6fT/gYdoWUk+45Q=;
        b=CLR+/UMr7C46sitX8cLBh0NGLUeM5tGG5rpLnmP4imMDotxofBceI3i/FH7GusQSv3
         F64lxWZm2ec83BZ9wad/+kC3G+8o3gsJdDquqhVefH0dK3Vy0NBdbSxiZb1XvPtVLy5p
         ZmqZB7E8G+myt28Wms5BmrH2Bruf8OyE/aAxQMMvQLI6eh1YgPOSVxR3dzbH5qJXWDQT
         9mvRuDIKE1gOCQ7S7WJFKpnvHQJnIreKoMmLfjDsYrx41Qw+4z4rzBeT9BUXtxjxk8vn
         x2vSUDTSpZBZTrF+hXJylED0x17zLYKY1pz+Yyd2UJzEhW+H1+jPELIcI61GMEVqRiMF
         GO+g==
X-Forwarded-Encrypted: i=1; AJvYcCUJ48mTVrZuazNcmqfWi2jsH9dY3aGGKgIlhnySPtOWAVE8Nmkac+5XGW2o0/GTalhWevfPmsxbkfg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6k0RGuTV7taGhBwJXvq/oXVFWOGuGyN1x8ew8+E4CU+KMqXH/
	odExs/5bAv4NvoLs3K9F4BRN49/1ewhnSrLdi3Bs+rMlXJEfCmnRT+Gm7l73AwV/fJI=
X-Gm-Gg: ASbGncuBIh8CSo/THckVEdJS7sqaIoAN8cXQdBRwhJDUGX0d9gI8K7/Zu/32PtdH5hq
	0iYMCNrTodwjjKk4P2+djaBeiy/8+zWT9VHHZr+lfOhXd1n235PsI3t40hy2wjPeBzrGcFsqwd7
	Hks1ZbU5NLkJydGbzAdVKF4AXMJ9kd3ste+Bk9upKROmu2oMDzPT2Owz9wGJWGW3PpkPnaSY5Q8
	pgVs6jTYlIL9k1JUmzG2whej+aNwc6HoAcvpoHhaKNSxbt5VFHoyf9SVkuv+yhXrsjYSxXUfdHp
	rv9TYOoekwl7kDO+VK232AiKHa/BU761KPfOio93iMggZCCGLxpqp6fjzQFXXj5C6EL4tm7wFgH
	pzB4EYSX4A4ohr8cGhOmgavkK4KY=
X-Google-Smtp-Source: AGHT+IGP/CEXCaGuQkCNk+FfpfP4/PxKrZ35x7SLbTy5h2U+tyAempmwH+hmFi9rXwNEsKJVKpY7Pw==
X-Received: by 2002:a17:90a:d2ce:b0:30e:3737:7c87 with SMTP id 98e67ed59e1d1-30e7dc4ecb4mr32283593a91.5.1747875068659;
        Wed, 21 May 2025 17:51:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365f7a32sm4265696a91.49.2025.05.21.17.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 17:51:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uHu9H-00000006WPt-2p6p;
	Thu, 22 May 2025 10:51:03 +1000
Date: Thu, 22 May 2025 10:51:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH v2 1/2] new: Add a new parameter (name/emailid) in the
 "new" script
Message-ID: <aC509xXxgZJKKZVE@dread.disaster.area>
References: <cover.1747306604.git.nirjhar.roy.lists@gmail.com>
 <2df3e3af8eb607025707e120c1b824879e254a01.1747306604.git.nirjhar.roy.lists@gmail.com>
 <aC0Q2HIesHMXqVLG@dread.disaster.area>
 <12e307e0-2a28-4a42-a8b3-d2186c871be7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12e307e0-2a28-4a42-a8b3-d2186c871be7@gmail.com>

On Wed, May 21, 2025 at 10:52:22AM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 5/21/25 05:01, Dave Chinner wrote:
> > On Thu, May 15, 2025 at 11:00:16AM +0000, Nirjhar Roy (IBM) wrote:
> > > This patch another optional interactive prompt to enter the
> > > author name and email id for each new test file that is
> > > created using the "new" file.
> > > 
> > > The sample output looks like something like the following:
> > > 
> > > ./new selftest
> > > Next test id is 007
> > > Append a name to the ID? Test name will be 007-$name. y,[n]:
> > > Creating test file '007'
> > > Add to group(s) [auto] (separate by space, ? for list): selftest quick
> > > Enter <author_name> <email-id>: Nirjhar Roy <nirjhar.roy.lists@gmail.com>
> > > Creating skeletal script for you to edit ...
> > >   done.
> > > 
> > > ...
> > > ...
> > > 
> > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > > ---
> > >   new | 5 ++++-
> > >   1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/new b/new
> > > index 6b50ffed..636648e2 100755
> > > --- a/new
> > > +++ b/new
> > > @@ -136,6 +136,9 @@ else
> > >   	check_groups "${new_groups[@]}" || exit 1
> > >   fi
> > > +read -p "Enter <author_name>: " -r
> > > +author_name="${REPLY:=YOUR NAME HERE}"
> > > +
> > >   echo -n "Creating skeletal script for you to edit ..."
> > >   year=`date +%Y`
> > > @@ -143,7 +146,7 @@ year=`date +%Y`
> > >   cat <<End-of-File >$tdir/$id
> > >   #! /bin/bash
> > >   # SPDX-License-Identifier: GPL-2.0
> > > -# Copyright (c) $year YOUR NAME HERE.  All Rights Reserved.
> > > +# Copyright (c) $year $author_name.  All Rights Reserved.
> > In many cases, this is incorrect.
> > 
> > For people who are corporate employees, copyright for the code they
> > write is typically owned by their employer, not the employee who
> > wrote the code. i.e. this field generally contains something like
> > "Red Hat, Inc", "Oracle, Inc", "IBM Corporation", etc in these
> > cases, not the employee's name.
> 
> Yes. The existing placeholder is already "YOUR NAME HERE" (which I have kept
> unchanged). The author can always use the company's name from read -p prompt
> or simply chose to fill it up later, right? Or are you saying that the
> existing placeholder "YOUR NAME HERE" is incorrect?

I'm noting that your prompt - <author_name> - is incorrect
for this "YOUR NAME HERE" field. That field is supposed to contain
the -copyright owner-, not the author of the patch. Sometimes they
are the same, but in many cases they are not.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
