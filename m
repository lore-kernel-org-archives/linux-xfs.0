Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5RD4veq099665
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 08:04:57 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8D981EE15FC
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 06:04:55 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id FtQZLykMMqDA7TYJ
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 06:04:55 -0700 (PDT)
Received: by wwj26 with SMTP id 26so2724265wwj.32
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 06:04:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E08456F.1090503@hardwarefreak.com>
References: <4E063BC6.9000801@task.com.br> <4E0694CC.8050003@hardwarefreak.com>
	<4E06C967.2060107@task.com.br> <20110626235959.GC32466@dastard>
	<4E07FA07.4050907@hardwarefreak.com> <4E0803AA.20809@task.com.br>
	<4E08456F.1090503@hardwarefreak.com>
Date: Mon, 27 Jun 2011 09:04:54 -0400
Message-ID: <BANLkTimJm5Fe1LvD1AQYZC5QCDs0gXJpFA@mail.gmail.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-xfs@oss.sgi.com, Marcus Pereira <marcus@task.com.br>

One thing this thread indicates is the need for a warning in mkfs.xfs
- according to several developers, there is, I think, linear increase
in allocation time to number of allocation groups.

It would be helpful for the end user to simply issue a warning stating
this when the AG count seems high with a brief explanation as to why
it seems high.  I would allow it, but print the warning.  Even a
simple linear check like agroups>500 should suffice for "a while".

Paul

On Mon, Jun 27, 2011 at 4:55 AM, Stan Hoeppner <stan@hardwarefreak.com> wro=
te:
> On 6/26/2011 11:14 PM, Marcus Pereira wrote:
>> Em 27-06-2011 00:33, Stan Hoeppner escreveu:
>>>
>>> I recommend 3 changes, one of which I previously mentioned:
>>>
>>> 1. =A0Use 8 mirror pairs instead of 4
>>> 2. =A0Don't use striping. =A0Make an mdraid --linear device of the 8 mi=
rrors
>>> 3. =A0Format with '-d agcount=3D32' which will give you 4 AGs per spind=
le
>>>
>>> Test this configuration and post your results.
>>
>> I am thanks for all advices. I will make the tests and post, may take
>> some time.
>>
>> About all other messages. My system may not be a Ferrari but its not a
>> Volks. I certainly do not have that many HDs in fiber channel, but the
>> sever is a dual core Xeon 6 cores with HT. Linux sees a total of 24
>> cores, total RAM is 24GB. The HDs are all SAS 15Krpm and the system runs
>> on SSD. They are dedicated to handle the maildir files and I have
>> several of those servers running nicely.
>> But I don=92t want to make the thread about my system larger.
>
> So you do or don't have the excessive head seek problem you previously
> mentioned? =A0If not then use the mkfs.xfs defaults.
>
>> Yes, I don=92t know much about XFS and Allocation groups, thanks for you
>> all to help me a bit.
>
> You're welcome. =A0Google should turn up a decent amount of information
> about XFS allocation groups if you're interested in further reading.
>
>> At the end the reason why I opened the thread it the error and the
>> developers should take some care about that.
>
>> Ok, no reason to use that many agcount but giving a "mkfs.xfs: pwrite64
>> failed: No space left on device" error for me stills seems a bug.
>
> The definition of a software bug stipulates incorrect or unexpected
> program behavior. =A0Error messages aren't bugs unless the wrong error
> message is returned for a given fault condition, or no error is returned
> when one should be.
>
> Are you stipulating that the above isn't the correct error message for
> the fault condition? =A0Or do you simply not understand the error message?
> =A0If the latter, maybe you should simply ask what that error means before
> saying the error message is a bug. :)
>
> --
> Stan
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
