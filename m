Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9OEEdO8081374 for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 09:14:39 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A73A81F26754
	for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 07:14:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TXUn100gy7Km23IG for
	<xfs@oss.sgi.com>; Mon, 24 Oct 2011 07:14:37 -0700 (PDT)
Date: Mon, 24 Oct 2011 12:13:19 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfs_symlink problem? 3.1 after rc10
Message-ID: <20111024141319.GB4441@andromeda.usersys.redhat.com>
References: <201110241148.39772.arekm@maven.pl>
	<20111024122729.GA4441@andromeda.usersys.redhat.com>
	<201110241540.01268.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201110241540.01268.arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

> It happened again:
> 
> http://ixion.pld-linux.org/~arekm/100_5434.JPG
> http://ixion.pld-linux.org/~arekm/100_5433.JPG
> 
> The weird thing is that I never ever hit this before with pre 3.1rc10 git 
> kernels. Was your bugfix a fix for new issue that was introduced in 3.1 cycle 
> or for something old?
> 
Hmm, sorry, my mistake here, I fixed a problem on xfs_readlink, not at xfs_symlink.

Although, by your last screenshots, it doesn't look to be related with the problem
I was working before.

On all screenshots the system is crashing while trying to acquire a mutex lock, I don't
know much about the code path where the crash is happening, but, maybe if you enable
CONFIG_XFS_DEBUG we can get some extra hints about where the system is crashing? Also,
have you fsck'ed this FS? maybe an `xfs_repair -nv` would give any clue if there is any
corrupted metadata which would cause this error


-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
