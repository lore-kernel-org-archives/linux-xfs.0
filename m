Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n563U4Io082000 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 22:30:04 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1231B1266ECB
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 20:37:09 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id BSpL2SSPCGI8E08a for
	<xfs@oss.sgi.com>; Fri, 05 Jun 2009 20:37:09 -0700 (PDT)
Message-ID: <4A29E1A1.1010202@sandeen.net>
Date: Fri, 05 Jun 2009 22:25:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Segmentation fault during xfs_repair
References: <20090605222236.GA39825@magus.portal.sigil.org>
	<4A29D851.9000700@sandeen.net>
	<20090606031445.GB39825@magus.portal.sigil.org>
In-Reply-To: <20090606031445.GB39825@magus.portal.sigil.org>
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
To: Richard Kolkovich <richard@intrameta.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Richard Kolkovich wrote:
> On Fri, Jun 05, 2009 at 10:45:37PM -0400, Eric Sandeen wrote:
>> Richard Kolkovich wrote:
>>> We have a corrupted XFS partition on a storage server.
>>> Attempting to run xfs_repair the first time yielded the message
>>> about a corrupt log file, so I have run xfs_repair with -L to
>>> clear that.  Now, xfs_repair segfaults in Phase 3.  I have tried
>>> -P and a huge -m to no avail.  It always seems to segfault at the
>>> same point:
>>> 
>>> bad directory block magic # 0 in block 11 for directory inode
>>> 341521797 corrupt block 11 in directory inode 341521797 will junk
>>> block Segmentation fault (core dumped)
>> For starters, which xfsprogs version.... if not latest, try
>> latest... if latest, I'll grab that metadump image and see if I can
>> reproduce it.
>> 
>> -Eric
> 
> Sorry - forgot to mention that.
> 
> Running on Fedora 11 (64bit).  Tried using 2.10.2 (from yum) and
> building from latest stable source (3.0.1).  Let me know if I should
> try a dev build.

(Hm, did I really leave F11 at 2.10.2?  I thought it was newer, but anyway)

No, I doubt anything else has fixed this since 3.0.1

I'll try pulling down that metadump image & see what I can see.

Feel free to file an xfsprogs bug with fedora, too, so the issue doesn't
get lost...

-Eric

> Thanks,
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
