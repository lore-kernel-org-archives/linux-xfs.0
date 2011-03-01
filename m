Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p21LOSkE219700 for <xfs@oss.sgi.com>; Tue, 1 Mar 2011 15:24:28 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66C1F5054F6
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2011 13:27:16 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 3KZNoYUudcR1N2jO for <xfs@oss.sgi.com>;
	Tue, 01 Mar 2011 13:27:16 -0800 (PST)
Message-ID: <4D6D64B1.8060109@sandeen.net>
Date: Tue, 01 Mar 2011 15:27:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] libxcmd: return error from cvtnum() on overflow
References: <4D6C075F.1010509@redhat.com> <4D6C1322.10102@sandeen.net>
	<1299013237.2727.12.camel@doink>
In-Reply-To: <1299013237.2727.12.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 3/1/11 3:00 PM, Alex Elder wrote:
> On Mon, 2011-02-28 at 15:26 -0600, Eric Sandeen wrote:
>> Test 071 was failing in weird ways, partly because it was trying
>> to pass in offsets larger than strtoll() could accept, which then
>> silently returned LLONG_MAX instead.  For DIO tests, this was
>> unaligned, so we got unexpected (to me, anyay) alignment errors.
>>
>> At least printing out the perror() makes this more obvious,
>> but unfortunately we then get the somewhat odd output:
>>
>> # xfs_io -f -d -c "pwrite 9223373136366403584  4096" /mnt/test/grrr
>> cvtnum: Numerical result out of range
>> non-numeric offset argument -- 9223373136366403584
>>
>> Test 071 still fails, but at least it's a bit more obvious as to why.
> 
> Your change looks good.  But here are a few more general questions
> (for anyone who cares to respond--not just you):
> - Do you plan to get test 071 working?  (Just curious.)

some day maybe, and I'd like to make it a generic test.

> - mkfs/xfs_mkfs.c and extimate/xfs_estimate.c each define their
>   own version of the same function.  Do you know why?  Is there
>   any reason we couldn't just have one?

I don't know ;)

> - The three version of cvtnum() are each a bit different.  Two
>   of them (the other two) return -1 for an empty string, while
>   this one returns 0.

hrm.

> - I'm not sure what you meant by "non-numeric" versus "invalid"
>   in call sites.

I mean perror says:

cvtnum: Numerical result out of range

but then the caller says:

non-numeric offset argument -- 9223373136366403584

"9223373136366403584" is not non-numeric; it is out of range.  :)

> - Call sites seem to be a bit varied on how (or whether) they
>   look for errors.  Kind of a mess...

yeah.

> Regardless, you can consider this one reviewed.  We should
> fix all three instances of the function to fix this problem
> though--either the same as this (and in the same commit)
> or separeately.

ok I may fix up the others, I'd forgotten about that.

-Eric

> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> V2: zero errno first so we don't pick up a stale errno.
>>
>> Note:
>> ... should I change all callsites from "non-numeric" to "invalid" perhaps?
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
