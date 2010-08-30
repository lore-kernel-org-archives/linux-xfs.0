Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7U1qLAZ237356 for <xfs@oss.sgi.com>; Sun, 29 Aug 2010 20:52:22 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FAAC178A07F
	for <xfs@oss.sgi.com>; Sun, 29 Aug 2010 18:52:58 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id QqfFjX7OKGwX1JKO for
	<xfs@oss.sgi.com>; Sun, 29 Aug 2010 18:52:58 -0700 (PDT)
Message-ID: <4C7B0EF6.5030505@sandeen.net>
Date: Sun, 29 Aug 2010 20:52:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs: minimum version with these commands
References: <4C7A2654.3080106@op.pl>
In-Reply-To: <4C7A2654.3080106@op.pl>
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
To: Bogdan <bogdandr@op.pl>
Cc: xfs@oss.sgi.com

Bogdan wrote:
>  Hello.
> 
>  I couldn't find this information in the xfsprogs ChangeLog, so I'm
> asking here: what is the minimum version of xfsprogs to:
> 
> 1) contain these utilities: xfs_db, xfs_freeze, xfs_check, and
> 2) xfs_db accepts the following command-line parameters: -i, -c, and
> 3) xfs_freeze accepts the following command-line parameters: -f, -u, and
> 4) xfs_db accepts the following interactive mode commands: "freesp
> -d", "quit", "blockget -n", "ncheck", "sb 0", "print".

I am not surprised that changelogs do not mention when "quit" was
added to xfs_db ...!

>  Or is there a ChangeLog that covers all xfsprogs versions in such
> deatil that I would be able to find this myself? If so, where can I
> find it?
> 

You could look at git and/or cvs history/blame to see when commands & 
options were added.

Most of the things you ask about are SO OLD it will take some digging
through renames and moves.

Do you really need to know if "xfs_check" was added in 1994, or 1995, for
example? :)

This strikes me as a bit of an odd question; what is your motivation here?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
