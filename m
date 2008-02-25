Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 09:17:34 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1PHHPgQ003463
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 09:17:28 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2428D614816
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 09:17:52 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id YmjrcJxJbYbFh12t for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 09:17:52 -0800 (PST)
Message-ID: <47C2F83C.8000306@sandeen.net>
Date: Mon, 25 Feb 2008 11:17:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs I/O error
References: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>	 <20080223220818.GC27124@teal.hq.k1024.org>	 <2db2c6b80802231414m38f70795n7f24fea1a40195df@mail.gmail.com>	 <20080224090106.GD27124@teal.hq.k1024.org>	 <2db2c6b80802240352o301a0d15q991efb97a1dbff82@mail.gmail.com>	 <20080224123129.GE27124@teal.hq.k1024.org> <2db2c6b80802250840r6e6f3c53m8953d3c8c07b02e8@mail.gmail.com>
In-Reply-To: <2db2c6b80802250840r6e6f3c53m8953d3c8c07b02e8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rekrutacja119 <rekrutacja119@gmail.com>
Cc: xfs@oss.sgi.com

Rekrutacja119 wrote:
> i tried doing dd if with the bs=1024, and the dd command went fine! i really
> don't understand it :( i wont write zeros to it, if it is fine, since this
> sector is probably correct.
> 
> any ideas what to do now?
> 
> also - still no solution to force XFS to not shutdown itself?

mount it readonly.

xfs isn't going to continue if doing so would further corrupt the fs.

-Eric
