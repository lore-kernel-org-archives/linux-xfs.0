Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9344U19172025 for <xfs@oss.sgi.com>; Sun, 2 Oct 2011 23:04:30 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 697C41F1866F
	for <xfs@oss.sgi.com>; Sun,  2 Oct 2011 21:04:28 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id jmLVR7jU3XEBe8yW for
	<xfs@oss.sgi.com>; Sun, 02 Oct 2011 21:04:28 -0700 (PDT)
Message-ID: <4E89343B.4030007@oracle.com>
Date: Mon, 03 Oct 2011 12:04:11 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: SEEK_DATA/SEEK_HOLE support
References: <4E887D7F.2010306@oracle.com>
	<20111002154259.GA14543@infradead.org>
	<4E888C0D.9060701@oracle.com> <20111002175902.GA9420@infradead.org>
In-Reply-To: <20111002175902.GA9420@infradead.org>
Reply-To: jeff.liu@oracle.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 10/03/2011 01:59 AM, Christoph Hellwig wrote:

> On Mon, Oct 03, 2011 at 12:06:37AM +0800, Jeff Liu wrote:
>> IMHO, to avoid data loss in some user application like cp(1), for
>> unwritten extents, we always need to check the pages status.  Just as
>> you mentioned above, return the map offset if pages are dirty for
>> SEEK_DATA, or a hole found.
> 
> I'd suggest to first implement the simple versions I schemed below,
> which would treat unwritten extents as data.  That is sub-optimal,
> but a) safe and b) easy to implement.  The second step would be to
> add probing for unwritten extents, which is even something we could
> do as a common helper routine shared by filesystems.

So I'll wait for Dave's patch become ready, and then continue to improve
it if necessary.
In the meantime, I'll try to figure out how to add a helper which can be
shared by all file systems for UNWRITTEN extents.

> 
> And the most important thing is of course adding QA for it.  Josef
> already wrote an xfstests case that needs to be resurrected, compared
> against the latest Posix draft and if nessecary updated.




Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
