Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 616268040
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 11:10:45 -0500 (CDT)
Message-ID: <51434820.6010100@sgi.com>
Date: Fri, 15 Mar 2013 11:11:12 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: test writing to device node on an RO
	filesystem
References: <514243C0.1000309@redhat.com> <5142896E.9060609@sandeen.net>
	<5143457A.6060303@sgi.com> <514345D5.8090005@sandeen.net>
In-Reply-To: <514345D5.8090005@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 03/15/2013 11:01 AM, Eric Sandeen wrote:
> On 3/15/13 10:59 AM, Rich Johnston wrote:
>> Eric,
>>
>> Thanks again for the new test. A few minor issues that can be corrected at commit time.
>>
>> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
>>
>> I can correct this a commit time.
>>
>> quilt refresh
>> Warning: trailing whitespace in line 24 of 306
>> Refreshed patch patches/V2-xfstests-test-writing-to-device-node-on-an-RO-filesystem.patch
>>
>> Do you also want me to add this top the quick group as Dave suggested when I commit this?
>
> Sure, thanks for that, and sorry my patches always seem so sloppy.  I mean well, and I try.  I'll try harder. ;)

Hehe no worries.

>
> -Eric
>
>> Thanks
>> --Rich
>>
>>
>>
>

This has been commited (with the correct test number this time ;) )

Thanks
--Rich

commit f835afd3f0f2bab78b5b303744bb9ad441276c02
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Mar 15 02:37:34 2013 +0000

     xfstests: test writing to device node on an RO filesystem

     We should be able to open device nodes for writing even
     if they live on a readonly filesytem.

     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Dave Chinner <dchinner@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
