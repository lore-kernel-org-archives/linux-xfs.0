Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2CAYfh7244060 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 04:34:41 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFCB01D2F519
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 02:36:14 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id 7BpqiURxt1fJC4Vj
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 02:36:14 -0800 (PST)
Message-ID: <4B9A1919.4010601@dermichi.com>
Date: Fri, 12 Mar 2010 11:36:09 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <20100304134641.GA26871@infradead.org>	<4B8FC1B7.3070505@dermichi.com>	<20100304222611.GK14317@discord.disaster>	<4B92C71C.5010003@dermichi.com>	<20100308000601.GF28189@discord.disaster>	<4B94EADD.2080108@dermichi.com>
	<4B953D3F.3090002@sandeen.net>	<4B975C5C.5090806@dermichi.com>
	<20100311233934.GB4732@dastard>	<4B9A0D2F.30506@dermichi.com>
	<20100312100019.GA13230@infradead.org>
In-Reply-To: <20100312100019.GA13230@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

> So what's interesting is that cyrus uses mmapp access to files, which
> might be an indicator that we have problems with excluding fsr on mmaped
> files.
 From what i saw by experimenting xfs_fsr doesn't skip mmapped files 
(while imho it should). Another cyrus file it hung on recently was:
/var/imap/user/x/xxxxxxxx.seen: Cyrus skiplist DB

I will be happy to test out any patches.

hth,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
