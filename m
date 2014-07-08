Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 64BB77F3F
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 16:04:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D42AAAC003
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 14:04:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MKzHP3TPLWRQ5OUd for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 14:03:55 -0700 (PDT)
Date: Wed, 9 Jul 2014 07:03:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Error (failing assert) in xfs_repair
Message-ID: <20140708210352.GA22339@dastard>
References: <trinity-abe1fdb7-c48f-4186-bc36-343c584e19d8-1404830904979@3capp-gmx-bs08>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <trinity-abe1fdb7-c48f-4186-bc36-343c584e19d8-1404830904979@3capp-gmx-bs08>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Hans Kraus <hans.w.kraus@gmx.at>
Cc: xfs@oss.sgi.com

On Tue, Jul 08, 2014 at 04:48:25PM +0200, Hans Kraus wrote:
> <html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>
> <div>Hi,</div>

Hi, can you please use text-only email, not html email?

> <div>I installed xfstools from the git repository on my debian 7 amd64<br/>
> backup server. I got the following assertion error:<br/>
> -------------------------------------------------------------------<br/>
> root@elefant:/home/kraush# xfs_repair -L /dev/vg_stor1/lv_stor1<br/>

What commit did you pull from? Also, a bit more information about
your filesystem and storage will help us:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> Phase 1 - find and verify superblock...<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - reporting progress in intervals of 15 minutes<br/>
> Phase 2 - using internal log<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - zero log...<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan filesystem freespace and inode maps...<br/>
> zeroing unused portion of secondary superblock (AG #20)<br/>
> Metadata corruption detected at block 0x2b9e8a001/0x200<br/>
> zeroing unused portion of secondary superblock (AG #16)<br/>
> bad agbno 4274958142 in agfl, agno 16<br/>
> freeblk count 1 != flcount 1806214135 in ag 16<br/>
> bad agbno 131784061 for btbno root, agno 16<br/>
> bad agbno 1628187110 for btbcnt root, agno 16<br/>
> agf_freeblks 2414458438, counted 0 in ag 16<br/>
> agf_longest 1482451932, counted 0 in ag 16<br/>
> agf_btreeblks 4031360978, counted 0 in ag 16<br/>
> bad agbno 1207336865 for inobt root, agno 16<br/>
> agi_count 1835626108, counted 0 in ag 16<br/>
> agi_freecount 952362526, counted 0 in ag 16<br/>
> xfs_repair: scan.c:1579: scan_ag: Assertion &#96;agf_dirty &#124;&#124;<br/>
> agfbuf-&gt;b_error != 117&#39; failed.<br/>

So AG 16 has garbage in superblock, the AGF and the AGI. How did
that happen? What went wrong with the storage that lead you to run
xfs_repair?

I think I see the problem, but I first need to confirm what assert
is firing by matching commits.

> root@elefant:/home/kraush#<br/>
> -------------------------------------------------------------------<br/>
> What shall I do to repair the file system (about 16 TB, 88% full,<br/>
> backuppc storage medium).</div>

You'll probably have to wait for a patch to fix the problem. The
sooner I can confirm the assert you hit, the sooner I'll be able to
get you that patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
