Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45AB77CAE
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:06:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F17378F8039
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:06:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8QBCfGyu6Wt7y88v for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 08:06:25 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7DADC4AC120
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:06:25 -0500 (CDT)
Subject: Re: [PATCH] xfs_quota: fall back silently if XFS_GETNEXTQUOTA fails
References: <1470120540-15135-1-git-send-email-zlang@redhat.com>
	<20160802122721.GE31492@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ee3edb6b-b218-88d5-abef-1b0b76c345ca@sandeen.net>
Date: Tue, 2 Aug 2016 10:06:24 -0500
MIME-Version: 1.0
In-Reply-To: <20160802122721.GE31492@infradead.org>
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



On 8/2/16 7:27 AM, Christoph Hellwig wrote:
> On Tue, Aug 02, 2016 at 02:49:00PM +0800, Zorro Lang wrote:
>> After XFS_GETNEXTQUOTA feature has been merged into linux kernel and
>> xfsprogs, xfs_quota use Q_XGETNEXTQUOTA for report and dump, and
>> fall back to old XFS_GETQUOTA ioctl if XFS_GETNEXTQUOTA fails.
>>
>> But when XFS_GETNEXTQUOTA fails, xfs_quota print a warning as
>> "XFS_GETQUOTA: Invalid argument". That's due to kernel can't
>> recognize XFS_GETNEXTQUOTA ioctl and return EINVAL. At this time,
>> the warning is helpless, xfs_quota just need to fall back.
> 
> We'd still want to report other errors, right?

I advised Zorro to do it this way, because -EINVAL can have a few
meanings, and we don't know for sure why we got it.  Could be a
bad cmd, or a bad type, or ...

If it fails, we're going to fall back anyway, so for any other
error we'd print it twice; on the fallback, we'd print the real
unexpected error anyway, so I think the user will get the relevant
information in this case.

But I guess we could do:

+	/* EINVAL is expected for XFS_GETNEXTQUOTA on older kernels */
 	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
+		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
+		    (cmd == XFS_GETNEXTQUOTA && errno != EINVAL)

and then change what we print (not perror("XFS_GETQUOTA") in all cases)?

But if we got i.e. EPERM, we'd print the EPERM error twice; once for the
first call, and once for the fallback.  I suppose that'd be ok, but not
sure it's helpful.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
