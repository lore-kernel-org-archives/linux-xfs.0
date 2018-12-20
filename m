Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728106AbeLTIUX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Dec 2018 03:20:23 -0500
Date: Thu, 20 Dec 2018 09:20:21 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] quota: Lock s_umount in exclusive mode for
 Q_XQUOTA{ON,OFF} quotactls.
Message-ID: <20181220082021.GA27845@quack2.suse.cz>
References: <1ad62e88-7784-6de8-c03d-01295375e315@gmail.com>
 <20181214095613.GD8896@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181214095613.GD8896@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Javier Barrio <javier.barrio.mart@gmail.com>
Cc: Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri 14-12-18 10:56:13, Jan Kara wrote:
> On Thu 13-12-18 01:06:29, Javier Barrio wrote:
> > Commit 1fa5efe3622db58cb8c7b9a50665e9eb9a6c7e97 (ext4: Use generic
> > helpers for quotaon and quotaoff) made possible to call
> > quotactl(Q_XQUOTAON/OFF) on ext4 filesystems with sysfile quota support.
> > This leads to calling dquot_enable/disable without s_umount held in excl.
> > mode, because quotactl_cmd_onoff checks only for Q_QUOTAON/OFF.
> > 
> > The following WARN_ON_ONCE triggers (in this case for dquot_enable, ext4,
> > latest Linus' tree):
> > 
> > [  155.036847] WARNING: CPU: 0 PID: 2343 at fs/quota/dquot.c:2469 dquot_enable+0x34/0xb9
> 
> ...
> 
> > This patch locks the superblock ->s_umount sem. in exclusive mode for all Q_XQUOTAON/OFF
> > quotactls too in addition to Q_QUOTAON/OFF.
> 
> Thanks for the patch! It looks good to me but let me run it past XFS
> people. Looking at XFS code they definitely do not *need* s_umount in
> exclusive mode for Q_XQUOTAON/OFF (they have their private mutex for
> the exclusion). Shared mode they currently get is enough for them. But
> exclusive mode is fine for them as well AFAICT and it would be easier if
> all quota backends had the same locking rules wrt VFS locks. XFS guys, any
> objections to switching Q_XQUOTAON/OFF handlers from having s_umount locked
> for read to having it locked exclusive?

Since there were no objections and the patch passed quota xfstests for XFS,
I've added it to my tree and will push it to Linus in the coming merge
window.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
