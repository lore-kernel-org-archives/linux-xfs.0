Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3JJrTq6114238 for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 14:53:30 -0500
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id VMtoAgjnrPFVzCmH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Apr 2012 12:53:27 -0700 (PDT)
Message-ID: <4F906D8A.9040504@sauce.co.nz>
Date: Fri, 20 Apr 2012 07:54:50 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: Fragmentation Issue We Are Having
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
Cc: b.candler@pobox.com

Brian Candler wrote:

--------------------------

Ah, that's new to me. So with inode32 and
   sysctl fs.xfs.rotorstep=255
you can get roughly the same locality benefit for sequentially-written files
as inode64?  (Aside: if you have two processes writing files to two 
different
directories, will they end up mixing their files in the same AG? That
could hurt performance at readback time if reading them sequentially)

-----------------------------

The "filestreams" mount option may be of use here, see:

http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/ch06s16.html

and page 17 of:

http://oss.sgi.com/projects/xfs/training/xfs_slides_06_allocators.pdf

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
