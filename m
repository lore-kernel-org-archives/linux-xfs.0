Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87DFC433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 15:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 858326144B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 15:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhD3PPO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 11:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231131AbhD3PPO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Apr 2021 11:15:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 867B76143D;
        Fri, 30 Apr 2021 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619795665;
        bh=Th8+izcyyIqW4HLl8oxLZmJ3v7j47te5i1UnvNIF0v8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BJYoJTX5GkjpWfpYPrOReb6faCNm3dH6GpI7+RHT62hfN9Yzr4HkrFu9r2WB5wkqL
         x3vUAdax5Ft+6p6qarZVnjLCQWP2u3yh3Frmdi66zfqdP7uMQp7HVzhgXmnLZfGezm
         22MFkwcViroyWa2ciot0Df8WQ9NwQX2EiTV7EJgataxZW+/eyD/DIhwxT4DBLt+htZ
         RIvhgB3N+F7tgfTjaz9OOX05+IDI8gfkj60U0sIDhzHxZdCFl+ldiGzrh5dhtE1Xo1
         1lHYDDqXtMyRJjcuCPezgYxGrftOIM5vZjlMUUAe0+e8WheRogi5QN1HjiiQWy4QlO
         C9qd5NihaUm8Q==
Date:   Fri, 30 Apr 2021 08:14:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't allow log writes if the data device is
 readonly
Message-ID: <20210430151424.GP3122264@magnolia>
References: <20210430004012.GO3122264@magnolia>
 <YIwHAGXOZSO+DnBw@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIwHAGXOZSO+DnBw@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 30, 2021 at 09:32:48AM -0400, Brian Foster wrote:
> On Thu, Apr 29, 2021 at 05:40:12PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While running generic/050 with an external log, I observed this warning
> > in dmesg:
> > 
> > Trying to write to read-only block-device sda4 (partno 4)
> > WARNING: CPU: 2 PID: 215677 at block/blk-core.c:704 submit_bio_checks+0x256/0x510
> > Call Trace:
> >  submit_bio_noacct+0x2c/0x430
> >  _xfs_buf_ioapply+0x283/0x3c0 [xfs]
> >  __xfs_buf_submit+0x6a/0x210 [xfs]
> >  xfs_buf_delwri_submit_buffers+0xf8/0x270 [xfs]
> >  xfsaild+0x2db/0xc50 [xfs]
> >  kthread+0x14b/0x170
> > 
> > I think this happened because we tried to cover the log after a readonly
> > mount, and the AIL tried to write the primary superblock to the data
> > device.  The test marks the data device readonly, but it doesn't do the
> > same to the external log device.  Therefore, XFS thinks that the log is
> > writable, even though AIL writes whine to dmesg because the data device
> > is read only.
> > 
> > Fix this by amending xfs_log_writable to prevent writes when the AIL
> > can't possible write anything into the filesystem.
> > 
> > Note: As for the external log or the rt devices being readonly--
> > xfs_blkdev_get will complain about that if we aren't doing a norecovery
> > mount.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_log.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 06041834daa3..e4839f22ec07 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -358,12 +358,14 @@ xfs_log_writable(
> >  	 * Never write to the log on norecovery mounts, if the block device is
> >  	 * read-only, or if the filesystem is shutdown. Read-only mounts still
> >  	 * allow internal writes for log recovery and unmount purposes, so don't
> > -	 * restrict that case here.
> > +	 * restrict that case here unless the data device is also readonly.
> >  	 */
> 
> The comment update is a little confusing because that second sentence
> explicitly refers to the read-only mount case (i.e., why we don't check
> XFS_MOUNT_RDONLY here), and that logic/reasoning remains independent of
> this change. Perhaps instead change the first part to something like
> "... if the data or log device is read-only, ..." ?

Will do.  Thanks for the review!

--D

> With that fixed up:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
> >  		return false;
> >  	if (xfs_readonly_buftarg(mp->m_log->l_targ))
> >  		return false;
> > +	if (xfs_readonly_buftarg(mp->m_ddev_targp))
> > +		return false;
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> >  		return false;
> >  	return true;
> > 
> 
