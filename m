Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0166A7F51
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 09:28:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4969304032
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 07:28:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id N3qT1BIvUsF9FjHg for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 07:28:49 -0700 (PDT)
Message-ID: <54FDAE25.6080907@sandeen.net>
Date: Mon, 09 Mar 2015 10:28:53 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: take XFS_IOLOCK_EXCL if suid removal is required
References: <54F9DBAE.2070002@redhat.com> <20150306210927.GA13958@dastard>
In-Reply-To: <20150306210927.GA13958@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 3/6/15 4:09 PM, Dave Chinner wrote:

...

>> Upgrade the lock to XFS_IOLOCK_EXCL in this case.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> I believe Jan Kara has already addressed this problem in
> this patchset:
> 
> http://oss.sgi.com/archives/xfs/2015-03/msg00051.html

Ah, yes, that should fix it.  Thanks Jan.

Sorry for missing it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
