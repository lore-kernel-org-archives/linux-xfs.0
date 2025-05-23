Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056AB2DCBE3
	for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748009553; cv=none; b=pf+cwFmEaEbOA4bDiG3HKlwWh4dLBODV7uFgz7bSB1q+TdNqumx/0yjr9Jv+WJp/SJJrVL/RYC+9Zb61yWwAl3E8cxVSUxG8Oa95uAt79Jt54QFSm3jXvrUsPpN3OjeRk8K35AQ2Ljz1p0EibY8ONJ5xst14G8C7PXwM1dxb1Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748009553; c=relaxed/simple;
	bh=0n59eMFJlkKbjvguOEdIDHYhl/dBZQ1R4YdT1oXHhaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZkpczXTsEUlpa6fLNjpJhWtLg98qnAKGJs2y4DXQg/MIlTNvwpIICfRuX/lwEwix3ZjfQheERcxUXkW3sH4tgbXJlgHzqApwFxDhR/5UqJE/4MSY/357QuQOrip9vAQUyIjapKzbPnjyretZjrkK7VMyPKT7aQmrDn0QSHJEDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QsXIMFnj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QsXIMFnj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748009550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H4+7fpqVuqjJM0FQ5QqoSe6SnJqWOfxI5NDtDYNoFiI=;
	b=QsXIMFnjRCu0qeb2k9dHMOC5LRqzRKDUVmEZar1q3n6TgOZ+n7zC4eUrfbHlDsr0z6v3r0
	MVbEq+Bvis3fBCerhQtMtPPs/5IXZsocdBz1eoWDJ0Rqg0ywbY+x6U+941Alt1kkwR1/+S
	HfdDA5mOT96UZV5G/o7ZvWjWUIssvn8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-bZ7upIMqNDqmTJAdaFNKqA-1; Fri, 23 May 2025 10:12:29 -0400
X-MC-Unique: bZ7upIMqNDqmTJAdaFNKqA-1
X-Mimecast-MFC-AGG-ID: bZ7upIMqNDqmTJAdaFNKqA_1748009549
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-310e7c24158so1168707a91.3
        for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 07:12:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748009548; x=1748614348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4+7fpqVuqjJM0FQ5QqoSe6SnJqWOfxI5NDtDYNoFiI=;
        b=JSTuewgZm4Llxgt67a54C9V9s5k/WHatFAVzYY2ObJ3nKxnlM0hXgBcLkPGitkcPlT
         mBesOS+O98rcP5AGZsgSUJWuHSsyW9CgbprDHuCBxv7v5nQyfmvxOUZiRas9W4zTJxrE
         vIqYgnX0Yo9VYCPLzQp77gPdYEknA31W6Y4HiT2egm/uQnrptSp+VPq1Ee3cDgZgQB+a
         xe0dSxDYi5h5l6mNvKcVj790Fua3857CD+AgGxqu0MocTuZMKs2wdIrcI2KadDXfita8
         H/WvnirUf5bTpNEPIe/HbLPyYJd/GbaQXkwIwLJl1j/x6iVygLKYlEfr+8VwRkCkY0yU
         wBfw==
X-Forwarded-Encrypted: i=1; AJvYcCWJuODYGlXO8wbY38zoSOoMmFppfDI8z2rrCH/qOd1P37zIfL3Zby4xt9h0LTbMKkccGH5KWQGzJBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD85S5AomvZ44fZz00bg0zcQOhjEAIOZxpy6WcpO6xGPeLep28
	Uvh9bT+wiG1RfTqDYcvCRP3/tfQ7RDaCCs/cp3XDs8D5Rt0EZJ/dQc0gyH7JbMUzEdj4lFBovzm
	8BHcQ1jQBzJcoVSlZNDPTGa4SKxJ+DxpMUZOpt8UvMZ6XgKYqw8EKPqAceGt72el19lCR/g==
X-Gm-Gg: ASbGncsadmIO5QUnrSgCShh+DyetOkVnueSJ8Am1E5uko6bni/FnOaSYFLSPKnTJSDO
	7JzQhCpLm7jkimcwLgawWeYr4zntMiO4tCY1F4lSTW0E2Kswc2Jzh3kujGHHBqljE3MELsnM47w
	pCJvWYFphJInSHsRgY7PJuVrg1IGhJMHpVklKUMM0qngYMETbKuih4hhmm1rRw9d22J3SZKlTYF
	/L5U5roRvZk6mgEBl0a1IK7WYaAXxfdxHMAdKZPws4mERZoBPeGhaXkb7eB5tioKZ+ua4F4rvb3
	CwH8jFzoYHSChwEOpAAL/3SkRXHQVDIeUZxElqIeBNex7+JJZLZx
X-Received: by 2002:a17:90b:4a8f:b0:310:8db0:16d3 with SMTP id 98e67ed59e1d1-3108db016d8mr18110859a91.17.1748009548354;
        Fri, 23 May 2025 07:12:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFflrRAaK5R8JT5jskEcknD1yOvlcyzxP3TpskbIROOPaj9vMTh/7mi/I9jRDExC1z9ZRp7w==
X-Received: by 2002:a17:90b:4a8f:b0:310:8db0:16d3 with SMTP id 98e67ed59e1d1-3108db016d8mr18110744a91.17.1748009547376;
        Fri, 23 May 2025 07:12:27 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e11e33c2esm12788555a91.1.2025.05.23.07.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 07:12:27 -0700 (PDT)
Date: Fri, 23 May 2025 22:12:21 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v3 1/2] new: Add a new parameter (name) in the "new"
 script
Message-ID: <20250523141221.dnndb3b24w27ocmu@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1747635261.git.nirjhar.roy.lists@gmail.com>
 <2b59f6ae707e45e9d0d5b0fe30d6c44a8cde0fec.1747635261.git.nirjhar.roy.lists@gmail.com>
 <20250523140343.nabmzlbss346faue@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523140343.nabmzlbss346faue@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, May 23, 2025 at 10:03:43PM +0800, Zorro Lang wrote:
> On Mon, May 19, 2025 at 06:16:41AM +0000, Nirjhar Roy (IBM) wrote:
> > This patch another optional interactive prompt to enter the
> > author name for each new test file that is created using
> > the "new" file.
> > 
> > The sample output looks like something like the following:
> > 
> > ./new selftest
> > Next test id is 007
> > Append a name to the ID? Test name will be 007-$name. y,[n]:
> > Creating test file '007'
> > Add to group(s) [auto] (separate by space, ? for list): selftest quick
> > Enter <author_name>: Nirjhar Roy <nirjhar.roy.lists@gmail.com>
> > Creating skeletal script for you to edit ...
> >  done.
> > 
> > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > ---
> >  new | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/new b/new
> > index 6b50ffed..636648e2 100755
> > --- a/new
> > +++ b/new
> > @@ -136,6 +136,9 @@ else
> >  	check_groups "${new_groups[@]}" || exit 1
> >  fi
> >  
> > +read -p "Enter <author_name>: " -r
> > +author_name="${REPLY:=YOUR NAME HERE}"
> > +
> >  echo -n "Creating skeletal script for you to edit ..."
> >  
> >  year=`date +%Y`
> > @@ -143,7 +146,7 @@ year=`date +%Y`
> >  cat <<End-of-File >$tdir/$id
> >  #! /bin/bash
> >  # SPDX-License-Identifier: GPL-2.0
> > -# Copyright (c) $year YOUR NAME HERE.  All Rights Reserved.
> > +# Copyright (c) $year $author_name.  All Rights Reserved.
> 
> Dave thought we shouldn't use "author_name" at here:
> https://lore.kernel.org/fstests/aC509xXxgZJKKZVE@dread.disaster.area/
> 
> If you don't mind, I'll merge PATCH 2/2 this week. If you still hope to
> have the 1/2, please consider the review point from Dave.

Oh, sorry, you've sent a V4... Please ignore this one, I'm going to review
your V4.

> 
> Thanks,
> Zorro
> 
> >  #
> >  # FS QA Test $id
> >  #
> > -- 
> > 2.34.1
> > 
> > 

