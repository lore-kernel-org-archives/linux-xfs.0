Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E69E305E10
	for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 16:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758557495; cv=none; b=SYl0reNYWhdrkTO3QstWNJ4lDJRKkSsG65XYOOQdUiz/TmQHruFRGG5Nqhw/ZPhs9sQpLe+HIYR04IMnde2SuD0SxMkHQG89XERExRdFRB8yIJvqNIkVnpTOENH8kwKV3oYOTix22OY4doVaVx61ZYLbcS9+UvGPNgSBARt/eR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758557495; c=relaxed/simple;
	bh=piRW+n9AXhte0Xmfd3V67d4ple8YotD/Hhkrh2gC6hQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAgcdTyhPlP0w3deS2vuI+eX5S0yPtbysrIOYHKSLcpSje5MKA31yU7vulEtj4cMQk4dM2QHZJjm5t/3cNRUiqLRWKvV/q3BrR4mwFnAl4B6VxomOlaE72GNt4c9QB3QMX4xyJZhzLaGzueq8c0wGaan2ihH2D8Oq4sgvpI77nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fFnScT29; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fFnScT29"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758557493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3kjRB1cExoH/ln99wAvvY/hAAGlfC0Wn/Et1R9X1ds=;
	b=fFnScT29XfiXVU1n5/BK2EX+4Gm21CkYD2CgkrIKN46tvkBpFNOq9YqdQCk8rJGZlqANBv
	kDBR8T6R8n30BEDusPV4rlMm8uF+BIPQz72xzuBjGu1giHm4bNEW769z1xIWAS+My/iCKB
	YxS/3b6YwfxgryNmGzoP7lSp31274Ks=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-wZtSirfpNVubkMR0VMRn3g-1; Mon, 22 Sep 2025 12:11:31 -0400
X-MC-Unique: wZtSirfpNVubkMR0VMRn3g-1
X-Mimecast-MFC-AGG-ID: wZtSirfpNVubkMR0VMRn3g_1758557490
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45e037fd142so41818885e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 09:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758557490; x=1759162290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3kjRB1cExoH/ln99wAvvY/hAAGlfC0Wn/Et1R9X1ds=;
        b=cig5pLagP88qvH3YDTkj3Ev2nHdaqpO520HnNSy9XcaNtf4pa2bfnNB3u8UwdBOxKU
         hAKLf5TF1XV1eWIjLTwMBjBdGj8ce2lQuFHyTe9/8V9lp7ZIekGrxFld7laLblB8S0WI
         SN0idq50QgF9e3S4xUJqcANuQba+FhV/j/v3n0ptXZva+vS3VZ9o6ljz63XuJjJ9MH4n
         W7FjLNWxjY93eTuWR+djjmNQmEq87Sism1wcAvRtGNYhHWukx0rkv+IqwTEbIK4X0E45
         9WVZqNFqc9wJkivBBlFpA9h4L5Faomnb6605VzRJb7jKmJ0RdrvnL7SnaTJ7bX71HJlL
         e4gg==
X-Gm-Message-State: AOJu0YwvvIwVrLZkoZ7XDTAtmPZV9mszIg/yy5L4zobBfXNNBTc+NA25
	r3DaTLCujEifYUrKJnL3+vXgwAxlG15Srbwc9c2yT/B01WhSP/PFqdmBq4rroo9MBX3oBXoor3T
	6FASUgIMb0/pnx+UkoRA/gcSKceWw0moHvWiDlLbp26fWscmbTxBYlzQChb4l
X-Gm-Gg: ASbGncso7kNbg1ez4B4EHPfqPcLucc7CCbuLDji5k+QEXOM6zGYKDcqlbwM2o5N1Oel
	IpewbaD1iFYTTZFfSDXm5sX+iLaQVcHjnYTk7RO0VHG/5plUHSCuACxb5OEFG53jfmQlkleWSI0
	9aA43hMx/oqfZbm9HuSwKug+bly2h+8n0tMIlBUpqqclsFKaE132HB+buBPnQVaQhneSHkBDZlJ
	tqzx+UluQS09U8nrqps4gM3qg80MCvVYxSEYp5zsNo0kLjbetUEcVhlxp4KF1Rrm4oDRUFHWwto
	hQLdbc6WZlWRxUWK6dY10nqfwIx+8WkP
X-Received: by 2002:a05:600c:548d:b0:46d:996b:8293 with SMTP id 5b1f17b1804b1-46d996b896cmr25837845e9.22.1758557489717;
        Mon, 22 Sep 2025 09:11:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErP8DvTjOFDsarVafnfVAEcn8diAuByLNqZYF0fFuJ22e56F1UKSSj0GIT7JSjIUZWYmNRJQ==
X-Received: by 2002:a05:600c:548d:b0:46d:996b:8293 with SMTP id 5b1f17b1804b1-46d996b896cmr25837605e9.22.1758557489183;
        Mon, 22 Sep 2025 09:11:29 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f1549285c9sm13481663f8f.52.2025.09.22.09.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 09:11:28 -0700 (PDT)
Date: Mon, 22 Sep 2025 18:11:27 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: regressions in xfs/633 and xfs/437?
Message-ID: <conkiyr3ppcjq6j3pwgkrbvakvvez5h4wixrmmjh2c2pmhazhd@f7jqzxdhpmvi>
References: <20250922152954.GR8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922152954.GR8096@frogsfrogsfrogs>

On 2025-09-22 08:29:54, Darrick J. Wong wrote:
> Hey folks,
> 
> Have any of you noticed a recent regression in xfs/437 and xfs/633?
> 
> --- /run/fstests/bin/tests/xfs/437.out	2025-07-15 14:41:40.303420629 -0700
> +++ /var/tmp/fstests/xfs/437.out.bad	2025-09-21 18:53:36.368250642 -0700
> @@ -1,2 +1,3 @@
>  QA output created by 437
>  Silence is golden.
> +mkfs/proto.c:1428:	error = libxfs_iget(mp, NULL, dst_ino, 0, &ip);
> 
> --- /var/tmp/fstests/xfs/633.out.bad
> +++ /dev/fd/63	2025-09-21 17:45:58.431935255 -0700
> @@ -1,6 +1,107468 @@
>  QA output created by 633
>  Format and populate
>  Recover filesystem
> +./common/xfs: line 335: 326611 Segmentation fault      (core dumped) $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
> +./common/xfs: line 335: 326617 Segmentation fault      (core dumped) $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
>  Check file contents
> +--- /tmp/326192.stat.before	2025-09-21 17:36:10.071959154 -0700
> ++++ /tmp/326192.stat.after	2025-09-21 17:36:12.863959041 -0700
> +@@ -1,23 +1,3 @@
> +-11a4 0:0 0 0 fifo 0 1731556303 ./S_IFIFO
> +-2000 0:0 0 0 character special file 0 1758501368 ./newfiles/p0/d1/c19
> +-2000 0:0 0 0 character special file 0 1758501368 ./newfiles/p0/d1/c1a
> <snip>
> 
> The xfs/437 failure is trivially fixable, not sure what's causing the
> segfault here?  Probably something in the new file_{get,set}attr code in
> xfs_db is my guess...?
> 
> MKFS_OPTIONS  -- -f -m metadir=1,autofsck=1,uquota,gquota,pquota, -n size=8k, /dev/sdf
> MOUNT_OPTIONS -- /dev/sdf /opt
> 
> (note that both problems happen on a variety of different
> configurations)
> 
> --D
> 

I haven't seen this, thanks, will look into it

-- 
- Andrey

