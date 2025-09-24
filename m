Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B17C17B418
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 13:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758722164; cv=none; b=GRiEWi7QjV0PG401+llN0VACmYqsxL9zevXM+NrCR72PDSCNMFzSzXGf0j7siEYYs4WNMtYJJYzXRZsJJ9+f0qD9hXclNRIn/2bNGXBxWxt9YzFUWFwOY3+19joMwZ0La0YhGbgNv50uXI6MuzdGvkatGcmePcZWI4UNjJ6GxOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758722164; c=relaxed/simple;
	bh=k5jiYphASrpiuHZbsIKQFRdaVX4q1TDbuhWEHUv7zP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XJzVOQ6kD8ASMq71TA3YonV6rnZByI+I8mN1rZkNXTIzU4fH38Svl63BYzD/KRotMIYoUyKj48f1C5xwuJxv0jEF+CvWf+M2zYkiEeDqFbrp8FcjDyic5qflKA8vYPd2H2a3HAl72dM+OpCC97Iq0QNSJFapsoAl13iQ29Soj1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=GGCoI3BU; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="GGCoI3BU"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8522bffdd71so214349685a.1
        for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 06:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758722160; x=1759326960; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rjt+Jgy4/Srswaflv9pOT4BZWehQ/Es2ibOd98UdDXM=;
        b=GGCoI3BUfOV+nhCqz7f0sB9iHlwu82/RvsXFuwzholzHCwfs5IBmdEU/of5N3c9e5u
         WRseJ7L+K0AG8OYAOKAK5QXwFbcOiPFgbYids8IQX58Er/KXH9ynLE166SoclokyhvXs
         oaiAhClYbAGdhIswVFs9oS7chp3hJsHobL1JA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758722160; x=1759326960;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rjt+Jgy4/Srswaflv9pOT4BZWehQ/Es2ibOd98UdDXM=;
        b=WU33GO5jxf15XcBRJOHv0T6lz67w8Heug7ujj5rkWPeuu2D6AE1ihRSR+BgDsyOmL+
         gYU9fNgDaUKdcx31sWj9AHv+D+0T6rimEz8sTPpTf0B3AL2E1W7VTOJOHTE2MmyWZOfU
         ztqIU04QgI/UIGttF9z3lxOF8SKNmigQx4Clpx3IEJjWrHKGKERGPNYZU2YiFdgy+Aqy
         CO6qsXsZ9vTQNalK8YSX6JBl525NcmoviE+le53eUjfHp13FsN4KYRUB6r/Q9xxwFzLq
         nnw5RO8gIesI0PPtEsek1Ywkc/0ktTtxSZIedlPK+foANr5Z6+cP7ISncL666low+T1f
         1w3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVBmx7KDjYsu6SKIDt4NKEsJlHvJj9PUq0/AM/PEe467rcB5RRWUHeRRs0YaV+bMSHK4rB5aFwz0JY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya0Rw/kVkQ946IMsXoM67iWYnPrs8HkU6gdkt55YDOOXT/lyld
	M0Y6lfoh+nPF2ZjdrX+R94NzSbKB5eS+X5gQ4PMZ50RbLvIPOtGtHfC/zVqXGeM7RXV48ynR7PD
	mEs/vc6OqvJH5ABZyMCCFyCCXxb/EKaxNXTlkXfB3+w==
X-Gm-Gg: ASbGncutggYYvlk5M2nxDBVxKAKFVIU1qcOOM7xrwczv3caESrNw2k+vfXDVxYjErZo
	kZ8NfWfpzBU7PxnddYZXd7tJMh/vVkjlXeG3cjXX/UhdcGloQW2oIB1SpQF6gEmWwx3s1mtb5OD
	Z8mT9pzC0BezbAR1R55wdBUetU7OpOzVKBGwz6zyrcibAxI1LbtTC/ovrj8BE2ctiXzvBV4l7iI
	UiXsIdF3BwNFCCWs1cLwY/BWHs55zhvnFwjuFM=
X-Google-Smtp-Source: AGHT+IEkU5UZp6STKf+1Cg4IwYZaEgbuC48/cRqtVthYajqkZpyDIRgjdk9b8chkuqsa8N3Tn0+O8lyN4RYewU3aHis=
X-Received: by 2002:a05:620a:4005:b0:7e6:98be:ee33 with SMTP id
 af79cd13be357-8516ab05228mr882474885a.14.1758722159966; Wed, 24 Sep 2025
 06:55:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs>
 <175798150113.381990.4002893785000461185.stgit@frogsfrogsfrogs>
 <CAJnrk1YWtEJ2O90Z0+YH346c3FigVJz4e=H6qwRYv7xLdVg1PA@mail.gmail.com>
 <20250918165227.GX8117@frogsfrogsfrogs> <CAJfpegt6YzTSKBWSO8Va6bvf2-BA_9+Yo8g-X=fncZfZEbBZWw@mail.gmail.com>
 <20250919175011.GG8117@frogsfrogsfrogs> <CAJfpegu3+rDDxEtre-5cFc2n=eQOYbO8sTi1+7UyTYhhyJJ4Zw@mail.gmail.com>
 <20250923205143.GH1587915@frogsfrogsfrogs>
In-Reply-To: <20250923205143.GH1587915@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 24 Sep 2025 15:55:48 +0200
X-Gm-Features: AS18NWDqKwpelXJanZ8RGJIghS6kjgcZNrZJyvbde88yrp9KsKF7zcg7QnohVz4
Message-ID: <CAJfpeguq-kyMVoc2-zxHhwbxAB0g84CbOKM-MX3geukp3YeYuQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] fuse: signal that a fuse filesystem should exhibit
 local fs behaviors
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Sept 2025 at 22:51, Darrick J. Wong <djwong@kernel.org> wrote:

> Oh, ok.  I can do that.  Just to be clear about what I need to do for
> v6:
>
> * fuse_conn::is_local goes away
> * FUSE_I_* gains a new FUSE_I_EXCLUSIVE flag
> * "local" operations check for FUSE_I_EXCLUSIVE instead of local_fs
> * fuseblk filesystems always set FUSE_I_EXCLUSIVE

Not sure if we want to touch fuseblk, as that carries a risk of regressions.

> * iomap filesystems (when they arrive) always set FUSE_I_EXCLUSIVE

Yes.

Thanks,
Miklos
