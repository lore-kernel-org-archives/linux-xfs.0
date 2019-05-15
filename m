Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40772 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfEOMmU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 08:42:20 -0400
Subject: Re: [PATCH 06/11] libxfs: create new file trans_buf.c
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-7-git-send-email-sandeen@redhat.com>
 <20190515060750.GY29573@dread.disaster.area>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8808a6c0-eebe-85b9-3f13-86ed8effdac5@sandeen.net>
Date: Wed, 15 May 2019 07:42:19 -0500
MIME-Version: 1.0
In-Reply-To: <20190515060750.GY29573@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 5/15/19 1:07 AM, Dave Chinner wrote:
> On Fri, May 10, 2019 at 03:18:25PM -0500, Eric Sandeen wrote:
>> Pull functions out of libxfs/*.c into trans_buf.c, if they roughly match
>> the kernel's xfs_trans_buf.c file.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> So I have no problems with this, but I'm not sure what the eventual
> goal is? Just sharing code, or is there some functionality that
> requires a more complete transaction subsystem in userspace?
> 
> I'm asking because if the goal is eventual unification with the
> kernel code, then we probably should name the files the same as the
> kernel code so we don't have to rename them again when we do the
> unification. That will make history searching a bit easier - less
> file names to follow across and git blame works a whole lot better...
> 
>> +int
>> +xfs_trans_read_buf_map(
>> +	xfs_mount_t		*mp,
>> +	xfs_trans_t		*tp,
>> +	struct xfs_buftarg	*btp,
>> +	struct xfs_buf_map	*map,
>> +	int			nmaps,
>> +	uint			flags,
>> +	xfs_buf_t		**bpp,
>> +	const struct xfs_buf_ops *ops)
> 
> Hmmmm. Will there be any follow-up to de-typedef these new files?
> 
> /me would love to just have a flag day that de-typedefs all of the
> userspace code.


Yes, after I moved stuff enough to see how/if it matches the kernel,
I de-typdefed to match where the kernel has done so.

I could certainly roll that into this patch.  I was trying to do small
steps but maybe that just makes things more complex to follow...

-Eric
