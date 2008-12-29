Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTK0U87027911 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:00:30 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B93D24FB7E
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 12:00:28 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id XBFBeyvsii1ZB9Z3 for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 12:00:28 -0800 (PST)
Received: from shambhala.lichtvoll.local
	(DSL01.83.171.154.140.ip-pool.NEFkom.net [83.171.154.140])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id DD9BE5AE4F
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 20:59:56 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: massively truncated files with XFS with sudden power loss on
	=?iso-8859-1?q?2=2E6=2E27=09and?= 2.6.28
Date: Mon, 29 Dec 2008 21:00:07 +0100
References: <200812291920.34123.Martin@Lichtvoll.de>
	<49592045.3050103@sandeen.net>
	(sfid-20081229_202235_177237_AC0CC0EF)
In-Reply-To: <49592045.3050103@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812292100.07339.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com

Am Montag 29 Dezember 2008 schrieb Eric Sandeen:
> Martin Steigerwald wrote:
> > Hi!
> >
> > Remember
> >
> > http://oss.sgi.com/pipermail/xfs/2008-November/037399.html
> >
> > ?
> >
> > I thought it was resolved and with later TuxOnIce and sync all is
> > better for sure. This all was with barriers and write cache enabled.
> >
> > But I had a hard crash this time while shutting down the system
> > regularily and the KDE addressbook, KDE settings, additional sidebar
> > all was lost due to truncated files. This was without barriers but
> > also without write cache.
>
> Some actual data here would be helpful; when you say "truncated files"
> what do you mean; are they 0 length?  Or shorter than they should be?
> How much shorter, and how do you know what they "should be?"

They are shortened by different amounts of bytes. Sometimes from 130 KB to 
60 bytes. Sometimes a file is 0 bytes.

http://oss.sgi.com/pipermail/xfs/2008-November/037399.html

> It is certainly at least possible that whatever is writing the KDE
> files is not following good practices for data integrity... I can't say
> that for sure, but apps have responsibility here, too.  :)

Yeah. I am willing to file enhancement requests were applicable.

> > Curious about the safety of my data I tried to simulate the thing. I
> > shouldn't have done that with my productive data but here are the
> > results:
> >
> > I just switched the machine off after having made a backup of my KDE
> > configuration and after closing my usual apps. Then I waited 30-40
> > seconds. First time was fine, second time KDE colors were lost again.
> > Third time I didn't wait that long. Side bar was lost. Fourth time I
> > pressed power off after *starting* KDE. Lots of stuff was lost,
> > including:
> >
> > - colors
> > - sidebar
> > - kpanel settings
> > - kgpg settings
> > - one kwallet digital wallet with passwords and stuff, a complete
> > file of 130 KB was just 60 bytes anymore
>
> Ah, data!  So it went from 130KB to 60 bytes?  Were the first 60 bytes
> valid data, or could you tell.

I do not have that one at hand anymore - I was quite panicking and forget 
to make a copy of the broken ~/.kde directory before fixing it. But see

http://oss.sgi.com/pipermail/xfs/2008-November/037399.html

for some examples. The contents upto to the truncation point were fine as 
far as I looked back then.

No holes either. Just less bytes than the once of the backup that I made 
just before doing my tests of today.

> > I have seen this on a 2.6.27.7, 2.6.28 with tuxonice patches.
>
> Seems it'd be worth testing w/o tuxonice, too.  I don't know what all
> is in there, honesetly.

Hmmm... I did not test suspend/resume cycled. I just bootet up once and 
shut the system down by pressing the power button long enough.

> > syncing
> > before a crash occurs seems to fix the issue. Did something change
> > with how aggressively the kernel writes data out?
> >
> > I think it was something along
> >
> > shambhala:/proc/sys/vm> cat dirty_expire_centisecs
> > 2999
> >
> > shambhala:/proc/sys/fs/xfs> cat xfsbufd_centisecs xfssyncd_centisecs
> > 100
> > 3000
> >
> > in all recent kernels!
>
> I don't think those have changed any time recently.

I think to lower them for now, until I got to the cause of that random 
lockups that *appear* to be related to switching between X11 and console 
and are offtopic for that list.

> > I expect to loose the changes for a dirtied file thats in the page
> > cache. But I do not expect to loose the current (old) file on disk in
> > that case, unless the crash happens when its actually written out at
> > that time.
>
> This will depend on what the application is doing, though.

Any hints or link on what it *should* be doing?

> > And
> > that appears to be highly unlikely expecially at the time just after
> > KDE started up when I did not use any application yet. I would be
> > surprised when the first things applications would be doing was to
> > write out what they just read in. And even then I would be surprised
> > when XFS did write to all the files at once. So I just don't get what
> > I have seen here and I think I see a regression. I am willing to look
> > deeper when I found how to do so safely enough.
>
> I take it that you see this even for files which you have not
> (intentionally) modified?

Yes. But then the try it directly after starting KDE case isn't the best 
one. Maybe KDE applications just write out lots of files when KDE is 
started. Hmmm, I maybe could have a glimpse at that with iotop.

> > If there an xfsqa test that simulates sudden interruption of write
> > activity?
>
> There are tests which interrupt IO with the XFS_IOC_GOINGDOWN ioctl,
> which simulates a filesystem shutdown, which is not exactly the same as
> a crash or a power loss, though.
>
> > Actually I am considering to switch to ext3/4. Maybe the people that
> > say don't use XFS on commodity hardware really have a point.
>
> No.  :)

No what? No, they don't have a point?

> > But then it did
> > work very well from 2.6.17.7 to 2.6.26, so I think what I face here
> > is a behavorial regression. It might be a performance improvement at
> > the same time, but for laptops and commodity workstations this is too
> > risky IMHO. Is there interest in digging this? I can accept when you
> > tell my not to use XFS on my laptop. But actually I think something
> > changed between 2.6.26 andf 2.6.27 and maybe thats worth looking at.
>
> If you know what is writing to the files that you often see truncated,
> an strace of that pid might be interesting, to see what sorts of IO it
> is doing.
>
> ls -l /proc/$PID/fd/* | grep $FILE
>
> might give a clue if anyone has these files open, then strace that pid
> to see if there is any interesting activity on them?

I could try that for the file kdeglobals. It seems to be written quite 
recently and in there are the desktop colors. Its basically like to get 
truncated even when the notebook has idled for more than 30 seconds.

> Otherwise, if you're highly motivated, and have a test box, do a little
> regression testing and see when you think this behavior changed.  But
> I'd start w/ pristine upstream kernels.

I think I will look at the contents of the tuxonice patch. I am not sure 
whether it patches anything in block/ oder fs/.

More tommorrow. See also my safe writing in applications mail, I tested 
with 2.6.26 and 2.6.25 and they might only have been subtile changes if 
at all.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
