Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E0CD7F58
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 11:26:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38C88AC001
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:26:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AAJgecJsDbhGdjjP for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 09:26:12 -0700 (PDT)
Message-ID: <55BF9621.3090202@sandeen.net>
Date: Mon, 03 Aug 2015 09:26:09 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfs: dquots should be stamped with sb_meta_uuid
References: <1438587625-31437-1-git-send-email-david@fromorbit.com>	<1438587625-31437-5-git-send-email-david@fromorbit.com>
	<55BF9575.2010106@sandeen.net>
In-Reply-To: <55BF9575.2010106@sandeen.net>
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

On 8/3/15 9:23 AM, Eric Sandeen wrote:
> On 8/3/15 12:40 AM, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Once the sb_uuid is changed, the wrong uuid is stamped into new
>> dquots on disk. Found by inspection, verified by generic/219.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

And yeah, sigh, this was in a prior version of my patch as well.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
