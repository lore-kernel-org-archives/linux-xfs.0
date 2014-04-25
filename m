Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 842E87F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 02:22:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D0A0AC006
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 00:22:09 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id tXMVzcCWGypxpNTk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Apr 2014 00:22:08 -0700 (PDT)
Message-ID: <535A0D05.1090004@oracle.com>
Date: Fri, 25 Apr 2014 15:21:41 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 05/10] xfs: fix error handling in xfs_bulkstat
References: <535078B8.4020905@oracle.com>
	<20140425064815.GB20871@infradead.org>
In-Reply-To: <20140425064815.GB20871@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On 04/25 2014 14:48 PM, Christoph Hellwig wrote:
>> Moreover, this fix also get rid of the redundant user buffer count
>> pre-checkups as it has already been validated in upper callers.
> 
>> -	if (!ubcountp || *ubcountp <= 0) {
>> -		return EINVAL;
>> -	}
> 
> Probably better to have this as a separate patch.

Sometimes, I'd to put such kind of trivial fixes into a relative effective patch
if possible. But from another point of view, yep, have it as a separate patch would
make it more convenient for reviewer.

> 
>> -			/*
>> -			 * Loop as long as we're unable to read the
>> -			 * inode btree.
>> -			 */
>> -			while (error) {
>> -				agino += XFS_INODES_PER_CHUNK;
>> -				if (XFS_AGINO_TO_AGBNO(mp, agino) >=
>> -						be32_to_cpu(agi->agi_length))
>> -					break;
>> -				error = xfs_inobt_lookup(cur, agino,
>> -							 XFS_LOOKUP_GE, &tmp);
>> -				cond_resched();
>> -			}
> 
> This code goes back to 1995, but I still can't see how it would make
> sense.  I think we should get rid of this, but I'd also love to have
> Dave and Eric double check it as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
