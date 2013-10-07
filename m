Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 871D07F52
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 20:46:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 71B728F8039
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 18:46:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id quDPVnuEk4SBkbii for <xfs@oss.sgi.com>;
	Sun, 06 Oct 2013 18:46:04 -0700 (PDT)
Message-ID: <5252125B.2040300@sandeen.net>
Date: Sun, 06 Oct 2013 20:46:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 46/55] xfs: Add xfs_log_rlimit.c
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-47-git-send-email-david@fromorbit.com>
	<5251A450.4000407@sandeen.net>
In-Reply-To: <5251A450.4000407@sandeen.net>
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

On 10/6/13 12:56 PM, Eric Sandeen wrote:
> On 9/4/13 5:05 PM, Dave Chinner wrote:
>> > From: Jie Liu <jeff.liu@oracle.com>
>> > 
>> > Add source files for xfs_log_rlimit.c The new file is used for log
>> > size calculations and validation shared with userspace.
>> > 
>> > [dchinner: xfs_log_calc_max_attrsetm_res() does not modify the
>> > tr_attrsetm reservation, just calculates the maximum. ]
>> > 
>> > [dchinner: rework loop in xfs_log_get_max_trans_res() ]
>> > 
>> > [dchinner: implement xfs_log_calc_unit_res() in util.c to give mkfs
>> > a worse case calculation of the log size needed. ]
> 2 things:
> 
> Ben, seems like your workflow lost the:
> 
> From: Jie Liu <jeff.liu@oracle.com>
> 
> at the top - in git, the author is listed as Dave in git.
> 
> (Although those [parentheticals] were pretty fundamental changes,
> something I just gave Rich a hard time for)  ;)
> 
> Also, this now breaks xfstest xfs/216 as a result of the mkfs changes.
> What are the plans for that?

Sorry, to be clear, it breaks that test (and others, pretty sure)
because the log sizes for small filesystems are significantly bigger:

-fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
+fssize=1g log      =internal log           bsize=4096   blocks=12800, version=2

-fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
+fssize=2g log      =internal log           bsize=4096   blocks=12800, version=2

-fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
+fssize=4g log      =internal log           bsize=4096   blocks=12800, version=2

-fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
+fssize=8g log      =internal log           bsize=4096   blocks=12800, version=2

-fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
+fssize=16g log      =internal log           bsize=4096   blocks=12800, version=2

-fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
+fssize=32g log      =internal log           bsize=4096   blocks=12800, version=2

-fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2
+fssize=64g log      =internal log           bsize=4096   blocks=12800, version=2

 fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
 fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2

-Eric
 
> Thanks,
> -Eric
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
