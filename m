Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5BMUWW3174873 for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 17:30:32 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 127D7123269D
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 15:30:53 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id fmlvUdnFXnHwTS5H for
	<xfs@oss.sgi.com>; Thu, 11 Jun 2009 15:30:53 -0700 (PDT)
Message-ID: <4A31859C.2090209@sandeen.net>
Date: Thu, 11 Jun 2009 17:30:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: catch bad depth in traverse_int_dir2block
References: <4A2C8AD8.9030107@sandeen.net>	<20090608074230.GA28066@infradead.org>	<20090609160622.GE63930@magus.portal.sigil.org>	<4A2E900B.3070100@sandeen.net>
	<20090610214750.GB39123@divination.intrameta.com>
In-Reply-To: <20090610214750.GB39123@divination.intrameta.com>
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
> On Tue, Jun 09, 2009 at 12:38:35PM -0400, Eric Sandeen wrote:
>> Richard Kolkovich wrote:
>>> Guys,
>>>
>>> After applying the patch, we get much further.  xfs_repair then fails in phase 7:
>>>
>>>
>>> xfs_repair: phase7.c:47: set_nlinks: Assertion `fs_inode_nlink' failed.
>>>
>>> Aborted
>>>
>>>
>>> Any ideas on that one?  Thanks!
>> Yep, I meant to reply, I hit that one too.  Haven't yet looked into that
>> one ....
>>
>> -Eric
> 
> Any ideas on a workaround if not a fix?  We really just want to get through the repair and see what
> (if anything) is still usable...

Try setting the nlink feature on the superblock, which apparently got
lost... i'm not sure why repair doesn't cope but you can fix that:

xfs_db -x /device

xfs_db> sb 0
xfs_db> write versionnum 0x30A4

but then you'll hit something else I'm looking at, an inode moved to
lost+found which is still not referenced, grr.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
