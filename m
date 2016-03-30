Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 78FF97CA2
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 19:27:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F07C3AC004
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 17:27:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WrVOfuC6NK1kJugv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 17:27:18 -0700 (PDT)
Subject: Re: [PATCH] xfs: disallow rw remount on fs with unknown ro-compat
	features
References: <56FAD75C.80502@redhat.com> <20160330001608.GG30721@dastard>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <56FB1D64.1080700@redhat.com>
Date: Tue, 29 Mar 2016 19:27:16 -0500
MIME-Version: 1.0
In-Reply-To: <20160330001608.GG30721@dastard>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 3/29/16 7:16 PM, Dave Chinner wrote:
> On Tue, Mar 29, 2016 at 02:28:28PM -0500, Eric Sandeen wrote:
>> Today, a kernel which refuses to mount a filesystem read-write
>> due to unknown ro-compat features can still transition to read-write
>> via the remount path.  The old kernel is most likely none the wiser,
>> because it's unaware of the new feature, and isn't using it.  However,
>> writing to the filesystem may well corrupt metadata related to that
>> new feature, and moving to a newer kernel which understand the feature
>> will have problems.
>>
>> Right now the only ro-compat feature we have is the free inode btree,
>> which showed up in v3.16.  It would be good to push this back to
>> all the active stable kernels, I think, so that if anyone is using
>> newer mkfs (which enables the finobt feature) with older kernel
>> releases, they'll be protected.
> 
> Ok, so the bug was introduced with the original extended feature
> masks in commit e721f50 ("xfs: implement extended feature masks"),
> which was introduced in 3.10. So it will need to go back to stable
> kernels all the way back to 3.10, right?
> 
> Cheers,
> 
> Dave.
> 

Yeah, that seems right; it's not when the first ro-compat feature
was introduced, it was when the handling was introduced, right?

If you need to massage the cc:stable line feel free, of course.

ie:

     Cc:  <stable@vger.kernel.org> # 3.10.x-

I think.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
