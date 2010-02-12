Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CKlNkI026326
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:47:23 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCD041CC0D1
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:48:38 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id H1xLKrkdKed8doCh for
	<linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:48:38 -0800 (PST)
Message-ID: <4B75BEA6.70403@sandeen.net>
Date: Fri, 12 Feb 2010 14:48:38 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>	<4B75738D.80108@sandeen.net>	<2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>	<2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>	<hl438l$bhm$1@ger.gmane.org>	<4B7594D3.6040304@sandeen.net>	<hl45te$kjs$1@ger.gmane.org>
	<hl4dpt$fq2$1@ger.gmane.org>
In-Reply-To: <hl4dpt$fq2$1@ger.gmane.org>
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
To: Nicolas Stransky <nico@stransky.cx>
Cc: linux-xfs@oss.sgi.com

Nicolas Stransky wrote:
> The -P option allowed me to complete xfs_repair successfully, but it
> also deleted almost everything on the filesystem... A directory that I
> could mount -o ro,norecovery before, with tens of GB of data in it, is
> now empty... That is really too bad.

Any idea what happened to the fs - what prompted the repair?

Did you save the logs, or a preliminary metadump?

I wonder what it found.  The files aren't in lost+found/ ?

 
> Thanks for your help.

Such as it was, I guess...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
