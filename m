Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB69FQG2030545 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 03:15:27 -0600
Received: from bob.dscon.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1842E16C8E3A
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 01:15:24 -0800 (PST)
Received: from bob.dscon.sk (bob.dscon.sk [88.86.113.10]) by cuda.sgi.com with
	ESMTP id XBsGWHM6Dg9hhKLP for <xfs@oss.sgi.com>;
	Sat, 06 Dec 2008 01:15:24 -0800 (PST)
Date: Sat, 6 Dec 2008 10:10:22 +0100
Subject: Re: kernel 2.6.27.7 problem
Message-ID: <20081206091022.GA24158@bob.dscon.sk>
References: <20081206023608.GA22135@bob.dscon.sk>
	<4939F104.9060201@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4939F104.9060201@sandeen.net>
From: xfs@bob.dscon.sk (DS)
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

No other messages before. No iSCSI/network messages...nothing.
Only this few lines and FS is down. After remount it works ....while and
hangs again.
Few hours it runs back on 2.6.24.3 and everything is OK.

It's production system, but I test it again in late night.
What can I do to identify problem?

Dusan


On Fri, Dec 05, 2008 at 09:27:00PM -0600, Eric Sandeen wrote:
> DS wrote:
> > Hi,
> > 
> > I have trouble with xfs after upgrade kernel 2.6.24.3 -> 2.6.27.7.
> > 
> > Message on console:
> >  end_request: I/O error, dev sde, sector 351572544
> >  I/O error in filesystem ("sde1") meta-data dev sde1 block 0x14f49201
> >  ("xlog_iodone") error 5 buf count 9728
> >  xfs_force_shutdown(sde1,0x2) called from line 1056 of file
> >  fs/xfs/xfs_log.c.  Return address = 0xffffffff80373233
> >  Filesystem "sde1": Log I/O Error Detected.  Shutting down filesystem:
> >  sde1
> >  Please umount the filesystem, and rectify the problem(s)
> 
> No messages before that?  It's telling you that you had an IO error
> (under the filesystem, potentially a storage proboblem).
> 
> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
