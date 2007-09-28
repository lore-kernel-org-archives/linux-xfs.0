Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 16:36:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8SNae9d008858
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 16:36:41 -0700
Message-ID: <46FD9006.6050807@sandeen.net>
Date: Fri, 28 Sep 2007 18:36:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Truncated Filesystem
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org> <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Benjamin Carr <bcarr@whoi.edu>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Including LKML on this one as it may be a partition size limit?  Sdc1 is 
> not 11TB.
> 
> Justin.

Yup saw the same thing:

(1957867653*1024)/1024/1024/1024/1024 = 1.82T

I'm afraid you don't have a truncated filesystem, you have a truncated
block device.  I'm afraid this is not an xfs problem... you need to
figure out what happened to sdc1 (for example, why doesn't it extend to
the end of sdc?)

-Eric
