Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB8DVk2J001001
	for <linux-xfs@oss.sgi.com>; Mon, 8 Dec 2008 07:31:48 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8705E16DBD5D
	for <linux-xfs@oss.sgi.com>; Mon,  8 Dec 2008 05:31:45 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id eSqWb3ew4CasKLFL for
	<linux-xfs@oss.sgi.com>; Mon, 08 Dec 2008 05:31:45 -0800 (PST)
Date: Mon, 8 Dec 2008 08:31:13 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS over SSD
In-Reply-To: <5d96567b0812080442r131d9fc8t4019c99ffbffa290@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812080829370.24867@p34.internal.lan>
References: <5d96567b0812080442r131d9fc8t4019c99ffbffa290@mail.gmail.com>
MIME-Version: 1.0
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
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com



On Mon, 8 Dec 2008, Raz wrote:

> I am thinking of using XFS over a SSD disk.
I am currently using XFS on an Intel X25-E with the logdev internal, using 
the defaults.
I see the point for putting the journal elsewhere; however, that may 
defeat the purpose of an SSD, if its latency is 0.01 or 0.001 and the HDD 
is 8-14ms, then it may defeat the purpose for writes or fast access 
anyhow?

> 1. Can I separate xfs meta data ( not just the logging) from 
the SSD ? > can I put the meta on a different disk ?
Yes, see the logdev option on the mkfs.xfs manpage.

> 2. When does a file's meta ( its block maps ) is being flushed to disk
> ? can I control it ?
I am not sure you can control this, will let the XFS devs/others take on 
this question.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
