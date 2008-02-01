Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Jan 2008 20:10:28 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m114ANrE001294
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2008 20:10:24 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0276358ADC1
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2008 20:10:42 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id AD0bEK9QIEFtj2uU for <xfs@oss.sgi.com>; Thu, 31 Jan 2008 20:10:42 -0800 (PST)
Message-ID: <35274.192.168.3.1.1201839007.squirrel@mail.aconex.com>
In-Reply-To: <61a567a60801311439n668ed585t7c03a803da57244f@mail.gmail.com>
References: <61a567a60801311439n668ed585t7c03a803da57244f@mail.gmail.com>
Date: Fri, 1 Feb 2008 15:10:07 +1100 (EST)
Subject: Re: how to use attr_multi() properly ?
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: VR <vreikine@gmail.com>
Cc: xfs@oss.sgi.com

> Hi,
> ...
> Could you please advise on how to call attr_multi() to get a bunch of
> attributes at once properly, or is it better just do attr_get() in a
> loop ?

Its better to just use attr_get in a loop (attr_multi on Linux is just
a userspace wrapper around the xattr syscalls, and is provided for IRIX
compatibility only).

cheers.

--
Nathan
