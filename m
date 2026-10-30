Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329145;
	b=2klpSdm6WW8MR3X+auas8q0UXUYNbhiE+7pMTPwmLvliku7LEhsZVwWOlKLPI90xKg+t
	 G0w7ULw92YX8h0i1ZY/jh6ezA7y0d6qr5SESR9V0t/eWyl3sYExiyPQByJxFWjCDyZH6x
	 ny4rTVYnguHG6Vc5XNOCaRBYEXilAA6xuCf9OqRzEs8QZbgno/ajaawLDfEgNHlbE41LS
	 ZNE4syjA/Kjq8d6045tSuQqWwQoCGGn5SGYCW5mbGBfGOLRYDo2h2Id+n9IgBqBXjfKH6
	 TPIzMzxX08bQJnjMjzKUUGCOQCTs8Wjo5MHs0J/5KEaxJ3fi+BfUMTgvu+k2ze27nfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329145;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=w/Jd2p/prMhPtETNelJfTcFSgzTHlHRnVEoen9y0JaA=;
	b=bz2qlnfc+5uTpVMWPfZn1lfZ8Jxco1CEimIMtzhDwkcE9ByZGySPbCwzTwprQYkJ1oYT
	 gBF1gXQJ9ORnt6xgBHdUU0rO6NR/hXcNeuC6SRAJZZ6ENxvvukguy/Rll7lNtXqcVlRDv
	 LD38MTWoTq9gokd8w3WzGRY4OL0Cu3TSTbJYg2pMI3B8og+xLZydHxux8wPYWrS37fIpi
	 LA+cl6PDOsWO2FmPE+8VeHtbF9r+gd+TPOgK3uG0bvG7zDZSXuyZcc+pcya+ic5W86VT+
	 6dFJe59v/o6vejyy5yEBjgU8qu6zYCUIhxZrh6eP5aABwbDeWiFGdiuwKIUiPwjSayQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hSHEsgsY;
	arc=none smtp.remote-ip=115.124.30.119
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926C9606A31C;
	Fri, 30 Oct 2026 02:59:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 926C9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hSHEsgsY
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793329134; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=w/Jd2p/prMhPtETNelJfTcFSgzTHlHRnVEoen9y0JaA=;
	b=hSHEsgsYOl/knZoiaKmOo9/szTsdb243LBtAHNpX/8InfeQ+O8kqyPkUuu0Awv2qPGL1dtHu80lxiinShoX3C//q9xO3uJS7nJ9pA7n/Uvoqx9PjlbXVT4MQjJDtbupw0uuaN9Pd4ZUnz3XFWW920V7V0LBApZUCRivWHHA722Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XDkufcn_1793329132;
Received: from 30.221.129.214(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDkufcn_1793329132 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Oct 2026 10:58:53 +0800
Message-ID: <0a8576a4-e397-4a49-ab0e-8f0f32bf2642@linux.alibaba.com>
Date: Fri, 30 Oct 2026 10:58:52 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/34] ocfs2: keep the current mount options on remount
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org,
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/30/26 12:07 AM, Christian Brauner wrote:
> ocfs2_init_fs_context() doesn't inherit the current mount options for a
> reconfigure. But ocfs2_check_set_options() insists on exactly one
> heartbeat mode and ocfs2_reconfigure() refuses to change the data mode.
> So every remount without heartbeat= fails with EINVAL, including
> emergency remount (sysrq u) which passes no options at all, and that
> WARNs for every ocfs2 mounted read-write. A remount that does pass
> heartbeat= silently resets every option it doesn't repeat, e.g. noacl,
> errors=, barrier= and preferred_slot=.
> 
> So start a reconfigure from the current options like exfat and gfs2 do.
> Asking for a different data or heartbeat mode still fails with EINVAL.
> 
> The next patch stops ocfs2 from setting SB_RDONLY after errors. An
> errored ocfs2 then stays read-write and emergency remount would run into
> this as well.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/ocfs2/super.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 0af2245ae303..67283244426e 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1222,6 +1222,19 @@ static int ocfs2_init_fs_context(struct fs_context *fc)
>  	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
>  	mopt->dir_resv_level = -1;
>  
> +	/*
> +	 * Start from the current options so a remount only changes what it
> +	 * specifies, emergency remount passes none at all.
> +	 */
> +	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
> +		struct ocfs2_super *osb = OCFS2_SB(fc->root->d_sb);
> +
> +		mopt->mount_opt = osb->s_mount_opt;
> +		mopt->atime_quantum = osb->s_atime_quantum;
> +		mopt->slot = osb->preferred_slot;
> +		mopt->user_stack = ocfs2_userspace_stack(osb);
> +	}

ocfs2_reconfigure() decides the transition from fc->sb_flags alone without
sb_flags_mask test, unlike reconfigure_super(). And fspick() passes
fs_context_for_reconfigure(target.dentry, 0, 0). So on a read-only mount:

  fspick(AT_FDCWD, "/mnt", 0)        sb_flags 0, sb_flags_mask 0
  fsconfig(fd, FSCONFIG_SET_STRING, "atime_quantum", "30", 0)
  fsconfig(fd, FSCONFIG_CMD_RECONFIGURE)
    reconfigure_super()
      ocfs2_reconfigure()
        (bool)(0 & SB_RDONLY) != sb_rdonly(sb)  -> 0 != 1, enters
        fc->sb_flags & SB_RDONLY                -> 0, takes the rw branch
        sb->s_flags &= ~SB_RDONLY
        osb->osb_flags &= ~OCFS2_OSB_SOFT_RO
        ocfs2_enable_quotas(osb)                -> writes the quota files

The final WRITE_ONCE(sb->s_flags, ...) in reconfigure_super() then
leaves it cleared, because SB_RDONLY is not in sb_flags_mask. The same
falls out of a legacy remount whose flags omit MS_RDONLY.

So it seems we should test sb_flags_mask as well?

Thanks,
Joseph

> +
>  	fc->fs_private = mopt;
>  	fc->ops = &ocfs2_context_ops;
>  
> 

