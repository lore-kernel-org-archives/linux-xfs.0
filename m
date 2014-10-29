Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B9107F47
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 05:34:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 18C19AC00C
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 03:34:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Oj5HbWrIan0jNE3Z for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 03:33:58 -0700 (PDT)
Date: Wed, 29 Oct 2014 21:33:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
Message-ID: <20141029103355.GI16186@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<5450686F.9070307@sandeen.net>
	<CAGdb-8d5-GuB40ZgP6uM5aQMi+qqaeFd=xqzuxWhM+1AaoLSVw@mail.gmail.com>
	<54506CD9.90403@sandeen.net>
	<CAGdb-8cGAzT_0ck-pJyQX-OcnE_3FPCA9TesHW7c_raDSKEXWg@mail.gmail.com>
	<20141029044017.GG16186@dastard>
	<CAGdb-8e=wttjj+wTj8wqRWyUUz+AUmz-O0=r3+HoJ5zGgV-dkQ@mail.gmail.com>
	<20141029075134.GB13323@dastard>
	<CAGdb-8dhPe9wvoGnUsFo2Q3EZWka+i2DcFN-AqJV_G09+=4f2w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGdb-8dhPe9wvoGnUsFo2Q3EZWka+i2DcFN-AqJV_G09+=4f2w@mail.gmail.com>
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

On Wed, Oct 29, 2014 at 05:21:52PM +0800, Tommy Wu wrote:
> Same testing in same machine (just different kernel).
> 
> 3.18-rc2:
> xfsdump will hang (the test.xfsdump.gz size stop around 57M)

Ugh, colliding fixes to the bulkstat code. pull again from
the xfs-fixes-for-3.18-rc3 branch and the hang should be fixed.

/me wonders why the new dump xfstest didn't pick this up

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
