Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1PFkhqr156126 for <xfs@oss.sgi.com>; Sat, 25 Feb 2012 09:46:43 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id MQaI9Cga7wmUXs9f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Feb 2012 07:46:41 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1S1JpZ-0004wD-Dn
	for xfs@oss.sgi.com; Sat, 25 Feb 2012 07:46:41 -0800
Message-ID: <33390983.post@talk.nabble.com>
Date: Sat, 25 Feb 2012 07:46:41 -0800 (PST)
From: Kamal Dasu <kdasu.kdev@gmail.com>
Subject: Re: [PATCH 4/4] V2 xfs: fix deadlock in xfs_rtfree_extent with
	kernel v2.6.37
In-Reply-To: <20120225094030.GA3148@infradead.org>
MIME-Version: 1.0
References: <33345988.post@talk.nabble.com> <33346009.post@talk.nabble.com>
	<33346035.post@talk.nabble.com> <33346043.post@talk.nabble.com>
	<33346051.post@talk.nabble.com>
	<20120219224118.GA31535@infradead.org>
	<33365485.post@talk.nabble.com> <33379323.post@talk.nabble.com>
	<20120225094030.GA3148@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Christoph,

I have not been able to create a simple test case for this yet.

Currently the only way I have is to use an a time shift recording
application 
that stored video streams on a real-time subvolume.  Sometimes when such
a stream is deleted I see the problem. I have not  figured out how a test to 
consistently get allocation where the bit map span multiple extents while 
freeing  the inode. 

I am still trying to come with a simple test case. 
If you have any ideas let me know I will be happy to try it out.

Kamal



Christoph Hellwig wrote:
> 
> On Thu, Feb 23, 2012 at 08:52:57AM -0800, Kamal Dasu wrote:
>> 
>> To fix the deadlock caused by recursively calling xfs_rtfree_extent
>> from xfs_bunmapi():
>> 
>>  - removed  xfs_trans_iget() from xfs_rtfree_extent(),
>>    instead added asserts that the inode is locked and has an inode_item
>>    attached to it.
>>  - in xfs_bunmapi() when dealing with an inode with the rt flag
>>    call xfs_ilock() and xfs_trans_ijoin() so that the
>>    reference count is bumped on the inode and attached it to the
>>    transaction before calling into xfs_bmap_del_extent, similar to
>>    what we do in xfs_bmap_rtalloc.
>> 
>> Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
> 
> This looks good, thanks a lot!
> 
> Do you have an easily reproducable testcase for this which we could
> put into xfstests?
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

-- 
View this message in context: http://old.nabble.com/-PATCH-0-4--RFC-xfs%3A-resurrect-realtime-subvolume-support-on-kernel-2.6.37-tp33345988p33390983.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
