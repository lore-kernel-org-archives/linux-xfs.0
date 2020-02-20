Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36356C11D00
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 02:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10D0824670
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 02:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBTCM0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 21:12:26 -0500
Received: from sandeen.net ([63.231.237.45]:38662 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbgBTCM0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Feb 2020 21:12:26 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 564762A76;
        Wed, 19 Feb 2020 20:12:08 -0600 (CST)
Subject: Re: Modern uses of CONFIG_XFS_RT
To:     Luis Chamberlain <mcgrof@kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>,
        Yong Sun <YoSun@suse.com>
References: <20200219135715.GZ30113@42.do-not-panic.com>
 <20200219143227.aavgzkbuazttpwky@andromeda>
 <20200219143824.GR11244@42.do-not-panic.com> <20200219170945.GN9506@magnolia>
 <20200219175502.GS11244@42.do-not-panic.com> <20200219220104.GE9504@magnolia>
 <20200220001729.GT11244@42.do-not-panic.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <86c1597a-3681-be41-a838-d32e22c0c363@sandeen.net>
Date:   Wed, 19 Feb 2020 20:12:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200220001729.GT11244@42.do-not-panic.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/19/20 6:17 PM, Luis Chamberlain wrote:
> On Wed, Feb 19, 2020 at 02:01:04PM -0800, Darrick J. Wong wrote:
>> On Wed, Feb 19, 2020 at 05:55:02PM +0000, Luis Chamberlain wrote:
>>> On Wed, Feb 19, 2020 at 09:09:45AM -0800, Darrick J. Wong wrote:
>>>> On Wed, Feb 19, 2020 at 02:38:24PM +0000, Luis Chamberlain wrote:
>>>>> On Wed, Feb 19, 2020 at 03:32:27PM +0100, Carlos Maiolino wrote:
>>>>>> On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
>>>>>>> I hear some folks still use CONFIG_XFS_RT, I was curious what was the
>>>>>>> actual modern typical use case for it. I thought this was somewhat
>>>>>>> realted to DAX use but upon a quick code inspection I see direct
>>>>>>> realtionship.
>>>>>>
>>>>>> Hm, not sure if there is any other use other than it's original purpose of
>>>>>> reducing latency jitters. Also XFS_RT dates way back from the day DAX was even a
>>>>>> thing. But anyway, I don't have much experience using XFS_RT by myself, and I
>>>>>> probably raised more questions than answers to yours :P
>>>>>
>>>>> What about another question, this would certainly drive the users out of
>>>>> the corners: can we remove it upstream?
>>>>
>>>> My DVR and TV still use it to record video data.
>>>
>>> Is anyone productizing on that though?
>>>
>>> I was curious since most distros are disabling CONFIG_XFS_RT so I was
>>> curious who was actually testing this stuff or caring about it.
>>
>> Most != All.  We enabled it here, for development of future products.
> 
> Ah great to know, thanks!
> 
>>>> I've also been pushing the realtime volume for persistent memory devices
>>>> because you can guarantee that all the expensive pmem gets used for data
>>>> storage, that the extents will always be perfectly aligned to large page
>>>> sizes, and that fs metadata will never defeat that alignment guarantee.
>>>
>>> For those that *are* using XFS in production with realtime volume with dax...
>>> I wonder whatcha doing about all these tests on fstests which we don't
>>> have a proper way to know if the test succeeded / failed [0] when an
>>> external logdev is used, this then applies to regular external log dev
>>> users as well [1].
>>
>> Huh?  How did we jump from realtime devices to external log files?
> 
> They share the same problem with fstests when using an alternative log
> device, which I pointed out on [0] and [1].
> 
> [0] https://github.com/mcgrof/oscheck/blob/master/expunges/linux-next-xfs/xfs/unassigned/xfs_realtimedev.txt
> [1] https://github.com/mcgrof/oscheck/blob/master/expunges/linux-next-xfs/xfs/unassigned/xfs_logdev.txt
> 
>>> Which makes me also wonder then, what are the typical big users of the
>>> regular external log device?
>>>
>>> Reviewing a way to address this on fstests has been on my TODO for
>>> a while, but it begs the question of how much do we really care first.
>>> And that's what I was really trying to figure out.
>>>
>>> Can / should we phase out external logdev / realtime dev? Who really is
>>> caring about this code these days?
>>
>> Not many, I guess. :/
>>
>> There seem to be a lot more tests these days that use dmflakey on the
>> data device to simulate a temporary disk failure... but those aren't
>> going to work for external log devices because they seem to assume that
>> what we call the data device is also the log device.
> 
> That goes to show that the fstests assumption on a shared data/log device was
> not only a thing of the past, its still present, and unless we address
> soon, the gap will only get bigger.
> 
> OK thanks for the feedback. The situation in terms of testing rtdev or
> external logs seems actually worse than I expected given the outlook for
> the future and no one seeming to really care too much right now. If the
> dax folks didn't care, then the code will likely just bit rot even more.
> Is it too nutty for us to consider removing it as a future goal?

Less nutty would be to analyze the failures and fix the tests.

Here's a start, I'll send this one to fstests.

diff --git a/common/repair b/common/repair
index 5a9097f4..cf69dde9 100644
--- a/common/repair
+++ b/common/repair
@@ -9,8 +9,12 @@ _zero_position()
 	value=$1
 	struct="$2"
 
+	SCRATCH_OPTIONS=""
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
+
 	# set values for off/len variables provided by db
-	eval `xfs_db -r -c "$struct" -c stack $SCRATCH_DEV | perl -ne '
+	eval `xfs_db -r -c "$struct" -c stack $SCRATCH_OPTIONS $SCRATCH_DEV | perl -ne '
 		if (/byte offset (\d+), length (\d+)/) {
 			print "offset=$1\nlength=$2\n"; exit
 		}'`
diff --git a/tests/xfs/030 b/tests/xfs/030
index efdb6a18..e1cc32ef 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -77,7 +77,10 @@ else
 	_scratch_unmount
 fi
 clear=""
-eval `xfs_db -r -c "sb 1" -c stack $SCRATCH_DEV | perl -ne '
+SCRATCH_OPTIONS=""
+[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
+eval `xfs_db -r -c "sb 1" -c stack $SCRATCH_OPTIONS $SCRATCH_DEV | perl -ne '
 	if (/byte offset (\d+), length (\d+)/) {
 		print "clear=", $1 / 512, "\n"; exit
 	}'`



