Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59334 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753332AbeDMD6w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Apr 2018 23:58:52 -0400
Subject: Re: [PATCH V2] xfs: enhance dinode verifier
References: <a1454c1f-e01a-5570-85d3-d55181c9ddd3@redhat.com>
 <c80d14ca-2d47-86f7-62f8-90affb06cef7@sandeen.net>
 <20180413035632.GB32099@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d61bd844-52ba-12a5-f658-d6aebaed3e93@sandeen.net>
Date: Thu, 12 Apr 2018 22:58:50 -0500
MIME-Version: 1.0
In-Reply-To: <20180413035632.GB32099@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, wen.xu@gatech.edu

On 4/12/18 10:56 PM, Darrick J. Wong wrote:
> On Thu, Apr 12, 2018 at 09:55:41PM -0500, Eric Sandeen wrote:
>> Add several more validations to xfs_dinode_verify:
...

>> @@ -476,12 +478,25 @@ xfs_dinode_verify(
>>  	if (XFS_DFORK_Q(dip)) {
>>  		switch (dip->di_aformat) {
>>  		case XFS_DINODE_FMT_LOCAL:
>> +			if (dip->di_anextents)
>> +				return __this_address;
>> +		/* fall through */
>>  		case XFS_DINODE_FMT_EXTENTS:
>>  		case XFS_DINODE_FMT_BTREE:
>>  			break;
>>  		default:
>>  			return __this_address;
>>  		}
>> +	} else {	/* No attr fork */
>> +		switch (dip->di_aformat) {
>> +		case 0:	/* Uninitialized OK */
> 
> Might be a good idea to point out that a newly allocated inode chunk
> will have all these fields set to zero

Well, that was the intent of my terse comment...  I can write a longer
one, clearly it did not do the trick?

-Eric

