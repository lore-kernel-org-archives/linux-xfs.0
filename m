Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795185362;
	b=aVpJ678IphxaF7tESmPLB4jtimgKSQ7aD5QYOK+VHCJdfWmDosThqj6iUyGHtv43ohcf
	 JF1KrAZ8+AgQN1vr4d5725SKkzdyk/B/Ifmb5+wMnEomyi9KVP+jl76l0/UpoH2/OiTWu
	 VfKD6KrHuRN8MPl9cnfq91jY7cdBUEj4GeroNTo5hFbxCzPRJBZzSI5Re0xNxacYo4ti+
	 TCgOmTD7kpkFKEDFUxNGC5Ymn47fxqCYk1I1WDOF+m/sHLD0qQaZ2LuoK7qq+pCJn8RfO
	 GrPC5r5vHlJHX9XoP04v+FGBVJ/MNrKmXcec02c941XvObBWur0PNaprFOEk2t61IeA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185362;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
	b=KkqcuzswBNopJ413wUP4fMSv3XlaFbrnXCSn9XvYdG+MqDoNWcnxkza1h+GUQgQjQu2R
	 rF+Ocek5ET7mMGxMAjD87y762+Tev4jfRUJpixWLPHEs8AQ+XH5vEPhq4nV7ieXC+NGFT
	 YEBIfRcjwZtfWxhrqRL2v/Dwpw/Hh57fQmAoVfI6X3vyN7tKDmXR1VD5j3mnRPnTohShW
	 3Y3IVG5abiEvN+c8RPmCbZAQFGI3Mb1FkliiChrBxUR+gqgT5/WggCHjBYHzSlOUTzODe
	 74K3DLS33HRWwcXSm8DUgPGCAlkqkx2n/wSvDeRgNK2vmBSgJSrMUKpJNYCWzba1J4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZmlktTxO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C57606A32C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 14:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8C57606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZmlktTxO
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b894a5ce3dso1256236a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 06:36:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795185360; cv=none;
        d=google.com; s=arc-20260327;
        b=GkPTzeVDytw+nT4J2WADe6e9ax8TgzmjldWz3gHGStXX3xf7PlUhACD+nNVNNeYzz7
         k6yyik6YUeBMVPXXRfl28o89WOqD8BoBDH1DPI48xlDp9eTOY8LPZVyWyhuFLzMJxVDk
         SwKh9qT/aXuvMoG00dg39+fjc1q/73NWvVMjpyjT2PAIVvboyyl5fkvm1/dL3b6q8tQO
         2m/fYbEIilBMkONNxrLHW4nRcVDRHVShps7TLWy5222/A490B4TC3r9u+5xB2dNwBu+W
         uu7WFaaHqdj8K3+NjmzAnkzWK/LgE+EcF4KBEPHE0oRCaW09uRhR0yCChuIYM4eLbl78
         d+5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        fh=TCyxyaqJ//4Pl/Hm3TqbUgWx/ErqfDaxSyp05GP23mg=;
        b=VbAHwt9y2xU3a2NbW5t1bmf83HuKdn1YHLJ2dHU+uH4+BMaYSF6D1vorG1TN7dPWlX
         eYC/A6sfATCDlpNVgBvVBUJkusX7e+bG0TZ+JjJvet5WoVz3EHZI7V5m4yb9IwnwAYEn
         V1GGiJo155Kczkg1QIjM1OzSB0QXkUvdEjYYw5hXU4PjMxy7eOitqosJVpiMNJGYAaxS
         DdI3xaafA+24dJb9Hsr/eD+DOu56E4zaxDmq2vUuJ/ZqLzZEo+Ayv3ik6RoSbLjwOiJ1
         VB4vBengosB3uLIWoCUVx2t4+C7lQuZ7XIxAjI6Te1fgUd47IK0O1asBNyJLuIzxOKTN
         BTyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185360; x=1795790160; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        b=ZmlktTxOJqc0gUgZkQM8tVXb/Y0XP5vIjBlg31tczPuc6Q95f4xzDo/jLK66eDcTRR
         yQXNy421kiJhT7oH9vLVwxVroKGeg4J9z03nrEStYvsVMA3xboXgWcwA2+JIMTGITaZ1
         038E81NLDLzYcW4o0qQ4SonrTGr0vzYZ8MzGW8HkM5d16we7L+/rT4b4KMUSsfEHVibx
         uS8nmmaGxZ1wTgmldg9y07wcPtmMKFly5bIu+HgpUAR6RPvU1IG7Ma4/oDa4cuosYPJr
         k7UPz9VVFyx4nQjmDqMOy5HZQrVCpdYWfBCELvWA6ZL08iBITG0L9mhiTPT1o4IF12kK
         cWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185360; x=1795790160;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        b=iQ0jeD853mjG2ZQmZd+246ZLY/i+5lCN6ymxjPV05l8ykbL4ZuQ4B4taRQ+QG7Z6c3
         QzpQoZ3223pZawZ2oTi2zRH4HRLbnXaLZ57LnlD8EEWX3/7awaZkqjUejaFBF2ZGfqwd
         bOGFz37mv6OV4WXjCuzXK+HilUVdkjwRdpIlP+b3NiI1h+p//6rF6T8S8j6Ru8obqmqy
         4lQ1mZza5nB8KUu5WNDYCFIFQOIx9g+IdTx+NBlN0YnsF/n4+pMJ6sY95sL1uYN0FkH5
         xmjfHuYipPlDwvGER8vjHC9LWLRPv/skMQdS/mTD9dpjqN+HhUKwK/CPdusA3ohRQvtz
         s7aA==
X-Forwarded-Encrypted: i=1; AL+hErEQlSE5rwCGza3/6pZsmV51pWYHgmPbW4NVYU1k5usPKOP1AF0QPyy04KIhjfQetVJ1krRy04V42Pk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+w/exf60laGDmMFggNKPNO/Dy+gudhXBMMswLeSL5ynExTV+eI
	pUVwfbAcbAQepuzT3q2Cm344jsJktbeeAqiX3TIEjO52oeD1SagGuwUxenhp5vrSLY4Qaz/QNL5
	V/SmUbgCjb9Sjgz4AerWavWCxt5WuzvQ=
X-Gm-Gg: AZFdTZc+zJuIMV1G8g4f5kq51WyNnAiTNjRzW3rUoqlDHJ0Vf1kP6gvdspX/F6iKO4+
	E5nW63NKEmgmTZxG2Qz2+0nRQkqqKdp6qWzwleyHTBXacO7/jNod/AzgARhc6LrpJTEhs84U6fC
	snVhSS7UTf3pXDS1rV2vsBai41QVtK7Jrz5vK5WhZGLbIwOdU02iFmZqKnOm5ztXfObSxhxq+HW
	Tb4NL6TcR3QBpeNegyEQdTmq94f4oH3AdSZwVoek1jkSTzXvW+Cb9pVaVGk5Xs9/+ubHmLXFbvF
	wg9dME+o9SvCQSbTIEOZFZX038ZEX065FcL/9ZsT2slZ7baqeuoz3v2j28E/fNzIIntxgCFUDkM
	Jit63eeB5YBYmlauwqcn6R016CKyKOFIh2ypTpcZXIttdP3JoB1OzcRpaOXJ5M6Ozbm67Gg==
X-Received: by 2002:a05:6402:448e:b0:6b8:7769:ffea with SMTP id
 4fb4d7f45d1cf-6ba37ece3efmr2475801a12.45.1795185359456; Fri, 20 Nov 2026
 06:35:59 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <av4Hn9u80fs8iHZ6@dread> <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com> <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
 <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
In-Reply-To: <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 15:35:47 +0100
X-Gm-Features: Aa3M54oxXjJW5NIYEP5VP8q0nzSYgFKLfJAws7Wa7snJYDGBmmJmUUUXbQQ7PSo
Message-ID: <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: koraynilay <koray.fra@gmail.com>
Cc: Lauri Gates <lauri.gates@gmail.com>, Dave Chinner <dgc@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, Christian Brauner <christian@brauner.io>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:12=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
> > With non-zero xflags_mask, internal contact masks
> > can be used for -EINVAL not for silent ignoring.
>
> What do you mean by "internal contact masks"?
>

I mean that users do file_setattr() with a bunch of flags
some of them are just ignored randomly without any any way
for user to know about it, because this logic is some internal kernel const=
ant,
which cannot and should not be documented in the API.

Thanks,
Amir.
