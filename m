Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CLo0VP034235 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 15:50:01 -0600
Received: from vms173007pub.verizon.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 286751CC2D4
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 13:51:15 -0800 (PST)
Received: from vms173007pub.verizon.net (vms173007pub.verizon.net
	[206.46.173.7]) by cuda.sgi.com with ESMTP id Tf1lVZaVfY5bmzS1
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 13:51:15 -0800 (PST)
Received: from [192.168.10.2] ([unknown] [98.114.168.230])
	by vms173007.mailsrvcs.net
	(Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16
	2009)) with ESMTPA id <0KXR006ZW0P6QZK0@vms173007.mailsrvcs.net> for
	xfs@oss.sgi.com; Fri, 12 Feb 2010 15:51:06 -0600 (CST)
Subject: Re: xfs_repair doesn't fix sb versionnum missing attr
From: C Linus Hicks <linush@verizon.net>
In-reply-to: <4B75C841.3010105@sandeen.net>
References: <1265996674.7755.7.camel@lh10.linush.net>
	<4B75BA12.1060704@sandeen.net>
	<1266007649.7755.12.camel@lh10.linush.net>
	<4B75C841.3010105@sandeen.net>
Date: Fri, 12 Feb 2010 16:51:06 -0500
Message-id: <1266011466.7755.35.camel@lh10.linush.net>
MIME-version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, 2010-02-12 at 15:29 -0600, Eric Sandeen wrote:
> C Linus Hicks wrote:
> > On Fri, 2010-02-12 at 14:29 -0600, Eric Sandeen wrote:
> >> C Linus Hicks wrote:
> >>> I run:
> >>>
> >>> xfs_check /dev/sdc10
> >>>
> >>> And it reports:
> >>>
> >>> sb versionnum missing attr bit 10
> >>>
> >>> Then I run:
> >>>
> >>> xfs_repair /dev/sdc10
> >>>
> >>> And it reports output from 7 phases and "done".
> >>>
> >>> Again I run:
> >>>
> >>> xfs_check /dev/sdc10
> >>>
> >>> And it reports:
> >>>
> >>> sb versionnum missing attr bit 10
> >>>
> >>> Is this how it's supposed to work?
> >>> Thanks for any help.
> >>> Linus
> >>>
> >> I've never seen that before.
> >>
> >> This might be interesting to see:
> >>
> >> # xfs_db /dev/sdc10
> >> xfs_db> sb 0
> >> xfs_db> version
> >>
> >> If you want to send me a zipped-up, obfuscated metadump of the filesystem
> >> I could take a quick look.
> >>
> >> -Eric
> > 
> > The output from the "version" command:
> > 
> > versionnum [0x3084+0x0] = V4,ALIGN,DIRV2,EXTFLG
> > 
> > I'll email the metadump directly to you so as not to pollute the list.
> 
> Ok so a little less mystery here; I was concerned about how we got here,
> but Linus had to manually reconstruct his superblock, hence the missing
> flags.
> 
> Looks like there are selinux attributes on all the files, so of course
> the sb should have the attr flags set.
> 
> This does look like one test that check has and repair doesn't.
> 
> <checking upstream for sure>
> 
> yep!
> 
> Linus, FWIW simply creating a new file on the fs with xattrs (any
> old file works if selinux is on) will set the flags as if it were
> the first file created w/ an attr...
> 
> [root@host Linus-repair-bug]# xfs_check sdc10-md.log.img 
> sb versionnum missing attr bit 10
> [root@host Linus-repair-bug]# mount -o loop sdc10-md.log.img mnt/
> [root@host Linus-repair-bug]# echo foobar > mnt/blah
> [root@host Linus-repair-bug]# ls -Z mnt/blah
> -rw-r--r--  root root root:object_r:file_t             mnt/blah
> [root@host Linus-repair-bug]# umount mnt
> [root@host Linus-repair-bug]# xfs_check sdc10-md.log.img 
> [root@host Linus-repair-bug]#
> 
> I suppose that check should get added to repair though.
> 
> Care to file a bug so it doesn't get lost?
> 
> -Eric

Sure, I can do that.
Linus


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
