Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OLHj1f056036 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 16:17:45 -0500
Received: from crcuda.crossroads.com (crcuda.crossroads.com [66.219.50.99]) by
	cuda.sgi.com with ESMTP id Mb5aOgy6YqIIZDFZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 14:19:29 -0700 (PDT)
Message-ID: <50885B60.9050904@crossroads.com>
Date: Wed, 24 Oct 2012 16:19:28 -0500
From: Wayne Walker <wwalker@crossroads.com>
MIME-Version: 1.0
Subject: Re: File system corruption
References: <5077077A.3040608@crossroads.com> <20121011210741.GC2739@dastard>
	<50789076.7040402@crossroads.com> <20121013001425.GN2739@dastard>
In-Reply-To: <20121013001425.GN2739@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/12/2012 07:14 PM, Dave Chinner wrote:
<snip>
> And SB/AGF 3 and 4 are ok, too. So, the filesystem headers just beyond 
> the 2TB offset are zero. That tends to point to a block device 
> problem, as an offset of 2TB is where a 32 bit sector count will 
> overflow (i.e. 2^32). Next step is to run blktrace/blkparse on the cp 
> workload that generates the error to see if anything actually writes 
> to the 2TB offset region, and if so, where it comes from. Probably 
> best to compress the resultant blkparse output file - it might be 
> quite large but the text will compress well. Cheers, Dave. 

Dave,

Thank you for your help.

10 MB .gz file at http://rx-7.bybent.com/blktrace.sde1.out.gz

What I can see seems to have most of the writes are around 2^31.

Wayne

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
