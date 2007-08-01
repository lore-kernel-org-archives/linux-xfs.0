Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Aug 2007 05:23:34 -0700 (PDT)
Received: from isp.becroft.co.nz (isp.becroft.co.nz [202.89.33.33])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l71CNTbm028796
	for <linux-xfs@oss.sgi.com>; Wed, 1 Aug 2007 05:23:30 -0700
Subject: Re: Proper method of snapshotting XFS with external log using LVM2
From: Mario Becroft <mb@gem.win.co.nz>
In-Reply-To: <20070801121713.GY31489@sgi.com>
References: <1185737538.12064.44.camel@server.ak.quickcircuit.co.nz>
	 <20070801121713.GY31489@sgi.com>
Content-Type: text/plain
Date: Thu, 02 Aug 2007 00:23:29 +1200
Message-Id: <1185971009.13401.146.camel@server.ak.quickcircuit.co.nz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-xfs@oss.sgi.com

Hi David,

Thanks very much for your clear explanation of how to snapshot XFS
filesystems with external log. It is good to know that I am doing it
right.

I found that in the latest Linux kernel version 2.6.22.1, you cannot use
the method I have been using, and which you confirmed is ok. The problem
is that if you xfs_freeze the filesystem, then the LVM snapshot command
hangs forever. (Back in kernel version 2.6.16 this did not happen.) I
guess the snapshot command is also attempting to freeze the filesystem,
or something, which doesn't work when it is already frozen. I suppose
how to fix this is a question for the linux-lvm mailing list.

Thanks again for your detailed answer.

-- 
Mario Becroft <mb@gem.win.co.nz>
