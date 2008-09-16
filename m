Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 22:55:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G5sxcK006682
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:54:59 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C56E445C91
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:56:30 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id wKknpetDQYGcCAd2 for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:56:30 -0700 (PDT)
Date: Tue, 16 Sep 2008 15:56:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: read only remount not so happy
Message-ID: <20080916055614.GX5811@disturbed>
References: <e03b90ae0809141904r47de6883k185174bb13df34b4@mail.gmail.com> <e03b90ae0809152103w5653bdbfrc1f060d9e41e7246@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e03b90ae0809152103w5653bdbfrc1f060d9e41e7246@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Breidenbach <jeff@jab.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 15, 2008 at 09:03:41PM -0700, Jeff Breidenbach wrote:
> This is starting to go downhill. Everything is still running, but some
> processes that interact with the filesystem actions are performing
> slowly.
> 
> ===
> 
> 
> [9608310.848311] Assertion failed: atomic_read(&mp->m_active_trans) ==
> 0, file: /build/buildd/linux-2.6.24/fs/xfs/xfs_vfsops.c, line: 708

Known problem. Race in the VFS code - fix is due in 2.6.28, I think.
Details can be found by googling the error message.  Reboot the system.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
