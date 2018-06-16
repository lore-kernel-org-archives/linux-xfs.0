Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41434 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751407AbeFPEfj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Jun 2018 00:35:39 -0400
Subject: Re: cfg file versioning (was: [PATCH 2/2] mkfs: remove notion of
 config "type")
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <8c2a5a07-5d47-48a1-1593-e93eb0fb883a@sandeen.net>
 <20180614164121.GC6825@magnolia> <20180614234239.GO10363@dastard>
 <CAB=NE6V7JmsPpkCB1zp0CuY5YTJvMonG7UJPjScKYVJZLWb3xg@mail.gmail.com>
 <20180615023304.GP10363@dastard>
 <235ac120-5a94-0207-da54-badaa307502e@sandeen.net>
 <20180616001743.GT10363@dastard>
 <558124ff-bc3f-f969-072c-3db8c9493bfd@sandeen.net>
 <20180616024422.GB19934@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ac11ec46-688b-0692-948d-c90efd61076b@sandeen.net>
Date: Fri, 15 Jun 2018 23:35:37 -0500
MIME-Version: 1.0
In-Reply-To: <20180616024422.GB19934@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 6/15/18 9:44 PM, Dave Chinner wrote:
> On Fri, Jun 15, 2018 at 07:55:02PM -0500, Eric Sandeen wrote:
>> t
>>
>> On 6/15/18 7:17 PM, Dave Chinner wrote:
>>> On Thu, Jun 14, 2018 at 09:45:49PM -0500, Eric Sandeen wrote:
>>>>

...

>>>> So, pretend I'm dumb ('cause I often am) and spell it out for me, what would
>>>> we do with a version?
>>>>
>>>> If a config file contains a section or token that some version of mkfs doesn't
>>>> understand, it'll fail.
>>>>
>>>> If we try to read a config file with a too-new version, we'd ... fail?
>>>
>>> Fail with a useful error message, rather than do something
>>> unexpected or incorrect.
>>
>> like "section 'foo' uknown" or "token 'bar' unknown?"
>> We'd do that today...
> 
> User upgrades xfsprogs version (e.g. has built a git version to sort
> a problem with repair. Days later, runs mkfs, it throws "unknown
> foo" errors. User has no idea why, nor how to remedy the problem.

> As opposed to an error that says "Config file version too old -
> please update", which tells them exactly what the problem is, and
> it's easy to understand that it's a result of using the git version
> rather than the distro packaged version.

So the thing I'm still working out is what, exactly, would necessitate
a newer version stamped into a config file.

I'm being pedantic for two reasons; I don't want to add complexity we
don't need, and I don't want to implement versioning that doesn't
actually solve the future problem because we failed to clearly define
what the versioning means.  So bear with me, I guess, while I
look at actual concrete examples to be sure we've really defined what
versioning would actually mean, and make sure we're explicit about what
would require a version bump.

There are 2 things I can think of which could cause a config file
to become incompatible in some way with a future or past mkfs version;
I think these are the same two you alluded to.

1) We add or remove a section or token from mkfs's parsing abilities,
   within the current file format.

tl;dr: This should not change the version.  Read on if interested,
or skip down to 2)

Added/removed directives are indistinguishable, IMHO, from adding or
removing a command line option or suboption.  Say we remove -n ftype
some day, because by now everyone should be using it, or whatever.
Or maybe we add -m encryption=1

An older mkfs looking at a newer config file w/ new tokens would simply
reject them in the same way as it would reject an unknown commandline option.
I don't think we need to rev the version when we add new tokens, we just state
that it's unknown, as we do on the commandline:

# mkfs.xfs -m encryption=1/dev/blah
unknown option -m encryption=1

and with:

[metadata]
encryption=1

# mkfs.xfs /dev/blah
Unknown token at /etc/xfs/mkfs/default:5 : encryption=1 [*]

seems equally clear.  Same goes for any option that we deprecate and remove.

And further, an older or newer config file may not even /contain/ the added
or removed directive, so a file cannot be rejected based on version for that
reason alone; it can only be accepted or rejected based on the tokens actually
found within it - just like on the commandline.

So I really don't think adding or removing tokens from the parser for the current
cfg file format can possibly require a version change.

2) So maybe we'll change the config file format itself?

If we change it to a completely new format like xml or json, we'd be
validating the format, not testing a version.  We can't just slap
"cfg_file_version=2" at the top of an xml or json file and expect it to
parse, because... that's not xml or json.  So I don't think we can really drop
a version directive in today's cfg file and hope it'd be parseable in some new
future format's parser.

(if we /did/ change to xml we'd have a dtd version...!)

So I think the only case I see for bumping the version is if we change
some internal parsing detail of the current home-grown file format.
(INI is pretty standard and time tested so this seems unlikely, but ok...)

Maybe we'll do nested sections, or something, if this has some use
in your new subvolume work.  Maybe we have a new hierarchy in some
weird variant of an ini format?

[[foo]]
[bar]
baz=1

[wut]
urk=0

[[zap]]
...

I guess this is the only case where I can really see the value.  We'd
still need to make assumptions about differing binaries being able
parse out the version /itself/ (seem xml comment above).  So we'd need to
assume that we're still in an ini-like world, I guess, or at least not in
some other new, well-defined format..  It seems like the
safest way to do this would be to require a version number on the first
line as a comment, because the "# comment" syntax seems unlikely to
change?  So something like:

# mkfs-xfs-cfg-version-1

which is outside of the normal token parsing, because the whole /point/
of versioning in this case is that the parsing mechanism itself might change,
right?  So version /must/ be parsed independently from anything else.

So in this case we'd reject any newer version than we understand, and if
future mkfs ever drops old parsers, those would reject versions older than
what it supports.

So I've talked myself into needing a version, now to see if you agree
with me about which circumstances would actually trigger a version
change, and whether the version parsing itself needs to be separate from the
standard parsing, because it indicates the required parsing mechanism required
for the /rest/ of the file...

Thanks,
-Eric

[*] It doesn't say this today, but we should fix it to distinguish parsing
errors from unknown sections and tokens, then we can say "Unknown or
unsupported token ..."  etc.
