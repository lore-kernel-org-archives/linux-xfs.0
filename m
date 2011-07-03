Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p63ME7ha076492 for <xfs@oss.sgi.com>; Sun, 3 Jul 2011 17:14:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCE6D523A65
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2011 15:14:06 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 5JShEWb6IAswBFBX for <xfs@oss.sgi.com>;
	Sun, 03 Jul 2011 15:14:06 -0700 (PDT)
Message-ID: <4E10E9AD.1020709@sandeen.net>
Date: Sun, 03 Jul 2011 17:14:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs doesn't resize
References: <47455.1309470147@sonic.net> <4E1091C7.5040906@sandeen.net>
	<20110703193822.GA28632@wombat.san-francisco.ca.us>
In-Reply-To: <20110703193822.GA28632@wombat.san-francisco.ca.us>
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
To: Keith Keller <kkeller@sonic.net>
Cc: xfs@oss.sgi.com

On 7/3/11 2:38 PM, Keith Keller wrote:
> On Sun, Jul 03, 2011 at 10:59:03AM -0500, Eric Sandeen wrote:
>> On 6/30/11 4:42 PM, kkeller@sonic.net wrote:
>>> # uname -a
>>> Linux sahara.xxx 2.6.18-128.1.6.el5 #1 SMP Wed Apr 1 09:10:25 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> Yes, it's not a completely current kernel.  This box is running CentOS 5
>>> with some yum updates.
>>
>> try
>>
>> # rpm -qa | grep xfs
>>
>> If you see anything with "kmod" you're running an exceptionally old xfs codebase.
> 
> Yes, I do have a kmod-xfs package, so clearly a kernel update is in
> order.  So my goals are twofold: 1) verify the current filesystem's
> state--is it healthy, or does it need xfs_db voodoo?  2) once it's
> determined healthy, again attempt to grow the filesystem.  Here is
> my current plan for reaching these goals:

> 0) get a nearer-term backup, just in case :)  The filesystem still seems
> perfectly normal, but without knowing what my first xfs_growfs did I
> don't know if or how long this state will last.

good idea.
 
> 1) umount the fs to run xfs_db
> 
> 2) attempt a remount--is this safe, or is there risk of damaging the
> filesystem?

I'm not sure.

You probably hit this bug:
http://oss.sgi.com/archives/xfs/2007-01/msg00053.html

See also:
http://oss.sgi.com/archives/xfs/2009-07/msg00087.html

I can't remember how much damage the original bug did ...

> 3) If a remount succeeds, then update the kernel and xfsprogs.  If
> a remount doesn't work, then revert to the near-term backup I took
> in 0) and attempt to fix the issue (with the help of the list, I hope).

One thing you might be able to do, though I don't remember for sure
if this works, is to freeze the fs and create an xfs_metadump
image of it.  You can then point xfs_repair at that image, and see
what it finds.  But I'm not sure if metadump will work on a frozen
fs... hm no.  Only if it's mounted ro.

Otherwise -maybe- xfs_repair -n -d might work after a mount -o remount,ro.

(-n -d means operate in no-modify mode on an ro-mounted fs)


So you'd need to mount readonly before you could either do xfs_repair -nd
or xfs_metadump followed by repair of that image.  Either one would give
you an idea of the health of the fs.

> 4) In either case, post my xfs_db output to the list and get your
> opinions on the health of the fs.

repair probably will tell you more as an initial step.

> 5) If the fs seems correct, attempt xfs_growfs again.
> 
> Do all these steps seem reasonable?  I am most concerned about step 2--
> I really do want to be able to remount as quickly as possible, but I
> do not know how to tell whether it's okay from xfs_db's output.  So if a
> remount attempt is reasonably nondestructive (i.e., it won't make worse
> an already unhealthy XFS fs) then I can try it and hope for the best.
> (From the other threads I've seen it seems like it's not a good idea to
> run xfs_repair.)

you can run it with -n to do no-modify.  If it's clean, you're good;
if it's a mess, you won't hurt anything, other than making you sad.  :)

> Would it make more sense to update the kernel and xfsprogs before
> attempting a remount?  If a remount fails under the original kernel,

is it still mounted I guess?

A newer up to date kernel certainly won't make anything -worse-

You should uninstall that kmod rpm though so it doesn't get priority
over the xfs.ko in the new kernel.  If you need to revert to the old
kernel, you could always reinstall it.

> what do people think the odds are that a new kernel would be able to
> mount the original fs, or is that really unwise?

I don't think a newer kernel would do any further harm.

> Again, many thanks for all your help.

You're welcome but here's the obligatory plug in return - running RHEL5
proper would have gotten you up to date, fully supported xfs, and you wouldn't
have run into this mess.  Just sayin' ... ;)

-Eric
 
> --keith
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
