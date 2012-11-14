Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAEIXPbt155509 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 12:33:25 -0600
Received: from xmail.sgi.com (pv-excas3-dc21-nlb.corp.sgi.com [137.38.102.207])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 997318F8033
	for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 10:35:27 -0800 (PST)
Message-ID: <50A3E46E.9040508@sgi.com>
Date: Wed, 14 Nov 2012 12:35:26 -0600
From: Andrew Dahl <adahl@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 2/2 V2] xfstests: xfs_tosspages() test addition
References: <20121108222315.505370321@sgi.com>
	<20121108222315.709683665@sgi.com>
	<20121108232726.GV6434@dastard> <50A19EC0.4040405@sgi.com>
	<50A3DC58.4080704@sgi.com>
In-Reply-To: <50A3DC58.4080704@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 11/14/2012 12:00 PM, Mark Tinguely wrote:
> On 11/12/12 19:13, Andrew Dahl wrote:
>>
>> Tests the XFS_IOC_ZERO_RANGE ioctl by way of the "xfs_io zero" utility
>> to ensure it is tossing the expected ranges.
>>
>> The ranges tested are [0,1] [0,4095] [0,4096] [0,4097] [4095,8191]
>>    [4095,8192] [4095,8193] [4096,8192] [1024,4096]
>>
>> Signed-off-by: Andrew Dahl<adahl@sgi.com>
>>
>> ---
>>
> 
> ...
> 
> 
>> +
>> +    $XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
> 
> -F is deprecated in xfs_io.
> 
> Looks good.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Actually... I just realized I neglected to add one change in there. The
call to _require_xfs_io_zero doesn't exist, but should in common.rc

I'll repost the patch with this included.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
