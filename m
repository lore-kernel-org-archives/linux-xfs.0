Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jan 2008 07:50:29 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0OFoN1E021946
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 07:50:25 -0800
Received: from mail161.messagelabs.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B768B5569F7
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 07:50:43 -0800 (PST)
Received: from mail161.messagelabs.com (mail161.messagelabs.com [216.82.253.115]) by cuda.sgi.com with SMTP id tb098A8DjyklIh9f for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 07:50:43 -0800 (PST)
Subject: Re: xfs_rapair memory requirement per TB
From: Rene Salmon <salmr0@bp.com>
In-Reply-To: <op.t5euakap3jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <1201042882.32649.256.camel@holwrs01.bp.com>
	 <op.t5c3kfub3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <20080123085339.GB12435@p15145560.pureserver.info>
	 <20080124002828.GC155259@sgi.com>
	 <op.t5euakap3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jan 2008 09:50:16 -0600
Message-Id: <1201189816.32649.358.camel@holwrs01.bp.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Ralf Gross <Ralf-Lists@ralfgross.de>, xfs@oss.sgi.com





> >> >
> >> > General rule of thumb at the moment is 128MB of RAM/TB of
> filesystem
> >> > plus 4MB/million inodes on that filesystem.
> >>
> >> Did this change lately? I found the rule of thumb: 2 GB RAM for 1
> TB
> >> of disk storage + some RAM per x inodes.
> >
> > The above is based on actual theoretical usage, the below:
> >
> >> http://oss.sgi.com/archives/xfs/2005-08/msg00045.html
> >
> > was based on reported usage on during live repair runs.
> >
> > I think Barry discovered the difference to be things external
> > to repair such as heap fragmentation and has since corrected
> > the worst of the issues so requirements are, in general,
> > much closer to the theoretical numbers now.
> 
> Yes, quite a few memory improvements have been made.
> 
> Right now, I can repair a 9TB filesystem with ~150 million inodes
> in 2GB of RAM without going to swap using xfs_repair 2.9.4 and
> with no custom/tuning/config options.




Thanks. That is great news about the memory improvements.  We currently
run SLES 10 SP1 which comes with:

hpcxe005:# xfs_repair -V
xfs_repair version 2.8.16

others come with:

hpcxe001:~ # xfs_repair -V
xfs_repair version 2.9.2


Did the memory improvements make it into 2.8.16? How about 2.9.2? If not
i take it we can download the latest source and just have the 2.9.4
xfs_repair binary laying around in case we ever need to use it.  Would
using a 2.9.4 xfs_repair binary on a 2.8.16 created xfs file system
cause any problems?

Thanks
Rene

> 
