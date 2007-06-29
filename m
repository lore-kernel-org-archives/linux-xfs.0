Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 00:34:58 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T7YrtL018262
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 00:34:54 -0700
Subject: Re: xfs_fsr, performance related tweaks
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <4684B1CC.60004@corky.net>
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net>
	 <4684A506.4030705@corky.net>
	 <op.tun7i8wd3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <4684A98B.1030000@corky.net> <20070629070814.GR31489@sgi.com>
	 <4684B1CC.60004@corky.net>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 17:33:55 +1000
Message-Id: <1183102435.15488.170.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Just Marc <marc@corky.net>
Cc: David Chinner <dgc@sgi.com>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

On Fri, 2007-06-29 at 08:16 +0100, Just Marc wrote:
> 
> 
> In my first post I already said something like that can be done but
> it's 
> just an ugly hack.   Don't you think it would best be handled cleanly 
> and correctly by fsr itself?
> 

As I said earlier, fsr already issues the ioctl you're
concerned about using - I'm not sure what the issue is
there - if you need to do a setxattr, Just Do It.

cheers.

--
Nathan
