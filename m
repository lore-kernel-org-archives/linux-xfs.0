Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795443281;
	b=4rS1JsE2YnjQIJmt0uDJbRofhYVrdXUuQFAVbSYQOWPr9qYiK0hrniT4L2hSOTx7SXJ3
	 oTnSKbIAlT1HVQ0sNkaGw1ginxOp94O9Kw4tS7Oy6cZI11BOOyoYAG6J10drj2j89aXQ3
	 6P92rfbMgwokUnHir13spcbsI2dYt3FoIxIzlgI430Hsxd57gWCqYjpU9YRQSpbKaiPTP
	 nLGLMA5ESPuYLsuZCj6cBXdogbgOD8w3LNGMZQlCLXNsBdykRmp0HpHZcaF0WFW99Jprj
	 Pnzp994RX8q8LyuyxrqakbHCHZkSriT9y8pnlXijanus2S+eSSC2uiKm7CWvvqysayQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443281;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=AOY0PbbuOL71oawD6vspI9ahlDMqf1h6fTODPqf8U0Q=;
	b=UuGpGJKZCsmnkxq9vHE5q1yZbT8WUKT5kYfmJCrMQ0Q8r8GHvDUg5epD2NGzHq5LEB63
	 2wFTrwWkryv8i63cU+9wP3k4X0ulJ4bm0GmK8lTHlJ777RMsW8AsGGWcKX5W9gP9LGj1P
	 qRgfB9J93/ymDCdazWx75md1oq4GUJTrj7ZR/0DdGyxL7oSkA5RJn4010idlNayPftS0G
	 cbppe9mwItSWTh3dnWhEe5usrcicUtyd+O4ReEdRwbie+LsaC5tEX1d+6ZBefa+PcYe//
	 lIa12wBY4RcVz2o+79vr++gt8u3PP1UtKvJWNhm/pGHxNKOu4eIZqKSK5EIEpWqzVew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oROifbQ3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B8F606A32D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 14:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9B8F606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oROifbQ3
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b894d9a075so3594961a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 06:14:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795443279; cv=none;
        d=google.com; s=arc-20260327;
        b=BKPHMBYpICdZvaiwe5BdpuIYRduPeSfJzClzwe9xvjP6cInn4IGZjeTuA0WXYcV4dm
         r66XTh9/MfPcxcnE3tIHDwzpUjU8qFEgSiHwBe+ABtIo4XykNhYxbLk0h10SZ5YyaY1g
         jMqKjVubCh8laA1kMsipBOmFNkoTlurGaNvXvIqfYjkn/WDMrEoyW3zqGdhE/Y2wj9NN
         M4cxkXBEVHojFw82nM7nR108JKWh9C50pWwmyZQLIADpEUmCwdQQ6IYKTz8Ys0CWd1RC
         Fa9aYLg8gmR6qeuQz0+QjNveDXvKLseEloiJ//wkw0X+VwxF/ws7PcJT9h4HH7hyAoL9
         vINw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AOY0PbbuOL71oawD6vspI9ahlDMqf1h6fTODPqf8U0Q=;
        fh=v/60dom5UXSSPihc5S4ru1M7mMLBdbeMMMnePRiGjeQ=;
        b=kbkytRyLoMyFm6FkrqNrIdAfH5aab/Ta1b/+vxhquaULtFdlijgtjyEpPYQ7ulmkgm
         WTo8MCjciI5IuC3gmDzWkvlvMWOpIiVUj13ejxZLLySl76k2QHnk5GNHgtNpYVHf/4QY
         f7rFb0HWIgq2ukPc7Mj5n986JkVAqIJEqec5gKwWeU08k6NWcRGlI8FWl7ybt8UCrsPh
         S4Px787q3BrWUd4vTnq6N+EcuqiyUlmfeUAOiGnCzlfFFB5cIhqz69U5qvq1b2zfRJNN
         HinSvJ76Tndg/3NBiGmtltfQ8JVuosiOUSmKUr8u8hrLhiEGOUuR0tcidDJUE6K1X1Sp
         /QPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443279; x=1796048079; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AOY0PbbuOL71oawD6vspI9ahlDMqf1h6fTODPqf8U0Q=;
        b=oROifbQ3ZfFHP08nzs0+lu8sfpgDDivFrSADeoz3+9bTXvesuEy2rwbBPYElBwR/Zk
         p2DFa+x0RSp8ucrwkMJCDfO7Ki0RSaRlkB2G52iH9aWFVWkweQv70nv1VsEHkEQwbRUd
         2YEdMiXyLmew14pnSjgcXldLLk9a8OCHu7//RaUtbKG6L+X3Xrz7aeYMEWRTgtjNihm2
         dxhXwncufRKlY5aFIrVzglnY/4jLvuZ4pYgkpxMTb/fER4OXELal/eEVCMUwiO8d/LG5
         a4F3Tm35MPWkaNr7NVSraYc6Vex2mPYtjvUd1NlbBfa0Tya24bh6j51cEkgB0W4hNz3u
         afqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443279; x=1796048079;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AOY0PbbuOL71oawD6vspI9ahlDMqf1h6fTODPqf8U0Q=;
        b=o8TvHZnd4l9b47B7pd8Fv3zULlhDRyF2AcplAzZEE7S6R8wCUSKx1P2DFLS6C7+rov
         R1ap3kbw0RiucWQ+4nJHNpaOBD6J4+U/JOIDDMlQCq889FQ7kahnGydfXUHVyFYLwF5Q
         EhZGC/WYx02iUo60Dj2h2PRiNNErg/meuBxMLy9tRAjFNEqNGKDOFtoEAXiSyGZ3Vqsp
         VcTBSVygpEe7B4l7m5hVnuRGG9fTgO5CVOf/7Yx2ouyxkzZLaObhTmrmBOIvirCi218K
         1O9z9onzHkz2ny9fbHsu8HzqyTuj6udAXFRir5OfEpa6OP7oEn+y4unzMVQk9zBqPnUl
         ZmwA==
X-Forwarded-Encrypted: i=1; AL+hErFGu1Ks5UX+RRpgSVCIrKXyT9uvME1wagA1VZoQbxbszQbjGj+r24zTCMD98I1rxj2qBUrY/RDmpK8=@vger.kernel.org
X-Gm-Message-State: APuU4Z9FXAjqeh1GoNXZYtCxe96WJ8Rnaa/uBvNPVN7ASNqEy4znLYJE
	af/lWrpBvdKtQ3iqmdA/2JpXFRkBHP2Wl8zozmfNNTt+osmUD7rXJaKbRQ57yd9GVHi1HgbEHQ7
	SMkKso3vhdox2OJAhuO9CDcXQrKgxgaE=
X-Gm-Gg: AZFdTZesdLm5Xl6DDF+qlKcPzWVu5mmaHJDxbsF6BsSxXkMoVjgNdtRHNSWoQ6j/R3X
	HbycXudxzrv3StP8DZmE1BHq10JrLsAnIPQQ+4ZmvL6hU/DWQha7/E4zisk8jJXmp+QtNJ4U6Ye
	4LKEan2vCa5Tt90oQD2B8i9oKuRQCOy7MMsPdlNSgqiVIWps7LRY16d9lBsCUf49Y8sZqroF6cM
	TDce1Cgz2IMUwpaEhbUfNb4DdMtZPjxj/APtN81rF4V0kHz1V6+Fux0tMRqUs1uQzQeZVTXp9B0
	Id+MrVjWHQfyOQhQZnVBMId6dQdrwnP7VH/qsmoU6hm+Ba/eQiu5Ukfo9igAMUxd9n33TaqwHoM
	+P5LCAf9knbpewp1cNtWcMVrMP4CubZDIOSI0tCBYAemLElDUcmePzPD7e10tFAMxHXeYSg==
X-Received: by 2002:a05:6402:1e90:b0:6b6:8ed8:765a with SMTP id
 4fb4d7f45d1cf-6ba37eb79cdmr8133267a12.38.1795443278525; Mon, 23 Nov 2026
 06:14:38 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-4-koray.fra@gmail.com>
 <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com> <DN2N0BY83OY2.1OV3ZAZFSWCDG@gmail.com>
In-Reply-To: <DN2N0BY83OY2.1OV3ZAZFSWCDG@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 15:14:25 +0100
X-Gm-Features: Aa3M54qAtfdGB0LeRebZKK7K89qIg_MfhE7-Z5I2BzYrqC2uKTrvU0S-v_Coln4
Message-ID: <CAOQ4uxg9O-R_SUPAZ75ESGB99-4Z4EEUKGMkCF2f-sXkGPq1GA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 2:50=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 2:00 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
> >> modern xflags (FS_XFLAG_*) fileattr API with masks.
> >>
> >> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT and add them to
> >> FS_XFLAG_COMMON (and add FS_COMPR_FL and FS_ENCRYPT_FL to FS_COMMON_FL=
)
> >> to be used in this API switch.
> >>
> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/file_attr.c           |  8 +++++
> >>  fs/ntfs/file.c           | 63 +++++++++++++++++++--------------------=
-
> >>  include/linux/fileattr.h |  6 ++--
> >>  include/uapi/linux/fs.h  |  2 ++
> >>  4 files changed, 44 insertions(+), 35 deletions(-)
> >>
> > ...
> >
> >> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> >> index 50be49f4c913..fde6fb2fe39c 100644
> >> --- a/fs/ntfs/file.c
> >> +++ b/fs/ntfs/file.c
> >> @@ -155,31 +155,37 @@ int ntfs_file_release(struct inode *vi, struct f=
ile *filp)
> >>   * @dentry: dentry to report the flags of
> >>   * @fa: filled in with the flags of @dentry
> >>   */
> >> +#define NTFS_RO_XFLAGS (FS_XFLAG_COMPR | FS_XFLAG_ENCRYPT | FS_XFLAG_=
CASEFOLD)
> >> +#define NTFS_RW_XFLAGS (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
> >> +                       FS_XFLAG_NOATIME | FS_XFLAG_NODUMP)
> >
> > Nit: checkpatch may allow 100 chars, but this due formatting is not
> > easy on the eyes
> > pls break to RO line
> It should be 78 and imo it looks fine, but yes, I'll split it in next
> patch.
>
> > and indent the broken lines below (
>
> This should be a diff-only problem, in my working tree the file has them
> correctly indented using 3 tabs (wide 8) and 0 space, probably same
> problem as the PROJID line being unaligned here:

Sorry, pls ignore.

> >>  #define FS_XFLAG_PROJID                0x00100000      /* project ID =
*/
> >> +#define FS_XFLAG_COMPR         0x00200000      /* Compress file */
>
> >
> >> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> >> index 4faa40febf11..219e7c8eb601 100644
> >> --- a/include/linux/fileattr.h
> >> +++ b/include/linux/fileattr.h
> >> @@ -7,12 +7,14 @@
> >>  #define FS_COMMON_FL \
> >>         (FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
> >>          FS_NODUMP_FL | FS_NOATIME_FL | FS_DAX_FL | \
> >> -        FS_PROJINHERIT_FL | FS_VERITY_FL)
> >> +        FS_PROJINHERIT_FL | FS_VERITY_FL | FS_COMPR_FL | \
> >> +        FS_ENCRYPT_FL)
> >>
> >>  #define FS_XFLAG_COMMON \
> >>         (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
> >>          FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
> >> -        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
> >> +        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_COMPR | \
> >> +        FS_XFLAG_ENCRYPT)
> >
> >
> > Rule:
> >
> > You cannot add a flag to common without carefully auditing all
> > filesystems that support the legacy flag.
>
> Yeah, sashiko pointed out a problem in f2fs, and I could reproduce it in
> testing, where adding COMPR to COMMON makes f2fs crash, it also needs
> NOCOMP in COMMON.
>

I don't think this is correct, or at least not enough.
My agent said that this breaks or changes things on  f2fs/ext4/ubifs
I didn't bother to check if all of them are true - I doubt it
bottom line - need careful audit and good testing.


> > FS_XFLAG_ENCRYPT can go into common but must also
> > go to FS_XFLAG_RDONLY_MASK because it's read-only for
> > all existing fs.
> >
> > COMPR is rw for some fs and ro for others.
> > As with CASEFOLD, you cannot make it COMMON before
> > converting all casefold fs to new API so that each can say
> > whether it wants RO or RW.
>
> How's CASEFOLD currently handled? in the v2 I'm drafting, I added
> fileattr_mask_to_legacy() and fileattr_legacy_to_mask(), which convert
> between the old format (filtering by FS_XFLAGS_MASK) and the new mask
> format.
>

Good question.
Need to check this.

> > I think there may be a way to deal with this easily since
> > ntfs doesn't need to set either but not sure.
>
> We could export the 2 other helpers I added for v2 (xflags_to_flags and
> flags_to_xflags) and make NTFS use them?
> Though adding the fileattr_ prefix will make the current (v2) vfs code
> maybe too verbose.
>

Honestly, I can't say for sure - you can try
I think you may need a different set of helpers fileattr_prep_ used by the
filesystsems that are converted to xflags_mask, which may be different from
the set of helpers used by the user facing ioctls but I'm not sure.

The thing is - this is all hard to wrap our heads around

You and I have parts of the design in our heads w.r.t backward
compat with legacy API, both UAPI and vfs internal api.

I think you should put it in writing to see that you and I have
not left anything out because this v1 surely does get it wrong
in several places both wrt legacy UAPI breakage and internal
API correctness.

Thanks,
Amir.
