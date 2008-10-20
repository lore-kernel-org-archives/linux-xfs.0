Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 15:39:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KMdGPJ013619
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:39:16 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACC801311352
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:41:00 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id HcsBW0MlQMOQ1IKe for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:41:00 -0700 (PDT)
Date: Tue, 21 Oct 2008 09:39:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Oops when mounting
Message-ID: <20081020223937.GB21152@disturbed>
References: <f40b17020810201324v48873a2ah51023120b17511d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f40b17020810201324v48873a2ah51023120b17511d6@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Procurves <procurves@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 20, 2008 at 10:24:29PM +0200, Procurves wrote:
> Hi,
> 
> I get this oops when mounting my xfs partition, this specific one is for
> 2.6.24.5 (Slackware 12.1 Install Disc):
> http://pastebin.com/f5f7f56a
> 
> I also run it through ksymoops:
> http://pastebin.com/f42942ef9

Seems like a corrupted log. Can you try adding this patch:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commitdiff;h=d9477f0f0902890585ecd3181e22622c418f12d7

And seeing if that detects the corruption and aborts recovery?

> The partition has now been reformatted as I have no spare time for this.
> I hope this in some way will help you guys with your development of xfs.

Well, maybe not.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
