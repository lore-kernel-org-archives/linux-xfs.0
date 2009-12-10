Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBA1GV15025423 for <xfs@oss.sgi.com>; Wed, 9 Dec 2009 19:16:32 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0781DEC43A
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2009 17:17:06 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id Cu4K979ESyDxLCOl for
	<xfs@oss.sgi.com>; Wed, 09 Dec 2009 17:17:06 -0800 (PST)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.4 #31773)
	id <01NH2PS31OSG90W6CH@mx.isti.cnr.it> for xfs@oss.sgi.com; Thu,
	10 Dec 2009 02:16:16 +0100
Date: Thu, 10 Dec 2009 02:16:35 +0100
From: Asdo <asdo@shiftmail.org>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
In-reply-to: <4B204783.7040109@shiftmail.org>
Message-id: <4B204BF3.1000600@shiftmail.org>
MIME-version: 1.0
References: <4B204334.1000605@shiftmail.org> <4B204783.7040109@shiftmail.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-raid <linux-raid@vger.kernel.org>

Asdo wrote:
> Asdo wrote:
>> and I think I have seen around 10MB/sec when they are of 500KB (this 
>> transfer at 10MB/sec was in parallel with another faster one however). 
> Yes I definitely confirm: right now I have just 1 rsync copy running, 
> it's in a zone where files are around 500KB on average, and it's going 
> at 9 MB/sec.
> Stack traces of the writer process conform to what I have posted in my 
> previous email, even now that the writer is the only process using the 
> destination array.
Excuse me, I am going nuts...
In this case of 9MB/sec for 500KB files, stack traces on the writer are 
indeed very similar to what I have posted, but the relative frequency of 
the two type of stack traces is different:
20%: waiting on the reader (this almost never happened when using 
multiple parallel rsyncs)
50%: xlog_state_get_iclog_space+0xed/0x2d0
30%: xfs_buf_lock+0x1e/0x60


The reader is waiting either on select (on the writer I guess) or on this:
  [<ffffffff810da74d>] sync_page+0x3d/0x50
  [<ffffffff810da769>] sync_page_killable+0x9/0x40
  [<ffffffff810da682>] __lock_page_killable+0x62/0x70
  [<ffffffff810db8be>] T.768+0x1ee/0x440            
  [<ffffffff810dbbc6>] generic_file_aio_read+0xb6/0x1d0
  [<ffffffffa031cd95>] xfs_read+0x115/0x2a0 [xfs]     
  [<ffffffffa031832b>] xfs_file_aio_read+0x5b/0x70 [xfs]
  [<ffffffff8111ec32>] do_sync_read+0xf2/0x130         
  [<ffffffff8111f215>] vfs_read+0xb5/0x1a0             
  [<ffffffff8111f81c>] sys_read+0x4c/0x80              
  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b  
  [<ffffffffffffffff>] 0xffffffffffffffff              


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
