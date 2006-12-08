Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Dec 2006 12:25:35 -0800 (PST)
Received: from mail.lichtvoll.de (12.unused.teamix.net [194.150.191.12] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB8KPQqw028987
	for <linux-xfs@oss.sgi.com>; Fri, 8 Dec 2006 12:25:27 -0800
Received: from localhost (dslb-084-056-065-242.pools.arcor-ip.net [84.56.65.242])
	by mail.lichtvoll.de (Postfix) with ESMTP id 418945AD2D
	for <linux-xfs@oss.sgi.com>; Fri,  8 Dec 2006 21:00:04 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: invalid directory entry - bad magic number on inode
Date: Fri, 8 Dec 2006 20:59:59 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200612082100.00395.Martin@lichtvoll.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hello,

today, I got a strange problem with XFS that seemed to affect only one 
file. I stumbled upon it as I tried to remove the package serendipity on 
my Debian mostly Etch/some Sid/probably some Experimental:

-----------------------------------------------------------------------
deepdance:~#130> aptitude purge serendipity
Paketlisten werden gelesen... Fertig
[...]
Entferne serendipity ...
dpkg: Fehler beim Bearbeiten von serendipity (--purge):
 
Kann »/usr/share/serendipity/www/plugins/serendipity_event_livesearch/lang_pt_PT.inc.php« 
nicht entfernen: Das Argument ist ungültig
Fehler traten auf beim Bearbeiten von:
 serendipity
[...]
-----------------------------------------------------------------------

That means that the package could not removed cause that PHP file could 
not be removed

"Das Argument ist ungültig" means in english => "The argument is invalid"

-----------------------------------------------------------------------
deepdance:~#2> 
ls -l /usr/share/serendipity/www/plugins/serendipity_event_livesearch/lang_pt_PT.inc.php
ls: /usr/share/serendipity/www/plugins/serendipity_event_livesearch/lang_pt_PT.inc.php: 
Das Argument ist ungültig
deepdance:~#2> 
ls -l /usr/share/serendipity/www/plugins/serendipity_event_livesearch/
insgesamt 0
?--------- ? ? ? ?                ? /usr/share/serendipity/www/plugins/serendipity_event_livesearch/lang_pt_PT.inc.php
-----------------------------------------------------------------------

Now that looks strange. I thought I better boot into SUSE 10.1 and check 
my Debian root partition.

-----------------------------------------------------------------------
deepdance:~ # xfs_check /dev/hda5
agi unlinked bucket 14 is 4110 in ag 0 (inode=4110)
agi unlinked bucket 25 is 12633 in ag 0 (inode=12633)
agi unlinked bucket 33 is 929 in ag 0 (inode=929)
[... more of that kinda usual stuff ...]
agi unlinked bucket 60 is 233532 in ag 9 (inode=37982268)
agi unlinked bucket 61 is 233533 in ag 9 (inode=37982269)
bad magic number 0 for inode 43113648
agi unlinked bucket 0 is 74624 in ag 11 (inode=46211968)
agi unlinked bucket 1 is 74625 in ag 11 (inode=46211969)
[...]
agi unlinked bucket 57 is 47865 in ag 15 (inode=62962425)
agi unlinked bucket 58 is 164986 in ag 15 (inode=63079546)
block 10/73160 type unknown not expected
allocated inode 4110 has 0 link count
allocated inode 929 has 0 link count
[... more of that ...]
allocated inode 37982268 has 0 link count
allocated inode 37982269 has 0 link count
link count mismatch for inode 43113648 (name ?), nlink 0, counted 1
allocated inode 46140958 has 0 link count
allocated inode 46137510 has 0 link count
[... more of that ...]
-----------------------------------------------------------------------

Hmmm, seems 43113648 is corrupted.

As I need the laptop tomorrow for work I ran xfs_repair without much 
further diagnostics. It seems to have fixed it the problem properly:

-----------------------------------------------------------------------
deepdance:~ # xfs_repair /dev/hda5
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
error following ag 1 unlinked list
error following ag 2 unlinked list
error following ag 3 unlinked list
error following ag 8 unlinked list
error following ag 11 unlinked list
error following ag 12 unlinked list
error following ag 15 unlinked list

-----------------------------------------------------------------------

Are those above harmless?

-----------------------------------------------------------------------

Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
bad magic number 0x0 on inode 43113648
bad version number 0x2d on inode 43113648
bad inode format in inode 43113648
bad magic number 0x0 on inode 43113648, resetting magic number
bad version number 0x2d on inode 43113648, resetting version number
bad inode format in inode 43113648
cleared inode 43113648
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - clearing existing "lost+found" inode
        - marking entry "lost+found" to be deleted
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
entry "lang_pt_PT.inc.php" in shortform directory 43058698 references free 
inode 43113648
junking entry "lang_pt_PT.inc.php" in directory inode 43058698
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
rebuilding directory inode 128
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 929, moving to lost+found
disconnected inode 3366, moving to lost+found
[...more of those...]
-----------------------------------------------------------------------

Another run of xfs_check remains completely silent. All seems well again.

Anyone any idea what that might have been?

Unfortunately I cannot provide much further info. I do not even now when 
this problem might have occured first.

There are no traces of XFS problems in /var/log/syslog.

I will do a backup now and then run a SMART offline check just to be 
sure...

Any hints on what I could try if it ever happens again? Suppose I can save 
out the bad inode contents before I let xfs_repair fix it...

Aside that so far no problems with XFS since 2.6.17.7 whatsoever ;-).

This is on IBM ThinkPad T23 with 768 MB (it swapped out nevertheless... I 
had two KDE sessions running and whatnot...) and this kernel:

deepdance:~> cat /proc/version
Linux version 2.6.18.1-ck1-tp23-sws2-2.2.8 (root@deepdance) (gcc-Version 
4.1.2 20060901 (prerelease) (Debian 4.1.1-13)) #1 PREEMPT Wed Oct 25 
11:55:21 CEST 2006

It contains suspend2 patches by Nigel Cunningham and responsive ness 
patches by Con Koliva. Apart from that it is vanilla.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
