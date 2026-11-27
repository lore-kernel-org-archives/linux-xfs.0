Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795796335;
	b=B1AHF6idRT+U0SVHVdNebAVoxQF/4e0GvJbl6va7JwQCvYPtb3oBHsw6VQBk+ZJD9BD/
	 f4kaxCyWrbRZpgNSWvLOUeFfy8v3v7Cc+YhRMAHbKSfvuz0H9Svk5Zsj3FtsLnfZamgK/
	 6PirkRTltMnImys+efIKFzlKvc9kCI5KKH7fa1uM+rWzzXqa6xaRJQE6ha7w4m3FVSWrr
	 3f/v7is67m6gDc7d/eUv/ZaAJLMum+ntLV5IEIwA6pGaCGlaoM+U3IdToGdzg653n8//i
	 Mc1F6m9rk2f0oXv/N/J5fTq+x89VMcbgicFxpXdMsq6YbJznpZH5WYldW2a/lmZ5Ihw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795796335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
	b=1yIOjlCa44yPnD0wEpxcV3TswVwUzCZTc2UoPyc7xTV5K5ru7UlgghKlz3q8Px28Fs1j
	 TfV/W8E5KAbByNWORLHoaKiUBS50KlPzWL9LjjDlN9guYEp3+dkpDfgoPZkN+7VGn1wY/
	 WWTvGU5Ch8Q9024iR6t4NRZlDTk7SaZ4pAV7GRC5zcBneip+z8BazaJIRJq6JM7gyQ9si
	 6J7U+iLVRoywixHU0ymGi10EiOIIS4qooEwaFqg1THUEXm7Z2n60Yn4DW55XaKIRROfZo
	 U3aA2FgPWaMythFq+tRHZ3rmHrGB9YWQda6wLGzBGnNuI1ILfvxpjDK5EhIdJlLRlxg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="naloy12/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BBB606A31E
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 16:18:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9BBB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=naloy12/
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6baa6f27904so8268577a12.0
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 08:18:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795796333; cv=none;
        d=google.com; s=arc-20260327;
        b=VhtSpcaPqyfKI1GDlc6E2j3qg9tTjwQSTxnJj8Uu6m3T4ctB69qnnrFraGnlHF0kv4
         jAmIbXWE2Oq+1V805w+9FqsLU4bFXyQbBvXtIKvMvPaln4IeqWYNOlbASk46vx7uZ65E
         DM3862EKiHTrKdATtRtU3lgIyjybScakXJp7nijAuxxMVM/S72JaLFB8LoNf3krpgIug
         sAzyDX8EK+52HjM3mNQ7de2UEEtAP1iUnrFwIjj5yu2KMfqlziz//+wSYQF8RF6n55a/
         ph7mwrsafqWDoNxur6SdTlQ6we1Qh/kvk4BM7abSrkwW++CD2agAdIWPe1c+zzHnzu3M
         QoWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        fh=hEPBFY5KF+5AKyJat0r+cb49iEui0OSkVPO8yZtOh08=;
        b=tAu7vM6SdRlRtDo0FmhKz4cWTzbCk57hSa4jQZOKLZozlDJMD4GVL13o4GAfUDzR38
         VsITI+H4yCCe3X3OTk+jxtqociakyifPB7nBdeaaUUYKAwGvwuuL9sNqhu+Rs2ip9dC1
         xtcKP7r6TkICvCsoabNvVbJPMrEkt4WM5yVwe3RWoaPcTKP+//0WpxOZ+OZ/e3NRtya/
         6cd8ErIcFA/Di+Nb7mwr9nvt2p1uASLPRTCOwRjGpKCMmqJAxH7GQLbguF/oDQesu8d6
         D23JXW+UMzGcrvymEAV4cMuA5AThWAEgxAnXbJtC9Y7KZX16LyeKWmKN14VQKvowU3gk
         fjZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795796333; x=1796401133; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        b=naloy12//Z/JEicfOBVG7/emu8n6hsVyuTwhG/APX5YJILPJ+Ejhpn8jBE4NDP7/lK
         g0UksYAE6Bdao6mTsS9kfqJqJTBy4iSLcQUfz2p6ydY9idCCIBNNnumqk9ahTewMQrhJ
         T08f33nweDrOyw3pKSkr1Qkrkked0vr7ZHwRDHta+TN6WG0oGzqsuhDrEOx72fBh5WU0
         oYgUXVXd1tU/mzTeQ0mzsTJviZuAX74N/jPwzeSjBiwxnyK0h0TealYMchARBmDUZIOX
         ViMp+AC7Q+jtL9fE4jDvp/Jor7sArB0DX5YSBPvQ3+fL8nmRlQu5cAOGwV0tlnPOhQ6L
         rUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795796333; x=1796401133;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        b=1ZgifGCSjhtq/+qQJnU7U4rACJs5VuvL8/zhSNvh6CN7Uxn8tjyBU2oMNp/9QwQDLp
         Y/2Vzlym+9VtBx/23pq6KSgHcCJo9TVB++hx+Qd2R8TH5mcOBCjFFSXFdmYnlOdTbRE5
         NC1/8phAxpSI5q7325v6Vars5y0rfId2fwkMsTev2GUxPcHb3BR0GV4Ew49a0l3pqoDk
         btDgqi3HWOE/JNcz6f2ehMPjIQ2VE0b5Xco7q9AUjAwOejs1J/6/dpWLkhfCMFqRzTCj
         o2B6F291/9lEdBLx5k07ruj8B3ERiZBJph8vk/H2dhiFSv30ySVgGHSpkk8oLeC9+/KU
         WM4w==
X-Forwarded-Encrypted: i=1; AL+hErELIssfyBcsUFB3MSYA/PdtA1S/KgNX1dV5c/eBcYECDo3iO88PBJk25+/Ntj4HrurHWAsJHifTSOY=@vger.kernel.org
X-Gm-Message-State: APuU4Z+DR3jdsChnqoGCGjD6JxQn/VVnzYihrLnMyriJ/95mSdkn7KFd
	4jTsxwvYk1YrkntHE8hvkV7Om1Z7dyc8dF4jMIiI09EiYbwj54LyE0HKHcSsPLw1T90h7kU2uUu
	KE18gzLKwxTBATPiLv/6hhnvVWlW6e8U=
X-Gm-Gg: AZFdTZcH6ifWf5UeXXUGH45KVUZduaHyHk5DbdGd2fjyvq7dH3B4obGa4iB7RBuvBAS
	LiR8N44V9q/0GCc6gj4veTX1PbTh8DNLp2LLAdZLkX2nSzi5uZ4Oqj3357KCaqgp+uxEOBejxK/
	yZweVP+FxjML0aPzAbf7bTPW6/aPJuI71bTKMGS56v80k+DM+JXdOwU0iGaw8WP3U254UD7xZqZ
	pJRHpyRTRGA5uNcdInq/wEW7MbI1/D5RH2kCcxfc4Rkaqka2ut3fQ+GSCA5uyLHuNkJ5kk2YMVJ
	NdkVDyqHmbk82VuZg5YsvHYKEVgiTt6SBIGklzeK+cZcGP5HXLOKfrDVwxKLwQNR4RXJDVB7hpA
	OfDqzNHXl2zbldhPWfmJeyS0QVXTBK3G7RQcWjJGcD0OW+VnmFmfWgoxqHgPGtI8QECJ6aA==
X-Received: by 2002:a05:6402:e05:b0:6af:80c4:8981 with SMTP id
 4fb4d7f45d1cf-6ba37e890fcmr19985269a12.26.1795796332918; Fri, 27 Nov 2026
 08:18:52 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <20261119153222.65195-1-lauri.gates@gmail.com>
 <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
In-Reply-To: <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 17:18:39 +0100
X-Gm-Features: Aa3M54qCjcbbYjv0mzgNqjSQ7Sw_WVEr_GJN4PX5Bm9lrA0JqzVoRsl7zVlER60
Message-ID: <CAOQ4uxhE38TnXseMOyWY1OvidBWew2hAYAV+rYeTPaqRYZb45g@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: Christian Brauner <brauner@kernel.org>
Cc: Lauri Gates <lauri.gates@gmail.com>, koraynilay <koray.fra@gmail.com>, 
	Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 1:44=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Nov 19, 2026 at 05:32:22PM +0200, Lauri Gates wrote:
> > One constraint for that case: the flag has to stay out of
> > FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
> > FS_XFLAGS_MASK is reported as supported on every filesystem, so a
> > plain flag there would read as "supported, not shared" on btrfs.
>
> Right.
>
> > Christian, with this mask on the way, would you take a plain flag
> > (say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
> > that filesystems advertise through fsx_xflags_mask? If so, I'll build
> > the RFC on top of koraynilay's series instead of using the inverted
> > FS_XFLAG_NOSHARED.
>
> Yes, a plain flag is fine. It's simply the stx_attributes_mask model.
> Filesystems that have support raise the flag in the mask and everyone
> else just doesn't. I see that Amir's busy discussing some details in v2
> so maybe base the RFC on that series, I guess.

FWIW, I think the v2 posted API is a solid candidate wrt the UAPI -
The AT_FILEATTR_ opt-in and the struct extension leave very little
open questions - the remaining discussion over v2 and obviously needed v3
is around implementation and the fine details of the contract, but for a si=
mple
readonly flag like FS_XFLAG_MAYSHARE, it is very clear how it behaves.

Thanks,
Amir.
