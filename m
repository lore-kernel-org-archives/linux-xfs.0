Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 07:04:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8OE4K8q023821
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 07:04:21 -0700
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86EF8477660
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 07:05:54 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by cuda.sgi.com with ESMTP id rBZsYeBhJCMDL6Pj for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 07:05:54 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8OE5iPX032046
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 10:05:44 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8OE5Yws138202
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 10:05:34 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8OE5Vfv011834
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 10:05:33 -0400
Subject: Re: [PATCH 7/10] jfs: Fix error handling in
	write_super_lockfs/unlockfs
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <20080922195742t-sato@mail.jp.nec.com>
References: <20080922195742t-sato@mail.jp.nec.com>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 09:05:29 -0500
Message-Id: <1222265129.19388.12.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, 2008-09-22 at 19:57 +0900, Takashi Sato wrote:
> I've changed write_super_lockfs/unlockfs so that they always return
> 0 (success) to keep a current behavior.

Address Christoph's concerns, and you can add my ack.  The bits that
change the return code need to be a single patch.

> Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
> Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>


> -static void jfs_write_super_lockfs(struct super_block *sb)
> +static int jfs_write_super_lockfs(struct super_block *sb)
>  {
>  	struct jfs_sb_info *sbi = JFS_SBI(sb);
>  	struct jfs_log *log = sbi->log;
> @@ -553,9 +553,10 @@ static void jfs_write_super_lockfs(struc
>  		lmLogShutdown(log);
>  		updateSuper(sb, FM_CLEAN);
>  	}
> +	return 0;

Alright.  Nothing should fail here, and if it does, we're screwed
anyway.

> -static void jfs_unlockfs(struct super_block *sb)
> +static int jfs_unlockfs(struct super_block *sb)
>  {
>  	struct jfs_sb_info *sbi = JFS_SBI(sb);
>  	struct jfs_log *log = sbi->log;
> @@ -568,6 +569,7 @@ static void jfs_unlockfs(struct super_bl
>  		else
>  			txResume(sb);
>  	}
> +	return 0;

jfs_unlockfs() could return non-zero in the case where lmLogInit()
fails.  I'm not sure what good that does though.  There isn't much the
caller can do when an unfreeze fails.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
