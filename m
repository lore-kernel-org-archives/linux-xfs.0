Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o28CGHRM032702 for <xfs@oss.sgi.com>; Mon, 8 Mar 2010 06:16:18 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 483231D1DDD9
	for <xfs@oss.sgi.com>; Mon,  8 Mar 2010 04:17:47 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id jQTxjSvBF3q9ZGio
	for <xfs@oss.sgi.com>; Mon, 08 Mar 2010 04:17:47 -0800 (PST)
Message-ID: <4B94EADD.2080108@dermichi.com>
Date: Mon, 08 Mar 2010 13:17:33 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <4B8F871C.60802@dermichi.com>	<20100304112018.GG14317@discord.disaster>	<4B8FA2CD.6010904@dermichi.com>	<20100304131511.GH14317@discord.disaster>	<20100304134641.GA26871@infradead.org>	<4B8FC1B7.3070505@dermichi.com>	<20100304222611.GK14317@discord.disaster>	<4B92C71C.5010003@dermichi.com>
	<20100308000601.GF28189@discord.disaster>
In-Reply-To: <20100308000601.GF28189@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hi Dave!
> That's ... unexpected. That implies that ip->i_temp == NULL after it
> has been joined to a transaction. I can't see how that could occur
> there.  Can you recompile the kernel with CONFIG_XFS_DEBUG and
> re-run the test as that option includes all sorts of sanity checks
> for ip->i_temp?
CONFIG_XFS_DEBUG is enabled now. Is there anything special in dmesg i 
should look for? Or should i just send another oops when it happens again?

thanks,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
