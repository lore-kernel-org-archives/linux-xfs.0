Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4GMETRP144477 for <xfs@oss.sgi.com>; Sat, 16 May 2009 17:14:30 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A83F528EFF6
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 15:14:38 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 53Ql9XlyxH2uoLii for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 15:14:38 -0700 (PDT)
Message-ID: <4A0F3ACD.7020905@sandeen.net>
Date: Sat, 16 May 2009 17:14:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix readline/editline for xfs_io and	xfs_quota
References: <4A0E177C.7070902@sandeen.net>
	<20090516203413.GB28186@infradead.org>
	<4A0F37CF.4030709@sandeen.net>
In-Reply-To: <4A0F37CF.4030709@sandeen.net>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Christoph Hellwig wrote:

...

>> (btw, any reason we don't enable readline support by default if
>> we find the headers installed?)
>>
> 
> I dunno... Nathan, any idea?  Maybe some git-digging is in order.
> 
> -Eric
> 

xfsprogs-2.4.2 (25 March 2003)
        - Added the xfs_io(8) command, an xfs_db(8) alike command
          for testing and debugging the XFS file IO path.
        - Added an optional dependency on the GNU readline library
          which is "off" by default and enabled with the configure
          option --enable-readline=yes; it affects the interactive
          tools only (xfs_db and now xfs_io).

looks like it was done that way originally and never changed, commit
e246ba5f93896ac873d25f65c05496e6e2c69e34 I think.

Fine by me to make the default yes if it's there ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
