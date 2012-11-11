Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qABJqfDX162155 for <xfs@oss.sgi.com>; Sun, 11 Nov 2012 13:52:41 -0600
Message-ID: <50A00274.1080604@sgi.com>
Date: Sun, 11 Nov 2012 13:54:28 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: add CRC infrastructure
References: <1352295452-4726-1-git-send-email-david@fromorbit.com>
	<1352295452-4726-2-git-send-email-david@fromorbit.com>
	<509D7F1A.3090201@sgi.com> <20121111012643.GH6434@dastard>
In-Reply-To: <20121111012643.GH6434@dastard>
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

On 11/10/12 19:26, Dave Chinner wrote:
> On Fri, Nov 09, 2012 at 04:09:30PM -0600, Mark Tinguely wrote:
>> On 11/07/12 07:37, Dave Chinner wrote:
>>> From: Christoph Hellwig<hch@lst.de>
>>>
>>>   - add a mount feature bit for CRC enabled filesystems
>>>   - add some helpers for generating and verifying the CRCs
>>>   - add a copy_uuid helper
>>>
>>> The checksumming helpers are losely based on similar ones in sctp,
>>> all other bits come from Dave Chinner.
>>>
>>> Signed-off-by: Christoph Hellwig<hch@lst.de>
>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>> ---
>>> +/*
>>> + * Calculate the intermediate checksum for a buffer that has the CRC field
>>> + * inside it.  The offset of the 32bit crc fields is passed as the
>>> + * cksum_offset parameter.
>>> + */
>>> +static inline __uint32_t
>>> +xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
>>> +{
>>> +	__uint32_t zero = 0;
>>> +	__uint32_t crc;
>>> +
>>> +	/* Calculate CRC up to the checksum. */
>>> +	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
>>> +
>>> +	/* Skip checksum field */
>>> +	crc = crc32c(crc,&zero, sizeof(__u32));
>>
>> I know this came from sctp and I know I can't convince you to copy/null
>> the *cksum_offset to make one block for those with hardware crc32c devices.
>>
>> Since the *cksum_offset value is never used in creating and verifying
>> the checksum, the 4 bytes of zeros does not add any new information,
>> why not just drop it from the cksum calculation?
>
> Because it gives a different CRC value. If we zero the CRC field,
> and then do an entire block CRC ignoring the location of the CRC, we
> get the same value as using the above algorithm. While we aren't
> going to do this type of verification/calculation in the kernel
> code, there are use cases for it, say in repair, where we don't have
> to worry about multiple verifications of the object occurring.
>
> Hence by making sure we zero the CRC field during the calculation,
> we retain the flexibility of doing faster, single pass calculation
> and verification where it makes sense to use it.  If we optimise
> away the zero block for the CRC, then we that flexibility when it
> comes to implementing other tools that check and recalculate CRC
> values.

I was mostly thinking about down the road when crc32c offloading is
common. The copy/null/checksum/replace model of the routine can be done
anytime that it make sense to do so (as long as only one checksum can
happen at one time).

>
>>> +	/* Calculate the rest of the CRC. */
>>> +	return crc32c(crc,&buffer[cksum_offset + sizeof(__be32)],
>>> +		      length - (cksum_offset + sizeof(__be32)));
>>> +}
>>> +
>>> +/*
>>> + * Convert the intermediate checksum to the final ondisk format.
>>> + *
>>> + * Note that crc32c is already endianess agnostic, so no additional
>>> + * byte swap is needed.
>>> + */
>>> +static inline __be32
>>> +xfs_end_cksum(__uint32_t crc)
>>> +{
>>> +	return (__force __be32)~crc;
>>> +}
>>> +
>>
>> Wouldn't you have to cpu_to_le32() for big endian machines?
>
> Good catch, I hadn't noticed that fix - it's been quite a while
> since this particular patch was originally written. So, yeah, it
> probably does need that fix.
>
> FWIW, I don't have a big endian machine immediately handy to test
> this. Do you?

I am sure there is something in the pool. I will ask on Monday.
Someone was going to do some testing on a big endian machine before the
user space release anyway. I guess I just volunteered. A log recovery
test from a different endian machine sounds interesting.

> Cheers,
>
> Dave.


--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
