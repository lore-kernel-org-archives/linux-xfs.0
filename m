Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561F93AC0C2
	for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 12:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777291341; cv=pass; b=r1EGZ3qyeaH2DlQqk28+MklhcPE9HPM6V5+cIbKNeNn7QMkfO5/gdzoaL+GFIbWVpxSV/vmRimNAtdZuhE9KCnA1tIPy53SKiZ/p0T0jfMNiBmYIEGeasV4m7O0q7S1OEFckda6nPloKoq36DLi2EsnVXgZAu5uKLesvb7NglWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777291341; c=relaxed/simple;
	bh=f7oNU5FaDQl+Nkbi/6/Ivnlhsv7ogl5Ysmt1I3aNaRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eBCDJEAMBmEEag6ABr4SvCIdWH3oxxxb/lLHiH/UQg9WrDZFr02h8m4uy73EOtkkwN5LyqcZ7Nxwtrmphv7/nEk9rk5g8KHRZ2NWdkH8dcU4cYCU82mq7dUHDjIQIr1/QfE+waLj5250UdilXWR/kxE2rLYSmfN5fcdWC8V1TJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1Qji05Y; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1Qji05Y"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-67785ef88feso7274111a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 05:02:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777291339; cv=none;
        d=google.com; s=arc-20240605;
        b=Goy+gHxNAyXGmsqLm10ozfjq1os8ECd854eZ9L/0CwCFEl+M9FDu+54RXR3Hatm0LM
         bLzabYvqknCl2Z5Cm4328v3C7tTKj71xglhS5O7D/jSywG1teHc76huVQNStdAKWA6/w
         bepLgFyyXPYY6aQBuGfyAvdYYH8yEKBlHnP2LN/zxOK4PsamBTkRpTPjFEw5L2qr7Ypz
         s7p7sv/18vcdIqlwXhOqjrmr0LwGqse3GysNmnMFMi/6wqcPFmSxuVtid0XmRTkmsIUx
         xirATmRsPc0qhtw9q45Q+58XC2IJswC4HO/c0iAUIr7NSct0QWgV8rKROsW1SAbKfTOu
         i3jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bSw1aMO32TuHJYbNOmDfdqPOAHdqlsV6G0A1b+WUvMY=;
        fh=5SRz5ViDzjo/aQqk0gRVwjAQR3BTfu8sBytNfOkQoM4=;
        b=OAWfLL1Wm8K28drHjeml8aNgZ3WEHrhfFAZrC4TcDNazQs6xhnkbWxjq2vW74O9OH1
         vKkjDZTK7FMFn4/W3MwHzmOEoQ7KLRTx8mpcsR0K9VFwSql3DoH/SfPlHw9bULg/ZeHc
         60TjyvhinGM/WbezZ8bkVrnszrIt4qqRSHvNV3iZ/cZpK3iMqB63k/Evgv1eXoGHaPc/
         DRZyncrHwYxNNzxksXTC+cMmS8Yu2V3990/TSqpuDuwMgWjUZF/FuWUlpZzLMYk35lpi
         iX0G7MZ4CkKYfxURF9sD+j/fsyPspohx7v9oCkphqcLGEgwnSMNyAGBwJa1JE0/w1pyz
         Zshw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777291339; x=1777896139; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bSw1aMO32TuHJYbNOmDfdqPOAHdqlsV6G0A1b+WUvMY=;
        b=L1Qji05YBSR2Px1RPMh0Qij8MMdumsVHV5YhEmf2miBD194l4h2f4Z7suJgFn1jtUi
         nzfd7Qh5/RECtOiX7nuAY1uhhuzoTTrXeMLpEZrhbXjht25kKCDiiIthtTp3DVHH5Nqx
         eMrNP697teAtC8Hv70hpPCgecgtZdpvh2VsT5utyY5amkOAKY+Yw0YFGZ/BKhJ1O6/Lw
         qfJ3koSwuyZNC3NIanPJvHA7FAEzxMODU8ZsjqoAInWEwJvYyPQ2vbfnqaO+SOYsAp7/
         a/kbMqdC5MiCHNxJE+BLEO8y0jN6NVDA5IEUYIDJmJJouMA+qdoOSNLNGUIDhH2IoA7V
         DMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777291339; x=1777896139;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSw1aMO32TuHJYbNOmDfdqPOAHdqlsV6G0A1b+WUvMY=;
        b=YO0IQLB3gDd2Sqgf5uRT3GzPDgAvsANhKA+QLwgfyn3yuMf7SW4ujx8gny8MUHgJ2W
         0dFaUoAhNtGReSzk1Zzs2bndqJPH8u6AwcFc8RFzb//YQfPgN+2uNrc8Te/et4ktSTnv
         eO1QI/fmWWtolAA++d+z/M4kICKMCv2269ftmg8JV84Z+zN+z/Zq8U0s5E4KXYvB7FxW
         Wq7DS1kFMV3IKcJviOJoZf6U1jZ7h3aj5zQGXwayxh3vvxcWBURFZ0dtS+hTFaSdcXGu
         FynxUqqiNVJ6cAd8DQCzr4y+8CFRQGC49qzN2Z6Lk+/ViB+lnKdPYIdrVzxHC8Uf1oab
         YR7A==
X-Forwarded-Encrypted: i=1; AFNElJ/m7ADKFgNd/jWSCjxMS9L2XgrhWeg+Ch+uOWYqh8TEEYmrDux+oNhqAYbmVbDLRMS2mLhjCMV6wo0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk78/gSpkZE0MNLeuYp40vTalVEYoHhEL/KKYu6IAozpUFoeBg
	q3FgtDtU2MpDMWbRc5qdm/stTPRFi4LaN3YCtw/RhF+PelS9ZsWrxRjzHq0nw7vWhIFqn4raEVd
	mFSE9C6b5PPfgMVpaakndwWfNVwDEYKw=
X-Gm-Gg: AeBDiet27NO9wSrYnAlP+KXSrAnItL0/Ps5zaKQvQ+SgMvPusHog47kr4LiD4+Wj9Gp
	Ktkx7Y1Ck3cyFJnD3Ge5Y/7HtwvhwHP2AP4XdICYzvd91COIqUYIpvXKz75HJ40Rqp6aSs1I+VK
	VfrzoksTGHIel67cOBa/qwQLuOfhKwQVXVCxNWYIYXCwp6XKH/JXTNhFbTtQf0ua67C+Q+0z7y4
	T32/2sy0WoF6JmYM29CkZRvJ0I1gGze09QL+FKfIhg5miir4TJRlVUfaMsLZhfbvXvAx8dS9IRA
	5BuJjxxRren6MR+8E5leDN9WT3HH
X-Received: by 2002:a05:6402:c46:b0:670:d548:da79 with SMTP id
 4fb4d7f45d1cf-672bfd87175mr18491070a12.3.1777291337998; Mon, 27 Apr 2026
 05:02:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260424-case-sensitivity-v11-0-de5619beddaf@oracle.com>
 <20260424-case-sensitivity-v11-12-de5619beddaf@oracle.com> <isfgwmd5hxjfn7dj7p54yzlhumx2hrkt3zw7fscs2ywm57g3hu@co27drpx24lq>
In-Reply-To: <isfgwmd5hxjfn7dj7p54yzlhumx2hrkt3zw7fscs2ywm57g3hu@co27drpx24lq>
From: Lionel Cons <lionelcons1972@gmail.com>
Date: Mon, 27 Apr 2026 14:02:00 +0200
X-Gm-Features: AVHnY4JzeOH_kK3jDOjK2FxeQTqZ9zkWJjZAaa-9jIyvUG0bleb4vaJ230stvGc
Message-ID: <CAPJSo4WmRu_64TxBsaimWOqz3VAU0TZ1H-_hw36HSqzQULm39w@mail.gmail.com>
Subject: Re: [PATCH v11 12/15] isofs: Implement fileattr_get for case sensitivity
To: Jan Kara <jack@suse.cz>
Cc: Chuck Lever <cel@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org, sj1557.seo@samsung.com, 
	yuezhang.mo@sony.com, almaz.alexandrovich@paragon-software.com, 
	slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, 
	hansg@kernel.org, senozhatsky@chromium.org, 
	Chuck Lever <chuck.lever@oracle.com>, Roland Mainz <roland.mainz@nrubsig.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 12:47, Jan Kara <jack@suse.cz> wrote:
>
> On Fri 24-04-26 21:53:14, Chuck Lever wrote:
> > From: Chuck Lever <chuck.lever@oracle.com>
> >
> > Upper layers such as NFSD need a way to query whether a
> > filesystem handles filenames in a case-sensitive manner so
> > they can provide correct semantics to remote clients. Without
> > this information, NFS exports of ISO 9660 filesystems cannot
> > advertise their filename case behavior.
> >
> > Implement isofs_fileattr_get() to report ISO 9660 case handling
> > behavior via the FS_XFLAG_CASEFOLD flag. The 'check=r' (relaxed)
> > mount option enables case-insensitive lookups, and this setting
> > determines the value reported. By default, Joliet extensions
> > operate in relaxed mode while plain ISO 9660 uses strict
> > (case-sensitive) mode. All ISO 9660 variants are case-preserving,
> > meaning filenames are stored exactly as they appear on the disc.
> >
> > Case handling is a superblock-wide property, so the callback
> > must report the same value for every inode type. Regular files
> > previously had no inode_operations; introduce
> > isofs_file_inode_operations to carry the callback. Symlinks
> > previously shared page_symlink_inode_operations; introduce
> > isofs_symlink_inode_operations, which wires page_get_link
> > alongside the callback, so that fileattr queries on a symlink
> > reach the isofs implementation instead of returning
> > -ENOIOCTLCMD. The flag is set in both fa->fsx_xflags and
> > fa->flags so FS_IOC_FSGETXATTR and FS_IOC_GETFLAGS agree.
> >
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Roland Mainz <roland.mainz@nrubsig.org>
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>
> ...
>
> > @@ -281,6 +293,18 @@ const struct file_operations isofs_dir_operations =
> >  const struct inode_operations isofs_dir_inode_operations =
> >  {
> >       .lookup = isofs_lookup,
> > +     .fileattr_get = isofs_fileattr_get,
> > +};
> > +
> > +const struct inode_operations isofs_file_inode_operations =
> > +{
> > +     .fileattr_get = isofs_fileattr_get,
> > +};
> > +
> > +const struct inode_operations isofs_symlink_inode_operations =
> > +{
> > +     .get_link = page_get_link,
> > +     .fileattr_get = isofs_fileattr_get,
> >  };
>
> Hum, I thought casefolding is a directory attribute. At least I don't see
> a big point in reporting it for regular files or symlinks (and then why not
> report it for device nodes or named pipes?). So why did you decide for this
> change?

Where do you see this being a per-directory attribute in
https://web.archive.org/web/20170404043745/http://www.ymi.com/ymi/sites/default/files/pdf/Rockridge.pdf

Lionel
