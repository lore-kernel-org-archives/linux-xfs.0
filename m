Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Dec 2007 16:12:14 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de [85.214.69.204])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB30CAMR014453
	for <xfs@oss.sgi.com>; Sun, 2 Dec 2007 16:12:11 -0800
Date: Mon, 3 Dec 2007 01:12:19 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: ACL limit
In-Reply-To: <475343FB.3060902@sgi.com>
Message-ID: <Pine.LNX.4.64.0712030110520.9395@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711301902360.18767@fbirervta.pbzchgretzou.qr>
 <20071202223105.GS119954183@sgi.com> <475343FB.3060902@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com


On Dec 3 2007 10:47, Timothy Shimmin wrote:
>
> Yeah, it's just an array of entries in an EA value.
> The EA value is limited to 64K so it's a question of how
> many entries you can fit into that.
> (64K - 4)/12 = 5461
>
> (So just have to sort out the ondisk change as mentioned above)

I'd already be happy if the ext3 ACL limit (~120) was possibe :-)
The rest I can solve with groups (which is also probably faster
than 1600 ACL entries).
