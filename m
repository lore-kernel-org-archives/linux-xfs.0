Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B860A7F37
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 14:57:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D56230405F
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 12:57:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0Pa2Op5fvXUPNVYY for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 12:57:09 -0700 (PDT)
Message-ID: <55D23C95.7090501@sandeen.net>
Date: Mon, 17 Aug 2015 14:57:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 04/10] xfs_repair: fix broken EFSBADCRC/EFSCORRUPTED usage
	with buffer errors
References: <20150815014338.1839.37405.stgit@birch.djwong.org>	<20150815014404.1839.75324.stgit@birch.djwong.org>
	<55D23B3B.6060803@sandeen.net>
In-Reply-To: <55D23B3B.6060803@sandeen.net>
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
To: "Darrick J. Wong" <djwong@alder.djwong.org>, david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

On 8/17/15 2:51 PM, Eric Sandeen wrote:
> On 8/14/15 8:44 PM, Darrick J. Wong wrote:
>> When we encounter CRC or verifier errors, bp->b_error is set to
>> -EFSBADCRC and -EFSCORRUPTED; note the negative sign.  For whatever
>> reason, repair and db use the positive versions, and therefore fail to
>> notice the error, so fix all the broken uses.
>>
>> Note however that the db and repair turn the negative codes returned
>> by libxfs into positive codes that can be used with strerror.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This looks right, but I think there's more; see:
> 
> XFS_WANT_CORRUPTED_GOTO
> XFS_WANT_CORRUPTED_RETURN
> 
> (these return negative errors in kernelspace)
> 
> and a bunch of stuff in libxlog/xfs_log_recover.c...

Ok, I guess libxlog/* was never switched to negative, and so far it looks
ok.

The XFS_WANT_CORRUPTED* macros seem like a problem, though.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
