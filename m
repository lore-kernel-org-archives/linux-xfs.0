Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9L2EMZg195388 for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 21:14:22 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E46524096
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 19:15:55 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id bPA0FVe0SHkPWhq4 for
	<xfs@oss.sgi.com>; Tue, 20 Oct 2009 19:15:55 -0700 (PDT)
Message-ID: <4ADE6ED8.20003@tlinx.org>
Date: Tue, 20 Oct 2009 19:15:52 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs_fsr: XFS_IOC_SWAPEXT failed; & miscellania
References: <4ADD4D9B.9090808@tlinx.org> <4ADE33D5.6080907@sandeen.net>
In-Reply-To: <4ADE33D5.6080907@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>

Eric Sandeen wrote:
> Linda A. Walsh mumbled:
>> ...weird message...daily fsr run...root partition:
>>   meaning? file busy? 
>>
>> fsr[20906]: XFS_IOC_SWAPEXT failed: ino=16781994: Invalid argument
> 
> What kernel?  and what file is inode 16781994?  (find / -inum 16781994)
---
kernel name = "2.6.27.29-0.1-vanilla", from distro SuSE 11.1
	(It's the unpatched version of their current kernel.)


> EINVAL can come from many places; trying to defrag a swapfile is one of 
> them ...
---
	inode corresponds to '/etc/samba/secrets.tdb'
miscellanea 

It would appear samba doesn't like its "secrets" file possibly being
'defraged' ;^) moved around.  Hmmm...

Would that be because of a "file lock" or would just being 
"open" cause that?  Maybe Memory mapped?

Odd that I haven't seen it on other days... (i.e. it's not a message
I normally see, which is why I asked about it...).

-l

------
p.s. - other thoughts(related to using xfs_io/bmap)...

BTW...just in using xfs_io/xfs_bmap a bit and the man pages,
some comments.  Don't know which are under your control and
which are due to distro-config defaults, or which
are due to my specific configuration (or lack thereof), but:

doc related:
1) when not using "hyperlinked manpages" that invoke program output,
(;-)), things like being able to see 'referenced' flag names that
are displayed in a program (like for xfs_io{lsattr|chattr}') isn't
easy.
It might be nice, if possible, to include the 'current set' of [supported]
options in the man page.  The situation of a reader viewing the 
'remote information' (the actual options displayed in the active
program) could be worse -- they could be in a browser and have no
access to a console window.  Of course in that case, if the manpages
were being displayed from a machine that had the command, a properly
configured webserver would have a plugin to run the command and 
show the output in a scrolled <pre> region, in real time....:-).

&doc related+FYI
2) reading the xfs_io manpage, it referred to the xfsctl manpage 
o find out params for some sub-command.  Some (unnamed, but one might 
have a hint by my kernel usage) "bright" distro packagers have the
idea that even 'manpages' about library or system functions are
'development' material that goes in a separate (not included by default)
'devel' rpm.  (sigh).  Don't know if there's any automated
way to include info from that manpage in the relevant sections, to prevent
the information from being separated, but something to think about
if the documentation ever gets re-arranged (not soon, I'm sure, but
just an FYI).


Question:
3) I'd been using chattr to change options like "+d" (nodump) on xfs
options. It seems to work.  Is that accidental or by design?  Maybe there
needs to be a 'chattr.xfs' subcommand and chattr needs to call a 'flavor'
based on filesystem...(I know that's partially an 'upstream' issue).


Enhancement?
4) is it possible to configure the xfs_utils with 'readline' and history
support?  -- allowing re-edit of previous lines and even a restoration
of one's previous command history on entry?

At least the readline support would be helpful  given my typing accuracy
(i.e. re-edit of previous line...though even a history that only lasts
for the given session, could be useful for repeating commands on multiple
files...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
