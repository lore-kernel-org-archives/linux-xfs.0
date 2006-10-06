Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Oct 2006 00:32:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k967W2aG007234
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 00:32:04 -0700
Date: Fri, 06 Oct 2006 17:33:11 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: review: set blocksize patch - libxfs & mkfs
Message-ID: <9489DFAC1E1AEC644253529C@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20061006064608.GE11034@melbourne.sgi.com>
References: <778901771D2CDD34FDDE6CFA@timothy-shimmins-power-mac-g5.local>
 <20061006064608.GE11034@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

Hi Dave,

--On 6 October 2006 4:46:08 PM +1000 David Chinner <dgc@sgi.com> wrote:

> On Fri, Oct 06, 2006 at 04:34:03PM +1000, Timothy Shimmin wrote:
>> Request for review of libxfs patch.
> ....
>> Index: xfsprogs/libxfs/darwin.c
>> ===================================================================
>> --- xfsprogs/libxfs/darwin.c.orig	2006-10-06 14:12:27.000000000 +1000
>> +++ xfsprogs/libxfs/darwin.c	2006-10-06 14:14:03.000000000 +1000
>> @@ -51,8 +51,8 @@
>> 	return (writable == 0);
>> }
>>
>> -void
>> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
>> +int
>> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize,
>> int fatal)
>> {
>> }
>
> Should "return fatal;" to fail specific setting of this until it is
> supported on this platform.

Oops.
Yep.
(Also want a return statement for an int returning function, d'oh:)
And likewise for the others, yep - done.

Thanks muchly.

--Tim
