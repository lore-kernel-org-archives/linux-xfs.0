Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE5727F47
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 09:48:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA28130405F
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 07:48:27 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19]) by cuda.sgi.com
	with ESMTP id k19iHhGjIDM6J59b (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 07:48:26 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-abe1fdb7-c48f-4186-bc36-343c584e19d8-1404830904979@3capp-gmx-bs08>
From: "Hans Kraus" <hans.w.kraus@gmx.at>
Subject: Error (failing assert) in xfs_repair
Date: Tue, 8 Jul 2014 16:48:25 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7467487367090245652=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7467487367090245652==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>
<div>Hi,</div>

<div>I installed xfstools from the git repository on my debian 7 amd64<br/>
backup server. I got the following assertion error:<br/>
-------------------------------------------------------------------<br/>
root@elefant:/home/kraush# xfs_repair -L /dev/vg_stor1/lv_stor1<br/>
Phase 1 - find and verify superblock...<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - reporting progress in intervals of 15 minutes<br/>
Phase 2 - using internal log<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - zero log...<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan filesystem freespace and inode maps...<br/>
zeroing unused portion of secondary superblock (AG #20)<br/>
Metadata corruption detected at block 0x2b9e8a001/0x200<br/>
zeroing unused portion of secondary superblock (AG #16)<br/>
bad agbno 4274958142 in agfl, agno 16<br/>
freeblk count 1 != flcount 1806214135 in ag 16<br/>
bad agbno 131784061 for btbno root, agno 16<br/>
bad agbno 1628187110 for btbcnt root, agno 16<br/>
agf_freeblks 2414458438, counted 0 in ag 16<br/>
agf_longest 1482451932, counted 0 in ag 16<br/>
agf_btreeblks 4031360978, counted 0 in ag 16<br/>
bad agbno 1207336865 for inobt root, agno 16<br/>
agi_count 1835626108, counted 0 in ag 16<br/>
agi_freecount 952362526, counted 0 in ag 16<br/>
xfs_repair: scan.c:1579: scan_ag: Assertion &#96;agf_dirty &#124;&#124;<br/>
agfbuf-&gt;b_error != 117&#39; failed.<br/>
Aborted<br/>
root@elefant:/home/kraush#<br/>
-------------------------------------------------------------------<br/>
What shall I do to repair the file system (about 16 TB, 88% full,<br/>
backuppc storage medium).</div>

<div>Any help appreciated, Hans</div>

<div>&nbsp;</div>
</div></div></body></html>


--===============7467487367090245652==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7467487367090245652==--
