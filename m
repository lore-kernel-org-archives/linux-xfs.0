Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTJ8sAf024241 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 13:08:55 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7100D179346B
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 11:08:53 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id V6MVK3biR4tpd3hm for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 11:08:53 -0800 (PST)
Message-ID: <49592045.3050103@sandeen.net>
Date: Mon, 29 Dec 2008 13:08:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: massively truncated files with XFS with sudden power loss on
	2.6.27	and 2.6.28
References: <200812291920.34123.Martin@Lichtvoll.de>
In-Reply-To: <200812291920.34123.Martin@Lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Martin Steigerwald <Martin@Lichtvoll.de>
Cc: xfs@oss.sgi.com

Martin Steigerwald wrote:
> Hi!
> 
> Remember
> 
> http://oss.sgi.com/pipermail/xfs/2008-November/037399.html
> 
> ?
> 
> I thought it was resolved and with later TuxOnIce and sync all is better 
> for sure. This all was with barriers and write cache enabled.
> 
> But I had a hard crash this time while shutting down the system regularily 
> and the KDE addressbook, KDE settings, additional sidebar all was lost 
> due to truncated files. This was without barriers but also without write 
> cache.

Some actual data here would be helpful; when you say "truncated files"
what do you mean; are they 0 length?  Or shorter than they should be?
How much shorter, and how do you know what they "should be?"

It is certainly at least possible that whatever is writing the KDE files
is not following good practices for data integrity... I can't say that
for sure, but apps have responsibility here, too.  :)

> Curious about the safety of my data I tried to simulate the thing. I 
> shouldn't have done that with my productive data but here are the 
> results:
> 
> I just switched the machine off after having made a backup of my KDE 
> configuration and after closing my usual apps. Then I waited 30-40 
> seconds. First time was fine, second time KDE colors were lost again. 
> Third time I didn't wait that long. Side bar was lost. Fourth time I 
> pressed power off after *starting* KDE. Lots of stuff was lost, 
> including:
> 
> - colors
> - sidebar
> - kpanel settings
> - kgpg settings
> - one kwallet digital wallet with passwords and stuff, a complete file of 
> 130 KB was just 60 bytes anymore

Ah, data!  So it went from 130KB to 60 bytes?  Were the first 60 bytes
valid data, or could you tell.

> I cannot remember having seen this kind of behavior anywhere between 
> 2.6.17.7 and 2.6.26! And I had sudden interruptions of write activity 
> from time to time. 
> 
> I can't prove anything right now. I possibly could if I dare to test this 
> again with 2.6.26! But from my experiences this never was so massive. 
> Prior to the null file fixes a file or two might have been corrupted and 
> that not all the times. Thats to be expected if thats the file that where 
> written out at the time. But now it seems that almost every file that is 
> opened for writing or not even just for writing is truncated seriously at 
> sudden interruption of write activity. Whereas before it appeared that 
> usually either the change was not made or it was made - at least for 
> small files. Now the file is truncated, no holes, just lots less bytes 
> than before.
> 
> I think I will go back to 2.6.26 for now - with write barriers, cause 
> thats what used to work. I went too far already with my tests, cause its 
> difficult to be sure that I found all truncated files even when I close 
> all productivity applications in my tests. Altough it seems I was able to 
> recovery everything everytime by mixing the current data set with the 
> broken stuff restored from the last backup this is setting my data at a 
> too high risk.
> 
> Do you have any idea on how to help to get down to the cause of this - 
> without risking precious data? Did anyone else see this? Does anyone use 
> XFS on laptops and had recent power losses or crashes?
> 
> I have seen this on a 2.6.27.7, 2.6.28 with tuxonice patches. 

Seems it'd be worth testing w/o tuxonice, too.  I don't know what all is
in there, honesetly.

> syncing 
> before a crash occurs seems to fix the issue. Did something change with 
> how aggressively the kernel writes data out?
> 
> I think it was something along
> 
> shambhala:/proc/sys/vm> cat dirty_expire_centisecs
> 2999
> 
> shambhala:/proc/sys/fs/xfs> cat xfsbufd_centisecs xfssyncd_centisecs
> 100
> 3000
> 
> in all recent kernels!

I don't think those have changed any time recently.

> I expect to loose the changes for a dirtied file thats in the page cache. 
> But I do not expect to loose the current (old) file on disk in that case, 
> unless the crash happens when its actually written out at that time. 

This will depend on what the application is doing, though.

> And 
> that appears to be highly unlikely expecially at the time just after KDE 
> started up when I did not use any application yet. I would be surprised 
> when the first things applications would be doing was to write out what 
> they just read in. And even then I would be surprised when XFS did write 
> to all the files at once. So I just don't get what I have seen here and I 
> think I see a regression. I am willing to look deeper when I found how to 
> do so safely enough.

I take it that you see this even for files which you have not
(intentionally) modified?

> If there an xfsqa test that simulates sudden interruption of write 
> activity?

There are tests which interrupt IO with the XFS_IOC_GOINGDOWN ioctl,
which simulates a filesystem shutdown, which is not exactly the same as
a crash or a power loss, though.

> Actually I am considering to switch to ext3/4. Maybe the people that say 
> don't use XFS on commodity hardware really have a point.

No.  :)

> But then it did 
> work very well from 2.6.17.7 to 2.6.26, so I think what I face here is a 
> behavorial regression. It might be a performance improvement at the same 
> time, but for laptops and commodity workstations this is too risky IMHO. 
> Is there interest in digging this? I can accept when you tell my not to 
> use XFS on my laptop. But actually I think something changed between 
> 2.6.26 andf 2.6.27 and maybe thats worth looking at.

If you know what is writing to the files that you often see truncated,
an strace of that pid might be interesting, to see what sorts of IO it
is doing.

ls -l /proc/$PID/fd/* | grep $FILE

might give a clue if anyone has these files open, then strace that pid
to see if there is any interesting activity on them?

Otherwise, if you're highly motivated, and have a test box, do a little
regression testing and see when you think this behavior changed.  But
I'd start w/ pristine upstream kernels.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
