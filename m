Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA3977F5D
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 11:27:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 950A4AC002
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:27:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TCRuokkupq0rTYB3 for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 09:27:52 -0700 (PDT)
Message-ID: <55BF9686.30101@sandeen.net>
Date: Mon, 03 Aug 2015 09:27:50 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs: fix sb_meta_uuid usage
References: <1438587625-31437-1-git-send-email-david@fromorbit.com>	<1438587625-31437-2-git-send-email-david@fromorbit.com>
	<55BF92DF.6080506@sandeen.net>
In-Reply-To: <55BF92DF.6080506@sandeen.net>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 8/3/15 9:12 AM, Eric Sandeen wrote:
> On 8/3/15 12:40 AM, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> After changing the UUID on a v5 filesystem, xfstests fails
>> immediately on a debug kernel with:
>>
>> XFS: Assertion failed: uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid), file: fs/xfs/xfs_inode.c, line: 799
>>
>> This needs to check against the sb_meta_uuid, not the user visible
>> UUID that was changed.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> first of a few brown paper bags for me :(  I guess I didn't test on debug after all.  :(

Actually I did, this was also in my prior patches.  Le sigh.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
