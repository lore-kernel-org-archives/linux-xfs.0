Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 06:31:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4DDVGle004783
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 06:31:20 -0700
Received: from caffeine.csclub.uwaterloo.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93D6A15DE57
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 06:32:04 -0700 (PDT)
Received: from caffeine.csclub.uwaterloo.ca (caffeine.csclub.uwaterloo.ca [129.97.134.17]) by cuda.sgi.com with ESMTP id 2N1ltZUIZczBp380 for <xfs@oss.sgi.com>; Tue, 13 May 2008 06:32:04 -0700 (PDT)
Date: Tue, 13 May 2008 09:31:58 -0400
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
Message-ID: <20080513133158.GA7579@csclub.uwaterloo.ca>
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48292742.8090409@sgi.com>
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: Georgi Chorbadzhiyski <gf@unixsol.org>, xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, May 13, 2008 at 03:29:38PM +1000, Donald Douwsma wrote:
> Your distro is building all of these modules into the kernel.
> 	CONFIG_XFS_FS=y
> 	CONFIG_JFS_FS=y
> 	CONFIG_GFS2_FS=y
> 
> This isnt exactly standard practice, normally they'd be set to =m and only
> used if required to mount a filesystem. You may want to ask the slackware
> people why they chose to do this for their hugexxx.s kernels.

Because they have always done it that way so it has to be right? :)

-- 
Len Sorensen
