Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Dec 2007 21:36:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB55aMrf013615
	for <xfs@oss.sgi.com>; Tue, 4 Dec 2007 21:36:24 -0800
Message-ID: <475638FD.9090208@sgi.com>
Date: Wed, 05 Dec 2007 16:37:01 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [Patch] xfs_lowbit64 broken on ia32
References: <20071203211620.GN115527101@sgi.com> <475608D8.4070402@sgi.com> <20071205032128.GB115527101@sgi.com>
In-Reply-To: <20071205032128.GB115527101@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

David Chinner wrote:
> On Wed, Dec 05, 2007 at 01:11:36PM +1100, Lachlan McIlroy wrote:
>> David Chinner wrote:
>>> The recent change to the internals of xfs_lowbit64 broke it on
>>> ia32 - the code treats the 64bit value as an unsigned long
>>> which is only 32 bits on ia32 and hence throws away the high 32
>>> bits. 64 bit platforms are not affected.
>>>
>>> Tested with a userspace implementation comparing the original
>>> code with the new code.
>>>
>>> Signed-off-by: Dave Chinner <dgc@sgi.com>
>>> ---
>>> fs/xfs/xfs_bit.h |    4 ++--
>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> Index: 2.6.x-xfs-new/fs/xfs/xfs_bit.h
>>> ===================================================================
>>> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_bit.h	2007-11-02 
>>> 13:44:45.000000000 +1100
>>> +++ 2.6.x-xfs-new/fs/xfs/xfs_bit.h	2007-12-03 14:43:33.169851481 +1100
>>> @@ -68,8 +68,8 @@ static inline int xfs_lowbit32(__uint32_
>>> /* Get low bit set out of 64-bit argument, -1 if none set */
>>> static inline int xfs_lowbit64(__uint64_t v)
>>> {
>>> -	unsigned long	t = v;
>>> -	return (v) ? find_first_bit(&t, 64) : -1;
>>> +	unsigned long long	t = v;
>> Why create a local copy?  Why not just pass v into find_first_bit()?
> 
> Because I thought that taking the address of a function parameter
> was a big no-no because the result is undefined (i.e. platform and
> compiler dependent)?
> 

Really?  Didn't occur to me but then I can't say for sure I've ever
used the address of an argument.  If we need a local copy then why
not use __unit64_t instead of unsigned long long?
