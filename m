Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D86741442D
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 04:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791952843; cv=none; b=SI5TYjwiopGMwPyTpHdbljbf5zWaRfb+708XJ10uLy8ner16ckJK5rZC1i4nvYl5gsFQQBg6+1j+sSby9Iv7fOky0JV8MqYThJsbEus7TvbVCj9uzSnC05xwKWX778oZoNmvCfRcMcZYNgnurK7dfGJwz+KLEaJz/Adx55fAPtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791952843; c=relaxed/simple;
	bh=n0Hs5KVddvSkBLEzXlL+zhClUBSiGyvm5QaOrNgUFDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OcvL5qRDbeK32OLQXO1NTYZ7ExS7eLQXiK9cGDm3ietISlRbK0rkJVcHgxJW8sFAIuYMIepREdiUucaAkZ+fc9TN/imd26rDB4gKi9eVq+3W6fS3HlzK15JRkBm/VtWWCWrp+g/hy98F2+sG1tAI35QekM5bbL0ceE5+5BfUt5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tyhicks.com; spf=pass smtp.mailfrom=tyhicks.com; dkim=pass (2048-bit key) header.d=tyhicks.com header.i=@tyhicks.com header.b=ncQOfXsY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=K0VjHOtO; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tyhicks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tyhicks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tyhicks.com header.i=@tyhicks.com header.b="ncQOfXsY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="K0VjHOtO"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id AB2C87A00E4
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 00:40:40 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 14 Oct 2026 00:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1791952838; x=1792039238; bh=mAFiYhtbFe
	mwvvnCWTEeExr0pkWB7IZg7tNJUrlWDeo=; b=ncQOfXsYux6xUE5Yfpf1YgaBFT
	cTHfw7QjzH5wusg7wxu/N7/hm73X28PpKquXZc5xiYwPW4+lAfqJxibqXR+UvLz+
	2ZTUnxRz7HtcfNGFgS1MJkd0Tuv5h/GpjcWCaiSGJ1TZ1UdFlpedEaseFuzvowv/
	TqQSSl8IG9OCVkOhNBJP95SN5RDQQl8GiR1aqF1Dp02uVWnRjvaljmZODDWOuAYc
	RQbBArRhfe9jWPm3Oy560onwObhrAOQw70BBPuWWCXlWiSD0St3KNWW1JAL9kmbP
	bNzF5pEbPDujqawxsBVKwUfbzwYVRc65jY+AqtX1732BeF90Rc9hAafKJ/NA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791952838; x=1792039238; bh=mAFiYhtbFemwvvnCWTEeExr0pkWB7IZg7tN
	JUrlWDeo=; b=K0VjHOtOjP8x4OK/qLK5hjnzj3UEK+pOwByQK/diLCthYYtuRak
	4w+UCUKGCK7JFq5rpq992TQ414sGpeXwoQll/jApp5jSvjv1N0AQ/vV6o8TAQSoj
	0jIdCgbmVEwbpWc/GDIYhV7iGxhVnAVGyxOucONqfd+Qut3pa8xlZu9eupkPHb7a
	O19RfpWHCKap1Ii2AG4C4Rgf9FKDqPAESBzjmyuI8I+/7v/rcZf87XvPdXRhxOVR
	PHI64FJJSdJiopZc5fM/F+oblU4aUcPwF93Yc0oXuLowDYOwPy7A3lW/OBTdMI+P
	X7xVR3mFNXlN4nZtsbMmUuaI/XZPAGqxlHA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=tyhicks.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791952838; d=tyhicks.com;
	mf=PGNvZGVAdHloaWNrcy5jb20+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm1:rsa-sha256:gy7Tn5byw2w65b2xn1XhU0XN7jUwqLutu0bwZarJxI2JNnA
	0NmTEYgFI8sVOkAcE9FUHi8F///r+aAEVfu9C1cUYnuXS5bg7AiIORtnaAdjArXT
	CbqEC4p6KUWBEmcoQJs7A2GelFopNi9VyL8uGj4JaypfoPxBqUoyQtomNy9O+W6i
	0l13ULIZ3jGufGsoNpxlwippHfa7IHVPKwjQb0Q3njklKFtxlSyUcnbsUz2z9rUs
	IWxKR7tLvnmnvLY+fi4IOiTAu60J2qUeRlUyzhwbWRlJmBeJhmRTa9l4CosKYGLi
	ADG7MvDQ5mbVBWx9OS6Z7igAkeOpIYHrMfna9HQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:qUmERcW4JyBitZMe5zuk9ywp5LRlIgLiVnlpfK0/pBM=:n0Hs5KVddvSkBLEzXlL+zhClUBSiGyvm5QaOrNgUFDY=;
X-ME-Sender: <xms:xgfPaiirqaGth-_QIS8OAsoYy7Sf2rYbZwFhAfjJ0MuAWKxQ7THxuQ>
    <xme:xgfPajaE8ofnGot4Pky4vdm_HNaxz3sV7tnqENiHW1NZcFJGvD6DD5wX-ruqy_MSt
    qzisuah0SMwdW1miO5q3pRD4Y4a5JhX9iIk39cqEEXme_YFFqwv3Rg>
X-ME-Received: <xmr:xgfParPcjPkYn4vlK0LMTgxNr5Ysji4BSj-bUDmcojpTmB7UhXNDHw>
X-ME-Proxy-Cause: dmFkZTFKd7b9t+rYxj8fdFEGtNMVuNQ5jOwC8SdIlUTY97d1oNKv/jurn5DUraLtoIX+2E
    I3bIdfkpsGhUi+/tt/Szji6YvW2+vzMoDGWv9xPK+lO1Sb1zC3bVSP3NLZ3IFInykWKEaP
    PH93NfwO6+b7/crRfH4wX5WXalVIiTPCeErxbBQz6CcsOBGB7Z36o5CAXL7bOQ0KwYB3u2
    Tt7S2s6M3ONy1Jf6lLNDRHUve8aF4/8yXcvszXWYbXHvQvvmoncKrISq6v28AJ11qBn/sv
    qp0QBdjQ9qmGRZKU7BnZTWgAAxoRXCyTV5hWG4Si3B29+0DMJIgEbol0t/XKYLu9NNjraX
    0smkOXWfrc/IBFYy/pyNxGx9kfhI0WiCxuDyZdzXI9f2NIYsJkUDkDUeJG4zUPuBWtaBvE
    Mwi2vLMuBjIiVqP446bbIM7nhubKyyD0dXHP2HMFxaXSbWZp3G1UIOBjW6FPA7HQKr1TcP
    BPwGPZdrFFh4a5r7M1kmZLbWcfqQp/zQcXFYEYi5bg9fYkAJaxBna2FbAXCGRPGb4Oc6Gh
    1r+gceQWpvlFBkLAjH/mFrxDSXQUT5CImV6pag4feAxFZbphAWhHyasICJGejFWDtY2NaB
    BCVdHpJu62iJDBfhFB3EF7k3EeYcm32d9i47bHoDPeSCp+YbyXeBn+EXahFQ
X-ME-Proxy: <xmx:xgfPanR7GBzeumdsdancLyUun9rpWy2_-9xodM1WQNRR_NGP-MwpZg>
    <xmx:xgfPau7MdffZ0A3QPGcRatiLqM8PYL5uRriXSWH_CfIWpuOpVlPScw>
    <xmx:xgfPaia9aS220tTKgJDOpqj2xLlBZI6Y-T6J6zgubPIDKeXL060mVQ>
    <xmx:xgfPaqZKI-8EgzC6LYS3JQGrtcebVT9OxULUA-QFxdCybqbmiymnFA>
    <xmx:xgfPan3Lpy4_ahjI4bwYfGxNbwKEt-4H9IVwxWRAdOc68A38BkASVj37>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 00:40:36 -0400 (EDT)
Date: Tue, 13 Oct 2026 23:40:28 -0500
From: Tyler Hicks <code@tyhicks.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 01/28] ecryptfs: don't leak the inode when a lookup
 can't open the lower file
Message-ID: <as8HvJJq-JP5-UCp@elm>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-1-60743a3dc326@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-1-60743a3dc326@kernel.org>

On 2026-10-12 12:20:46, Christian Brauner wrote:
> ecryptfs_lookup_interpose() opens the lower file of a regular file to
> read the size from the header. If that fails it calls make_bad_inode()
> and returns the error. A new inode is still I_NEW at that point and
> nothing ever unlocks or puts it, so it leaks together with the reference
> it holds on the lower inode. And an inode that was already in the cache
> gets marked bad for all its other users instead of just losing the
> reference this lookup took.
> 
> umount then complains:
> 
>   VFS: Busy inodes after unmount of ecryptfs (ecryptfs)
> 
> That's a WARN, or a BUG with CONFIG_BUG_ON_DATA_CORRUPTION. The lower
> filesystem reports the same when it is unmounted. Use iget_failed() for
> a new inode and iput() for one from the cache.
> 
> Reproducer, opening the lower file read-write fails on a read-only bind
> mount:
> 
>   sig=$(printf x | ecryptfs-add-passphrase - | sed -n 's/.*\[\(.*\)\].*/\1/p')
>   mount --bind -o ro /lower /lower
>   mount -i -t ecryptfs -o ecryptfs_sig=$sig,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough /lower /upper
>   cat /upper/f      # EROFS
>   umount /upper     # VFS: Busy inodes after unmount of ecryptfs
> 
> Fixes: 3b06b3ebf441 ("eCryptfs: Fix new inode race condition")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Thanks, Christian! I ran this through the regression tests in the
ecryptfs-utils project and everything passed. I also followed the steps
in your reproducer, with and without this change, and verified that it
fixes the intended issue.

  Acked-by: Tyler Hicks <code@tyhicks.com>

Tyler

> ---
>  fs/ecryptfs/inode.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 525297c7ebd8..0d8452558a98 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -362,7 +362,10 @@ static struct dentry *ecryptfs_lookup_interpose(struct dentry *dentry,
>  	if (S_ISREG(inode->i_mode)) {
>  		rc = ecryptfs_i_size_read(dentry, inode);
>  		if (rc) {
> -			make_bad_inode(inode);
> +			if (inode_state_read_once(inode) & I_NEW)
> +				iget_failed(inode);
> +			else
> +				iput(inode);
>  			return ERR_PTR(rc);
>  		}
>  	}
> 
> -- 
> 2.53.0
> 
> 
