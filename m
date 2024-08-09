Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008B43B1A2;
	Fri,  9 Aug 2024 17:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723223327; cv=none; b=otmB+S9N+RD6m0ySa12W0bsQqcdFMGcF1pxiKtg4OCGFG4FTgcF8K3uwJpcTOKWzFH3t0Cq43okM5NNE4KuXZnVRBSsoByGV797DISG8bK/Vc0InF2L1zOqrjURm22mnNzAhPUyeYZBZ6hTsUtfx5yrAydFaTZbqwthKHxcOvUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723223327; c=relaxed/simple;
	bh=Sfw93jLscWCKEbEC5Mx1wdh3zf4xAdcm0Xtf+YUCBzY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=JWifyFEkNlk4H1ko6XMJe9Pr75yJJVScFmIW8RJKE7ObBBva4y9gfRgQKAOXkHev/PT3s2jx2vYI9z9Y7t4ovXBObEyM+DsnUJq9E9tkhHm+RkGczTKMWI258x/+xb+Kl1mLUuDQKC6CRVsKhfN54wQgNhQtBuoKSRFfEOk//zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OYzQKgIi; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OYzQKgIi"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-530ad969360so2595869e87.0;
        Fri, 09 Aug 2024 10:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723223324; x=1723828124; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jUPA00ha0pjXeAraW7mmJ2vOxIYn9Y2B/PCyUa4C5aY=;
        b=OYzQKgIifNdaB5sNrVkem2kHmC7i1rdrCcc31a/uz2ZuwujmP48wSR4BVhiq3p0OzK
         KhNjJZS5i6WeNRcHCffwAqQQ86DCgP12Wov65z+u0U9zIVSCzEzWGLvhnjN0N2OlkD2w
         fxUkIcugYffBh4pBsNXwRt7W6g3MZL8KTJrnzeOnV71TULhp48eJ3NzLNkmr/DFESNko
         PBxKMaWV8X7hMxD/3YRIAj+5M4ghw0ccn1MTX8cqpLngVOLyTvNynzvHQAfJL6/QLwPn
         gAqUbxzkCm0slHrE/u/xvLlIKYiYr7p7ncJThxN8QZgmhGhio688FgjzmjSaXNnfJZrw
         Cx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723223324; x=1723828124;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jUPA00ha0pjXeAraW7mmJ2vOxIYn9Y2B/PCyUa4C5aY=;
        b=nWbYGnANN5eruME7l7Rx+EQJyl7pWSGxmnL6eoQ/vd3AU+UlEd83bIGepdWg9EhhDY
         6wOtQa860ECydwQYxUuLI2u/nllDdraLz6qzW/lcSVB9yX5HSBRW3eL4jRMrt0vKXYyK
         0AHHVzq1xBbcdJayhrocW02ECs8R8r64iYNlEW96NYywhl6JyKp8fw+aomS6+VSDf/wa
         w+5n4IcBEC4mcz3JoP5WgmIYSxbr1T1Vt+3r2pbl8eLTuNPpYVdvhGtwe19iLCvjN56n
         XrsdPdk6jztw4CtDZpE35QhIbmfnIT6DawhAM6ZlajAkEjxdkvCQcoiWGKK9Ti4RDu7y
         S8hQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/z6Ugqkx/Wz17wQanprsQ0mVvm+EniIwitgg+GCloWWvYoAj4dJrdLTzhnf3E059FVT63qdI7A0MFp7Uwm9HxTo1x0/BGQzKG2mnW
X-Gm-Message-State: AOJu0Yx8WTbmo97o1wwmI9UqdMoNeFGMMnJF6Bzb0wKRqJH2agWs9Ws0
	OQQrJj8nJX2i1Og6IQHi+FdiKrlk/tKWqVPY8WtEK4q2xgagdGLXlJMhVdSp
X-Google-Smtp-Source: AGHT+IHobUxoA7hg0QDjsiXD9Li0fuvS8vzc9e8+oXMypsKQzMRpWYoYhgb2mQLLvMzKuy6bv+zERQ==
X-Received: by 2002:a05:6512:220a:b0:52c:e670:7a12 with SMTP id 2adb3069b0e04-530eea0761bmr1791507e87.60.1723223323483;
        Fri, 09 Aug 2024 10:08:43 -0700 (PDT)
Received: from [130.235.83.196] (nieman.control.lth.se. [130.235.83.196])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-530de457d49sm1053614e87.130.2024.08.09.10.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 10:08:43 -0700 (PDT)
Message-ID: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com>
Date: Fri, 9 Aug 2024 19:08:41 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-xfs@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
From: Anders Blomdell <anders.blomdell@gmail.com>
Subject: XFS mount timeout in linux-6.9.11
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

With a filesystem that contains a very large amount of hardlinks
the time to mount the filesystem skyrockets to around 15 minutes
on 6.9.11-200.fc40.x86_64 as compared to around 1 second on
6.8.10-300.fc40.x86_64, this of course makes booting drop
into emergency mode if the filesystem is in /etc/fstab. A git bisect
nails the offending commit as 14dd46cf31f4aaffcf26b00de9af39d01ec8d547.

The filesystem is a collection of daily snapshots of a live filesystem
collected over a number of years, organized as a storage of unique files,
that are reflinked to inodes that contain the actual {owner,group,permission,
mtime}, and these inodes are hardlinked into the daily snapshot trees.

The numbers for the filesystem are:

   Total file size:           3.6e+12 bytes
   Unique files:             12.4e+06
   Reflink inodes:           18.6e+06
   Hardlinks:                15.7e+09
   
Timing between the systems are:

   6.8.10-300.fc40.x86_64:

     # time mount /dev/vg1/test /test
     real	0m0.835s
     user	0m0.002s
     sys	        0m0.014s

   6.9.11-200.fc40.x86_64:

     # time mount /dev/vg1/test /test
     real	15m36.508s
     user	0m0.000s
     sys	        0m27.628s

     (iotop reports 1-4 MB/s)

