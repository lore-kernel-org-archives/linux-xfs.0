Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49950 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952025AbdDZCRR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 22:17:17 -0400
Subject: Re: [PATCH 00/12] mkfs: save user input into opts table
References: <20170423185503.31415-1-jtulak@redhat.com>
 <2bc062f7-eae5-b89a-59e6-4d10daadcd3e@sandeen.net>
 <20170426020213.GX28800@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <aa55ab19-7e6f-168b-8c3e-605fd4c35939@sandeen.net>
Date: Tue, 25 Apr 2017 21:17:15 -0500
MIME-Version: 1.0
In-Reply-To: <20170426020213.GX28800@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/25/17 9:02 PM, Luis R. Rodriguez wrote:
> On Tue, Apr 25, 2017 at 11:20:34AM -0500, Eric Sandeen wrote:
>> On 4/23/17 1:54 PM, Jan Tulak wrote:
>>> Hi guys,
>>>
>>> I decided to split my big patchset into more smaller ones. So, this is the
>>> first set. It adds set/get functions similar to Dave's suggestion, to save and
>>> retrieve user values to and from the big opts table and prepares the ground for
>>> future patches.
>>>
>>>
>>> It is a mix of patches I already submitted and new ones:
>>> Patches 2, 3, 4, 5 are just slightly modified to fix their issues.
>>> Other patches are new.
>>>
>>> The last few patches could be merged into one, because it should only
>>> substitute variables for get/set calls, but because there are so many
>>> places where the changes occurs, I split them into smaller chunks,
>>> making it (hopefully) easier for you to review.
>>>
>>> This patchset requires my two previous uint patches.
>>
>> Just to be clear, those were NAK'd, I believe, so these may need
>> to be rebased without them.
> 
> I checked and I see concerns for the data types used expressed but from
> what I can tell Jan addressed these concerns and followed up with
> subsequent patches. Perhaps it was not clear given he only respun one
> of the patches multiple times.

I apologize - somehow I missed the re-submission.  I'll take a look.

-Eric
