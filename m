Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9K2ZNds008880 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 21:35:23 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29E9412F3AA1
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 19:51:33 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 5D2V43AlpAzlhdaF
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 19:51:33 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 600836C126
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 21:36:35 -0500 (CDT)
Message-ID: <4CBE55B3.5010405@hardwarefreak.com>
Date: Tue, 19 Oct 2010 21:36:35 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: avoid mbox file fragmentation
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
In-Reply-To: <20101019234217.GD12506@dastard>
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
To: xfs@oss.sgi.com

Dave Chinner put forth on 10/19/2010 6:42 PM:

> I've explained how allocsize works, and that speculative allocation
> gets truncated away whenteh file is closed. Hence is the application
> is doing:

My apologies for missing this requiring another post.  It is appreciated.

> 	open()
> 	seek(EOF)
> 	write()
> 	close()

The application is Dovecot IMAP server.  I'm not positive, but I believe
this is the append method it uses, as do most mbox writers.

> allocsize does not help you because the specualtive prealloc done in
> write() is truncated away in close().
> 
> What you want is _physical_ preallocation, not speculative
> preallocation. i.e. look up XFS_IOC_RESVSP or FIEMAP so your
> application does _permanent_ preallocate past EOF. Alteratively, the
> filesystem will avoid the truncation on close() is the file has the
> APPEND attribute set and the application is writing via O_APPEND...

Thank you very much Dave.  I'll see if I can get Timo to implement this.
 Odds are long as I believe mbox has a very small user base today
compared to maildir and thus has lower development priority.  If it's
relatively easy to implement, maybe he can/will do it.

> The filesystem cannot do everything for you. Sometimes the
> application has to help....

Agreed.  I'm far from an expert on either, but I've been around the
block enough, and been on this list long enough, to know this. :)
Please don't think I was "blaming" XFS for the fragmentation.  Any file
that constantly gets appended, forever, is going to fragment.  Fact of
life.  I just thought there may be a tweak in XFS to lessen the
fragmentation effects.  Maybe it's simply time for me to move to maildir
format which pretty much eliminates fragmentation altogether.  The main
reason I like mbox is the fast full body searching of mail folders.
Doing so with maildir crawls, relatively speaking, especially for
folders with 15k+ emails.  The second is portability of mbox files.
Just about any MUA can read them.  Backup/restore is fast and
straightforward, although restoring individual messages is a bear.

> /proc/mounts displays some default options.

Yep.  We went through them together previously.  The main ones missing
there are the performance enhancing (log) options.

> As I say to _everyone_ who complains about this: Patches
> to correct documentation issues are greatly appreciated. You don't
> need to be a coding export to send a patch correcting a man page....

I would love to do so Dave.  However, I don't know at what rev the
defaults have changed.  What has been stated on list recently is that
recent kernels default both logbufs=8 and logbsize=256k which are the
maximum values, according to my man page for mount.  My man page for
mount is rather old as Debian Stable lags well behind upstream, and it
states these default values are based on the fs block size and the
machine's memory size.  Maybe the current man page has the correct info
already?  Anyone have a link to the most current man page for mount?

I guess this is one of the downsides to using a newer rolled kernel in
place of a distro's default kernel?  The man page doesn't get updated
and doesn't reflect features/defaults of the new kernel?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
