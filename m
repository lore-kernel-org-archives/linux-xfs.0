Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6REkJjT191411 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 09:46:19 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 266B647661C
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 07:49:24 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id 6vjKqiEVx5jIdaLf for
	<xfs@oss.sgi.com>; Tue, 27 Jul 2010 07:49:24 -0700 (PDT)
Date: Tue, 27 Jul 2010 16:49:14 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: High latencies writing to a memory mapped file
Message-ID: <20100727144914.GA29349@citd.de>
References: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com>
	<20100727092452.GA23307@citd.de>
	<4C4EDEFD.7000401@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C4EDEFD.7000401@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On 27.07.2010 08:28, Stan Hoeppner wrote:
> Matthias Schniedermeyer put forth on 7/27/2010 4:24 AM:
> 
> > We have a linux-computer with samba to act as a fileserver for a few 
> > Windows-Clients and ever since kernel 2.6.26 (Never happend with 2.6.25) 
> > the server randomly "hangs" for a few seconds (Which is more of a 
> > problem that drives people crazy).
> 
> Can you supply any kinda of empirical data or logging that would suggest the
> problem lies with XFS?  You've not given us much to go on except anecdote.
> 
> Google "linux server hangs" and you'll find thousands of causes and solutions.

The "best" further anecdote i have is:
I cloned(*) the server, on identical hardware (ignoring HDDs), for 
someone else with 2 major differences.
- no loop-aes, as they didn't need encryption.
- ext4 instead of xfs

That machine has currently an uptime of 180 days and i don't have a 
single report of a "hang". (Which technically doesn't mean that the 
machine doesn't have that same bug. Only that no one ever complained to 
me)

For empirical data: I don't know how or where to start.



*:
In the best sense of the word.
As the first step i 'rsync'ed the "system"-HDD of our server to a new 
HDD. ...


Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
