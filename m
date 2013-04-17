Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 38BF67F4E
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 13:23:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 226C8304064
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 11:23:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WqT06ggnnAovzL6B for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 11:23:30 -0700 (PDT)
Message-ID: <516EE8A1.9070703@sandeen.net>
Date: Wed, 17 Apr 2013 11:23:29 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: replace xfs_check with xfs_repair -n
References: <1366216695.3762.32325.camel@chandra-dt.ibm.com>
	<516ED4A0.9040706@sandeen.net>
	<1366221810.3762.32341.camel@chandra-dt.ibm.com>
In-Reply-To: <1366221810.3762.32341.camel@chandra-dt.ibm.com>
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
To: sekharan@us.ibm.com
Cc: XFS mailing list <xfs@oss.sgi.com>

On 4/17/13 11:03 AM, Chandra Seetharaman wrote:
> Hi Eric,
> 
> Thanks for the quick feedback.
> 
> On Wed, 2013-04-17 at 09:58 -0700, Eric Sandeen wrote:
>> On 4/17/13 9:38 AM, Chandra Seetharaman wrote:
>>> Replace the usage of "xfs_check" with "xfs_repair -n" as xfs_check
>>> is planned to be depracated.
>>
>> Hm, I thought the plan was to keep xfs_check around for xfstests
> 
> I didn't think the plan was to keep xfs_check, may be I misunderstood.
> My understanding was that we wanted to deprecate xfs_check, but first we
> have to make xfstests not use xfs_check.
> 
>> use, for now; as Dave said in the earlier thread:
>>
>>> xfstests also still needs to run xfs_check. That means we also need
>>> either an override flag an make $XFS_CHECK_PROG have it set
>>> appropriately or add an internal xfs_db wrapper that runs the
>>> xfs_check functionality appropriately. The second is probably the
>>> better option...
>>
>> but that's not what this patch does...
> 
> The usages of xfs_check in xfstests looked simple and straight forward.
> Besides, I thought we should do what we suggest our users to do :),
> hence replaced xfs_check with "xfs_repair -n".

Dave or others can chime in too, but I think we still want xfs_check
(xfs_db) as a verifier against xfs_repair.

> Does this patch break something or technically incorrect ?

We used to explicitly run both xfs_repair and xfs_check to get two
distinct verification passes; the patch removes part of that, so I'd
say yes, it does "break" things a little.

> Do you think I should instead use 
>     xfs_db -F -i -p xfs_check -c "check" <dev>

Right, if the xfs_check script itself is going away, I think we still
want to invoke "xfs_check" behavior one way or another in xfstests to
keep current xfs verification levels for now.

Thanks,
-Eric

> Please advise.




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
