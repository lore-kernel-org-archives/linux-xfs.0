Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E572236FA
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 13:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771247598; cv=none; b=pdToRcz3BHJ7GZxbdEABRH8U25zpV8xHqjpvrYiWMffERSJ9NWbMQpcIAgmxlRbFpSURFY13GSnNtwlEuDJVlUGClhq9SpebwwuNJH9jUJxBapFY8c+eDffg3XZzI80scRe5k0Bs+Y5rerZF0rMe0XRMeaJSWKGN3Juhp/H/uHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771247598; c=relaxed/simple;
	bh=aZkJ2LC+4l1Mgl8JJsgnBU2eDftSKQyjyB4W5fPxgj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EeKCNtx0vabji9n/F7huLDEfEnlgZZVBnReMvAuIJMCeqUuiDS8DwgQqqRLnzbuAFdw6GaXrLYI2thURHXsfQcE9xNNEq/hWHSW4Gfw5bjRPQ8HVN2LxlBmeoH0t/zlbktkfJ1j/lLTkDu3+i0fJ/HBxsaGGY3j+S+iWy15mjT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S721I7Z9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BWf8iQ0A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S721I7Z9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BWf8iQ0A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771247596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eLHZr6BMZ2SnRfi1VuJNibTfFH2915IfXyQtxJbNFRI=;
	b=S721I7Z95QJkm5ZoSN11pfxB986ErA7RJkR3gVGgDKKwmZ4I3DbLJshEJ8N5u2lv9DsnEK
	1uNZw5ODDMySJgDUCDicjm14cXJdetQtq0sjFDGnW2vBzCIxMKVp9dQQt3qS/c4GFEZRx2
	l8NEvTrpX5I2Gkv/+fB2YOfS9iIKLok=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-AygzOy9QMeqVs2jea-dZVQ-1; Mon, 16 Feb 2026 08:13:14 -0500
X-MC-Unique: AygzOy9QMeqVs2jea-dZVQ-1
X-Mimecast-MFC-AGG-ID: AygzOy9QMeqVs2jea-dZVQ_1771247594
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-356236ae3c1so2940284a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 05:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771247593; x=1771852393; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eLHZr6BMZ2SnRfi1VuJNibTfFH2915IfXyQtxJbNFRI=;
        b=BWf8iQ0AUM/hISVUYYhq5MRqvtxkrijT9r9y8YrO9YzKrUatKNZZpYOeDi/h4lyXW4
         zzdUCt3zBkk+dhMvlhZmgEhRPZoiztNAgYKEBB93e4csNgVtgJbA2I93Q23OfvLUwdh1
         fImttlJTVJw9nhOrutMnRTJxdsm64ovuTn6XxWazNAol7JnQZuWC+HwzTiVY8uckPg+O
         AWwlsykSXKpMPtKjCBRWZrexgUk1J7auVe934z3a80AFdf88vTEB3mel/Z+fo57uXsfl
         4U6gaMJRG4AxMVJCwJs7v2qNP5Gbzoc0iKtJFitZE/1IyeFnb90nREEXaOlxrIsODyuz
         NwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771247593; x=1771852393;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eLHZr6BMZ2SnRfi1VuJNibTfFH2915IfXyQtxJbNFRI=;
        b=hubGi9q53cGxGtWc+CnPIDUOj6s8Ts4aQKR5nZQdRWcyKIBl+rrkepIEc2WP5xnRym
         gQnRA3C8DsHJKX3PcmnGP83j+a+lEJRYKLQk0HFQ2MgflAIR0d+54ZF2nilBMuPY0hL2
         69LE2Bak7KlIvFPxmbqsn3S6eyox9OUA/4SHH0Ok/zFXAuqLeAtq/ftrdfkdkpcYOB2+
         uD8tRMGzpiRhMj2rQCgLjEV4xubgFPgSx54CZhXjJdoxDZlsJxITWcqLPuyUBWovD99K
         gAfqtMi7zTfSQfwpKarXzM7uNcwQvCVJo9Koby4/DzYqcuIVrQA8xfVIXYu3kFP0linL
         M20Q==
X-Forwarded-Encrypted: i=1; AJvYcCUm+F0ScJm2hwyQhg/9Hj8IuYE6CKlUbUWY4vR+AtdDWh4JVYaSWij6qO/dYCNx2HHa4v/kA2TIPyU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCz95JE6KPUU4uXRyzhj+gowi0G01N5VWEZeY4jIFAnNiH4NuH
	DZd4ojbIRwbmxNBK3w9JDhqonNfXpt2sAsFPGDsyIcwWT468CBoYjTZAj0pzA+DJZ8HmN9Uamx8
	KGQhRPoF9FzNFPfGMd48+rfkKAKPqPjMb1M2cHIoVjBC84kojTKNnKdfXGSq7gQ==
X-Gm-Gg: AZuq6aJDNoDiDPstuKtkZPRHrMuSp5Ucq8QItPHFbMCiVLN+9DhAKc8OS8eUR7Fnckg
	psqRbsNMRpeMUSklvqXMEmiQIxvczDzYP/P+WQDjygVgyUxODSEQmjGyqnnX/OTpskr5kM3uGSA
	tpDeZb0jay7Z4PSj2Qv59tkdIL2bgI32lUaKZl4ukbR/m5tm0DFelP+JaLgf48h+EzXsST1eU1U
	S8a0CDNFS+yUXOX71jf4JvqramUbpEvkrpARQQkqp4nLWn9QFRO9jGZJi4TWNLKKimNbYmqSS0V
	XW/brhnfRemYM6KHMVSTWOiPyu2LkWtPCC/rMdt8otwMn/Jv4Cj5oGhroso38UB2wlBWDpP/Fkv
	nIQOpqVw/GiEoc3HBaifwOzG6l/PPNDWRRSTkG75yl6tT8NmOOixDsD8YEJGilA==
X-Received: by 2002:a17:90a:dfc8:b0:352:d0cf:9d18 with SMTP id 98e67ed59e1d1-357b50c0548mr6718925a91.5.1771247593525;
        Mon, 16 Feb 2026 05:13:13 -0800 (PST)
X-Received: by 2002:a17:90a:dfc8:b0:352:d0cf:9d18 with SMTP id 98e67ed59e1d1-357b50c0548mr6718904a91.5.1771247593047;
        Mon, 16 Feb 2026 05:13:13 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3567eba92e2sm16065290a91.12.2026.02.16.05.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 05:13:12 -0800 (PST)
Date: Mon, 16 Feb 2026 21:13:08 +0800
From: Zorro Lang <zlang@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Avoid failing shutdown tests without a journal
Message-ID: <20260216131308.atxnkqehyke4conu@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260210111707.17132-1-jack@suse.cz>
 <20260212084050.uim52ck6zhffd5kl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <zh372qbq2tq722476eaqrirmi55hxwzfs6msmzxfj6zv3jws5y@rdip5a6twsf6>
 <20260212164402.tbjcalfmeq6jfwum@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <bgtrbxzrwih2j2bgoanwf5sgl4go5xy6fxnvknkgnugqtkl5pt@iy6bcuqrx5ku>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bgtrbxzrwih2j2bgoanwf5sgl4go5xy6fxnvknkgnugqtkl5pt@iy6bcuqrx5ku>

On Mon, Feb 16, 2026 at 09:56:07AM +0100, Jan Kara wrote:
> On Fri 13-02-26 00:44:02, Zorro Lang wrote:
> > On Thu, Feb 12, 2026 at 11:41:59AM +0100, Jan Kara wrote:
> > > > I initially considered calling _require_metadata_journaling directly inside
> > > > _require_scratch_shutdown. However, I decided against it because some cases might
> > > > only need the shutdown ioctl and don't strictly require a journal.
> > > 
> > > Absolutely. I think they should stay separate.
> > > 
> > > So to summarize I think we should still add _require_metadata_journaling to:
> > > 
> > > overlay/087
> > > g/536
> > > g/622
> > > g/722
> > 
> > Agree :)
> 
> Should I send patches or will you do this modification?

As you brought this issue up, so I'd like to leave the finish line to you :)
I saw your 4 patches nearly use same subject and commit log too. If you fix more 4 cases,
we'll have 8 seperated patches :-D So how about squashing all changes into one single
patch? Does that make sense to you?

Thanks,
Zorro

> 
> > > and we might add fsync of parent directory before shutdown to g/737 and
> > > overlay/078. Does this sound good?
> > 
> > I'm concerned that adding broader sync or fsync operations might interfere with the
> > test's original intent. We should probably evaluate the impact further. Alternatively,
> > we could simply use _require_metadata_journaling to ensure we at least keep the
> > coverage for the original bug :)
> 
> I agree with the approach to just leave the test as is for now and invest time
> into deciding what's the proper solution once someone complains :)
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 

