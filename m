Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795107871;
	b=L1rjjjayKHcFeTvNq8o+dH7mRlj9NH4NThB4jeU3UuzvhHdclkKgLCMcSPweurPKmD4g
	 iTGPQaoCh9Xk12eqJesCD0P0mMzPfF8/RkayRLBPbxEgPGcTVyU0d7Mzq8IaH13QWAlk6
	 Zp2lbQZBiYgzD2JrH4tlt9WYof0mAuwpBcNgYHUCbhX8lYJN94/NxpSzvO2aGRTSUsmSL
	 pWAoI2f/GMIRpXouGoCWkvrmLTUYCl2i+UhYYxpoPJxb+oGjYkI09q8SlFkmotF3txm9k
	 skr2pvr1+JM0NWoJLwlinQ8L1Ur08HXEYxsskkkB2hBRe6irq0Ntj899pCRPTHzPhmA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107871;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
	b=tJ6BPNLnM4llVQVsrFmAkqg1EPAPMhXOns269gnvfKlXvEa++zCHRk2yzutxpYeDdp5h
	 I3euN2UzX/kBzPDdtF0aX0DnaB1yuZN+W4C9A847g+KGj7GZ2ozkauL3hCBpZOikCL+FF
	 1ayMojdL+nXsf1mXTqN+BLUwPSxOZ8eP6fO99NbNsOod36xbLmgpcLmmc7sHTDvj6C7zJ
	 LfqMAtUVosIa0hz/VL0pT8yvh+0wFPhL3WZnhG+hDwG/FyE1qay1bv+5u8w+XKiX9XKu7
	 sjgk6JX1m9zxgN+PSJCawGqaOPIifCACPHMVXtNH97fVrM3y6el8W7GYc21erW/6b/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s5zc6etq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46870606A320
	for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 17:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46870606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s5zc6etq
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6ba12b00c76so1154300a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 09:04:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795107869; cv=none;
        d=google.com; s=arc-20260327;
        b=CijFBcusqDEjHdM9v429fyhrGlHu58DHgTy58iRtZbAJexKUh5fU4D9RzaooLoxCky
         VzPQgozFVYKeoElU9LOfSwPwLvvyfLIsw88sOouh9f2iJldBftbPa1jq9zqLenhGzmE2
         v3MLmkgW3rxok1fB2rfUpMYUtjtCMbQI3vvAO9gDGgq7mIhsXa+v4IPxNOxzgr1MQ50i
         EIJ9gyl9mfoK/WsUvpvX7J8WYLI7iswdpY3vxRDTtCA7HDru7gkiQRIeTNJHBzbV9OSj
         ey5utH8HGDZSR+igDXYMHdbzjGN8qpj2naeTjknGW1GVIAPlIGBkqrPU7jAaP0JXTT9D
         oPIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
        fh=ZYGUnG9ZlLc8HVBZXixXqwCZ5e/iUKp68xO1jUdRxgY=;
        b=QW0HHYmCydPdEgxDmeIIerZq31xtOK7pmpq6e3q9f1p24uzq2QxDjMum8skIqvMpKh
         0UHa25FA8gPJVeMelgA4qdCo3lnrbwtMhWdlG3NCtnW6rvNycI89xce+nw3tIbPZDPvF
         /XWRGcDG9Mboz7/JQ+cMiKFN5pzNCN7j8PMYie0uwmLSDiG6mhz5p3vnBHdAE6jU12Hi
         RkQbg61UH3d9mSjD7otVhxNCOhKWtfvuL/bDHFNOrWfQ8SYmWXEkBLe3xqbXCs+dwHK9
         Owaxq7IOmRBCjoOvufWLUTSm7Zn30AVq3z8oAvtPuTeQJFTYFRqy94YykqgLmTkFnQUl
         au7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795107869; x=1795712669; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
        b=s5zc6etqP3GKrfiHHgIM6qRwBj4GIrrYXAc6mNtEDxVzqmttJaHCzBqV1dtIN+vio3
         Bnt6ZD+22BFWnuCnU8EfLslCEzR54XnIaMRCfU4Wp6aReVvOjg7SSEeZ++TPablfbh0l
         nWScX+/5rkWM/Hp/yZ+hSStf6OX4OY+2MyRjQ6hvynNEq3yrt2g+oozsb2uIIRwN9Z0y
         kqeQwucwtBml5gJuvt9l9W1sgy2+Q505qHa2NQnc54/JOh7uClHStUwVlxpUu36xurI8
         7fgIaULXH+3INvDRKkck+rkIPO9DQA/oiLHBMSnEoMnziJpuqf6MgQUtU78WnH6opbGH
         aXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107869; x=1795712669;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
        b=Dd900oRTIhmxwfO3vedssG8EA8r5v48sj73hpIw37B5kjZfDV196YkxpUpPsTUDpdb
         E5H6KIN/sj7s0o6n5eCQ3ItjEJ8LlLWC5RsAa6r8D/wG7ZaZz0wikeVwBnTZSHxkZ4va
         hphFYNaNX8NdvSVfqEE3jZ58PSiBaQ5fz0wv6Mf+bpaHehWymFAar4tVaoWwMCFu2Y+K
         L2lABTgXCeU067JDMGEQL9ElhnvKoGt3AqCn3cWodX71fR+bN5maWlAfxV7RTqYmW/+z
         60YO7or5xAV9G3iBw1Q/TDkCeHOtFEFUwUp7oVvZGMGSnXF09vP+FOPW38OURUHcyGQc
         UUlg==
X-Forwarded-Encrypted: i=1; AL+hErGz3Zxf69eTjRMnf5BDnOAHQrJEMpEOeC6zBJHwyKqKcuKIKj36HqHqJioWmCTQRSQzTRfQgFgf2HQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9XbBAfBveuDm7GICqw6DgdUGvcZANqwXesH8AKx2veQw7cyeRq
	yvHNLPCEqaAFyPS7RMO0E3GwLWuvOwBLTeLTMcg8Aga7ZOZhmMyPMPxZouLtiPspWaOaeq0HAHO
	Z3P6lTHz+J52smsAGGNRFu6m88XecpPk=
X-Gm-Gg: AYBFou2cZxM+YDlbQWj45dB9Q/H7uaADnhZ+tDO8WaLUNOMDOieb+iZSGCA1SOi8gmx
	J876ua4Dgtl5LKkHt/Z4EKbTD8kYKXUCbBVGYXFmGRWHOgmdiZuPSjfW3ZOGdOZYn5fb5tY1ACD
	iIZv0mIAPZC+bXQSMv+1d7F2s9pTvvxCHE2ub7yUXlJO0K5pz1g+q6eTo/z2b+K7Y/4CwjfJJbB
	arrvaR+kzB3sATcpCDiLqQxep17KlSIHQPC8m94VHL6yYDfKt+KybkvBYKolElXvu0sDkSsuARW
	5D4ipvUiU/n6dqF8tqZVxEv5sy5aF/R0rxmJLbgb1tu1kllkNGhD2k1T0YwW+UIyqluGJQyXaMo
	Xl6vO1UFbtBwXTy7ZuEHDR6PSqcYSl9d9ftsAtU5i+Zl/TiiayLtN+GEWMRmCQWX6W0vRvDg=
X-Received: by 2002:a05:6402:15cb:b0:6b7:b872:27a0 with SMTP id
 4fb4d7f45d1cf-6b887e9b3a2mr4758592a12.21.1795107868285; Thu, 19 Nov 2026
 09:04:28 -0800 (PST)
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
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
In-Reply-To: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 18:04:14 +0100
X-Gm-Features: AclHuK_v3fdGGegcviRdfo5LNeBocqyxiM32rnjQTLwAQD9spb3t-0FSAl1IioM
Message-ID: <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: koraynilay <koray.fra@gmail.com>
Cc: Lauri Gates <lauri.gates@gmail.com>, Dave Chinner <dgc@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, Christian Brauner <christian@brauner.io>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 12:00=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Thu Nov 19, 2026 at 10:59 AM CET, Lauri Gates wrote:
> > On Wed, Nov 18, 2026 at 10:16PM +0200, Dave Chinner wrote:
> >> I really don't care if it is exposed by statx or file_attr; checking
> >> the flag through either interface will be orders of magnitude faster
> >> than using FIEMAP to iterate extents on every file to find shared
> >> extents. My concern with statx is coherency - it runs completely
> >> unlocked and so can race with operations that add/remove the reflink
> >> flag...
> >
> > Thanks, Dave and Christian. Given Christian's preference and the
> > coherency point, I'll write the RFC against file_attr, once the
> > question at the end is settled. xfs_fileattr_get() already reads the
> > flags under XFS_ILOCK_SHARED, so the new flag gets that without extra
> > work. The answer can still go stale right after the call, as with any
> > stat result: a clone that lands after the read is missed, just as one
> > that lands after FIEMAP returns is missed today.
> >
> > As I suggested on the 6th, the flag would take the inverted meaning,
> > so that an unset flag stays the safe answer: say FS_XFLAG_NOSHARED
> > ("no extents shared with another file"), read-only, in
> > FS_XFLAG_RDONLY_MASK next to the case-folding flags.
>
> Hello, I don't have any say in the FIEMAP issue, but I wanted to let you
> know that, since also a mask was mentioned and your patch would be
> touching the fileattr API, there is work going[1] on for adding a
> fsx_xflags_mask that filesystem use[2][3] to advertise supported flags (o=
n
> get, like stx_attributes_mask) and users use to say what they want to
> change (on set).
> It doesn't seem like an FS_XFLAG_NOSHARED flag would touch this new
> change, but I thought it was worth pointing out, especially because this
> patch would also add FS_XFLAG_PROJID and a new FS_FILE_ATTR_XFLAGS_MASK
> to have a way to include both legacy and newly added xflags, so
> FS_XFLAG_NOSHARED would maybe also go there (correct me if I'm wrong).
>
> > Christian, one question on the shape within file_attr: would you take
> > the inverted flag, or would you rather keep a plain "may share" flag
> > and add a mask to struct file_attr that says which xflags the
> > filesystem reports?
>
> And if Christian chooses the mask approach, then my patch[4] becomes
> relevant.
> (in [4] I put the patch that will be sent in v5 of [1], since in [1]
> it's merged with the ptime change)
>
> (For Amir who I just CC'd, [5] is the main link for this thread)

Thanks for the CC and the link

>
> Thanks,
> koraynilay
>
> [1]: https://lore.kernel.org/all/20261115180343.576773-1-koray.fra@gmail.=
com/T/#u
> [2]: https://lore.kernel.org/all/CAOQ4uxj82K4z+2OiY5W1g7NyWAFOFjqqWnZSS3p=
rytW36j1LgA@mail.gmail.com/
> [3]: https://lore.kernel.org/all/CAOQ4uxiuJ=3DeZu28FZAUz3rpqPKqCimPxJucOn=
YYuBowvD09_Cw@mail.gmail.com/
> [5]: https://lore.kernel.org/linux-xfs/20261102193533.93690-1-lauri.gates=
@gmail.com/T/#u
>
> [4]:
> commit 0efe0de3b5cc2b767aa6e2bb9174eb05b0d818f1
> Author: koraynilay <koray.fra@gmail.com>
> Date:   Tue Nov 17 14:57:47 2026 +0100
>
>     vfs: add xflags mask to file_attr API
>
>     Add fa_xflags_mask to struct file_attr and equivalent fsx_xflags_mask
>     to struct file_kattr.
>
>     This lets filesystems advertise their support for specific xflags and
>     users specify only what they want to change, behaving like
>     statx.stx_attributes_mask:
>     - on GET (file_getattr): each filesystem fills the mask according to
>       its supported xflags, e.g. FS_XFLAG_COWEXTSIZE or FS_XFLAG_EXTSIZE,
>       and provides the values in the corresponding struct fields;
>     - on SET (file_setattr): userspace fills the mask according to which
>       xflags it wants to change, VFS validates this and preserves xflags
>       that were not specified in the mask;
>     - if xflags_mask =3D=3D 0, use legacy full-struct replacement to keep
>       compatibility with older programs.
>
>     Furthermore, add the missing FS_XFLAG_PROJID flag, to allow userspace=
 to
>     set the projid using file_[sg]etattr().

Correction. usersapce can already set projid using file_[sg]etattr().
With FS_XFLAG_PROJID in fsx_xflags_mask, chattr -p <projid>
could set the projid without having to read and set all the other xflags.

>
>     Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from accept=
ing
>     FS_XFLAG_PROJID, add an FS_FILE_ATTR_XFLAGS_MASK to support new xflag=
s
>     and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
>     validate that the xflags passed in fa_xflags and fa_xflags_mask field=
s
>     are valid.
>
>     Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
>     Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/file_attr.c           | 46 ++++++++++++++++++++++++++++++++++++++++++=
----
>  include/linux/fileattr.h |  5 +++++
>  include/uapi/linux/fs.h  |  3 +++
>  3 files changed, 50 insertions(+), 4 deletions(-)
>
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 833e03810b24..56ea65f790f1 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -102,10 +102,18 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>                                   struct file_attr *fattr)
>  {
> -       __u32 mask =3D FS_XFLAGS_MASK;
> +       /*
> +        * fsx_xflags_mask contains only flags added after the
> +        * file_[gs]etattr() API, so we need to tell userspace the filesy=
stem
> +        * actually supports all legacy (FS_XFLAGS_MASK and FS_XFLAG_PROJ=
ID,
> +        * which lacked its own bit) and new advertised flags.
> +        */
> +       __u32 mask =3D (FS_XFLAGS_MASK | FS_XFLAG_PROJID | fa->fsx_xflags=
_mask) &
> +                    FS_FILE_ATTR_XFLAGS_MASK;

This is not exactly how I envisioned exporting fa_xflags_mask.

fa_xflags_mask =3D=3D 0 means old kernel or unmodified fs.

For a new kernel with fs that supports flags other than
FS_XFLAGS_MASK it's the fs responsibility to advertise its supported
flags.

Something like:

     __u32 mask =3D (fa->fsx_xflags_mask ?: FS_XFLAGS_MASK) &
                              FS_FILE_ATTR_XFLAGS_MASK;

     memset(fattr, 0, sizeof(struct file_attr));
     fattr->fa_xflags =3D fa->fsx_xflags & mask;
     fattr->fa_xflags_mask =3D fa->fsx_xflags_mask ? mask : 0;

Then you can add filesystems that support get/set of new
attributes without support for legacy attributes.

And specific filesytems could opt-into the set of an individual
attribute like projid by advertising
fa->fsx_xflags_mask =3D FS_XFLAGS_MASK | FS_XFLAG_PROJID
or a subset thereof.

And I am still on the fence wrt should API also advertise the
fsx_xflags_ro_mask in addition to the supported mask.

The advantage being that it makes the interface symmetric.
User can alway setattr() with the buffer they got from getattr()
and instead of randomly ignoring flags in set, the fsx_ro_mask
along with fsx_mask defines the behavior exactly.

Thanks,
Amir.
