Received: from mail-qk2-f40.google.com (mail-qk2-f40.google.com [74.125.230.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680D550EBFC
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 14:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.232
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778596; cv=pass; b=kEma3ca/Cg5gImYmmoFLktW+LEvjdTxF+gE33v5nXGdB7OG9352XPp9H+bfFcaxrvpY0GNKPXeR199/X5MojsORGKlIzKtRz8u688c+iMzYQFPurMMPuPvymjHQIB0M+jZ3iM4iy1ima5DhwD+ee7AwFyPsTNv7yzXWuqGGXibA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778596; c=relaxed/simple;
	bh=Jv5f1g0f3qDS45IX1yQFN/XI/1HiyQaIpDbEOG1DCc4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=WzLTfuNJUMIxW1GT1HK9dlLRSbj2E8BBvGI0Z7YaTLxq6mvui/bAFYCW0StZc1Kgq7tEBwEgbuqgbLGAYRJfNR8yrFlj0SXn6Nl8iPOknRgEDH2+1tCw0kOEG7k8ZyDG/bP3XGHnzl1ivqRXMf48gWd6I0ghr4dB0BClyoZ6Go8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=JtZc2h8E; arc=pass smtp.client-ip=74.125.230.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="JtZc2h8E"
Received: by mail-qk2-f40.google.com with SMTP id d75a77b69052e-53324cfe178so39106101cf.3
        for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 07:29:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790778585; cv=none;
        d=google.com; s=arc-20260327;
        b=jTDGMHJVt6Yq9GfVQbiwa88owmkzibU3eRtjQh3no6D8wBHwJdZvW7iocThO5w0vhX
         ye+hVeDPShw3TPTVRSmyQbn4xRBT0TL8z7RSaZ7saKXJeJhRqdwhvkyhVjbsIaa0YomK
         DWqUDT4kvQ1GE/9GM4NNoMpViS4ZdlGCpZSxpgRyxkEM5TFR+COSi+PpHL0NY8pzN0Ac
         qJtvuDCVt5lj2+ZUX+7iRjO+VlawIpPRVGE5zwnaa6aOdSk7SADnAqmKk9XAqLKg8a1K
         1ap5Gzd31mQM0JzokkMzZPIEyykNQBF9m+gd2e16n1XS0OXpDfhh7PWGbHQbcexDPhFq
         4hnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=bFcOr5qvsPCgBjFZ4BWLUmj9QlCgJD693TK70ZfQ/Lc=;
        fh=h+kMTxE1xX2yhprXZsv1SS9cxCv38DuuUz/JwiGmOBU=;
        b=K01cJnYL6olqNC6at8NDq1OwYsP8hxqrxRP2GVTh0KcMW9EKPSqwgfBE5SODq5KSky
         5gcX1QHwlqgmBW5g6eOA695zdIfj/J7R5YJmz4m2qiEBW/l8CvxHaiKtYbbrPj8RMLZt
         4dicZsVGUg5fg/zr1nxnBgs5Pd1v/JE+ncvw4WDSZoVMbfO9jzcH8G4DntjlFwNlbvPi
         4N5YZ6g+hOHLtqGE50KMscjibR/CgceewuzCcNQAgoxxKkH/QXD2f+cA0HV1TEvXWy7i
         AU1dmMaHTaAEv4W4w71NxY0ByPB3XwaH1dU/2Ys0Ud2THcLFX9d63JklJ2aOb4AdL5De
         pQ8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1790778585; x=1791383385; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bFcOr5qvsPCgBjFZ4BWLUmj9QlCgJD693TK70ZfQ/Lc=;
        b=JtZc2h8EQA45wKHjoOhwjBPvJIRF+85Eyx9ImkE9V6edmGXF91BJBPX14iSyK7TyK8
         2ryN6nFxlROoSwmDZaf24EgMB1C/0riOHVLkH94bm6pdZs+12tQLuIFoulWdm8xK4NUi
         RWKl2Lup3bX3feQudkK0NEhGsFCbRAeccwFUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790778585; x=1791383385;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bFcOr5qvsPCgBjFZ4BWLUmj9QlCgJD693TK70ZfQ/Lc=;
        b=VB8qwppGhlYGVOyK1sAuqb4BO5mS8nAFd6+kTHOoaOGQ99LzZwrY6nKwdxvsApGwKx
         sBmZxTauN7PV3Q/UogkFeRfyczoBONKXTMhG5b50+R4+WAMQb/Nt3SYd8/vR5Gry3mOg
         mOaJmqax/NQDHwW+yDXY+5JJDexDlaYqm8Ity1vRZUhG9RaWTU1qoDxlc/MDXcYuvxWW
         AFpfyJLW2e/Weq4+pXUYouD76t4JVFGH2R1tpRj8/Q6Ma7iSxilWDilJQLn3dxgp4n9W
         JIfuhrnq4UKflszfD+sYyFw/NPrR3nh7XFpN8jAL0W2dMPZC+V3au1uTBNO9uX5jzzJR
         l1jA==
X-Forwarded-Encrypted: i=1; AKwUvBw4TPUF/f2KP3ahmXXyHSRTJPZfdCw42IKCbe+65bplMGmk+clV0jzKDclZH9d6bxD4Ex280vrIYx4=@vger.kernel.org
X-Gm-Message-State: AFuF++nouD1dJEfXjkSUQnA/OQvEbYKCOTwUlB/wH9FkuHGPXohWAJp/
	rRiMfNCkb6DE+/SYkxefj+iRYRRyPNSU49qAIfjcKo43mOWNwLr1U4e5GSyVk3Rll1b8knxn10/
	p0hoZzMP6z2n2Xgqs+OSZXc795iNGA9ApZTxHJgsrznd3hx2KC/JgBP8=
X-Gm-Gg: AYBFou0Avr548AL4LmMkj7aWZzOm6tKUTSHuiZFuSBXNQOI6A6DnlcP1XVXbhLjLjqA
	jJcTIHsln9IzeiAgPVcvuZnPqd0OhHaMdijizWzQyzc9/WDwkDhLtI7Hyyrz7QPi697+ey2M74X
	OI42vdIar9F+Zg1IProGkSOgTwJk8Jp3lH9Iiwe+Je7aw66q1C2+AaEq446ICzq9xPrTC81Ls5x
	bAnwfPuwyNT04Siber16T9+kOPQN3bCqEGxQ+LZXlRv17ZLcS2yPgaQ0LTcaiPwkSj3fiF8Ymyl
	77pCst4wgRBEedLGp8dpN9x1KSpBhKpbR88q5C9IIRU1LUBKoNYU6K8XOOtQVopcbCzO6bJEiKl
	KskrJNlX4ioLqew==
X-Received: by 2002:a05:622a:258f:b0:533:32f3:1db0 with SMTP id
 d75a77b69052e-533742bb8cbmr29673951cf.6.1790778584578; Wed, 30 Sep 2026
 07:29:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Sep 2026 16:29:33 +0200
X-Gm-Features: AclHuK8GeOe_W3mvOTyMrVDZeZ25RiRcVppHiB0syijS4_yNrxLEymVmpXQKS-M
Message-ID: <CAJfpeguyOXGQO4Q8rSAc8GxExTJU0G2o19fxRnh_93GvAoNcRg@mail.gmail.com>
Subject: fs_put_dax() vs. dax_holder_notify_failure() race
To: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Cc: fuse-devel <fuse-devel@lists.linux.dev>, Carlos Maiolino <cem@kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org, 
	John Groves <John@groves.net>
Content-Type: text/plain; charset="UTF-8"

During ->notify_failure() callback will dereference holder.  It may be
NULL at this point, resulting in an Oops, or it may be non-NULL but be
freed during that call, resulting in UAF.

This affects xfs at this point, but the fuse extent map patchset[1]
also adds dax failure handling and is affected by this issue.

I think this should be fixed in drivers/dax/super.c, since this will
be a problem in each user.

Thanks,
Miklos

[1] Report from sashiko (select Patch 8):

https://sashiko.dev/#/patchset/20260922061019.3320196-1-mszeredi%40redhat.com

Or here it is inline:

commit 1580a2f8ad3f103a20b6280aa39a01f8b0be2d3f
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: add support for opening dax device as backing

Add FUSE_BACKING_IS_DEV flag that allows opening a character device
(dax device) as a backing, in addition to regular files. Mark the
inode with S_DAX if FUSE_LOOKUP returns with FUSE_ATTR_DAX set.

> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 58dbdd17c1ef4..aa558a0c2e647 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
[ ... ]
> @@ -22,9 +23,16 @@ static void fuse_backing_free(struct fuse_backing *fb)
>  {
>   pr_debug("%s: fb=0x%p\n", __func__, fb);
>
> - if (fb->file)
> - fput(fb->file);
> - put_cred(fb->cred);
> + switch (fb->type) {
> + case FUSE_BACKING_PATH:
> + path_put(&fb->path);
> + put_cred(fb->cred);
> + break;
> +
> + case FUSE_BACKING_DAXDEV:
> + fs_put_dax(fb->dax_dev, fb);
> + break;
> + }
>   kfree_rcu(fb, rcu);

Does this code introduce a use-after-free race with a concurrent hardware
memory failure?

When a DAX-backed FUSE backing file is closed, fuse_backing_free() drops the
DAX device holder by calling fs_put_dax() and frees the backing object using
normal RCU via kfree_rcu().

Concurrently, a hardware memory failure can trigger dax_holder_notify_failure(),
which protects its read-side critical section with SRCU using dax_read_lock().

If dax_holder_notify_failure() reads dax_dev->holder_ops and checks for NULL,
and is preempted here, fs_put_dax() can run to completion. This would set
dax_dev->holder_ops and dax_dev->holder_data to NULL, and eventually free fb
after a normal RCU grace period.

Because kfree_rcu() does not wait for SRCU readers, the memory could be freed
while dax_holder_notify_failure() is still running.

[ ... ]
> @@ -79,23 +87,88 @@ static struct fuse_backing *fuse_backing_id_remove(struct fuse_conn *fc, u64 id,
>   return fb;
>  }
>
> +static int fuse_dax_notify_failure(struct dax_device *daxdev, u64 offset, u64 len, int mf_flags)
> +{
> + struct fuse_backing *fb = dax_holder(daxdev);
> +
> + fb->dax_error = true;

Can this code cause a NULL pointer dereference or use-after-free when racing
with fuse_backing_free()?

When dax_holder_notify_failure() resumes after the race described in
fuse_backing_free(), it blindly calls ops->notify_failure() which is this
function.

Because fs_put_dax() may have already cleared dax_dev->holder_data,
dax_holder() might return NULL causing a NULL pointer dereference here.
Depending on the timing, it could also return a stale pointer to the freed
fb object, resulting in a use-after-free.

> +
> + return 0;
> +}
