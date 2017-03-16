Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33722 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752460AbdCQANT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 20:13:19 -0400
Subject: Re: [PATCH 00/22] mkfs.xfs: Make stronger conflict checks
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170316233845.GY28800@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2030b8be-4fe0-c767-4c3a-0e5ff25c4362@sandeen.net>
Date: Thu, 16 Mar 2017 16:47:10 -0700
MIME-Version: 1.0
In-Reply-To: <20170316233845.GY28800@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On 3/16/17 4:38 PM, Luis R. Rodriguez wrote:
> On Wed, Mar 15, 2017 at 04:59:55PM +0100, Jan Tulak wrote:
>> This set is a follow-up of some old discussions and further attempts to untangle
>> the spaghetti in options parsing. In short, this patchset allows to define
>> cross-option conflicts and makes the conflicts detection more robust.
> 
> This series is pretty large. There are quite a bit of patches which just rename
> something, or just shove code from one place to another. Can you group up
> non-functional changes together first, and send a small series of simple stuff
> with no functional changes first?

I have to say I'm still struggling with it as well.  Apologies for the 
random detail nitpicking, I'm trying to look through it all to get a better
big picture.

And as far as "no-op changes" it's imperative to make them really no-op.
Make sure that other random changes aren't stuck into the middle of anything...

I'll probably keep flinging comments on various patches as I read them,
some of it may be helpful in terms of just learning some best practice
for patches, but TBH I'm still trying to wrap my head around the big change
and purpose.

-Eric
