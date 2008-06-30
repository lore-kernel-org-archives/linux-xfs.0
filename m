Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jun 2008 06:53:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5UDrneO030290
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 06:53:49 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E00D72D1F0
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 06:54:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id gDsNf2XSXZWfv0dr for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 06:54:51 -0700 (PDT)
Date: Mon, 30 Jun 2008 14:54:33 +0100
From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] freeze feature ver 1.8
Message-ID: <20080630135433.GA22522@agk.fab.redhat.com>
References: <20080630212005t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630212005t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Mon, Jun 30, 2008 at 09:20:05PM +0900, Takashi Sato wrote:
> Currently, ext3 in mainline Linux doesn't have the freeze feature which
> suspends write requests.  So, we cannot take a backup which keeps
> the filesystem's consistency with the storage device's features
> (snapshot and replication) while it is mounted.
> In many case, a commercial filesystem (e.g. VxFS) has
> the freeze feature and it would be used to get the consistent backup.
> If Linux's standard filesytem ext3 has the freeze feature, we can do it
> without a commercial filesystem.
 
Is the following a fair summary?

1. Some filesystems have a freeze/thaw feature.  XFS exports this to
userspace directly through a couple of ioctls, but other filesystems
don't.  For filesystems on device-mapper block devices it is exported to
userspace through the DM_DEV_SUSPEND ioctl which LVM uses.

2. There is a desire to access this feature from userspace on non-XFS
filesystems without having to use device-mapper/LVM.

Alasdair
-- 
agk@redhat.com
