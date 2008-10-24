Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 17:12:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O0CHk1023685
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 17:12:17 -0700
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFE1B1B15AC8
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 17:14:03 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id ZbNEcreHNJcIWzrd for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 17:14:03 -0700 (PDT)
Message-ID: <4901133B.6010404@tlinx.org>
Date: Thu, 23 Oct 2008 17:13:47 -0700
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Solved: Re: 2.6.27.[0,2] problems (v. 2.6.26.5): Samba & root-read-only
References: <48FED90F.7030809@tlinx.org> <20081022223005.GV18495@disturbed>
In-Reply-To: <20081022223005.GV18495@disturbed>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Cc: david@fromorbit.com

*Double Bingo*...2.6.27.3 fixed both probs!      Thanks!!

Dave Chinner wrote:
> On Wed, Oct 22, 2008 at 12:41:03AM -0700, Linda Walsh wrote:
>
> Going to 2.6.27 (and just trying 2.6.27.2), two VERY weird problems.
>   1) Samba boot using the 2.6.27.2 kernel (or .0 before), I can no 
>      longer mount any file systems from my windows client. 
>   2) My root disk comes up READ-ONLY.  It uses XFS.
> ------
> That XFS problem should be fixed in 2.6.27.3,
>
> Most likely is that the Samba problem will be caused by the smbd
> not being able to write to it's databases when clients try
> to connect because of the read-only root fs.
>
> Dave.
>   
