Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Nov 2008 05:57:27 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA6DvEQk013882
	for <xfs@oss.sgi.com>; Thu, 6 Nov 2008 05:57:14 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F367B58D82D
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2008 05:57:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id e3EpVrQ4LCDKiP1H for <xfs@oss.sgi.com>; Thu, 06 Nov 2008 05:57:17 -0800 (PST)
Message-ID: <4912F7BC.40501@sandeen.net>
Date: Thu, 06 Nov 2008 07:57:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: TAKE 052 - keep Eric happy :-)
References: <20081106055342.4C19958AE1F3@chook.melbourne.sgi.com>
In-Reply-To: <20081106055342.4C19958AE1F3@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

Tim Shimmin wrote:

heh... 'cause if Eric ain't happy, ain't NOBODY happy!

Thanks Tim,

-Eric

> Long devicenames cause this quota output to split onto 2 lines:
> 
> # xfs_quota -c "quota -gpu -birnN 99" /mnt/scratch
> /dev/mapper/testvol-test2
>                            880       1004       1004   00 [--------]           1         10         10   00 [--------]           0          0          0   00 [--------] /mnt/scratch
> 
> but if we make that "\n" go away, the test still passes.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> 
> Date:  Thu Nov  6 16:52:39 EST 2008
> Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
> Inspected by:  sandeen@sandeen.net
> 
> The following file(s) were checked into:
>   longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb
> 
> 
> Modid:  master-melb:xfs-cmds:32444a
> xfstests/052 - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/> xfstests/052.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/052.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
> 	- Long devicenames cause this quota output to split onto 2 lines:
> 	  # xfs_quota -c "quota -gpu -birnN 99" /mnt/scratch
> 	  /dev/mapper/testvol-test2
> 	  880       1004       1004   00 [--------]           1         10         10   00 [--------]           0          0          0   00 [--------] /mnt/scratch
> 	  but if we make that "\n" go away, the test still passes.
> 	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> 
> 
