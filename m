Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6Ked7S088533 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 14:40:39 -0600
Message-ID: <50997638.6000804@sgi.com>
Date: Tue, 6 Nov 2012 14:42:32 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] xfstests: Revert commit edd6bc "optionally run all tests
	under quota"
References: <20121105150133.857716755@sgi.com>
	<20121105150150.558785273@sgi.com> <20121106201210.GB24575@dastard>
In-Reply-To: <20121106201210.GB24575@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/06/2012 02:12 PM, Dave Chinner wrote:
> On Mon, Nov 05, 2012 at 09:01:34AM -0600, rjohnston@sgi.com wrote:
>> Revert commit edd6bc which causes the following tests to fail:
>>
>> 142.out.bad:Can't initialize the DMAPI
>> 143.out.bad:Can't initialize the DMAPI
>> 144.out.bad:Can't initialize the DMAPI
>> 145.out.bad:Can't initialize the DMAPI
>> 146.out.bad:Can't initialize the DMAPI
>> 147.out.bad:Can't initialize the DMAPI
>> 150.out.bad:Can't initialize the DMAPI
>> 155.out.bad:Can't initialize the DMAPI
>> 156.out.bad:Can't initialize the DMAPI
>> 157.out.bad:Can't initialize the DMAPI
>> 158.out.bad:Can't initialize the DMAPI
>> 161.out.bad:Can't initialize the DMAPI
>> 168.out.bad:Can't initialize the DMAPI
>> 175.out.bad:Can't initialize the DMAPI
>> 176.out.bad:Can't initialize the DMAPI k
>> 185.out.bad:Can't initialize the DMAPI
>>
>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>
> Looks fine, but please use 'git revert edd6bcf' to revert the patch
> and put this error message in it rather than applying a quilt patch
> to do the revert.
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
> Cheers,
>
> Dave.
>

Thanks Dave commit is 103af3.

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
