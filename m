Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5BCB57F53
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 06:33:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 40AAC8F8033
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 04:33:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ShbD5XrhJNAjEh7q for
	<xfs@oss.sgi.com>; Fri, 06 Sep 2013 04:33:43 -0700 (PDT)
Message-ID: <5229BCB8.2070207@redhat.com>
Date: Fri, 06 Sep 2013 07:30:00 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 07/11] xfs: retry trans reservation on ENOSPC in
	xfs_inactive()
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-8-git-send-email-bfoster@redhat.com>
	<20130905014016.GU23571@dastard> <5228AED7.1010700@redhat.com>
	<20130906001718.GQ12779@dastard>
In-Reply-To: <20130906001718.GQ12779@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/05/2013 08:17 PM, Dave Chinner wrote:
> On Thu, Sep 05, 2013 at 12:18:31PM -0400, Brian Foster wrote:
>> On 09/04/2013 09:40 PM, Dave Chinner wrote:
>>> On Tue, Sep 03, 2013 at 02:25:04PM -0400, Brian Foster wrote:
>>>> An ifree data block reservation can fail with ENOSPC. Flush inodes
>>>> to try and free up space or attempt without a data block
>>>> reservation to avoid failing out of xfs_inactive().
>>>>
>>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>>>> ---
>>>>  fs/xfs/xfs_inode.c | 11 +++++++++++
>>>>  1 file changed, 11 insertions(+)
>>>>
...
> 
>> Subsequent to avoiding that, I
>> believe there were inconsistent fs issues called out due to the unlinked
>> lists being populated after umount.
> 
> That sounds like a recovery failure, not so much an ENOSPC failure.
> i.e. that recovery only looks at the log to see if it's clean, and
> only recovers unlinked lists if it's dirty. There is the
> *possibility* of having a clean log with inodes on the unlinked
> list, and log recovery doesn't run the unlinked list processing in
> that case.
> 

Interesting, I'll have a closer look when I rework the inactive
transaction reservation bits. Thanks.

Brian

> This is one of the issues we'll need to fix for O_TMPFILE support
> as it will actively use inodes on unlinked list for potentially long
> periods of time.
> 
>> Taking a further look, I missed the XFS_TRANS_RESERVE flag and whole
>> m_resblks mechanism. I'll take a closer look at that and see if that
>> works to resolve the problem instead of the flush.
> 
> It should - the only time it won't is if we exhaust the pool, but
> that doesn't happen in normal ENOSPC situations and any blocks we do
> end up freeing will immediately refill the reserve pool...
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
