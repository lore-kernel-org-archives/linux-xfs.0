Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o28I7XJt056152 for <xfs@oss.sgi.com>; Mon, 8 Mar 2010 12:07:34 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D14081D1ED27
	for <xfs@oss.sgi.com>; Mon,  8 Mar 2010 10:09:04 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 6DcRvOC0BCN5xvUJ for
	<xfs@oss.sgi.com>; Mon, 08 Mar 2010 10:09:04 -0800 (PST)
Message-ID: <4B953D3F.3090002@sandeen.net>
Date: Mon, 08 Mar 2010 12:09:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <4B8F871C.60802@dermichi.com>	<20100304112018.GG14317@discord.disaster>	<4B8FA2CD.6010904@dermichi.com>	<20100304131511.GH14317@discord.disaster>	<20100304134641.GA26871@infradead.org>	<4B8FC1B7.3070505@dermichi.com>	<20100304222611.GK14317@discord.disaster>	<4B92C71C.5010003@dermichi.com>	<20100308000601.GF28189@discord.disaster>
	<4B94EADD.2080108@dermichi.com>
In-Reply-To: <4B94EADD.2080108@dermichi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Weissenbacher <mw@dermichi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Michael Weissenbacher wrote:
> Hi Dave!
>> That's ... unexpected. That implies that ip->i_temp == NULL after it
>> has been joined to a transaction. I can't see how that could occur
>> there.  Can you recompile the kernel with CONFIG_XFS_DEBUG and
>> re-run the test as that option includes all sorts of sanity checks
>> for ip->i_temp?
> CONFIG_XFS_DEBUG is enabled now. Is there anything special in dmesg i
> should look for? Or should i just send another oops when it happens again?

Odds are you'll still oops, just earlier.  Send anything interesting
you see in the dmesg if/when it happens...

-Eric
 
> thanks,
> Michael
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
