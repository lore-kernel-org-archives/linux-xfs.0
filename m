Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70C2C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 21:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241431AbiBGVmI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241483AbiBGVmI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 16:42:08 -0500
X-Greylist: delayed 594 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 13:42:07 PST
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9387C0612A4
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 13:42:07 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id EB80115B04;
        Mon,  7 Feb 2022 15:31:43 -0600 (CST)
Message-ID: <fbe0bef1-a9a7-9670-1548-9792639ae2a2@sandeen.net>
Date:   Mon, 7 Feb 2022 15:32:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263811682.863810.12064586264139896800.stgit@magnolia>
 <bb88560e-bbdf-80c5-b4d6-6c00f4ab3ef1@sandeen.net>
 <20220205003618.GU8313@magnolia> <20220207010541.GE59729@dread.disaster.area>
 <20220207170913.GA8313@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 04/17] libfrog: move the GETFSMAP definitions into libfrog
In-Reply-To: <20220207170913.GA8313@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/7/22 11:09 AM, Darrick J. Wong wrote:
> On Mon, Feb 07, 2022 at 12:05:41PM +1100, Dave Chinner wrote:
>> On Fri, Feb 04, 2022 at 04:36:18PM -0800, Darrick J. Wong wrote:
>>> On Fri, Feb 04, 2022 at 05:18:12PM -0600, Eric Sandeen wrote:

...

>>>> Do we /need/ to build fully functional xfsprogs on old userspace?
>>>> (really: systems with old kernel headers?)  How far back do we go,
>>>> I wonder?  Anyway...
>>>
>>> TBH we could probably get rid of these entirely, assuming nobody is
>>> building xfsprogs with old kernel headers for a system with a newer
>>> kernel?
>>
>> Just fiddle the autoconf rules to refuse to build if the system
>> headers we need aren't present. It just means that build systems
>> need to have the userspace they intend to target installed in the
>> build environment.
> 
> GETFSMAP premiered in 4.12, so I'm going to take this response (and the
> lack of any others) as a sign that I can respin this patch to require
> recent kernel headers instead of providing our own copy.

Sounds reasonable, thanks. Maybe in the future when we add stuff like
this for bleeding edge interfaces we can mark the date, and mark another
one in what, a year or two, as a reminder for removal.

-Eric

