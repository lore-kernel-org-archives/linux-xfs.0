Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8SGbYNg258857 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 11:37:34 -0500
Message-ID: <5065D292.4090600@sgi.com>
Date: Fri, 28 Sep 2012 11:38:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfsprog: remove duplicate vector memalign from xfs_io
References: <20120925142414.660506845@sgi.com>
	<20120925142421.398175185@sgi.com> <20120926220434.GG13214@sgi.com>
	<20120927124742.695778439@sgi.com> <20120927225248.GB25626@dastard>
In-Reply-To: <20120927225248.GB25626@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 09/27/12 17:52, Dave Chinner wrote:
> On Thu, Sep 27, 2012 at 07:47:36AM -0500, Mark Tinguely wrote:
>> The vector feature of xfs_io uses its own memory buffer in the iov structure
>> and does not use the buffer entry. Remove the duplicate memalign.
>>
>> v2: removed global buffer in __dump_buffer() and use passed buf pointer per
>>      Ben's detection.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> Reviewed-by: Ben Myers<bpm@sgi.com>
>
> Looks good, Thanks for fixing this.
>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
>


Committed to git://oss.sgi.com/xfs/cmds/xfsprogs.git, master branch.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
