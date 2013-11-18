Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4AFD29DF9
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 06:40:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7457BAC006
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 04:40:20 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7GvhLIsym8uLbeZ2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 04:40:19 -0800 (PST)
Message-ID: <528A0AE5.40702@oracle.com>
Date: Mon, 18 Nov 2013 20:41:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 4/4] xfs: implement parallism quota check
References: <5281F527.3040200@oracle.com>
	<20131115172626.GD16942@infradead.org>
	<5288BE14.1050302@oracle.com> <20131118110449.GB1304@infradead.org>
In-Reply-To: <20131118110449.GB1304@infradead.org>
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

On 11/18 2013 07:04 PM, Christoph Hellwig wrote:

> On Sun, Nov 17, 2013 at 09:01:08PM +0800, Jeff Liu wrote:
>> On 11/16 2013 01:26 AM, Christoph Hellwig wrote:
>>> As Dave pointed out this really should be xfs_bukstat_ag.  But looking
>>> at the code you're almost 90% there anyway.
>> One main reason I did not make a per ag bulkstat is because bulkstat() will
>> skip an allocation group if read agi buffer failed, i.e,
>>
>> while (XFS_BULKSTAT_UBLEFT(ubleft) && agno < mp->m_sb.sb_agcount) {
>> 	cond_resched();
>> 	error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
>> 	if (error) {
>> 		/*
>> 		 * Skip this allocation group and go to the next one.
>> 		 */
>> 		agno++;
>>                 agino = 0;
>> 		continue;
>> 	}
>> 	....
>> }
>>
>> Should it capture this issue and drop a warning in this case?
> 
> I've been thinking hard about this, but I can't really see any reason
> why we would skip an AG instead of propagating the error.  The only
> error xfs_ialloc_read_agi can return is an I/O error from reading
> the buffer from disk, and we'd really want to propagate that sort
> of I/O errror.  I'd suggest a patch at the beginning of the series
> to just change that behavior for all the two places in bulkstat that
> call xfs_ialloc_read_agi.  None of the other callers seem to behave
> this way either.

Ok, thanks for clearing up my confusion.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
