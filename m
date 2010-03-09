Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o29C899I137581 for <xfs@oss.sgi.com>; Tue, 9 Mar 2010 06:08:10 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 872EA22770E
	for <xfs@oss.sgi.com>; Tue,  9 Mar 2010 04:09:40 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id XD93IvtMHTXq9I0S
	for <xfs@oss.sgi.com>; Tue, 09 Mar 2010 04:09:40 -0800 (PST)
Message-ID: <4B963A80.8000701@dermichi.com>
Date: Tue, 09 Mar 2010 13:09:36 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <4B8FA2CD.6010904@dermichi.com>	<20100304131511.GH14317@discord.disaster>	<20100304134641.GA26871@infradead.org>	<4B8FC1B7.3070505@dermichi.com>	<20100304222611.GK14317@discord.disaster>	<4B92C71C.5010003@dermichi.com>	<20100308000601.GF28189@discord.disaster>	<4B94EADD.2080108@dermichi.com>
	<4B953D3F.3090002@sandeen.net>	<4B96118C.6080906@dermichi.com>
	<20100309113821.GM28189@discord.disaster>
In-Reply-To: <20100309113821.GM28189@discord.disaster>
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

> Not an oops - it's an assertion fail which causes a deliberate trap
> for debugging.
OK, but is it normal that the load is >=2.0 after that (while the
processor is still mostly idle).

> That's not what I expected to see. Are you running out of space on
> your filesystem?
Not even close:
# df -h /var
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda4             377G  192G  185G  51% /var

cheers,
Michael

PS: Sorry for the private Mail Dave, the "reply-all-forgetness" bit me ;-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
