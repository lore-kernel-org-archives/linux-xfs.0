Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53645 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755460AbeFSU5M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 16:57:12 -0400
Date: Tue, 19 Jun 2018 22:57:10 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2] mkfs: add mkfs config version specifier for the
 config file
Message-ID: <20180619205710.GH7508@wotan.suse.de>
References: <20180618180520.22146-1-mcgrof@kernel.org>
 <e09a067d-5412-e0c7-f854-a0c5af1c6828@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e09a067d-5412-e0c7-f854-a0c5af1c6828@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com

On Tue, Jun 19, 2018 at 02:53:28PM -0500, Eric Sandeen wrote:
> Soo.... 
> 
> I'm really on the fence about versioning at all, because we have yet to
> identify any concrete scenario in which we'd need to bump the version;
> we haven't even defined what exactly the "version" implies.

Right.

> So unless anyone has a concrete example of how a version would be needed,
> functional, reliably-parsed, and well-defined I'm inclined to leave this out.

Dave asked for it, so I would imagine he could make a better case for it.

But from a generic file format point of view, a version typically does
make sense for a slew of reasons, but it is typically the not known, the
unexpected, for which it can be a life saver.

Things that I can mention other than what you mentioned (whether or not
they are good, this is just a list of crazy things):

 1) We move from using our own parser to e2fsprogs profile parser (recall
    that my studies revealed it was the smallest) or lib_iniconfig (more
    robust, and widely used, however a kitchen sink compared to e2fsprogs
    profile parser)

    Both however support the INI format we are using.

    The version however may help to make the old parser not barf if
    say we added some magic in the future which would make the old
    parser barf.

 2) Data type change for an existing token. Say crc=2 was invented
    (again just an example), it would barf on the old parser, but with
    the version check it would immediately tell you a more meaningful
    message.

Perhaps the biggest advantage I can think of then then is a better error
message for a set of supported features, starting with what we have today
reflected as parsed as version 1. This does differ from what we do with
the CLI, however as with the respecification simplifcation done on
config.c in contrast to the CLI respecification checks, I would see
this as a win for users, and yet keeps things simple.

If this seems acceptable and reasonable, then version would be a reflection
of supporting the format and layout of the file, as well was indicative
of supporting only a specific feature set.

Thoughts?

  Luis
