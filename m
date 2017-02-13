Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: iomap infrastructure and multipage writes V5
From: xfs-owner@oss.sgi.com
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4458557028027014434=="
Message-ID: <mailman.5047.1487025124.4130.xfs@oss.sgi.com>
Date: Mon, 13 Feb 2017 16:32:04 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: sandeen@sandeen.net

--===============4458557028027014434==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This list has been closed.  Please subscribe to the
linux-xfs@vger.kernel.org mailing list and send any future messages
there. You can subscribe to the linux-xfs list at
http://vger.kernel.org/vger-lists.html#linux-xfs

For any questions please post to the new list.


--===============4458557028027014434==
Content-Type: message/rfc822
MIME-Version: 1.0

Return-Path: <sandeen@sandeen.net>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on oss.sgi.com
X-Spam-Level: 
X-Spam-Status: No, score=-100.0 required=5.0 tests=USER_IN_WHITELIST
	autolearn=ham version=3.3.1
X-Original-To: xfs@oss.sgi.com
Delivered-To: xfs@oss.sgi.com
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B06037CA0
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2017 16:32:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2632EAC006
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2017 14:31:59 -0800 (PST)
X-ASG-Debug-ID: 1487025117-0bf57b64d255edc0001-NocioJ
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with ESMTP id PDB41e7qLjcPy6JT for <xfs@oss.sgi.com>; Mon, 13 Feb 2017 14:31:57 -0800 (PST)
X-Barracuda-Envelope-From: sandeen@sandeen.net
X-Barracuda-Effective-Source-IP: sandeen.net[63.231.237.45]
X-Barracuda-Apparent-Source-IP: 63.231.237.45
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 1082678FC;
	Mon, 13 Feb 2017 16:31:56 -0600 (CST)
Subject: Re: iomap infrastructure and multipage writes V5
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
X-ASG-Orig-Subj: Re: iomap infrastructure and multipage writes V5
References: <1464792297-13185-1-git-send-email-hch@lst.de>
 <20160628002649.GI12670@dastard> <20160630172239.GA23082@lst.de>
 <20160718111400.GC16044@dastard> <20160718111851.GD16044@dastard>
 <20160731191900.GA29301@lst.de> <20160802234247.GO16044@dastard>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <75a139c8-5e49-3a89-10d1-20caeef3f69a@sandeen.net>
Date: Mon, 13 Feb 2017 16:31:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:45.0)
 Gecko/20100101 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20160802234247.GO16044@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: sandeen.net[63.231.237.45]
X-Barracuda-Start-Time: 1487025117
X-Barracuda-URL: https://192.48.176.25:443/cgi-mod/mark.cgi
X-Barracuda-Scan-Msg-Size: 1567
X-Virus-Scanned: by bsmtpd at sgi.com
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=2.7 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.36489
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header

On 8/2/16 6:42 PM, Dave Chinner wrote:
> On Sun, Jul 31, 2016 at 09:19:00PM +0200, Christoph Hellwig wrote:
>> Now after spending this much time I've started wondering why we even
>> reserve blocks in xfs_iomap_write_allocate - after all we've reserved
>> space for the actual data blocks and the indlen worst case in
>> xfs_bmapi_reserve_delalloc.  And in fact a little hack to drop that
>> reservation seems to solve both the root cause (depleted reserved pool)
>> and the cleanup mess.  I just haven't spend enought time to convince
>> myself that it's actually safe, and in fact looking at the allocator
>> makes me thing it only works by accident currently despite generally
>> postive test results.
>>
>> Here is the quick patch if anyone wants to chime in:
>>
>> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
>> index 620fc91..67c317f 100644
>> --- a/fs/xfs/xfs_iomap.c
>> +++ b/fs/xfs/xfs_iomap.c
>> @@ -717,7 +717,7 @@ xfs_iomap_write_allocate(
>>  
>>  		nimaps = 0;
>>  		while (nimaps == 0) {
>> -			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>> +			nres = 0; // XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>>  
>>  			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, nres,
>>  					0, XFS_TRANS_RESERVE, &tp);
>>
> 
> This solves the problem for me, and from history appears to be the
> right thing to do. Christoph, can you send a proper patch for this?

Did anything ever come of this?  I don't think I saw a patch, and it looks
like it is not upstream.

Thanks,
-Eric

> Cheers,
> 
> Dave.
> 


--===============4458557028027014434==--
