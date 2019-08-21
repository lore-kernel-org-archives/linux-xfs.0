Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44749C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 15:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15AB022DD3
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 15:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfHUPjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 11:39:10 -0400
Received: from sandeen.net ([63.231.237.45]:58088 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbfHUPjK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Aug 2019 11:39:10 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 05D6817DFF;
        Wed, 21 Aug 2019 10:39:08 -0500 (CDT)
Subject: Re: [PATCH] xfsprogs: fix geometry calls on older kernels for 5.2.1
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <7d83cd0d-8a15-201e-9ebf-e1f859270b92@sandeen.net>
 <20190820211828.GC1037350@magnolia>
 <20190820224600.GI1119@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <bde705a3-828a-13d7-e5d8-960cc48be9d0@sandeen.net>
Date:   Wed, 21 Aug 2019 10:39:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820224600.GI1119@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/20/19 5:46 PM, Dave Chinner wrote:
> On Tue, Aug 20, 2019 at 02:18:28PM -0700, Darrick J. Wong wrote:
>> On Tue, Aug 20, 2019 at 03:47:29PM -0500, Eric Sandeen wrote:
>>> I didn't think 5.2.0 through; the udpate of the geometry ioctl means
>>> that the tools won't work on older kernels that don't support the
>>> v5 ioctls, since I failed to merge Darrick's wrappers.
>>>
>>> As a very quick one-off I'd like to merge this to just revert every
>>> geometry call back to the original ioctl, so it keeps working on
>>> older kernels and I'll release 5.2.1.  This hack can go away when
>>> Darrick's wrappers get merged.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>
>> For the four line code fix,
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>>> ---
>>>
>>> I'm a little concerned that 3rd party existing code which worked fine
>>> before will now get the new XFS_IOC_FSGEOMETRY definition if they get
>>> rebuilt, and suddenly stop working on older kernels. Am I overreacting
>>> or misunderstanding our compatibility goals?
>>
>> As for this question ^^^ ... <URRRK>.
>>
>> I thought the overall strategy was to get everything in xfsprogs using
>> libfrog wrappers that would degrade gracefully on old kernels.
> 
> The wrappers were a necessary part of the conversion. They should
> have been merged with the rest of XFS_IOC_FSGEOMETRY changes. How
> did this get broken up?

because libxfs sync is automated, and wrappers are not.  Darrick tried, but
despite his best efforts my suckiness prevailed spectacularly this time.

Anyway my worry was about 3rd parties directly using the ioctl definition
but I guess I've been convinced that I don't need to worry about that because
it's not for 3rd party consumption in general.

>> For xfsdump/restore, I think we should just merge it into xfsprogs and
>> then it can use our wrappers.
> 
> Don't need to care about dump/restore:
> 
> $ git grep FSGEOM
> common/fs.c:    if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geo)) {
> doc/CHANGES:      XFS_IOC_FSGEOMETRY instead of XFS_IOC_GETFSUUID ioctl, so
> $
> 
> It only uses teh V1 ioctl.

Yup, thanks for checking that.

> As it is, the correct thing to do here is to put the fallback into
> the xfsctl() function. This is actually an exported and documented
> interface to use xfs ioctls by external problems - it's part of
> libhandle(), and that should be obvious by the fact the man page
> that describes all this is xfsctl(3).
> 
> i.e. any app using XFS ioctls should be using the xfsctl()
> interface, not calling ioctl directly. The whole reason for that it
> because it allows us to handle things like this in application
> independent code....
>  
> So I'd suggest that the fallback code should be in the xfsctl
> handler and then userspace will pick this up and won't care about
> which kernel it is running on...
> 
> I suspect the bigger picture is to convert all the open ioctl()
> calls in xfsprogs for XFS specific ioctls to xfsctl(). We've kinda
> screwed this pooch since we stopped having to support multiple
> platforms.
> 
>> For everything else... I thought the story was that you shouldn't really
>> be using xfs ioctls unless you're keeping up with upstream.
> 
> Or you should be linked against libhandle and using xfsctl() to
> be isolated from these sorts of things.

Yeah fair.

Thanks,
-Eric
