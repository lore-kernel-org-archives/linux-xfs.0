Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55311 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeFTNL5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jun 2018 09:11:57 -0400
Received: by mail-wm0-f65.google.com with SMTP id v16-v6so5917004wmh.5
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jun 2018 06:11:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180619235244.GA5527@wotan.suse.de>
References: <20180618180520.22146-1-mcgrof@kernel.org> <e09a067d-5412-e0c7-f854-a0c5af1c6828@sandeen.net>
 <20180619205710.GH7508@wotan.suse.de> <26e331b2-182b-d928-cb94-8bb9b836ae5c@sandeen.net>
 <20180619235244.GA5527@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 20 Jun 2018 15:11:35 +0200
Message-ID: <CACj3i72h7P52_Aumzqzo0bkqAMwyP+9BcvzkFHTRbK2JEmqb+w@mail.gmail.com>
Subject: Re: [PATCH v2] mkfs: add mkfs config version specifier for the config file
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Chinner, Dave" <david@fromorbit.com>

On Wed, Jun 20, 2018 at 1:52 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Tue, Jun 19, 2018 at 04:21:25PM -0500, Eric Sandeen wrote:
>> On 6/19/18 3:57 PM, Luis R. Rodriguez wrote:
>> > But from a generic file format point of view, a version typically does
>> > make sense for a slew of reasons, but it is typically the not known, the
>> > unexpected, for which it can be a life saver.
>> >
>> > Things that I can mention other than what you mentioned (whether or not
>> > they are good, this is just a list of crazy things):
>> >
>> >  1) We move from using our own parser to e2fsprogs profile parser (recall
>> >     that my studies revealed it was the smallest) or lib_iniconfig (more
>> >     robust, and widely used, however a kitchen sink compared to e2fsprogs
>> >     profile parser)
>> >
>> >     Both however support the INI format we are using.
>> >
>> >     The version however may help to make the old parser not barf if
>> >     say we added some magic in the future which would make the old
>> >     parser barf.
>>
>> ... if the file format does not change, a parser change doesn't matter, and
>> a version change would be pointless.
>
> It can. Consider support for different comment styles.

IMO comments are part of the format and if they change, then the
format itself was changed too. So I find it difficult to see any
practical use for a config version, but all arguments about it were
already said. Still, if we end up with something like this, let's make
the section to be optional.

If we ever happen to find ourselves in such situation and we need the
version check as an emergency brake, then we can specify that the v2
format has to begin with version=2. The old parser will understand it
and abort, but if it is not present, it is equal to version=1 and we
will not pollute the configs in the meantime.

Cheers,
Jan
