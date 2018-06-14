Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54758 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbeFNEXK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 00:23:10 -0400
Subject: Re: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <20180614040628.GJ10363@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c4ae2aaf-ee28-5c35-b3f5-ffe8a57d3c01@sandeen.net>
Date: Wed, 13 Jun 2018 23:23:09 -0500
MIME-Version: 1.0
In-Reply-To: <20180614040628.GJ10363@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On 6/13/18 11:06 PM, Dave Chinner wrote:
> With this change, we'll have code to maintain it to ensure that the
> file gets updated properly, and it will probably take more time and
> effort to validate that the generated file is correct (and debug if
> it's not!) compared to the 30s it will take to hand edit the
> template file to change or add a new default...

Well, yeah.  /if/ we need a template, as well as text in a man page,
then this gets it down to editing 1 file instead of two, I guess.
But it really seems like we need to rethink these structures to get it
all tied together, not requiring 2 or 3 manual updates across several files.
It's bound to get out of sync.  I guess that can wait, but right now this
dispersal isn't good.

> I'm also not convinced we should ship a "default.template" file,
> either.  I'd much prefer we ship a real config file with all the
> options defined but commented out as a "start here template".

As the code stands today, if a 100% commented-out config file
exists, then mkfs will tell you that it's overriding built-in
defaults with the config file which contains ... nothing.
If we ship such a thing by default, that's what will happen by
default.

(Actually today it fails to parse and errors out but a patch
to fix that is on the list).

I guess we could behave as if "no config file" if a config file
contained no parseable tokens ... but that gets weird too.

Putting a blank config file in place to be parsed by default
is messy, so a .template approach seems reasonable to me, if we
need such a thing at all.

-Eric
