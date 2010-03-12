Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2C9iJhq240502 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 03:44:20 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C50A2350D9
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 01:45:51 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id sxKCBorHOhorCvSO
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 01:45:51 -0800 (PST)
Message-ID: <4B9A0D2F.30506@dermichi.com>
Date: Fri, 12 Mar 2010 10:45:19 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <4B8FA2CD.6010904@dermichi.com>	<20100304131511.GH14317@discord.disaster>	<20100304134641.GA26871@infradead.org>	<4B8FC1B7.3070505@dermichi.com>	<20100304222611.GK14317@discord.disaster>	<4B92C71C.5010003@dermichi.com>	<20100308000601.GF28189@discord.disaster>	<4B94EADD.2080108@dermichi.com>
	<4B953D3F.3090002@sandeen.net>	<4B975C5C.5090806@dermichi.com>
	<20100311233934.GB4732@dastard>
In-Reply-To: <20100311233934.GB4732@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hi Dave!
> Hi Michael - have you got any idea what the files are that are
> hitting this? This failure is implying that the inode is still dirty
> after syncing all the data. Is something trying to modify it while
> XFS is trying to map it?
Yes, as far as i can tell it's always a file that some process is 
currently modifying. It happens ofter with some file unter /var/log 
which syslog is currently modifying. I tried setting the "no-defrag" 
flag via xfs_io's chattr on all log files but that didn't seem to help. 
It seems that cyrus imapd is triggering this problem far more likely 
than any other program. Some examples of files where it usually hangs:
/var/spool/imap/x/user/xxxx/cyrus.cache (lsof -> cyrus)
/var/imap/db/log.xxxxxxx (lsof -> cyrus)
/var/log/xxx.log (lsof -> syslog)

> We've seen this occasionally in the past, but we've never been able
> to reproduce it with any reliability.  Hence any information you can
> extract would certainly help us here.
I've also seen this happen occasionally before, but recently it started 
to happen on about every second run of xfs_fsr. Because this is a 
production system i've ceased using xfs_fsr for the moment. I've not 
been able to reproduce it on others systems yet.

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
