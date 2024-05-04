Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49F36CDC1;
	Sat,  4 May 2024 18:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714846646; cv=none; b=SjHB2xF7XcSONL7pAzoNT7W52y0UxmItYiuYhZXnNA76MYpEVsnrMF+F6Uf+6t3JpbmouzXE8jQFa+1rtHGi8qD8z9LbsrH9k41gMc8t/BMjmj3URPDpZpIHxG7cpBXoHtcNTWs2sdx24wPej4MWLdmv2n3L4H14FO9CfqQRN/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714846646; c=relaxed/simple;
	bh=8RoDxEZS1EWPFuivjRixRPBjVES0Fa7HfsNSHBuwUEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VHh9IzXiGsiVhf741R22xf9jKgbOv5Wv0PBPF/gKMFcLnLu9Ex2KoXDiO4FkeHSuLzrtl5dWWL+t/K6D+9gz7xVTM84CvIGR4qCIyfh3qTrkjPtxWpVXt09b68CZlfnGjexiOt0ouzmoMIgURQWZdjls+kFKsFa6ttI1cIJ8g80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xrq8EIbD; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xrq8EIbD"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7928c351c6cso47566485a.3;
        Sat, 04 May 2024 11:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714846644; x=1715451444; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izpDu+BENOcJzlyZP2UkeXCJG5Y+B248VkQYYB3dY6M=;
        b=Xrq8EIbDTw39ARLTXY6d0XJmwZJCVB1qyYiJPZNPGHlpWn8tqVvdScfAFkbwvZ2kzC
         4DQMvNgRYHP4ytLzQmib7ygpXGYi4aMAiu/tbV3NHd8mwYEr2uR+qVtHlLOaTvg4JbZE
         t2Jb0V6ElJoE+tn8yNB+0mVYj6yqDHQOqN41Gwmf518QI0Uoxbdjt7LeoliwFGTmC5Qm
         HOwYeDjKBcHslBG0umm4Rpn4IXUPv9pXX+U7MtZAVSe7CTIvvfXQTjErji9JLJmaqiNm
         aVFQ8vZnvi0vIRSN57QmxeiDVgHicHZck0LNPbZGc8Pkd5ydWqXN1y+LULmT5ts9x9cH
         Zkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714846644; x=1715451444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=izpDu+BENOcJzlyZP2UkeXCJG5Y+B248VkQYYB3dY6M=;
        b=NAdT2AMLj60qH+lxm9LLFJQ3ehbmNE3EuQ+8BgpTUgnBOdln7i54RZp70VL8Sgz7c+
         q42h90ASCEhpUNOg8YoKFut5jxSHmjbxN0j9onu/zItf9NWgtT2oLkzqfpbexX2ifumm
         PND37hCogDjcKCSK5ZOczlNMObsoOhpUjA4A+vkpsIt91hxUpmJOyoiSXmFYbuQivsjn
         LaVeNy60NdL6GIE96W6TekEe8d/F5JCch3hAn7uIzrfojd7JaO/RQO7Sd+dUMnHP2q+/
         XuP6H2lq1wiVUosWxtfAIi5pe8wod7mwHLIHIwb4rF7Hct3fJMYT4tLtvYFQg2MNJmEH
         8V/g==
X-Forwarded-Encrypted: i=1; AJvYcCVWGYJjlaGpi3UZ6kmFpcR3p6md6+vsKb4hjBPDgNNc+DdrZBhgcXw+zmsV1gTLtVYvefJ7yGPBLQVytz5gidtz4UwtLnsPuO6Z7ieNc98mRXgta5VEnOhsOU8HzENz7AUw
X-Gm-Message-State: AOJu0Yw/sIFncXj7+97toFtTvBh6Rd/g9kkNNI44ZCDqR0mtcf0EXPzu
	SnUs5xH1UuzGLXspHD6AuIGWzEO4JetKrwQHD9ZQVUXLWRD+9z4FwFj2I8QXA4YW97/bWv9I0J/
	1fpTXrNhOp7n08DvovL//qm/HJgA=
X-Google-Smtp-Source: AGHT+IEN3jgFkasOgz7liCCSmgTx5BH17mYUVIPvp2HjKdGJRF2oFG92i38v65tb1jzNIpoBEkU/8r7Am90fQOeeIhc=
X-Received: by 2002:a05:6214:1d2e:b0:6a0:a8f2:618b with SMTP id
 f14-20020a0562141d2e00b006a0a8f2618bmr8042117qvd.6.1714846643755; Sat, 04 May
 2024 11:17:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501184112.3799035-1-leah.rumancik@gmail.com> <2024050436-conceded-idealness-d2c5@gregkh>
In-Reply-To: <2024050436-conceded-idealness-d2c5@gregkh>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 4 May 2024 21:17:12 +0300
Message-ID: <CAOQ4uxhcFSPhnAfDxm-GQ8i-NmDonzLAq5npMh84EZxxr=qhjQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 01/24] xfs: write page faults in iomap are not
 buffered writes
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Leah Rumancik <leah.rumancik@gmail.com>, stable@vger.kernel.org, 
	linux-xfs@vger.kernel.org, chandan.babu@oracle.com, fred@cloudflare.com, 
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 4, 2024 at 12:16=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Wed, May 01, 2024 at 11:40:49AM -0700, Leah Rumancik wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > [ Upstream commit 118e021b4b66f758f8e8f21dc0e5e0a4c721e69e ]
>
> Is this series "ok" to take?  I've lost track of who we should be taking
> xfs stable patches from these days...
>

Yes, because it was posted to xfs list and acked by Darrick:
https://lore.kernel.org/linux-xfs/20240426231407.GQ360919@frogsfrogsfrogs/

I guess the cover letter that is missing from this series would have
mentioned that.

Anyway, how can you keep track, that is a good question.

There are some tell signs that you could rely on in the future:
1. All the stable xfs patch series in the recent era, as this one, have bee=
n
    Acked-by: Darrick J. Wong <djwong@kernel.org>
2. The majority of stable xfs patches in the recent era,
    have been posted and Signed-off-by the xfs maintainer that is
    listed in MAINTAINER in the respective LTS kernel:

$ git diff stable/linux-5.10.y -- MAINTAINERS |grep -w XFS -A 2
 XFS FILESYSTEM
-M: Amir Goldstein <amir73il@gmail.com>
-M: Darrick J. Wong <djwong@kernel.org>
amir@amir-ThinkPad-T480:~/src/linux$ git diff stable/linux-5.15.y --
MAINTAINERS |grep -w XFS -A 2
 XFS FILESYSTEM
-C: irc://irc.oftc.net/xfs
-M: Leah Rumancik <leah.rumancik@gmail.com>
amir@amir-ThinkPad-T480:~/src/linux$ git diff stable/linux-6.1.y --
MAINTAINERS |grep -w XFS -A 2
 XFS FILESYSTEM
-C: irc://irc.oftc.net/xfs
-M: Darrick J. Wong <djwong@kernel.org>
amir@amir-ThinkPad-T480:~/src/linux$ git diff stable/linux-6.6.y --
MAINTAINERS |grep -w XFS -A 2
 XFS FILESYSTEM
-M: Catherine Hoang <catherine.hoang@oracle.com>
 M: Chandan Babu R <chandan.babu@oracle.com>

Leah,

I guess a patch to MAINTAINERS for 6.1.y is in order...

Thanks,
Amir.
