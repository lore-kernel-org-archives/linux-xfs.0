Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jan 2008 19:22:19 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0V3MBWW027409
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2008 19:22:15 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22420D56FCA
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2008 19:17:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id HkkAJyDlwGg9FRmo for <xfs@oss.sgi.com>; Wed, 30 Jan 2008 19:17:41 -0800 (PST)
Message-ID: <47A13DD1.1010908@sandeen.net>
Date: Wed, 30 Jan 2008 21:17:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
References: <20080129093201.GA16203@citd.de> <20080129171658.GB21228@citd.de> <20080130232628.GA9671@citd.de>
In-Reply-To: <20080130232628.GA9671@citd.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

Matthias Schniedermeyer wrote:
> A little followup.
> 
> Today i bought another 750GB HDD, and a 500GB.
> 
> Initializing the encryption of the 500GB finished a minute ago and the 
> same bug, of course with a different size (357702MB), was observable.
> 
> Workaround also worked in this case (Now its 476937MB). This also proves 
> that the bug is of recent nature, the last 500GB HDD i bought was just 
> over a month ago and this bug didn't show up then.

Yes, it's a regression in 2.9.5.

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=1.82;r2=1.83

-Eric
