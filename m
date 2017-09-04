Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47119 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753120AbdIDBBh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 3 Sep 2017 21:01:37 -0400
Subject: Re: [PATCH] misc: fix more stupid compiler warnings
References: <20170901222157.GL3775@magnolia>
 <20170903072432.GA32095@infradead.org> <20170904002235.GB4671@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ab0468ce-2ab4-3ed9-e065-799ff2194039@redhat.com>
Date: Sun, 3 Sep 2017 20:01:36 -0500
MIME-Version: 1.0
In-Reply-To: <20170904002235.GB4671@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On 9/3/17 7:22 PM, Darrick J. Wong wrote:
> On Sun, Sep 03, 2017 at 12:24:33AM -0700, Christoph Hellwig wrote:
>> Can you splits this up a bit to be more self explanatory, e.g.
>> one patch per warning class or logical change?
>>
>>>  	if (be32_to_cpu(free->hdr.nvalid) > maxent ||
>>> -				be32_to_cpu(free->hdr.nvalid) < 0 ||
>>>  				be32_to_cpu(free->hdr.nused) > maxent ||
>>> -				be32_to_cpu(free->hdr.nused) < 0 ||
>>>  				be32_to_cpu(free->hdr.nused) >
>>>  					be32_to_cpu(free->hdr.nvalid)) {
>>
>> be32_to_cpu returns uint, so this makese sense.
>>
>>> -	(void)getcwd(curdir,MAXPATHLEN);
>>> +	if (!getcwd(curdir, MAXPATHLEN)) {
>>> +		perror("getcwd");
>>> +		strcpy(curdir, ".");
>>> +	}
>>
>> All this chdir magic will need a lot more explanation.  To me it
>> seems like most of this is a left over from IRIX days where we
>> could have device names relative to a volume.  The proper fix
>> probably is to just remove that whole thing - if we'd ever
>> need to bring it back we should use openat relative to a dirfd
>> instead.
> 
> Yeah, AFAICT all this getcwd/chdir stuff seems to exist so that
> check_open can change the working directory (it doesn't on Linux) and we
> can change back to continue to use relative paths.  Nothing ever changes
> the directory (at least not in the call paths of libxfs_init) so I think
> we can just rip it out.  As a separate patch.
> 
> In the meantime, do you want me to resend with just the uncontroversial
> bits?

The rest is all fine with me, sorry, I should have said that as well.

I agree with Christoph that splitting into logically grouped changes
makes sense; I was going to let that slide, but it always has been
and still is best practice, of course.

As for moving that ASSERT - yeah, at one point we said that if a null
ptr deref is going to happen immediately after, the ASSERT is really
of no value.

-Eric

