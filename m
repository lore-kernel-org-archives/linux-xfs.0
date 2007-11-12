Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 06:57:41 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lACEvFlK014329
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 06:57:17 -0800
Date: Mon, 12 Nov 2007 09:57:21 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [[PATCH, RESEND]] less AGs for single disks configs.
In-Reply-To: <20071112090147.GD66820511@sgi.com>
Message-ID: <Pine.LNX.4.64.0711120956340.2701@p34.internal.lan>
References: <20071031233516.GB88034736@melbourne.sgi.com>
 <1194839329-22003-1-git-send-email-xaiki@sgi.com>
 <1194839329-22003-2-git-send-email-xaiki@sgi.com>
 <1194839329-22003-3-git-send-email-xaiki@sgi.com>
 <1194839329-22003-4-git-send-email-xaiki@sgi.com>
 <1194839329-22003-5-git-send-email-xaiki@sgi.com>
 <1194839329-22003-6-git-send-email-xaiki@sgi.com> <20071112090147.GD66820511@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xaiki@sgi.com, xfs@oss.sgi.com



On Mon, 12 Nov 2007, David Chinner wrote:

> On Mon, Nov 12, 2007 at 02:48:49PM +1100, xaiki@sgi.com wrote:
>> From: Niv Sardi <xaiki@sgi.com>
>>
>> get the underlying structure with get_subvol_stripe_wrapper(),
>> and pass sunit | swidth as an argument to calc_default_ag_geometry().
>>
>> if it is set, get the AG sizes bigger.
>>
>> this also cleans up a typo:
>> -       } else if (daflag)      /* User-specified AG size */
>> +       } else if (daflag)      /* User-specified AG count */
>
> No need to mention that you are cleaning up a typo in the description ;)
>
>> ---
>>  xfsprogs/mkfs/xfs_mkfs.c |   18 ++++++++++++------
>>  1 files changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
>> index 78c2c77..4cf9975 100644
>> --- a/xfsprogs/mkfs/xfs_mkfs.c
>> +++ b/xfsprogs/mkfs/xfs_mkfs.c
>> @@ -393,6 +393,7 @@ void
>>  calc_default_ag_geometry(
>>  	int		blocklog,
>>  	__uint64_t	dblocks,
>> +	int		multidisk,
>>  	__uint64_t	*agsize,
>>  	__uint64_t	*agcount)
>>  {
>> @@ -428,12 +429,13 @@ calc_default_ag_geometry(
>>  	 *
>>  	 * This scales us up smoothly between min/max AG sizes.
>>  	 */
>> +
>>  	if (dblocks > GIGABYTES(512, blocklog))
>> -		shift = 5;
>> +		shift = 5 - (multidisk == 0);
>>  	else if (dblocks > GIGABYTES(8, blocklog))
>> -		shift = 4;
>> +		shift = 4 - (multidisk == 0);
>>  	else if (dblocks >= MEGABYTES(128, blocklog))
>> -		shift = 3;
>> +		shift = 3 - (multidisk == 0);
>>  	else
>>  		ASSERT(0);
>
> Ok, so now we end up with half the number of allocation groups
> at these different sizes. That's not exactly what I had in mind.
> basically, what you've done works out as:
>
> 	> 512GB  old = 32 AGs, new = 16AGs
> 	> 8 GB   old = 16 AGs, new = 8AGs
> 	> 128MB  old = 8 AGs, new = 4AGs
>
> on an 8Gb filesystem we still get 8 AGs, which is far too many.
> on a 750GB disk, we still get 16AGs, which to far too many.
>
> A single spindle, regardless of it's size, will have similar
> seek characteristics so scaling the number of AGs with size
> is the wrong thing to do - you don't get better parallelism
> out of a single spindle, just more seeks and lower performance.
> hence keeping the number of AGs fixed up to the point where
> the AG size tops out (i.e. 4TB) seems like a better scaling
> factor to me. i.e. something like:
>
>
> 	if (!multidisk) {
> 		if (dblocks >= TERABYTES(4, blocklog)) {
> 			blocks = XFS_AG_MAX_BLOCKS(blocklog);
> 			goto done;
> 		}
> 		agcount = 4;
> 		/* work out ag size here */
> 		goto done;
> 	}
>
> I'd also like to see some test results showing the mkfs output
> for the different configurations to confirm it works correctly
> (i.e. that the corner cases work correctly).
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
>

Dave, when this is put into place do you recommend people re-format their 
XFS partitions for those with a 750GiB drive -or- with a < 2TB RAID5 
array, would one see any increase in speed?

Justin.
