Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E36477F3F
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 16:26:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C31D08F8049
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 14:26:25 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id A8bIq7Y2v6Qvtzri
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 14:26:25 -0700 (PDT)
Message-ID: <544C159E.8010408@hardwarefreak.com>
Date: Sat, 25 Oct 2014 16:26:54 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: file streams allocator behavior
References: <544BF26F.6000708@clear.net.nz>
In-Reply-To: <544BF26F.6000708@clear.net.nz>
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
To: Richard Scobie <r.scobie@clear.net.nz>, xfs@oss.sgi.com

On 10/25/2014 01:56 PM, Richard Scobie wrote:
> Stan Hoeppner said:
> 
>> How can I disable or change the filestreams behavior so all files go
>> into the one AG for the single directory test?
> 
> Hi Stan,
> 
> Instead of mounting with -o filestreams, would using the chattr flag
> instead help?
> 
> See
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch06s16.html

That won't help.  That turns it on (if it's not enabled by default these
days).  I need to turn off the behavior I'm seeing, whether it's due to
the filestreams allocator or default inode64.  Then again it may not be
possible to turn it off...

Anyone have other ideas on how to accomplish my goal?  Parallel writes
to a single AG on the outer platter edge vs the same to all AGs across
the entire platter?  I'm simply trying to demonstrate the differences in
aggregate bandwidth due to the extra seek latency of all AGs case.

Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
