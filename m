Return-Path: <bounce+sandeen-linuxfs=sandeen.net@bounce.pbwiki.com>
Received: from sf5.coceve.com (sf5.coceve.com [208.96.6.144])
	by sandeen.net (Postfix) with ESMTP id 2BD351807DF04
	for <sandeen-linuxfs@sandeen.net>; Mon, 13 Aug 2007 09:24:17 -0500 (CDT)
Subject: [PBwiki] linuxfs: EasyFsProjects edited
Date: Mon, 13 Aug 2007 14:24:17 +0000
From: "J. Bruce Fields" <notification@pbwiki.com>
Reply-to: bfields@fieldses.org
Message-ID: <bd950d98e44c59e25fcaa2d7de9ac1b6@dev.pbwiki.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
	boundary="b1_bd950d98e44c59e25fcaa2d7de9ac1b6"
To: sandeen-linuxfs@sandeen.net
List-ID: <xfs>


--b1_bd950d98e44c59e25fcaa2d7de9ac1b6
Content-Type: text/plain; charset = "utf-8"
Content-Transfer-Encoding: 8bit

Linuxfs.pbwiki.com was just edited. Here's what was changed:
J. Bruce Fields (bfields@fieldses.org) changed the page 'EasyFsProjects'.


View the current version of EasyFsProjects at http://linuxfs.pbwiki.com/EasyFsProjects
See a full list of changes at http://linuxfs.pbwiki.com/changes.php
------
Start your own PBwiki at http://pbwiki.com/ 
Change notification preferences at http://linuxfs.pbwiki.com/notification.php, unsubscribe completely with http://linuxfs.pbwiki.com/notification.php?verify=197c0&unsub=sandeen-linuxfs%40sandeen.net

New! -- Get better control over your notifications and wiki experience.
Sign up for a PBwiki identity. It's easy and free! Start at http://linuxfs.pbwiki.com/notification.php


--b1_bd950d98e44c59e25fcaa2d7de9ac1b6
Content-Type: text/html; charset = "utf-8"
Content-Transfer-Encoding: 8bit

<table><tr><td>
<h3>Linuxfs.pbwiki.com/EasyFsProjects was just edited</h3>
J. Bruce Fields (<a href=mailto:bfields@fieldses.org>bfields@fieldses.org</a>) changed <a href="http://Linuxfs.pbwiki.com/">EasyFsProjects</a>, which you're watching.<br></td><td></td>
</tr></table>
<br>
The changed portions of the page follow, with <span style="color:#900;background-color:#fcc;text-decoration:line-through;">red</span> indicating removed text and <span style="color:#090;background-color:#cfc;font-weight:bold;">green</span> indicating added text.
<div style="margin:8px;background-color:#eee;color:#999;padding:8px">
Looking for a simple file systems project to work on?  Try one of the following.  The contact is the IRC nick of someone on #linuxfs you can talk to to find out more about the project.  If you can also be a contact for a project, please add yourself as one.<br><span style="color:#900;background-color:#fcc;text-decoration:line-through;">Lazy atime - Keep atime in memory, only update it on-disk when the inode will be written out for some other reason (basically, don't dirty the inode on an atime update).  This is as opposed to plain old noatime - see touch_atime() in fs/inode.c.  Contact: valh   Update I wrote both a lazy atime and a relative atime, see: http://infohost.nmt.edu/~val/patches.html#relatime</span><br>Stat with flags - Implement flags to the stat() system call that allow you to say which fields of the stat structure you care about, and which the system can ignore.  This can speed up stat() in many common cases.  This was proposed to be a feature of the fstatat() system call, passing flags AT_GET_{SIZE,INO,UID,GID,...} to request only the specified fields, and ignoring others if any of those flags are given.  Contact: valh, zab   Update This project has been worked on by multiple people. Need to demonstrate benefit for this feature, other than on Lustre.<br>SEEK_HOLE, SEEK_DATA - New parameters to seek() asking for the next part of the file with data in it.  As it currently stands, even if a file is sparse on disk, the file system still has to shovel zeroes out through the read() system call.  Some applications, such as archivers or backup programs, can make good use of an interface that says, e.g., the next 8MB of the file are all zeroes, instead of having to read 8MB of zeroes.  See the following:   http://blogs.sun.com/roller/page/bonwick?entry=seek_hole_and_seek_data   http://www.google.com/search?hl=en&amp;lr=&amp;q=+site:lkml.org+seek_hole+seek_data   Contact: cw, valh   Update Eric Lorimer has written an initial implementation for ext3.<br>A generically useful library for finding and managing contiguous areas of disk space.  Getting the interface right is non-trivial, but there are a lot of concepts which are independent of on-disk file system layout which could be reused.  Good starting points are the ext3 reservation code and/or the XFS extent allocation code (the ext2 preallocation code is NOT a good place to start).  Short of that, finish and test the port of the ext3 reservation code to ext2, started here:   http://infohost.nmt.edu/~val/patches/resv_only_patch   Contact: valh<br>Some kind of hook into the disk EIO reporting which allows file systems to register a handler which does things like set the &quot;fsck me now&quot; bit.  Contact: valh<br><span style="color:#090;background-color:#cfc;font-weight:bold;">Lazy atime - Keep atime in memory, only update it on-disk when the inode will be written out for some other reason (basically, don't dirty the inode on an atime update).  This is as opposed to plain old noatime - see touch_atime() in fs/inode.c.  Contact: valh   Update I wrote both a lazy atime and a relative atime, see: http://infohost.nmt.edu/~val/patches.html#relatime</span><br>
</div>
View <a href="http://linuxfs.pbwiki.com/EasyFsProjects">EasyFsProjects</a><br>
Change your <a href="http://linuxfs.pbwiki.com/notification.php">notification preferences</a>. You can also <a href="http://linuxfs.pbwiki.com/notification.php?verify=197c0&unsub=sandeen-linuxfs%40sandeen.net">turn off emails<a/> completely.<br><br>
<br>
<b>New!</b> -- Get better control over your notifications and wiki experience.<br>
Sign up for a PBwiki identity. It's easy and free! Start at <a href="http://linuxfs.pbwiki.com/notification.php">my.pbwiki.com</a><br>(There was one <a href="http://linuxfs.pbwiki.com/changes.php">change</a> since your last notification 3 days, 11 hours ago)



--b1_bd950d98e44c59e25fcaa2d7de9ac1b6--
