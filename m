Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 02:11:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m619Be0W010394
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 02:11:41 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0611FD7F2B7
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 02:12:42 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id 5Cl7B57YTwXbvMY0 for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 02:12:42 -0700 (PDT)
Message-Id: <6B16FAEFB450496A9AA95BFF27BD6AE6@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080630212005t-sato@mail.jp.nec.com> <20080630135433.GA22522@agk.fab.redhat.com>
In-Reply-To: <20080630135433.GA22522@agk.fab.redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] freeze feature ver 1.8
Date: Tue, 1 Jul 2008 18:12:32 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alasdair G Kergon <agk@redhat.com>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Hi,

Alasdair G Kergon wrote:
>> Currently, ext3 in mainline Linux doesn't have the freeze feature which
>> suspends write requests.  So, we cannot take a backup which keeps
>> the filesystem's consistency with the storage device's features
>> (snapshot and replication) while it is mounted.
>> In many case, a commercial filesystem (e.g. VxFS) has
>> the freeze feature and it would be used to get the consistent backup.
>> If Linux's standard filesytem ext3 has the freeze feature, we can do it
>> without a commercial filesystem.
>
> Is the following a fair summary?

Yes, you are right.
We'd like to use the freeze feature without device-mapper/LVM.

> 1. Some filesystems have a freeze/thaw feature.  XFS exports this to
> userspace directly through a couple of ioctls, but other filesystems
> don't.  For filesystems on device-mapper block devices it is exported to
> userspace through the DM_DEV_SUSPEND ioctl which LVM uses.
>
> 2. There is a desire to access this feature from userspace on non-XFS
> filesystems without having to use device-mapper/LVM.
>
> Alasdair

Cheers, Takashi 
