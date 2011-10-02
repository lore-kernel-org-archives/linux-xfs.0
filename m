Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p92JB9GS144946 for <xfs@oss.sgi.com>; Sun, 2 Oct 2011 14:11:10 -0500
Received: from mga01.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AE9F16B1DC3
	for <xfs@oss.sgi.com>; Sun,  2 Oct 2011 12:17:34 -0700 (PDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
	cuda.sgi.com with ESMTP id ZVpfPHvsuIli2AG0 for
	<xfs@oss.sgi.com>; Sun, 02 Oct 2011 12:17:34 -0700 (PDT)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: SEEK_DATA/SEEK_HOLE support
References: <4E887D7F.2010306@oracle.com>
	<20111002154259.GA14543@infradead.org> <4E888C0D.9060701@oracle.com>
	<20111002175902.GA9420@infradead.org>
Date: Sun, 02 Oct 2011 12:11:07 -0700
In-Reply-To: <20111002175902.GA9420@infradead.org> (Christoph Hellwig's
	message of "Sun, 2 Oct 2011 13:59:02 -0400")
Message-ID: <m2fwjbky44.fsf@firstfloor.org>
MIME-Version: 1.0
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
Cc: Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:
>
> And the most important thing is of course adding QA for it.  Josef
> already wrote an xfstests case that needs to be resurrected, compared
> against the latest Posix draft and if nessecary updated.

Also when you do it please make sure you don't break unlocked lseek()
The patches for that are in Al's queue.  Only take the lock
for SEEK_HOLE/DATA, but not for the other operations. Use the
new helper instead of cut'n'pasting code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
