Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BC427F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 10:17:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 090F18F804B
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 08:17:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gRpHYnAfNv2EzPbw for <xfs@oss.sgi.com>;
	Wed, 27 May 2015 08:17:00 -0700 (PDT)
Message-ID: <5565DFEB.9040000@sandeen.net>
Date: Wed, 27 May 2015 10:16:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/5] xfs_repair: refuse to run if we don't recognize
	version or feature flags
References: <20150526225126.26434.69010.stgit@birch.djwong.org>	<20150526225132.26434.82404.stgit@birch.djwong.org>	<20150527054536.GB10175@birch.djwong.org>
	<5565DAA7.4040406@sandeen.net>
In-Reply-To: <5565DAA7.4040406@sandeen.net>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: xfs@oss.sgi.com

On 5/27/15 9:54 AM, Eric Sandeen wrote:
> On 5/27/15 12:45 AM, Darrick J. Wong wrote:
>> Apparently xfs_repair running on a v5 filesystem doesn't check the
>> compat, rocompat, or incompat feature flags for bits that it doesn't
>> know about, which means that old xfs_repairs can wreak havoc.  So,
>> strengthen the checks to prevent repair from "repairing" anything it
>> doesn't understand.
>>
>> v2: Move the complaint code after the version number check, and print
>> the actual feature bits that we don't recognize.
> 
> Thanks.  That's a bit more wordy, but probably better, in the end.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Whoops, retract that, thanks for spotting those C&P errors, Fanael!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
