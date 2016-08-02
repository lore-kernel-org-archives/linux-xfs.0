Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F41D37CAE
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:54:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 93C1C304048
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:54:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vGCLAY388AcnCOt3 for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 08:54:54 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3225A4AC120
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:54:54 -0500 (CDT)
Subject: Re: [PATCH] xfs_quota: fall back silently if XFS_GETNEXTQUOTA fails
References: <1470120540-15135-1-git-send-email-zlang@redhat.com>
	<20160802122721.GE31492@infradead.org>
	<20160802131427.GD16413@zlang.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <564b87af-e3b2-5abf-4000-5f068191fc80@sandeen.net>
Date: Tue, 2 Aug 2016 10:54:53 -0500
MIME-Version: 1.0
In-Reply-To: <20160802131427.GD16413@zlang.usersys.redhat.com>
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
To: xfs@oss.sgi.com



On 8/2/16 8:14 AM, Zorro Lang wrote:
> On Tue, Aug 02, 2016 at 05:27:21AM -0700, Christoph Hellwig wrote:
>> On Tue, Aug 02, 2016 at 02:49:00PM +0800, Zorro Lang wrote:
>>> After XFS_GETNEXTQUOTA feature has been merged into linux kernel and
>>> xfsprogs, xfs_quota use Q_XGETNEXTQUOTA for report and dump, and
>>> fall back to old XFS_GETQUOTA ioctl if XFS_GETNEXTQUOTA fails.
>>>
>>> But when XFS_GETNEXTQUOTA fails, xfs_quota print a warning as
>>> "XFS_GETQUOTA: Invalid argument". That's due to kernel can't
>>> recognize XFS_GETNEXTQUOTA ioctl and return EINVAL. At this time,
>>> the warning is helpless, xfs_quota just need to fall back.
>>
>> We'd still want to report other errors, right?
> 
> Yes. This patch will make xfs_quota's report and dump command report
> nothing if XFS_GETNEXTQUOTA fails and falls back to XFS_GETQUOTA.
> 
> But if XFS_GETQUOTA fails, it'll report errors.
> 
> As I mentioned in email, we don't report errors if XFS_GETNEXTQUOTA
> fails, or we don't report errors if kernel has no XFS_GETNEXTQUOTA
> feature? The first one won't report any errors from XFS_GETNEXTQUOTA call,
> include kernel has no this feature. 
> 
> So:
> "cmd == XFS_GETQUOTA" or "!(cmd == XFS_GETNEXTQUOTA && errno == EINVAL)"

Oh, I see, this is what I was trying to do before coffee in my earlier
reply, and failed.  :)

> I think they all make sense. Do you have any suggestions?

Ignoring EINVAL only for XFS_GETNEXTQUOTA seems like a reasonable
idea - we might print two warnings for other errors, though -
that might be a little odd, but not terrible.

I think the patch as it stands is ok; unexpected errors will be caught
and printed on the fallback, and we don't need extra complexity around
printing two different command names that way.

But if there's preference for printing failure information for
both calls, that's fine with me, as long as we filter out EINVAL for
GETNEXTQUOTA.

-Eric

> Thanks,
> Zorro
> 
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
