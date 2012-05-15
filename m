Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FF9E8D194031 for <xfs@oss.sgi.com>; Tue, 15 May 2012 10:09:14 -0500
Date: Tue, 15 May 2012 10:13:31 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: file corruption issue
Message-ID: <20120515151331.GG16099@sgi.com>
References: <51509.110.174.53.110.1336699622.squirrel@boosthardware.com>
	<20120511165012.GC16099@sgi.com>
	<59946.110.174.53.110.1336959906.squirrel@boosthardware.com>
	<20120514142948.GS3963@sgi.com>
	<64776.110.174.53.110.1337043522.squirrel@boosthardware.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <64776.110.174.53.110.1337043522.squirrel@boosthardware.com>
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
To: Patrick Shirkey <pshirkey@boosthardware.com>
Cc: xfs@oss.sgi.com


On Tue, May 15, 2012 at 02:58:42AM +0200, Patrick Shirkey wrote:
> Unfortunately I cannot unmount the partition/s to run xfs_metadump because
> they are in use.
> 
> I have found some files that were truncated on a recent crash. Is there
> any tool I can run on those files to get info that might be useful?

Hrm.. xfs_bmap output could be helpful so we can see the block map.  Do you
know how big they are supposed to be?  How much was truncated?

Unfortunately since you don't know which database will have the corruption...
you'll need to get xfs_bmap output for all of them, and then after a crash get
the 'after'.  Is that a possibility?

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
