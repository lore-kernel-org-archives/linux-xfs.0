Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D8C2D738F
	for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501071; cv=pass; b=ffTmqDYtcQjlUP8/mypN1uEpxeu4qzNFitFLyya1ZNMaeHVzAp4C6QQibyiAbKvaVNfOlXG+wCuPr7cjFnsvCEW/3kuuUD/AslJQhCrb8XT7XVCVPNib9gO1cx1Gai3M7DCZ3eL5Nv733wvhqi0TfhacoAlZv0MDYsvYDqZfhI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501071; c=relaxed/simple;
	bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OoMMpfUBDwJsG/wWD0LwySsEknxAG3RgdMuHMQ6J1nuii09Xe/zPiZ89BkJk+0DZudxG0yB24qHiHFxP9ZIpUq/gy9SIJiwIlfXPEBSoWP+r11s/+76pXl05U1bil6YOyG1cSputAzro6XbIRmlYRYEWDSliMeyFiPrSP2KTZqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRqy9Oiq; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRqy9Oiq"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64b5ed53d0aso1716531a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 10:17:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768501067; cv=none;
        d=google.com; s=arc-20240605;
        b=lDrFzniKPc5pTFqCP1NrKZ6nNZGYrlPHA0moXLiihYItGttabu3C9xDHge1WmTmZJk
         zT+ccm5yjUHcp4EU5yITLmM04Teo/Xm+UBY9iR37tuaFzunmbSsqZaE6mSof4+b1A9JZ
         0cCaSeb2r4N1SnF1mh3Moe/VK0Q59E7Z7MZagxhN0rrmqGvJqoRtmyH2EdxxKUQb3hJM
         0/JGUMgKPKZ2eZroNa8Qwyjj1G8ybfZe+BBn0gubAMKj2YW1mI/Z64MTSWFlEUmN+SkH
         B9L+YnilV5+U112EYx2wWaKX8BGszyZurruaPRkI1MbLVHKpqown6LaxURx4dXp2O/Ca
         Rnrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        fh=/PaVih9Z2LnCOtuOZURmZBO/r8vMq7bRkhkE/0/bz+k=;
        b=LkTbIX0aWGdTxREwtnQoSRfr2xR0oWCrfm1/WJRUHjshvnIL0vdmDajTASoQn+PWZ2
         JX1mutoEwvatG2ZA8PtYbyU0MkpcXy1Rtp4dk2HRc0g5I1LAEoUR+EvUEEXcFPxpnyWg
         awm+GSKgb8D3ObND+9slmPkami1XooF9c4LLRz3jlv20LxQFSqrrH6mRqjC9UYLgMgQr
         +4bw9l/qOvItHcYiGSiKdp3V/TQy+EIDZEMd3CDV7awPg4MqpuKOFManaDzb4aXhF9QG
         ocz6Oit5YCktIKciC7s9b/wRIs9yf4z0D1rtDsjVkSeSpGTlMAG4GkVgk+KP6VqvqLQg
         VNTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768501067; x=1769105867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=JRqy9OiqbHt3NQq3XCkGStTAlcxglCMEMq+vkPdztBR4c+MkrffxyXlppZJ7bL4sv3
         +FXHo4WCeS6ifCEJXW+UdjZqdayxLi0mNMYJfj32IOulawR+3uE9C6Ut2x3X5eVTlY8+
         6iRo29sMNevgrrtfjtiRzEF0k4plHYlK2kgxZb4KZPdGjfbpVgT/wXn6hxIwTOtPADbq
         2v6VOk25RJEEoHnf4r5a+RfNediJCsI/4TTnPiMJgJQLHdyofqjBzPnr34u+fCoLT989
         FV5CVbIQ4AFknrnsxqTVaClS78Bq+9klbvidUC90tZ/EK9JmXeohHKVG3ipODkA8GlnY
         LSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501067; x=1769105867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=onLoRlDvEumpz5QzdlDuVeGrOYv/+rJPKVEosqD0J102xL5tHOMwPoNp3VpNwAb6+W
         Iym+p1ScBcw7eWuWB3hY8Y56NiiyhsEVOe/5GofhLfZdiEP3iv+xgLAxnXQOFoGSaMTE
         7ADd6Zj56ARzouF7Rho4HzWniNAR9vEgmLjVqryxk6xHHTlcQRYtIVFpPVt5WoDNlzQ+
         L5m3aqAL/Xrus13QQrmBEDz5ooBBYe7mnbdilerUATkGZR0oDHhF4ksgU2wZzWnDWg5+
         qTcEDIPlQ6/tdAH9nk5NX9vXU4q/Oo4F8N9dXq6h2lMxnn85YeCRXiylr9z/34Hp5OMv
         jmHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtpkXADge67ga6MzuMqmRtGMHYC8rvey3GsX2r6f0QTWYdlFT33lTHUO0FwJnPySLdUxJnzt/KFS4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwLBRBlWPromYyq0JUkenk/Z/6fkY1VIEQSGfrKw54NqB4vVNw
	xkaHdlj6w0jKdkxOTEUj9DA5QUpx8kdus+5OG4UdvfigrBOaGluoRW1eH5VRVePtI3c0Ac/zSPJ
	nAuZPWaS0ZWqm74hUhNRPlnZHgSJxWUQ=
X-Gm-Gg: AY/fxX6rJPQSaGm7uzc1ouKrWBDGIs5q4KpRS2Q4IEINyxSFidQZpXNxoOoHeE+d5X3
	PGbb5dX4JUua8/lrf8Upx9/FioLDIPpSZbUOZcpm0IzX2LVbtjhjBUQ46+EZfi3RbhVD74oFast
	ribXU6SO+Fcu0bTiG+rLJmJQqxJjpFoBzds3uak8AeS2wcE4yGWC/OX9pTEFO8FWV4bxipKy8H2
	oceQ+PIlHR/uqjAQxivCuNlzhk4y5xvbkDErLzs0EAneIrWm9h/xtoyDjQhn+e32VSIGT/Ghdj9
	SvMNf+AItXMOknC4Q1hOitsJthjbaw==
X-Received: by 2002:a05:6402:510f:b0:64b:7eba:39ed with SMTP id
 4fb4d7f45d1cf-654525ccad4mr346097a12.13.1768501066374; Thu, 15 Jan 2026
 10:17:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 19:17:35 +0100
X-Gm-Features: AZwV_QjhT3ZtgvkbHJB7796GEklGCbcNDL5CeRwrn_YYeN3X8FqPO-3_iRnRORw
Message-ID: <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> In recent years, a number of filesystems that can't present stable
> filehandles have grown struct export_operations. They've mostly done
> this for local use-cases (enabling open_by_handle_at() and the like).
> Unfortunately, having export_operations is generally sufficient to make
> a filesystem be considered exportable via nfsd, but that requires that
> the server present stable filehandles.

Where does the term "stable file handles" come from? and what does it mean?
Why not "persistent handles", which is described in NFS and SMB specs?

Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
by both Christoph and Christian:

https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e93c0=
0c@brauner/

Am I missing anything?

Thanks,
Amir.
