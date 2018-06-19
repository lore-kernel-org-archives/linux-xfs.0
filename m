Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50002 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755369AbeFSVV0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 17:21:26 -0400
Subject: Re: [PATCH v2] mkfs: add mkfs config version specifier for the config
 file
References: <20180618180520.22146-1-mcgrof@kernel.org>
 <e09a067d-5412-e0c7-f854-a0c5af1c6828@sandeen.net>
 <20180619205710.GH7508@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <26e331b2-182b-d928-cb94-8bb9b836ae5c@sandeen.net>
Date: Tue, 19 Jun 2018 16:21:25 -0500
MIME-Version: 1.0
In-Reply-To: <20180619205710.GH7508@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com



On 6/19/18 3:57 PM, Luis R. Rodriguez wrote:
> On Tue, Jun 19, 2018 at 02:53:28PM -0500, Eric Sandeen wrote:
>> Soo.... 
>>
>> I'm really on the fence about versioning at all, because we have yet to
>> identify any concrete scenario in which we'd need to bump the version;
>> we haven't even defined what exactly the "version" implies.
> 
> Right.
> 
>> So unless anyone has a concrete example of how a version would be needed,
>> functional, reliably-parsed, and well-defined I'm inclined to leave this out.
> 
> Dave asked for it, so I would imagine he could make a better case for it.

Yup; well, I spoke with Dave and he was kind of leaving it as an exercise
for the reader, an exercise in which we are now engaged.  :)

> But from a generic file format point of view, a version typically does
> make sense for a slew of reasons, but it is typically the not known, the
> unexpected, for which it can be a life saver.
> 
> Things that I can mention other than what you mentioned (whether or not
> they are good, this is just a list of crazy things):
> 
>  1) We move from using our own parser to e2fsprogs profile parser (recall
>     that my studies revealed it was the smallest) or lib_iniconfig (more
>     robust, and widely used, however a kitchen sink compared to e2fsprogs
>     profile parser)
> 
>     Both however support the INI format we are using.
> 
>     The version however may help to make the old parser not barf if
>     say we added some magic in the future which would make the old
>     parser barf.

... if the file format does not change, a parser change doesn't matter, and
a version change would be pointless.

>  2) Data type change for an existing token. Say crc=2 was invented
>     (again just an example), it would barf on the old parser, but with
>     the version check it would immediately tell you a more meaningful
>     message.

But how is that any different from what it would do on the command line for
a similar change?

"Invalid value 2 for token crc=2 on line XYZ" is completely reasonable, and
does not require any version information.

In fact, what you are suggesting here means we'd bump the version if and only
if the config file contained "crc=2" which makes little sense.

> Perhaps the biggest advantage I can think of then then is a better error
> message for a set of supported features, starting with what we have today
> reflected as parsed as version 1. This does differ from what we do with
> the CLI, however as with the respecification simplifcation done on
> config.c in contrast to the CLI respecification checks, I would see
> this as a win for users, and yet keeps things simple.

See my earlier email for why versioning cannot depend on the presence or
absence of any parseable tokens ... stating "token XYZ not supported"
should suffice IMHO.

(now, it's true that today we don't distinguish between unknown vs.
unsupported tokens, I don't know if I should try to fix that before 4.17
or not; again, though, that is on the parser side, not the config file side.)

> If this seems acceptable and reasonable, then version would be a reflection
> of supporting the format and layout of the file, as well was indicative
> of supporting only a specific feature set.

What is or is not a supported token is wholly a function of the mkfs/parser
version, not the config file version, right?

So, not to be argumentative ... but I remain unconvinced of the need for
config file versioning.

Thanks,
-Eric


> Thoughts?
> 
>   Luis
> 
