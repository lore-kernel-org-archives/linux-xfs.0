Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51612 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934675AbeFMAkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jun 2018 20:40:39 -0400
Date: Wed, 13 Jun 2018 10:40:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug report: kernel hangs when mounting a crafted xfs image
Message-ID: <20180613004036.GE10363@dastard>
References: <5B6AC96A-7049-48D7-82A1-4AB42322D38B@gatech.edu>
 <20180612224028.GD10363@dastard>
 <86416821-C693-4904-9A6E-E249722E0FA8@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86416821-C693-4904-9A6E-E249722E0FA8@gatech.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Tue, Jun 12, 2018 at 11:30:45PM +0000, Xu, Wen wrote:
> Hi Dave,
> 
> I feel I can get your point a bit. Anyway recently I am fuzzing
> log section of XFS.  I reported four new bugs to mail list today.
> They are all memory corruption issues, and I think some of them
> are enough to be used to perform controlled write and code
> execution. And I feel these bugs are not complex ones but exist
> there that cannot simply be covered by CRC protection?

If CRCs are enabled, then they fail when there are random bit
corruptions in the journal. That stops these *storage errors* from
causing further problems. Fuzzing filesystems was originally
introduced to modelling storage errors and determine where the
filesystem error handling was deficient.

However, since "fuzzing" was taken over by the security crowd yeas
ago, it's all about malicious actors. I don't know how many times I
have to say "we cannot defend against malicious actors" before that
sinks in.

Again: CRCs are intended to mitigate the threat model of storage
level errors causing problems, not to defeat /malicious attackers/.
Modelling malicous users by random bit perturbation without CRC
protection exposes fundamental architectural trust model
deficiencies we cannot fix, and playing whack-a-mole with /malicious
fuzzing/ does not change that. Existing filesystems cannot win that
game, and it does nothing to protect users against emerging storage
error models and trends. I care about data storage, not malicious
actors.

> In my
> humble opinions, CRC protection mainly hardens the integrity of
> the metadata instead of eliminating malicious metadata leading to
> unexpected behaviors.

Key word in that statement: /malicious/

> I am not very sure considering my limited
> knowledge on XFS but you can take a look on them and see the
> severity of these issues. 

They are input checking problems, and log recovery does not have
robust input checking. That's why it has CRC protection - so we can
detect storage based errors to avoid parsing broken input.

We really need to improve the log recovery input verification, but
it's way more complex than any other subsystem we currently do
verification on. Untangling that mess will take time, resources and
careful planning. It's not a fast fix, but we'll get there. In the
mean time, throwing large numbers of "malicious actor" fuzzer bugs at
us doesn't help anyone.

If you want to do really useful fuzzing, try finding problems that
the v5 filesystem CRC checking doesn't detect and protect against.
That's something directly useful to us and hence XFS users, because
it indicates structures on disk we haven't fully protected from
typical storage based bit corruptions.

Put simply: I don't really care about bugs from "malicious image
corruption". I care about bugs that arise from storage errors that
we don't already catch, and that means v5 filesystems need to be the
focus of filesystem fuzzing....

I *really* don't want to have to say this again.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
