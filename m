Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Mar 2008 19:02:52 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2432Tq1002004
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2008 19:02:31 -0800
Received: from nf-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AD3A648470
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2008 19:02:58 -0800 (PST)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.191]) by cuda.sgi.com with ESMTP id 035xufRQN95Wuot2 for <xfs@oss.sgi.com>; Mon, 03 Mar 2008 19:02:58 -0800 (PST)
Received: by nf-out-0910.google.com with SMTP id e27so313040nfd.42
        for <xfs@oss.sgi.com>; Mon, 03 Mar 2008 19:02:57 -0800 (PST)
Message-ID: <e03b90ae0803031856s42ddf82dudb7fa9d84a637498@mail.gmail.com>
Date: Mon, 3 Mar 2008 18:56:46 -0800
From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: disappearing xfs partition
In-Reply-To: <e03b90ae0803031407n6693d1b3k268d8858504a9ce9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e03b90ae0803030514v585249ecjf93af325287b59f@mail.gmail.com>
	 <47CC3444.4070902@sandeen.net>
	 <e03b90ae0803031040i21e928f3ua75791921791705e@mail.gmail.com>
	 <47CC56CC.4020504@sandeen.net>
	 <e03b90ae0803031407n6693d1b3k268d8858504a9ce9@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Jeff Marshall <marshman@frozenbear.com>, xfs@oss.sgi.com

Following up and close out the topic, I got this comment from Eric.

>So parted has this bad habit of making partition tables that cannot
>actually be read from the disk, and poking the supposedly values
>directly into the kernel.  Then things work fine until reboot, at which
>time the partition table cannot be properly read.   Usually this turns
>into a truncated size due to an overflow....

I'd been using cfdisk and not parted, but that's apparently what
happened. Rewriting the partition table with cfdisk fixed everything
and allowed the partition to mount. At least for this boot.

Thanks all.
