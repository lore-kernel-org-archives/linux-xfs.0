Return-Path: <bounce+sandeen-linuxfs=sandeen.net@bounce.pbwiki.com>
Received: from sf10.coceve.com (sf10.coceve.com [208.96.6.155])
	by sandeen.net (Postfix) with ESMTP id 6BB811807E35C
	for <sandeen-linuxfs@sandeen.net>; Thu,  9 Aug 2007 21:35:21 -0500 (CDT)
Received: from dev.pbwiki.com (sf19 [208.96.32.19])
	by sf10.coceve.com (Postfix) with ESMTP id F0A08332466C
	for <sandeen-linuxfs@sandeen.net>; Fri, 10 Aug 2007 02:35:20 +0000 (GMT)
Date: Fri, 10 Aug 2007 02:35:20 +0000
From: EugeneTeo <notification@pbwiki.com>
Reply-to: eugeneteo@kernel.sg
Subject: [PBwiki] linuxfs: EasyFsProjects edited
Message-ID: <3e79967fcd63913586eb25c707ffe399@dev.pbwiki.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
	boundary="b1_3e79967fcd63913586eb25c707ffe399"
To: sandeen-linuxfs@sandeen.net
List-ID: <xfs>


--b1_3e79967fcd63913586eb25c707ffe399
Content-Type: text/plain; charset = "utf-8"
Content-Transfer-Encoding: 8bit

Linuxfs.pbwiki.com was just edited. Here's what was changed:
EugeneTeo (eugeneteo@kernel.sg) changed the page 'EasyFsProjects'.


View the current version of EasyFsProjects at http://linuxfs.pbwiki.com/EasyFsProjects
See a full list of changes at http://linuxfs.pbwiki.com/changes.php
------
Start your own PBwiki at http://pbwiki.com/ 
Change notification preferences at http://linuxfs.pbwiki.com/notification.php, unsubscribe completely with http://linuxfs.pbwiki.com/notification.php?verify=197c0&unsub=sandeen-linuxfs%40sandeen.net

New! -- Get better control over your notifications and wiki experience.
Sign up for a PBwiki identity. It's easy and free! Start at http://linuxfs.pbwiki.com/notification.php


--b1_3e79967fcd63913586eb25c707ffe399
Content-Type: text/html; charset = "utf-8"
Content-Transfer-Encoding: 8bit

<table><tr><td>
<h3>Linuxfs.pbwiki.com/EasyFsProjects was just edited</h3>
EugeneTeo (<a href=mailto:eugeneteo@kernel.sg>eugeneteo@kernel.sg</a>) changed <a href="http://Linuxfs.pbwiki.com/">EasyFsProjects</a>, which you're watching.<br></td><td></td>
</tr></table>
<br>
The changed portions of the page follow, with <span style="color:#900;background-color:#fcc;text-decoration:line-through;">red</span> indicating removed text and <span style="color:#090;background-color:#cfc;font-weight:bold;">green</span> indicating added text.
<div style="margin:8px;background-color:#eee;color:#999;padding:8px">
Looking for a simple file systems project to work on?  Try one of the following.  The contact is the IRC nick of someone on #linuxfs you can talk to to find out more about the project.  If you can also be a contact for a project, please add yourself as one.<br>Lazy atime - Keep atime in memory, only update it on-disk when the inode will be written out for some other reason (basically, don't dirty the inode on an atime update).  This is as opposed to plain old noatime - see touch_atime() in fs/inode.c.  Contact: valh   Update I wrote both a lazy atime and a relative atime, see: http://infohost.nmt.edu/~val/patches.html#relatime<br> on<span style="color:#900;background-color:#fcc;text-decoration:line-through;"> this.</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> this.</span><span style="color:#090;background-color:#cfc;font-weight:bold;">  This</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> project</span><span
style="color:#090;background-color:#cfc;font-weight:bold;"> has</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> been</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> worked</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> on</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> by</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> multiple</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> people.</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> Need</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> to</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> demonstrate</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> benefit</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> for</span><span style="color:#090;background-color:#cfc;font-weight:bold;">
this</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> feature,</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> other</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> than</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> on</span><span style="color:#090;background-color:#cfc;font-weight:bold;"> Lustre.</span><br>SEEK_HOLE, SEEK_DATA - New parameters to seek() asking for the next part of the file with data in it.  As it currently stands, even if a file is sparse on disk, the file system still has to shovel zeroes out through the read() system call.  Some applications, such as archivers or backup programs, can make good use of an interface that says, e.g., the next 8MB of the file are all zeroes, instead of having to read 8MB of zeroes.  See the following:   http://blogs.sun.com/roller/page/bonwick?entry=seek_hole_and_seek_data  
http://www.google.com/search?hl=en&amp;lr=&amp;q=+site:lkml.org+seek_hole+seek_data   Contact: cw, valh   Update Eric Lorimer has written an initial implementation for ext3.<br>A generically useful library for finding and managing contiguous areas of disk space.  Getting the interface right is non-trivial, but there are a lot of concepts which are independent of on-disk file system layout which could be reused.  Good starting points are the ext3 reservation code and/or the XFS extent allocation code (the ext2 preallocation code is NOT a good place to start).  Short of that, finish and test the port of the ext3 reservation code to ext2, started here:   http://infohost.nmt.edu/~val/patches/resv_only_patch   Contact: valh<br>
</div>
View <a href="http://linuxfs.pbwiki.com/EasyFsProjects">EasyFsProjects</a><br>
Change your <a href="http://linuxfs.pbwiki.com/notification.php">notification preferences</a>. You can also <a href="http://linuxfs.pbwiki.com/notification.php?verify=197c0&unsub=sandeen-linuxfs%40sandeen.net">turn off emails<a/> completely.<br><br>
<br>
<b>New!</b> -- Get better control over your notifications and wiki experience.<br>
Sign up for a PBwiki identity. It's easy and free! Start at <a href="http://linuxfs.pbwiki.com/notification.php">my.pbwiki.com</a>



--b1_3e79967fcd63913586eb25c707ffe399--
