Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 482D37F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 15:53:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 360528F8037
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 13:52:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wjCgAVqf23UkDW9B for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 13:52:55 -0700 (PDT)
Date: Thu, 30 Oct 2014 07:52:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
Message-ID: <20141029205252.GG13323@dastard>
References: <54506CD9.90403@sandeen.net>
	<CAGdb-8cGAzT_0ck-pJyQX-OcnE_3FPCA9TesHW7c_raDSKEXWg@mail.gmail.com>
	<20141029044017.GG16186@dastard>
	<CAGdb-8e=wttjj+wTj8wqRWyUUz+AUmz-O0=r3+HoJ5zGgV-dkQ@mail.gmail.com>
	<20141029075134.GB13323@dastard>
	<CAGdb-8dhPe9wvoGnUsFo2Q3EZWka+i2DcFN-AqJV_G09+=4f2w@mail.gmail.com>
	<20141029103355.GI16186@dastard> <20141029104304.GC13323@dastard>
	<CAGdb-8dxgsrywS_GtgM8Y7N1fYfxgZPr4sBQ1QiuqhJ_hHDFSg@mail.gmail.com>
	<20141029195006.GD13323@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141029195006.GD13323@dastard>
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
To: Tommy Wu <wu.tommy@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <xfs@oss.sgi.com>

On Thu, Oct 30, 2014 at 06:50:06AM +1100, Dave Chinner wrote:
> On Wed, Oct 29, 2014 at 08:32:52PM +0800, Tommy Wu wrote:
> > Does it just fix the hang issue or fix the dump corrupted issue?
> 
> The hang.

FWIW, can you run xfs_repair -n on your filesystem and post the
output? Can you also run a full dump and restore and post the
*entire* output of both?

Also, all the other information noted here would be useful:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
