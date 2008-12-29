Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTIKTPH009436 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 12:20:29 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 909191793663
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 10:20:27 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 2ttoJoTFCY9Yw8aa for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 10:20:27 -0800 (PST)
Received: from shambhala.lichtvoll.local
	(DSL01.83.171.154.140.ip-pool.NEFkom.net [83.171.154.140])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 698D45AE4F
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 19:20:24 +0100 (CET)
From: Martin Steigerwald <Martin@Lichtvoll.de>
Subject: massively truncated files with XFS with sudden power loss on 2.6.27
	and 2.6.28
Date: Mon, 29 Dec 2008 19:20:33 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812291920.34123.Martin@Lichtvoll.de>
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


Hi!

Remember

http://oss.sgi.com/pipermail/xfs/2008-November/037399.html

?

I thought it was resolved and with later TuxOnIce and sync all is better 
for sure. This all was with barriers and write cache enabled.

But I had a hard crash this time while shutting down the system regularily 
and the KDE addressbook, KDE settings, additional sidebar all was lost 
due to truncated files. This was without barriers but also without write 
cache.

Curious about the safety of my data I tried to simulate the thing. I 
shouldn't have done that with my productive data but here are the 
results:

I just switched the machine off after having made a backup of my KDE 
configuration and after closing my usual apps. Then I waited 30-40 
seconds. First time was fine, second time KDE colors were lost again. 
Third time I didn't wait that long. Side bar was lost. Fourth time I 
pressed power off after *starting* KDE. Lots of stuff was lost, 
including:

- colors
- sidebar
- kpanel settings
- kgpg settings
- one kwallet digital wallet with passwords and stuff, a complete file of 
130 KB was just 60 bytes anymore

I cannot remember having seen this kind of behavior anywhere between 
2.6.17.7 and 2.6.26! And I had sudden interruptions of write activity 
from time to time. 

I can't prove anything right now. I possibly could if I dare to test this 
again with 2.6.26! But from my experiences this never was so massive. 
Prior to the null file fixes a file or two might have been corrupted and 
that not all the times. Thats to be expected if thats the file that where 
written out at the time. But now it seems that almost every file that is 
opened for writing or not even just for writing is truncated seriously at 
sudden interruption of write activity. Whereas before it appeared that 
usually either the change was not made or it was made - at least for 
small files. Now the file is truncated, no holes, just lots less bytes 
than before.

I think I will go back to 2.6.26 for now - with write barriers, cause 
thats what used to work. I went too far already with my tests, cause its 
difficult to be sure that I found all truncated files even when I close 
all productivity applications in my tests. Altough it seems I was able to 
recovery everything everytime by mixing the current data set with the 
broken stuff restored from the last backup this is setting my data at a 
too high risk.

Do you have any idea on how to help to get down to the cause of this - 
without risking precious data? Did anyone else see this? Does anyone use 
XFS on laptops and had recent power losses or crashes?

I have seen this on a 2.6.27.7, 2.6.28 with tuxonice patches. syncing 
before a crash occurs seems to fix the issue. Did something change with 
how aggressively the kernel writes data out?

I think it was something along

shambhala:/proc/sys/vm> cat dirty_expire_centisecs
2999

shambhala:/proc/sys/fs/xfs> cat xfsbufd_centisecs xfssyncd_centisecs
100
3000

in all recent kernels!

I expect to loose the changes for a dirtied file thats in the page cache. 
But I do not expect to loose the current (old) file on disk in that case, 
unless the crash happens when its actually written out at that time. And 
that appears to be highly unlikely expecially at the time just after KDE 
started up when I did not use any application yet. I would be surprised 
when the first things applications would be doing was to write out what 
they just read in. And even then I would be surprised when XFS did write 
to all the files at once. So I just don't get what I have seen here and I 
think I see a regression. I am willing to look deeper when I found how to 
do so safely enough.

If there an xfsqa test that simulates sudden interruption of write 
activity?

Actually I am considering to switch to ext3/4. Maybe the people that say 
don't use XFS on commodity hardware really have a point. But then it did 
work very well from 2.6.17.7 to 2.6.26, so I think what I face here is a 
behavorial regression. It might be a performance improvement at the same 
time, but for laptops and commodity workstations this is too risky IMHO. 
Is there interest in digging this? I can accept when you tell my not to 
use XFS on my laptop. But actually I think something changed between 
2.6.26 andf 2.6.27 and maybe thats worth looking at.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
