Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E4DF7CA1
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 13:12:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 514818F8033
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 11:12:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AjZoEWlO7ZsAJF1o for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2016 11:12:20 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6690915B3B
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 13:12:20 -0500 (CDT)
Subject: Re: xfs metadata overhead
References: <CAC=x_0jDYb17Vh97Led7XXDiUMcUTJbpJ2Dw45gn=D0_w0K5VQ@mail.gmail.com>
	<20160622225117.GX12670@dastard>
	<CAC=x_0hdvm7SSP8EOAdUwLa-k3a3p7p7CRj8tyCnEx=As7A6jw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <71fbc905-ef05-126a-5c7f-c68c9018763c@sandeen.net>
Date: Thu, 23 Jun 2016 13:12:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAC=x_0hdvm7SSP8EOAdUwLa-k3a3p7p7CRj8tyCnEx=As7A6jw@mail.gmail.com>
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
To: xfs@oss.sgi.com

On 6/23/16 10:04 AM, Danny Shavit wrote:
> I see. We will try this direction.
> BTW: I thought that good estimate would be "volume_size -
> allocated_size - free_space". But it produced quite a difference
> compared to metadata dump size.
> Is there a specific reason?

How do you determine allocated_size, with du?

How different?  Can you show an example?

-Eric
 
> Thanks,
> Danny
> 
> On Thu, Jun 23, 2016 at 1:51 AM, Dave Chinner <david@fromorbit.com <mailto:david@fromorbit.com>> wrote:
> 
>     On Wed, Jun 22, 2016 at 06:58:16PM +0300, Danny Shavit wrote:
>     > Hi,
>     >
>     > We are looking for a method to estimate the size of metadata overhead for a
>     > given file system.
>     > We would like to use this value as indicator for the amount of cache memory
>     > a system for faster operation.
>     > Are there any counters that are maintained in the on-disk data
>     > structures like free space for examples?
> 
>     No.
> 
>     Right now, you'll need to take a metadump of the filesystem to
>     measure it. The size of the dump file will be a close indication of
>     the amount of metadata in the filesystem as it only contains
>     the filesystem metadata.
> 
>     In future, querying the rmap will enable us to calculate it on the
>     fly, (i.e. not requiring the filesystem to be snapshotted/taken off
>     line to do a metadump).
> 
>     Cheers,
> 
>     Dave.
>     --
>     Dave Chinner
>     david@fromorbit.com <mailto:david@fromorbit.com>
> 
> 
> 
> 
> -- 
> Regards,
> Danny
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
