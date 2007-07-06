Return-Path: <bounce+sandeen-linuxfs=sandeen.net@bounce.pbwiki.com>
Received: from sf10.coceve.com (sf10.coceve.com [208.96.6.155])
	by sandeen.net (Postfix) with ESMTP id 9575218054EF9
	for <sandeen-linuxfs@sandeen.net>; Fri,  6 Jul 2007 12:26:47 -0500 (CDT)
Received: from dev.pbwiki.com (sf5 [208.96.6.144])
	by sf10.coceve.com (Postfix) with ESMTP id 698C112A151A
	for <sandeen-linuxfs@sandeen.net>; Fri,  6 Jul 2007 17:26:46 +0000 (GMT)
Date: Fri, 6 Jul 2007 17:26:46 +0000
From: PBwiki Changebot <notification@pbwiki.com>
Subject: [PBwiki] linuxfs: EasyFsProjects edited
Message-ID: <b2ea91b2da15d73680f2c3a4392b5925@dev.pbwiki.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
	boundary="b1_b2ea91b2da15d73680f2c3a4392b5925"
To: sandeen-linuxfs@sandeen.net
List-ID: <xfs>


--b1_b2ea91b2da15d73680f2c3a4392b5925
Content-Type: text/plain; charset = "utf-8"
Content-Transfer-Encoding: 8bit

Linuxfs.pbwiki.com was just edited. Here's what was changed:
someone unknown changed the page 'EasyFsProjects'.


View the current version of EasyFsProjects at http://linuxfs.pbwiki.com/EasyFsProjects
See a full list of changes at http://linuxfs.pbwiki.com/changes.php
------
Start your own PBwiki at http://pbwiki.com/ 
Change notification preferences at http://linuxfs.pbwiki.com/notification.php, unsubscribe completely with http://linuxfs.pbwiki.com/notification.php?verify=197c0&unsub=sandeen-linuxfs@sandeen.net

New! -- Get better control over your notifications and wiki experience.
Sign up for a PBwiki identity. It's easy and free! Start at http://linuxfs.pbwiki.com/notification.php


--b1_b2ea91b2da15d73680f2c3a4392b5925
Content-Type: text/html; charset = "utf-8"
Content-Transfer-Encoding: 8bit

<table><tr><td>
<h3>Linuxfs.pbwiki.com/EasyFsProjects was just edited</h3>
someone unknown changed <a href="http://Linuxfs.pbwiki.com/">EasyFsProjects</a>, which you're watching.<br></td><td></td>
</tr></table>
<br>
The changed portions of the page follow, with <span style="color:#900;background-color:#fcc;text-decoration:line-through;">red</span> indicating removed text and <span style="color:#090;background-color:#cfc;font-weight:bold;">green</span> indicating added text.
<div style="margin:8px;background-color:#eee;color:#999;padding:8px">
Looking for a simple file systems project to work on?  Try one of the following.  The contact is the IRC nick of someone on #linuxfs you can talk to to find out more about the project.  If you can also be a contact for a project, please add yourself as one.<br>Lazy atime - Keep atime in memory, only update it on-disk when the inode will be written out for some other reason (basically, don't dirty the inode on an atime update).  This is as opposed to plain old noatime - see touch_atime() in fs/inode.c.  Contact: valh   Update I wrote both a lazy atime and a relative atime, see: http://infohost.nmt.edu/~val/patches.html#relatime<br> cases.<span style="color:#090;background-color:#cfc;font-weight:bold;">  This</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> was</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> proposed</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> to</span><span
style="color:#090;background-color:#cfc;font-weight:bold;"> be</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> a</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> feature</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> of</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> the</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> fstatat()</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> system</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> call,</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> passing</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> flags</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> AT_GET_{SIZE,INO,UID,GID,...}</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> to</span><span
style="color:#090;background-color:#cfc;font-weight:bold;"> request</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> only</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> the</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> specified</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> fields,</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> and</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> ignoring</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> others</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> if</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> any</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> of</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> those</span><span style="color:#090;background-color:#cfc;font-weight:bold;">
flags</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> are</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> given.</span>  Contact: valh, zab   Update Trevor Woerner (tlw) is starting work on this.<br>SEEK_HOLE, SEEK_DATA - New parameters to seek() asking for the next part of the file with data in it.  As it currently stands, even if a file is sparse on disk, the file system still has to shovel zeroes out through the read() system call.  Some applications, such as archivers or backup programs, can make good use of an interface that says, e.g., the next 8MB of the file are all zeroes, instead of having to read 8MB of zeroes.  See the following:   http://blogs.sun.com/roller/page/bonwick?entry=seek_hole_and_seek_data   http://www.google.com/search?hl=en&amp;lr=&amp;q=+site:lkml.org+seek_hole+seek_data   Contact: cw, valh   Update Eric Lorimer has written an initial implementation for ext3.<br>A generically useful library for finding and
managing contiguous areas of disk space.  Getting the interface right is non-trivial, but there are a lot of concepts which are independent of on-disk file system layout which could be reused.  Good starting points are the ext3 reservation code and/or the XFS extent allocation code (the ext2 preallocation code is NOT a good place to start).  Short of that, finish and test the port of the ext3 reservation code to ext2, started here:   http://infohost.nmt.edu/~val/patches/resv_only_patch   Contact: valh<br>Some kind of hook into the disk EIO reporting which allows file systems to register a handler which does things like set the &quot;fsck me now&quot; bit.  Contact: valh<br><span style="color:#090;background-color:#cfc;font-weight:bold;">Simple block bitmap sanity checking for ext2/3/4.  When a new block bitmap is read from disk in read_block_bitmap() there are a few bits that should ALWAYS be set for each group.  In particular, the blocks given by desc-&gt;bg_block_bitmap,
desc-&gt;bg_inode_bitmap, and bg_inode_table, +sbi-&gt;s_itb_per_group&quot;&gt;desc-&gt;bg_inode_table, +sbi-&gt;s_itb_per_group.  If any of those those bits (shifted to be relative to the current group, of course) are not set then the on-disk group descriptor is corrupt, or there is some problem reading it from disk and an ext3_error() should be called (possibly making the filesystem read-only).</span><br>
</div>
View <a href="http://linuxfs.pbwiki.com/EasyFsProjects">EasyFsProjects</a><br>
Change your <a href="http://linuxfs.pbwiki.com/notification.php">notification preferences</a>. You can also <a href="http://linuxfs.pbwiki.com/notification.php?verify=197c0&unsub=sandeen-linuxfs@sandeen.net">turn off emails<a/> completely.<br><br>
<br>
<b>New!</b> -- Get better control over your notifications and wiki experience.<br>
Sign up for a PBwiki identity. It's easy and free! Start at <a href="http://linuxfs.pbwiki.com/notification.php">my.pbwiki.com</a>



--b1_b2ea91b2da15d73680f2c3a4392b5925--
