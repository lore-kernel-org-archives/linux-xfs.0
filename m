Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46986 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936086AbdGTWsf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 18:48:35 -0400
Subject: Re: Collecting aged XFS profiles
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
 <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
 <20170717234814.GK17762@dastard>
 <CAAxjCEzP=bf5S12J8rTn7EyJK_MeM=t1JSa7pBzZyXK=9TrjQQ@mail.gmail.com>
 <bcb651de-75bf-97a6-7ed8-c083d2a440e5@sandeen.net>
 <CAAxjCEzZ2Q0wL=nhGVHVtK3M5Ws3MQdrUNKm3jJKO+1y-wxTkw@mail.gmail.com>
 <20170720030252.GT17762@dastard>
 <93399fda-5d20-5ec9-14f1-5496814fed79@sandeen.net>
 <20170720043806.GU17762@dastard>
 <a7d9b022-4328-995c-845e-abc59e5fd038@sandeen.net>
 <20170720222743.GV17762@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a2f12a57-3eae-f7b1-897f-5f56575b00b6@sandeen.net>
Date: Thu, 20 Jul 2017 17:48:34 -0500
MIME-Version: 1.0
In-Reply-To: <20170720222743.GV17762@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org



On 07/20/2017 05:27 PM, Dave Chinner wrote:
> On Thu, Jul 20, 2017 at 09:24:58AM -0500, Eric Sandeen wrote:
>> On 07/19/2017 11:38 PM, Dave Chinner wrote:
>>> On Wed, Jul 19, 2017 at 10:55:23PM -0500, Eric Sandeen wrote:
>>> FWIW, people building from the git tree are probably using the
>>> master branch (v4.11.0), not the for-next branch. I used to stage
>>> all the -rcX releases in the master branch, which was why I was
>>> confused by this at first. Never mind, I'll update my scripts that
>>> haven't been pulling the xfsprogs for-next branch from kernel.org...
>>
>> yeah, I was doing that when I was new to the maintainer game, for-next
>> was rebasable and more forgiving.  Maybe I should change that back.
> 
> Yeah, for-next is more forgiving, but if you are tagging stuff for
> releases (even -rc) then it probably should have been merged back
> into the master branch and then tagged. I've always worked under the
> assumption that -rc releases are "stable" release points because you
> are asking the wider public to use and test the release....
> 
> i.e. If stuff needs to be undone after a -rc release then we should
> use reverts that explain why something was undone - rebasing the
> entire dev branch to remove the problem from recorded history means
> we can't easily find out why that thing caused problems years down
> the track.

Fair enough, I'll switch back to that method, pushing things to
master more often, at least by the -rc stage.

-Eric
