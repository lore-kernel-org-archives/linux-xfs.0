Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 85B437F50
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 04:53:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35018AC001
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 02:53:04 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id R91LjxoV1XqcarZ6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Dec 2013 02:53:03 -0800 (PST)
Message-ID: <52BC0A71.5010904@oracle.com>
Date: Thu, 26 Dec 2013 18:52:33 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs: simplify xfs_ail_max
References: <52B9829A.10804@oracle.com> <20131226100721.GA11950@infradead.org>
In-Reply-To: <20131226100721.GA11950@infradead.org>
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

On 12/26 2013 18:07 PM, Christoph Hellwig wrote:
> On Tue, Dec 24, 2013 at 08:48:26PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> We have already simplified xfs_ail_min() with a new list helper, i.e,
>> list_first_entry_or_null(), but xfs_ail_max() still remains as same
>> as there is no corresponding list helper we can use for now.  It's
>> fairly easy to simulate the list behavior of getting the last item
>> in the AIL, therefore we can simplify xfs_ail_max() and move it to
>> the header file to make this pair of AIL routines looks symmetrical.
> 
> The usageof list_last_entry is fine with me, as is making it inline.
> But I think using the explicit if is a lot more readable than the ? :
> expression.
Sounds sensible to me, will take care of it.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
