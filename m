Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6O8Mrb0117755 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 03:22:54 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0317518C262B
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 01:23:37 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id SjBN7b17IEtmCORi for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 01:23:37 -0700 (PDT)
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
From: Andi Kleen <andi@firstfloor.org>
References: <4A691B2D.1090600@sandeen.net> <C68EA385.B8CE%elbles@sessys.com>
Date: Fri, 24 Jul 2009 10:23:33 +0200
In-Reply-To: <C68EA385.B8CE%elbles@sessys.com> (Sean Elble's message of "Thu,
	23 Jul 2009 23:32:21 -0400")
Message-ID: <87vdli1oca.fsf@basil.nowhere.org>
MIME-Version: 1.0
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
To: Sean Elble <elbles@sessys.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Sean Elble <elbles@sessys.com> writes:
>
> But another post <http://oss.sgi.com/archives/xfs/2003-07/msg00495.html> has
> a 2.4.21 kernel being used with a patch, so I'm not sure if I want to try a
> 2.6 kernel, or see if I can patch together a 2.4.x kernel on an old FC4 box
> I have laying around.  Truth be told, it's a lot of work just to blank the
> entries in /etc/shadow so I can login to a 150 MHz box again, so who knows
> if I'll even try at this point, hah.

If you just want to modify /etc/shadow I would just search for the strings
on the raw disk and then edit them directly with some hex editor.
You'll need to fill in something with the same length, presumably
another encrypted password. Just make sure you generate it with 
the same algorithm as Irix.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
