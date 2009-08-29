Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7TMD3gH246236 for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 17:13:13 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6B3740D3B0
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 15:13:31 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 8UsB5lIOlJlUW7AX for
	<xfs@oss.sgi.com>; Sat, 29 Aug 2009 15:13:31 -0700 (PDT)
Message-ID: <4A99A80C.9010307@sandeen.net>
Date: Sat, 29 Aug 2009 15:13:32 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: zero size file after power failure with kernel 2.6.30.5
References: <200908292102.21710@zmi.at>
In-Reply-To: <200908292102.21710@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> I have /home mounted like this:
> /dev/sda3 on /disks/work1 type xfs 
> (rw,noatime,logbufs=8,logbsize=256k,attr2,barrier,largeio,swalloc)
> 
> Hardware: onboard SATA with a single WD VelociRaptor drive.
> 
> My power supply melted and so I had a power fail and a sudden death 
> crash.
> ( So please remember: even when you have a UPS, your power can fail ! )
> 
> After replacing the part, I had almost no isse with my KDE desktop. In 
> earlier XFS releases, I constantly lost several config files all 
> truncated to 0 length or at some point only contained NULLs on such 
> occasions. So the situation improved a lot.
> 
> But almost is not good enough: Exactly my kmail config file was 0 sized 
> - obviously: at least when I started kmail, it started fresh without any 
> accounts or config, but once I exited kmail the config was created with 
> the default values and about 12KB size, while my config has >200KB.
> 
> Shouldn't it be that this doesn't happen anymore? I'd love to be in a 
> position where I really can rely on a crash not trashing any of my files 
> anymore. I used to have reiserfs previously, and never, not a single 
> time despite many crashes, did I have such an issue. I'd really be 
> pleased so see such stability in XFS. I'm using barriers - what else 
> must I do?
> 
> mfg zmi

this will depend on what kde is doing internally as well.

No filesystem can magically protect against buffered data loss on a 
crash.  An application could certainly be doing something that results 
in this sort of thing.  w/o reading some kde code I can't say for sure, 
and I don't mean to blame KDE, but this isn't necessarily a bug in xfs.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
