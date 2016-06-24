Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD98F7CA1
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 08:17:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80CD6304048
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 06:17:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MKGZhmh2UJH9cDgv for <xfs@oss.sgi.com>;
	Fri, 24 Jun 2016 06:17:25 -0700 (PDT)
Subject: Re: xfs metadata overhead
References: <CAC=x_0jDYb17Vh97Led7XXDiUMcUTJbpJ2Dw45gn=D0_w0K5VQ@mail.gmail.com>
	<20160622225117.GX12670@dastard>
	<CAC=x_0hdvm7SSP8EOAdUwLa-k3a3p7p7CRj8tyCnEx=As7A6jw@mail.gmail.com>
	<71fbc905-ef05-126a-5c7f-c68c9018763c@sandeen.net>
	<CAC=x_0hnGQHAenv985+FusWxK_63AatB_XK_mqbAmyt=OxqYrg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b920a8ec-6410-1daa-809c-04b48db24c0a@sandeen.net>
Date: Fri, 24 Jun 2016 08:17:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAC=x_0hnGQHAenv985+FusWxK_63AatB_XK_mqbAmyt=OxqYrg@mail.gmail.com>
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
To: Danny Shavit <danny@zadarastorage.com>, xfs-oss <xfs@oss.sgi.com>

On 6/24/16 5:34 AM, Danny Shavit wrote:
>> How do you determine allocated_size, with du?  
> yes via du
>> How different?  Can you show an example?
> meta data file size= 5.6 GB (*6,089,374,208*)
> 
> *df:*
> Filesystem                   1K-blocks       Used  Available Use% Mounted on
> /dev/dm-39                  2725683200  955900860 1769782340  36% /export/v1     = 978,842,480,640 bytes  
> 
> *du:*  du -s /export/v1/                                                                                     
> 952825644       /export/v1/     = 975,693,459,456 bytes
> 978,842,480,640 -975,693,459,456  = 
> 
> Metadata size according to calculation=*3,149,021,184* bytes

Oh, right.  I should have thought of this; "du" counts some metadata as
well, i.e. a directory full of zero-length files still consumes space
which is reported by du.

so your 975,693,459,456 bytes is file data as well as some metadata.

-Eric

>  
> Thanks,
> Danny
> 
> On Thu, Jun 23, 2016 at 9:12 PM, Eric Sandeen <sandeen@sandeen.net <mailto:sandeen@sandeen.net>> wrote:
> 
>     On 6/23/16 10:04 AM, Danny Shavit wrote:
>     > I see. We will try this direction.
>     > BTW: I thought that good estimate would be "volume_size -
>     > allocated_size - free_space". But it produced quite a difference
>     > compared to metadata dump size.
>     > Is there a specific reason?
> 
>     How do you determine allocated_size, with du?
> 
>     How different?  Can you show an example?
> 
>     -Eric
> 
>     > Thanks,
>     > Danny
>     >
>     > On Thu, Jun 23, 2016 at 1:51 AM, Dave Chinner <david@fromorbit.com <mailto:david@fromorbit.com> <mailto:david@fromorbit.com <mailto:david@fromorbit.com>>> wrote:
>     >
>     >     On Wed, Jun 22, 2016 at 06:58:16PM +0300, Danny Shavit wrote:
>     >     > Hi,
>     >     >
>     >     > We are looking for a method to estimate the size of metadata overhead for a
>     >     > given file system.
>     >     > We would like to use this value as indicator for the amount of cache memory
>     >     > a system for faster operation.
>     >     > Are there any counters that are maintained in the on-disk data
>     >     > structures like free space for examples?
>     >
>     >     No.
>     >
>     >     Right now, you'll need to take a metadump of the filesystem to
>     >     measure it. The size of the dump file will be a close indication of
>     >     the amount of metadata in the filesystem as it only contains
>     >     the filesystem metadata.
>     >
>     >     In future, querying the rmap will enable us to calculate it on the
>     >     fly, (i.e. not requiring the filesystem to be snapshotted/taken off
>     >     line to do a metadump).
>     >
>     >     Cheers,
>     >
>     >     Dave.
>     >     --
>     >     Dave Chinner
>     >     david@fromorbit.com <mailto:david@fromorbit.com> <mailto:david@fromorbit.com <mailto:david@fromorbit.com>>
>     >
>     >
>     >
>     >
>     > --
>     > Regards,
>     > Danny
>     >
>     >
>     > _______________________________________________
>     > xfs mailing list
>     > xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
>     > http://oss.sgi.com/mailman/listinfo/xfs
>     >
> 
>     _______________________________________________
>     xfs mailing list
>     xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
>     http://oss.sgi.com/mailman/listinfo/xfs
> 
> 
> 
> 
> -- 
> Regards,
> Danny

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
