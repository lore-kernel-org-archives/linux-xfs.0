Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5RFbHSp115282
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 10:37:17 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C07931B03
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 08:37:16 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 79BJJQrIHAiNN40S for <linux-xfs@oss.sgi.com>;
	Mon, 27 Jun 2011 08:37:16 -0700 (PDT)
Message-ID: <4E08A3AB.9050207@sandeen.net>
Date: Mon, 27 Jun 2011 10:37:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs error creating large agcount an raid
References: <4E063BC6.9000801@task.com.br>	<4E0694CC.8050003@hardwarefreak.com>	<4E06C967.2060107@task.com.br>	<20110626235959.GC32466@dastard>	<4E07FA07.4050907@hardwarefreak.com>	<4E0803AA.20809@task.com.br>	<4E08456F.1090503@hardwarefreak.com>	<BANLkTimJm5Fe1LvD1AQYZC5QCDs0gXJpFA@mail.gmail.com>	<4E089D4E.1060503@sandeen.net>
	<BANLkTikJe7ayzwD2Yqc7BHePfZ4x-M_SyQ@mail.gmail.com>
In-Reply-To: <BANLkTikJe7ayzwD2Yqc7BHePfZ4x-M_SyQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Paul Anderson <pha@umich.edu>
Cc: linux-xfs@oss.sgi.com, Marcus Pereira <marcus@task.com.br>, Stan Hoeppner <stan@hardwarefreak.com>

On 6/27/11 10:27 AM, Paul Anderson wrote:
> On Mon, Jun 27, 2011 at 11:10 AM, Eric Sandeen <sandeen@sandeen.net> wrot=
e:
>> On 6/27/11 8:04 AM, Paul Anderson wrote:
>>> One thing this thread indicates is the need for a warning in mkfs.xfs
>>> - according to several developers, there is, I think, linear increase
>>> in allocation time to number of allocation groups.
>>>
>>> It would be helpful for the end user to simply issue a warning stating
>>> this when the AG count seems high with a brief explanation as to why
>>> it seems high.  I would allow it, but print the warning.  Even a
>>> simple linear check like agroups>500 should suffice for "a while".
>>
>> I disagree.
>>
>> There are all sorts of ways a user can shoot themselves in the foot with
>> unix commands.  Detecting and warning about all of them is a fool's erra=
nd.
> =

> Clearly a philosophical difference.
> =

> In managing complex software, it is far better for users if the
> software itself can simply report why something is a problem, without
> resorting to expecting users to read source code or ask developers
> why.
> =

> There is nothing in the man page I see indicating what is good or bad
> regarding allocation groups - either document it there or warn in the
> software.  If allocation algorithms are linear with respect to
> allocation groups, the something like this should be stated in the man
> pages.
> =

> Doing neither leads to frustrated end users.  If you answer is "use
> the defaults" then explain why and which parameters is applies to
> (again in the documentation).
> =

> Also, it is not hard to do, and would have in this instance saved
> developer time.  Since the issue has come up a few times the last
> month or so, it seems worthwhile to deal with.

This one instance would not be hard to do, agreed.

To point out every potential pitfall in every bad option or combination
of options would be impossible.

I'd be happy with a version of the FAQ entry Dave pointed to in
the mkfs.xfs manpage, though, basically "don't change the defaults
unless you know for sure that it will address a shortcoming you have
seen in testing."

> It's sort of like the story about giving a person a fish versus
> teaching them how to fish.

Or a little like performing neurosurgery on a person vs. teaching
them how to do it themselves.  ;)

There is lots of "teaching to fish" in the documentation and the FAQ;
until you are really able to delve into the technical complexities
of XFS you probably should not try to fish in water that is too deep.

Just because a knob is there doesn't mean you should turn it as
far as it can go, and I don't think it's our job to warn against
that in every instance, either...

Those who wish to learn would be well advised to read up on the
many detailed technical docs available; I don't think that the
mkfs.xfs code is the right place to do this teaching, though.

But I guess it is a philosophical difference.

-Eric

> Paul
> =

> =

>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> =3D Warning!  mkfs.xfs detected insane =3D
>> =3D   option specification.  Cancel?   =3D
>> =3D                                    =3D
>> =3D      [   OK   ]     [ Cancel ]     =3D
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> -Eric
>>
>>> Paul
>>>
>>> On Mon, Jun 27, 2011 at 4:55 AM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
>>>> On 6/26/2011 11:14 PM, Marcus Pereira wrote:
>>>>> Em 27-06-2011 00:33, Stan Hoeppner escreveu:
>>>>>>
>>>>>> I recommend 3 changes, one of which I previously mentioned:
>>>>>>
>>>>>> 1.  Use 8 mirror pairs instead of 4
>>>>>> 2.  Don't use striping.  Make an mdraid --linear device of the 8 mir=
rors
>>>>>> 3.  Format with '-d agcount=3D32' which will give you 4 AGs per spin=
dle
>>>>>>
>>>>>> Test this configuration and post your results.
>>>>>
>>>>> I am thanks for all advices. I will make the tests and post, may take
>>>>> some time.
>>>>>
>>>>> About all other messages. My system may not be a Ferrari but its not a
>>>>> Volks. I certainly do not have that many HDs in fiber channel, but the
>>>>> sever is a dual core Xeon 6 cores with HT. Linux sees a total of 24
>>>>> cores, total RAM is 24GB. The HDs are all SAS 15Krpm and the system r=
uns
>>>>> on SSD. They are dedicated to handle the maildir files and I have
>>>>> several of those servers running nicely.
>>>>> But I don=92t want to make the thread about my system larger.
>>>>
>>>> So you do or don't have the excessive head seek problem you previously
>>>> mentioned?  If not then use the mkfs.xfs defaults.
>>>>
>>>>> Yes, I don=92t know much about XFS and Allocation groups, thanks for =
you
>>>>> all to help me a bit.
>>>>
>>>> You're welcome.  Google should turn up a decent amount of information
>>>> about XFS allocation groups if you're interested in further reading.
>>>>
>>>>> At the end the reason why I opened the thread it the error and the
>>>>> developers should take some care about that.
>>>>
>>>>> Ok, no reason to use that many agcount but giving a "mkfs.xfs: pwrite=
64
>>>>> failed: No space left on device" error for me stills seems a bug.
>>>>
>>>> The definition of a software bug stipulates incorrect or unexpected
>>>> program behavior.  Error messages aren't bugs unless the wrong error
>>>> message is returned for a given fault condition, or no error is return=
ed
>>>> when one should be.
>>>>
>>>> Are you stipulating that the above isn't the correct error message for
>>>> the fault condition?  Or do you simply not understand the error messag=
e?
>>>>  If the latter, maybe you should simply ask what that error means befo=
re
>>>> saying the error message is a bug. :)
>>>>
>>>> --
>>>> Stan
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>
>>
>>
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
