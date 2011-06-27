Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5RFR2bR114811
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 10:27:02 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD2FD31A2E
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 08:27:01 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id p4BrXsB0ibjxZnzi
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 08:27:01 -0700 (PDT)
Received: by wyh22 with SMTP id 22so1636465wyh.26
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 08:27:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E089D4E.1060503@sandeen.net>
References: <4E063BC6.9000801@task.com.br> <4E0694CC.8050003@hardwarefreak.com>
	<4E06C967.2060107@task.com.br> <20110626235959.GC32466@dastard>
	<4E07FA07.4050907@hardwarefreak.com> <4E0803AA.20809@task.com.br>
	<4E08456F.1090503@hardwarefreak.com>
	<BANLkTimJm5Fe1LvD1AQYZC5QCDs0gXJpFA@mail.gmail.com>
	<4E089D4E.1060503@sandeen.net>
Date: Mon, 27 Jun 2011 11:27:00 -0400
Message-ID: <BANLkTikJe7ayzwD2Yqc7BHePfZ4x-M_SyQ@mail.gmail.com>
Subject: Re: mkfs.xfs error creating large agcount an raid
From: Paul Anderson <pha@umich.edu>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com, Marcus Pereira <marcus@task.com.br>, Stan Hoeppner <stan@hardwarefreak.com>

On Mon, Jun 27, 2011 at 11:10 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 6/27/11 8:04 AM, Paul Anderson wrote:
>> One thing this thread indicates is the need for a warning in mkfs.xfs
>> - according to several developers, there is, I think, linear increase
>> in allocation time to number of allocation groups.
>>
>> It would be helpful for the end user to simply issue a warning stating
>> this when the AG count seems high with a brief explanation as to why
>> it seems high. =A0I would allow it, but print the warning. =A0Even a
>> simple linear check like agroups>500 should suffice for "a while".
>
> I disagree.
>
> There are all sorts of ways a user can shoot themselves in the foot with
> unix commands. =A0Detecting and warning about all of them is a fool's err=
and.

Clearly a philosophical difference.

In managing complex software, it is far better for users if the
software itself can simply report why something is a problem, without
resorting to expecting users to read source code or ask developers
why.

There is nothing in the man page I see indicating what is good or bad
regarding allocation groups - either document it there or warn in the
software.  If allocation algorithms are linear with respect to
allocation groups, the something like this should be stated in the man
pages.

Doing neither leads to frustrated end users.  If you answer is "use
the defaults" then explain why and which parameters is applies to
(again in the documentation).

Also, it is not hard to do, and would have in this instance saved
developer time.  Since the issue has come up a few times the last
month or so, it seems worthwhile to deal with.

It's sort of like the story about giving a person a fish versus
teaching them how to fish.

Paul


>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D Warning! =A0mkfs.xfs detected insane =3D
> =3D =A0 option specification. =A0Cancel? =A0 =3D
> =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0=3D
> =3D =A0 =A0 =A0[ =A0 OK =A0 ] =A0 =A0 [ Cancel ] =A0 =A0 =3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> -Eric
>
>> Paul
>>
>> On Mon, Jun 27, 2011 at 4:55 AM, Stan Hoeppner <stan@hardwarefreak.com> =
wrote:
>>> On 6/26/2011 11:14 PM, Marcus Pereira wrote:
>>>> Em 27-06-2011 00:33, Stan Hoeppner escreveu:
>>>>>
>>>>> I recommend 3 changes, one of which I previously mentioned:
>>>>>
>>>>> 1. =A0Use 8 mirror pairs instead of 4
>>>>> 2. =A0Don't use striping. =A0Make an mdraid --linear device of the 8 =
mirrors
>>>>> 3. =A0Format with '-d agcount=3D32' which will give you 4 AGs per spi=
ndle
>>>>>
>>>>> Test this configuration and post your results.
>>>>
>>>> I am thanks for all advices. I will make the tests and post, may take
>>>> some time.
>>>>
>>>> About all other messages. My system may not be a Ferrari but its not a
>>>> Volks. I certainly do not have that many HDs in fiber channel, but the
>>>> sever is a dual core Xeon 6 cores with HT. Linux sees a total of 24
>>>> cores, total RAM is 24GB. The HDs are all SAS 15Krpm and the system ru=
ns
>>>> on SSD. They are dedicated to handle the maildir files and I have
>>>> several of those servers running nicely.
>>>> But I don=92t want to make the thread about my system larger.
>>>
>>> So you do or don't have the excessive head seek problem you previously
>>> mentioned? =A0If not then use the mkfs.xfs defaults.
>>>
>>>> Yes, I don=92t know much about XFS and Allocation groups, thanks for y=
ou
>>>> all to help me a bit.
>>>
>>> You're welcome. =A0Google should turn up a decent amount of information
>>> about XFS allocation groups if you're interested in further reading.
>>>
>>>> At the end the reason why I opened the thread it the error and the
>>>> developers should take some care about that.
>>>
>>>> Ok, no reason to use that many agcount but giving a "mkfs.xfs: pwrite64
>>>> failed: No space left on device" error for me stills seems a bug.
>>>
>>> The definition of a software bug stipulates incorrect or unexpected
>>> program behavior. =A0Error messages aren't bugs unless the wrong error
>>> message is returned for a given fault condition, or no error is returned
>>> when one should be.
>>>
>>> Are you stipulating that the above isn't the correct error message for
>>> the fault condition? =A0Or do you simply not understand the error messa=
ge?
>>> =A0If the latter, maybe you should simply ask what that error means bef=
ore
>>> saying the error message is a bug. :)
>>>
>>> --
>>> Stan
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
