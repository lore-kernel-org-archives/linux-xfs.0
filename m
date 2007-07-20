Return-Path: <bounce+sandeen-linuxfs=sandeen.net@bounce.pbwiki.com>
Received: from sf10.coceve.com (sf10.coceve.com [208.96.6.155])
	by sandeen.net (Postfix) with ESMTP id 0A8771807F9D3
	for <sandeen-linuxfs@sandeen.net>; Fri, 20 Jul 2007 11:58:56 -0500 (CDT)
Received: from dev.pbwiki.com (sf6 [208.96.6.149])
	by sf10.coceve.com (Postfix) with ESMTP id 2C51312A1B0E
	for <sandeen-linuxfs@sandeen.net>; Fri, 20 Jul 2007 16:58:55 +0000 (GMT)
Date: Fri, 20 Jul 2007 16:58:55 +0000
From: PBwiki Changebot <notification@pbwiki.com>
Subject: [PBwiki] linuxfs: EasyFsProjects edited
Message-ID: <cdc9c504ca96a4c88fba1edfec0eb231@dev.pbwiki.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
	boundary="b1_cdc9c504ca96a4c88fba1edfec0eb231"
To: sandeen-linuxfs@sandeen.net
List-ID: <xfs>


--b1_cdc9c504ca96a4c88fba1edfec0eb231
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


--b1_cdc9c504ca96a4c88fba1edfec0eb231
Content-Type: text/html; charset = "utf-8"
Content-Transfer-Encoding: 8bit

<table><tr><td>
<h3>Linuxfs.pbwiki.com/EasyFsProjects was just edited</h3>
someone unknown changed <a href="http://Linuxfs.pbwiki.com/">EasyFsProjects</a>, which you're watching.<br></td><td></td>
</tr></table>
<br>
The changed portions of the page follow, with <span style="color:#900;background-color:#fcc;text-decoration:line-through;">red</span> indicating removed text and <span style="color:#090;background-color:#cfc;font-weight:bold;">green</span> indicating added text.
<div style="margin:8px;background-color:#eee;color:#999;padding:8px">
A generically useful library for finding and managing contiguous areas of disk space.  Getting the interface right is non-trivial, but there are a lot of concepts which are independent of on-disk file system layout which could be reused.  Good starting points are the ext3 reservation code and/or the XFS extent allocation code (the ext2 preallocation code is NOT a good place to start).  Short of that, finish and test the port of the ext3 reservation code to ext2, started here:   http://infohost.nmt.edu/~val/patches/resv_only_patch   Contact: valh<br>Some kind of hook into the disk EIO reporting which allows file systems to register a handler which does things like set the &quot;fsck me now&quot; bit.  Contact: valh<br><span style="color:#900;background-color:#fcc;text-decoration:line-through;">Simple block bitmap sanity checking for ext2/3/4.  When a new block bitmap is read from disk in read_block_bitmap() there are a few bits that should ALWAYS be set for each group.  In
particular, the blocks given by desc-&gt;bg_block_bitmap, desc-&gt;bg_inode_bitmap, and {desc-&gt;bg_inode_table, +sbi-&gt;s_itb_per_group}.  If any of those those bits (shifted to be relative to the current group, of course) are not set then the on-disk group descriptor is corrupt, or there is some problem reading it from disk and an ext3_error() should be called (possibly making the filesystem read-only).</span><br>
</div>
View <a href="http://linuxfs.pbwiki.com/EasyFsProjects">EasyFsProjects</a><br>
Change your <a href="http://linuxfs.pbwiki.com/notification.php">notification preferences</a>. You can also <a href="http://linuxfs.pbwiki.com/notification.php?verify=197c0&unsub=sandeen-linuxfs@sandeen.net">turn off emails<a/> completely.<br><br>
<br>
<b>New!</b> -- Get better control over your notifications and wiki experience.<br>
Sign up for a PBwiki identity. It's easy and free! Start at <a href="http://linuxfs.pbwiki.com/notification.php">my.pbwiki.com</a><br>(There was one <a href="http://linuxfs.pbwiki.com/changes.php">change</a> since your last notification 1 week, 6 days ago)



--b1_cdc9c504ca96a4c88fba1edfec0eb231--
