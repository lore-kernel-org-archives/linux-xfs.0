Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TA4sR6037635 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 05:04:54 -0500
Received: from mail-yx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7B4D11F9249
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 03:05:12 -0700 (PDT)
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	r6eMRDkeQya9ElgA for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2011 03:05:12 -0700 (PDT)
Received: by yxi13 with SMTP id 13so2688196yxi.26
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 03:04:51 -0700 (PDT)
Message-ID: <4E328457.2000401@gmail.com>
Date: Fri, 29 Jul 2011 11:58:47 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
In-Reply-To: <1309275199-10801-1-git-send-email-josef@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Sorry maybe I'm a bit late? :)

Il 28/06/2011 17:33, Josef Bacik ha scritto:
>
>   loff_t default_llseek(struct file *file, loff_t offset, int origin)
>   {
> +	struct inode *inode = file->f_path.dentry->d_inode;
>   	loff_t retval;
>
> -	mutex_lock(&file->f_dentry->d_inode->i_mutex);
> +	mutex_lock(&inode->i_mutex);
>   	switch (origin) {
>   		case SEEK_END:
> -			offset += i_size_read(file->f_path.dentry->d_inode);
> +			offset += i_size_read(inode);

Here we are under mutex, so I think we can use directly i_size without 
i_size_read.

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
