Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF71921C190
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 15:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733413574; cv=none; b=nHLnZ7Y5ZLG+88GBYRx39NJPR6LDxVaW6EZmbkz2UglGhD/JGyKut8UYdsU3DS4h6iHOCfT8BLMkILiGkDJrrZD6CxGKAvgVnTTbBph9eqocvAgKcTtCLbgqNNJE7+v8+7fGbhP25dhG8VOfmjWrusgKWM4BLbUwjXWGP7j4l5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733413574; c=relaxed/simple;
	bh=j46ZOts/TknzgayfC29c/R8OOxCxlyvJ/hmoaAwZkcQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7K4MNMRPTWeRotIA/1zFykgHJqgdPkCGSFy+DtcmKEPh8npc8VA4laUW2iK9r0lA22SO4dgrDGZCrZJfDzfab+Dzd7BqdPqYtyadvN0eLNajOrxUG/zj4PDNuoA2cHbxyTkeqUIAI6a8r7nUQYgsDgxVpUIImpse6gHXhWeO58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJXC9Af1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJXC9Af1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733413571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qTObC4U4rVyI/0CPWSm6IXG9BWv+zsxJjlMcJPmfagY=;
	b=cJXC9Af1diSmZ3yBUuDKh9OsS0BM38wkZnpaLomli63eTsE207SH1K/0wJv4mQklmX5QYG
	2j9uvH+89p4rwFp+hPSRb3lbwCwaWlh+x1dZjhDNIgJ0fRuX3JUwfHtsnoKAm+2TxYPoF0
	+GyseMSUKilEOG1/Md5cxHqiNFN89kY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-A67DYysnMhKyrW6P1G4vzQ-1; Thu, 05 Dec 2024 10:46:10 -0500
X-MC-Unique: A67DYysnMhKyrW6P1G4vzQ-1
X-Mimecast-MFC-AGG-ID: A67DYysnMhKyrW6P1G4vzQ
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-725aedbc7c1so443643b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Dec 2024 07:46:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733413569; x=1734018369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTObC4U4rVyI/0CPWSm6IXG9BWv+zsxJjlMcJPmfagY=;
        b=TqRxTxXuPlsc0Jsn/pQuo15MVQ5/7TrP/Tdr3vjSGze7xuzlrdnEzOlJlZOlZZeCI2
         ReeLxrO/Y7jwk8ofitcp+fEXE1LXGqZmBB39sZ4npA0Y7C0TfHmnsaiqcxOC/4B9z93D
         Y0bRDqNHXrcEBDpGe9NN/5szzFQ7QTPX5VPXiKG9PowybCxHLzWNmW2CGdlD+/dTkS8H
         6Zq7BkN3zCmYoSFe5/pShnn2XiVlDLXVTrQHXCctKPns4KdWujXQ6x5r77KkGvinfKsf
         xXwhiTF/K4k1EQznOAjMcKyyz3+G21A6CNm/HxkGSMVcJ8iTSQxZ/8Dzj5L671xs40Wq
         RB/g==
X-Gm-Message-State: AOJu0YxZQDzX223x/R5mmqipsxYYXS0N9UfFjRO6vBDHHKwYWOW6F1go
	eZnXwYUjsHmcPkXXF5L2lqSO3TRDGGhniQSCebWkqt7BQsqgBabqx8UHMi5e2EwBBp+S0wBDtE3
	Q8ojxVsh3EBFkEkeceC7n1MOE9DK6AS5yoGxoZmDxXMEpXUW813yXD3VdJZ0iXsKQga4/XMlR3c
	7m7wH0eTxlJCUmklG5SZlQ/iuGKzrr4ivp5xi2VRE+
X-Gm-Gg: ASbGnct7+UNKby9+vY5YiRa+gnM6EY3CGW/zi17/QNKN4jbHOyHmAllMyUZhDqTkQE1
	n/n3kOChMfXXV8bS9V7rb//W8wQA7tsfJK/eCbtFpJcx/O0FPJra27JuGJlPQ5El1YBXpkv5dQ3
	kisV9iJky9fw+SE6fF65h5Jdc3dRyV6ZgerqL+zl5fAb9EHXTPj/dbEHl73xa4iiT0PyMgukIw5
	vMkKxl5uBCFDSAsxMIVVhvxk1mxNwv/U147HJvrt1F00ho8paIrUsw9ssZrQ9r2XT5VIrJDWtAu
	rAxyIvMglxQtq68=
X-Received: by 2002:a17:903:32ce:b0:215:7742:73d6 with SMTP id d9443c01a7336-215bd0c4b00mr122339845ad.20.1733413569258;
        Thu, 05 Dec 2024 07:46:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzwo/ZfAte12+xW0R8Ai0BrPidAna5sy86e8BFm9gliDxzuh0zkl4NPVSxmQ2rTlfnDwRAwg==
X-Received: by 2002:a17:903:32ce:b0:215:7742:73d6 with SMTP id d9443c01a7336-215bd0c4b00mr122339415ad.20.1733413568586;
        Thu, 05 Dec 2024 07:46:08 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215f8f091a4sm14150165ad.182.2024.12.05.07.46.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 07:46:08 -0800 (PST)
Date: Thu, 5 Dec 2024 23:46:05 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: Re: 64k blocksize xfs can't be mounted
Message-ID: <20241205154605.iqunsnzsafyys7om@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241205152920.ptesvhhxvq2tcxif@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205152920.ptesvhhxvq2tcxif@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Thu, Dec 05, 2024 at 11:29:20PM +0800, Zorro Lang wrote:
> Hi,
> 
> Recently all my 64k blocksize xfs tests fail [1] on latest mainline
> linux (HEAD=feffde684ac29a3b7aec82d2df850fbdbdee55e4) with
> latest xfsprogs (for-next branch, HEAD=409477af). Do I miss something?

Even on ppc64le which is 64k pagesize, the 64k blocksize xfs still can't
be mounted:

# uname -m
ppc64le
# getconf PAGESIZE
65536
# mkfs.xfs -f -b size=65536 /dev/sda4
meta-data=/dev/sda4              isize=512    agcount=4, agsize=61440 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0  
data     =                       bsize=65536  blocks=245760, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=65536  ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=65536  blocks=2570, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=65536  blocks=0, rtextents=0
# mount /dev/sda4 /mnt/test
mount: /mnt/test: wrong fs type, bad option, bad superblock on /dev/sda4, missing codepage or helper program, or other error.
       dmesg(1) may have more information after failed mount system call.
# dmesg|tail
[17791.249663] XFS (sda4): Sparse inode alignment (0) is invalid.
[17791.250024] XFS (sda4): SB validate failed with error -22.

> 
> Thanks,
> Zorro
> 
> [1]
> # mkfs.xfs -f -b size=65536 /dev/nvme0n1p5
> meta-data=/dev/nvme0n1p5         isize=512    agcount=4, agsize=61440 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=0  
> data     =                       bsize=65536  blocks=245760, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=65536  ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=65536  blocks=32608, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> Discarding blocks...Done.
> 
> # mount -t xfs /dev/nvme0n1p5 /mnt/test
> mount: /mnt/xfstests/test: wrong fs type, bad option, bad superblock on /dev/nvme0n1p5, missing codepage or helper program, or other error.
>        dmesg(1) may have more information after failed mount system call.
> 
> # dmesg
> [  459.450856] XFS (nvme0n1p5): Sparse inode alignment (0) is invalid. 
> [  459.458090] XFS (nvme0n1p5): SB validate failed with error -22. 

