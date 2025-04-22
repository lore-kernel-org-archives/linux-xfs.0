Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E5D1EFFA5
	for <linux-xfs@vger.kernel.org>; Tue, 22 Apr 2025 06:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745302583; cv=none; b=DU4SDogVY5a/Ll7ACPNA68HUWffx9hUEcTFUyZDL52gCqCmpZzLiCY599/8t6cQzKdrTRsG/MQTCvRdbrBIOC1tMEhm0L7ZgG8l4FLwwIC3mxOtq3HjjvsvMTbZoPTnxf+rkcRUiRHqN2oFahygfSRisIXkIDjNNZClCvIq2UIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745302583; c=relaxed/simple;
	bh=5Et3crmwwW7FMCQ/SaJKPzdi0xnoEWDQYwqP6SF20HY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=JLv0KBqbZGFbyCHYzk9B1lkLXKTlBSUW2tnS5MCPB3hZclkPsLWCEp52dN6sjeLXIYTpcrNoKK8MKZQtt+5rW+2fBwV5rIn5J3pG5j8A2vVnD7+wOxCVkIm2+hKEKrn19w+ROMbqDYPlEZMu2OMU2sgihaoybLjmL/lRMcOBwig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NHD8IEtB; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NHD8IEtB"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5f6214f189bso7400142a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Apr 2025 23:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745302580; x=1745907380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:return-receipt-to
         :disposition-notification-to:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ispXyBR4LvjzWFUXUC7QVQX7xo4ZxXaLq7S07Cgp5zU=;
        b=NHD8IEtBMFUAhJPbBFPGwTA2MBwqC8AR2jGE9MS/EAt1W7QCmjQtkgPiOzbwHOPtCY
         oezmzgthLswdNv7BWUeH/i773ueaTBIFGhex5zVodV4CFX7v/uQBCwoUXNVocThotNI5
         zKm9f13+wVIFKRx8/P26mcevTBXgd3cRHB8H3L1AJ98UYs6ldn85jf1HM7IcxV828vrb
         xCU+ShP3EIhrjK4VJAJkrm676l63WgmGnUQHXaUQ3h58EDCFbr5id0efESYoZJ3tQ/xn
         JtKFX0T5DaL+HZalueayKlT2e5ZSec+28bWlxM9hrmApKPyL73Up7kpScPR49yBCgWFz
         jbCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745302580; x=1745907380;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:return-receipt-to
         :disposition-notification-to:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ispXyBR4LvjzWFUXUC7QVQX7xo4ZxXaLq7S07Cgp5zU=;
        b=JiQnHKvfbzON0kvOAdsmhBAeUO5vXntLBTx+cjHoVSWC5ihjOEyP54pwNasFZosvfO
         icar9R0VDd77e6pmHLzolanVbQPX8khKIP+iCGxMqo3hOj0///Y2bl/e3jQ/mIAQu3fN
         rKC6pkmgdXrCjlv7li81dOnXSbvyhbDHmLs2t7BH78r46XAMZfS3mdLbO8pXjtSjh+ff
         BeQaRK9RC1yEzVFGiD9FiKv5wSO80mKZhN06NqL7UQOzuD6SofVeKqkcwlBJEzYdqOfC
         eU7H9Xo0UCQZtpmyHbDJWSYb28En6b4Jd4nu0dblSeLiLIKoIw2a58I3A+E/R/d0oReR
         3O7Q==
X-Gm-Message-State: AOJu0YwN1WQjM2HCdOuNkAdqRTgSOnTcCLw+l2edIxjG77UIuYDjrGv9
	IVn5I+4l1BpNhQDntTq5BvPZVzPKFOMKUKNk6+a54IovtERwiepX
X-Gm-Gg: ASbGnct4MlpBg/THHofXuFp2F7ItIZYtN7TkxomoQhjLnu0985C45hKNJ2m2ixyThdp
	Rmn5QUpAntPVR+ddScf6x/8hzos2JQlyq2m+0AUHQv84zsQyQYlcp/dpkAyzJpSLt7JmolPLsfh
	/d6QLiLcvzrSLQVRB7Ixm12w5oxAv30sc/HC+PRkqhINqVtMnmZMO0ZYzzmw9cGaon/CD2nOebj
	+Z7zK6D89botx//rYpijriokJJi/9XfHoL51ZDvsUGQ2YwmCf+To2Tl027rPTgx/T4ZKnkquMIZ
	IbYMGKXysQeajHX1Ag2wywXcfjOClh9P0z3MbCyUKA==
X-Google-Smtp-Source: AGHT+IFCKurXxQzBbUgmJ9WzflHfkqVmNLEdtVFFIPEmPuRWKQ0cA4esMMNl99AuU1TwKlO1X/3iWQ==
X-Received: by 2002:a05:6402:4407:b0:5f6:214f:17ad with SMTP id 4fb4d7f45d1cf-5f6285ecd00mr12799927a12.31.1745302579473;
        Mon, 21 Apr 2025 23:16:19 -0700 (PDT)
Received: from [127.0.0.1] ([78.211.44.165])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f6255955a6sm5591526a12.43.2025.04.21.23.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 23:16:19 -0700 (PDT)
Date: Tue, 22 Apr 2025 08:16:17 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
 smoser@chainguard.dev, luca.dimaio1@gmail.com
Subject: Re: [PATCH RFC 0/2] prototype: improve timestamp handling
User-Agent: Thunderbird for Android
In-Reply-To: <20250422031019.GM25659@frogsfrogsfrogs>
References: <20250416144400.940532-1-luca.dimaio1@gmail.com> <20250422031019.GM25659@frogsfrogsfrogs>
Message-ID: <38CD4E31-1B83-4689-AD44-7AF9919AED6C@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thanks Darrick for the feedback,
I've also sent a v3 patch for this that still uses the prototype file, wit=
hout changing the file specification at all=2E
Let me know what you think of that=2E

I'm also a bit more aligned on the "walk and copy" functionality, I'll try=
 to implement that too=2E In the meantime if the prototype file implementat=
ion works, it could also be an improvement what do you think?

Thanks for your review
L=2E

On April 22, 2025 5:10:19 AM GMT+02:00, "Darrick J=2E Wong" <djwong@kernel=
=2Eorg> wrote:
>Crumbs, apparently I forgot ever to send this message=2E :(
>
>On Wed, Apr 16, 2025 at 04:43:31PM +0200, Luca Di Maio wrote:
>> Hi all,
>>=20
>> This is an initial prototype to improve XFS's prototype file
>> functionality in scenarios where FS reproducibility is important=2E
>>=20
>> Currently, when populating a filesystem with a prototype file, all gene=
rated inodes
>> receive timestamps set to the creation time rather than preserving time=
stamps from
>> their source files=2E
>>=20
>> This patchset extends the protofile handling to preserve original times=
tamps (atime,
>> mtime, ctime) across all inode types=2E The implementation is split int=
o two parts:
>>=20
>> - First patch extends xfs_protofile=2Ein to track origin path reference=
s for directories,
>> character devices and symlinks, similar to what's already implemented f=
or regular files=2E
>>=20
>> - Second patch leverages these references to read timestamp metadata fr=
om source files
>> and populate it into the newly created inodes during filesystem creatio=
n=2E
>>=20
>> At the moment, the new `xfs_protofile` generates a file that results
>> invalid for older `mkfs=2Exfs` implementations=2E Also this new impleme=
ntation
>> is not compatible with older prototype files=2E
>>=20
>> I can imagine that new protofiles not working with older `mkfs=2Exfs`
>> might not be a problem, but what about backward compatibility?
>> I didn't find references on prototype file compatibility, is a change
>> like this unwanted?
>
>I think it'd be more ergonomic for mkfs users to introduce an alternate
>implementation that uses nftw() to copy whole directory trees (like
>mke2fs -d does) instead of revising a 52-year old file format to support
>copying attrs of non-regular files=2E  Then we can move people to a
>mechanism that doesn't require cli options for supporting spaces in
>filenames and whatnot=2E
>
>--D
>
>> If so, what do you think of a versioned support for prototype files?
>> I was thinking something on the lines of:
>>=20
>> - xfs_protofile
>>   - if the new flag:
>>     - set the first comment accordingly
>>     - add the additional information
>>   - else act as old one
>>=20
>> - proto=2Ec
>>   - check if the doc starts with the comment `:origin-files enabled`
>> 	(for example)
>>   - if so, this is the new format
>>   - else old format
>>=20
>> Eager to know your thoughts and ideas
>> Thanks
>> L=2E
>>=20
>> Luca Di Maio (2):
>>   xfs_proto: add origin also for directories, chardevs and symlinks
>>   proto: read origin also for directories, chardevs and symlinks=2E cop=
y
>>     timestamps from origin=2E
>>=20
>>  mkfs/proto=2Ec          | 49 +++++++++++++++++++++++++++++++++++++++++=
++
>>  mkfs/xfs_protofile=2Ein | 12 +++++------
>>  2 files changed, 55 insertions(+), 6 deletions(-)
>>=20
>> --
>> 2=2E49=2E0
>>=20
