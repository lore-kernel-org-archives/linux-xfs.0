Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 757807CA1
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 23:58:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37609304048
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 21:58:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3bw9JHbaod2EAau8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 21:58:41 -0700 (PDT)
Subject: Re: [PATCH 2/3] block: require write_same and discard requests align
	to logical block size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
	<146612626092.12764.773833541076937471.stgit@birch.djwong.org>
Date: Wed, 29 Jun 2016 00:58:06 -0400
In-Reply-To: <146612626092.12764.773833541076937471.stgit@birch.djwong.org>
	(Darrick J. Wong's message of "Thu, 16 Jun 2016 18:17:41 -0700")
Message-ID: <yq1oa6ksiap.fsf@sermon.lab.mkp.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

Darrick> Make sure that the offset and length arguments that we're using
Darrick> to construct WRITE SAME and DISCARD requests are actually
Darrick> aligned to the logical block size.  Failure to do this causes
Darrick> other errors in other parts of the block layer or the SCSI
Darrick> layer because disks don't support partial logical block writes.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
