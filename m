Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 20:56:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4K3uX9f017376
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 20:56:33 -0700
Received: from sca-es-mail-1.sun.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FA25B9EB5A
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 20:57:22 -0700 (PDT)
Received: from sca-es-mail-1.sun.com (sca-es-mail-1.Sun.COM [192.18.43.132]) by cuda.sgi.com with ESMTP id Gy9rvEUVtBnkMgSC for <xfs@oss.sgi.com>; Mon, 19 May 2008 20:57:22 -0700 (PDT)
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m4K3vLGb005690
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 20:57:22 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1500901EW6PY00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for xfs@oss.sgi.com; Mon, 19 May 2008 20:57:21 -0700 (PDT)
Date: Mon, 19 May 2008 21:57:12 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
In-reply-to: <20080514170625t-sato@mail.jp.nec.com>
Message-id: <20080520035712.GA7252@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <20080514170625t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On May 14, 2008  17:06 +0900, Takashi Sato wrote:
> +static int ioctl_freeze(struct file *filp)
> +{
> +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* If filesystem doesn't support freeze feature, return. */
> +	if (sb->s_op->write_super_lockfs == NULL)
> +		return -EINVAL;

Should this be EINVAL, or EOPNOTSUPP?  Usually EINVAL means there is
something wrong with the passed ioctl parameters (e.g. bad value),
while EOPNOTSUPP is "operation not supported" and makes more sense.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
