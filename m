Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Oct 2008 13:45:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m92Kj1RE001235
	for <xfs@oss.sgi.com>; Thu, 2 Oct 2008 13:45:01 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3454F1095CAE
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2008 13:46:38 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id c67TBXZobMJc9MJy for <xfs@oss.sgi.com>; Thu, 02 Oct 2008 13:46:38 -0700 (PDT)
Message-ID: <48E53314.5010609@sandeen.net>
Date: Thu, 02 Oct 2008 15:46:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Regression Issue in kernel 2.6.26.3
References: <48E51BF5.3080100@g-b.net>
In-Reply-To: <48E51BF5.3080100@g-b.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: albert.graham@g-b.net
Cc: xfs@oss.sgi.com

Albert Graham wrote:
> Hi Guys,
> 
> I use Fedora 8 as my MythTV backend server which uses XFS, ISince upgrading from kernel-2.6.25 to kernel-2.6.26 I've 
> been getting the following errors (see below).
> 
> This occurs on very light load (e.g. rsync from a remove server - via the internet), the only option is to reboot the 
> server as the messages are constantly recursive once it starts.
> 
> Now, I know my kernel it tainted with the NVIDIA driver and this is not a problem with any previous kernel.
> 
> Please let me know if there is anything I can do to assist diagnosing this issue.
> 
> Albert.
> 
> 
>   =======================
> XFS internal error XFS_WANT_CORRUPTED_RETURN at line 280 of file fs/xfs/xfs_alloc.c.  Caller 0xf88e0018
> Pid: 8025, comm: rsync Tainted: P          2.6.26.3-14.fc8PAE #1
>   [<f8900a41>] xfs_error_report+0x2c/0x2e [xfs]
>   [<f88de86c>] xfs_alloc_fixup_trees+0x264/0x273 [xfs]
>   [<f88e0018>] ? xfs_alloc_ag_vextent_near+0x6e4/0x82b [xfs]

Do you know if the filesystem shows any corruption?

Try xfs_repair -n to see; if it is, getting an xfs_metadump prior to
repairing may help a post-mortem.

-Eric
