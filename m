Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6DgZ5A018518 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 07:42:36 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A8571BF1224
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 05:42:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id lwkFEtS6gKSq01uJ for <xfs@oss.sgi.com>;
	Sat, 06 Dec 2008 05:42:33 -0800 (PST)
Message-ID: <493A8149.5020704@sandeen.net>
Date: Sat, 06 Dec 2008 07:42:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel 2.6.27.7 problem
References: <20081206023608.GA22135@bob.dscon.sk>	<4939F104.9060201@sandeen.net>
	<20081206091022.GA24158@bob.dscon.sk>
In-Reply-To: <20081206091022.GA24158@bob.dscon.sk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: DS <xfs@bob.dscon.sk>
Cc: xfs@oss.sgi.com

DS wrote:
> No other messages before. No iSCSI/network messages...nothing.
> Only this few lines and FS is down. After remount it works ....while and
> hangs again.
> Few hours it runs back on 2.6.24.3 and everything is OK.
> 
> It's production system, but I test it again in late night.
> What can I do to identify problem?

Complain to the iscsi people perhaps...?

__end_that_request_first() in block/block-core.c() is what is issuing
your first error,

>  end_request: I/O error, dev sde, sector 351572544

and the rest is xfs reacting to that.

Maybe the first thing I'd check is whether that sector nr. is sane for
your device (I'd assume it is, but maybe worth checking).

If that's all you've got I'm not sure offhand what else to debug....

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
