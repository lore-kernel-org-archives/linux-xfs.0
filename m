Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:49522 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751844AbdKHMg2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 07:36:28 -0500
Received: by mail-wr0-f182.google.com with SMTP id o88so2270297wrb.6
        for <linux-xfs@vger.kernel.org>; Wed, 08 Nov 2017 04:36:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171107192846.GA24617@infradead.org>
References: <20171107020607.GA26910@magnolia> <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com> <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com> <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org> <20171107192846.GA24617@infradead.org>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Wed, 8 Nov 2017 13:35:46 +0100
Message-ID: <CAOFm3uFLRCZwtw4F884Rd=5=yZnX_ibzBzyiC4f+=5iju4k81Q@mail.gmail.com>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>

On Tue, Nov 7, 2017 at 8:28 PM, Christoph Hellwig <hch@infradead.org> wrote=
:
> On Tue, Nov 07, 2017 at 02:15:26PM -0500, Theodore Ts'o wrote:
>> On Tue, Nov 07, 2017 at 06:46:58PM +0000, Alan Cox wrote:
>> > > Given that it had no license text on it at all, it "defaults" to GPL=
v2,
>> > > so the GPLv2 SPDX identifier was added to it.
>> > >
>> > > No copyright was changed, nothing at all happened except we explicit=
ly
>> > > list the license of the file, instead of it being "implicit" before.
>> >
>> > Well if Christoph owns the copyright (if there is one) and he has stat=
ed
>> > he believes it is too trivial to copyright then it needs an SPDX tag t=
hat
>> > indicates the rightsholder has stated it's too trivial to copyright an=
d
>> > (by estoppel) revoked any right they might have to pursue a claim.
>>
>> If Cristoph has revoked any right to pursue a claim, then he's also
>> legally given up the right to complain if, say, Bradley Kuhn starting
>> distributing a version with a GPLv3 permission statement --- or if Greg
>> K-H adds a GPLv2 SPDX identifier.  :-)
>
>
> First Christoph really appreciate=D1=95 spelling his name right.
>
> Second Christoph really appreciates talking to him when trying to slap
> on licensing bits on his code.  I'm not evil, but I'd really like to
> understand what you are doing and why, and I might be fairly agreeable
> if that makes sense.
>
> Doing batch annotations of code where you do not the know any of
> the history of is a receipt for a desaster if we want to use that
> information anywhere.
>
> So Greg, please explain WTF you are trying to do and talk to the
> people who wrote the code you are "annotating".

Christoph:

I am not speaking for Greg but let me highlight some issues and
benefits as I chipped in a bit to help:

Some data points in the 4.14.rc7 kernel:
- there are 64,742 distinct license statements
 ... in 114,597 blocks of text
 ... in 42,602 files
- license statements represent 480,455 lines of text
- licenses are worded in 1,015 different ways
- there are about 85 distinct licenses, the bulk being the GPL

NB: All of these tallies were computed with scancode-toolkit [1]

License text lines represent about 14.7% of all source comments.
(using a CLOC to count comment lines)

>From an engineering perspective this feels to me as pure madness,
unless everyone in kernel land is in love with legalese!

I like to think of it this way:

Licensing is important but repetitive long boilerplate in patches and
in every file is just a noisy distraction from the code substance.

Imagine if the kernel had 500 versions of a printf() function?
Maintainers would refactor the hell of it to use a few functions.

Replacing the boilerplate with licensing ids is exactly the same:
a sane refactoring to remove duplicated boilerplate.

In the end and ideally there should be no more than one line of
licensing info per file, so no more than 70Kish: so there are
about 400K lines of boilerplate to remove.

The benefits now and later:
- no distraction with licensing boilerplate cr*p in patches and files
- no guessing licensing needed when sending a patch
- anyone can grep the kernel tree for licensing, no extra tool needed
- Greg must feel really good about deleting so much things for once

The downsides:
- folks can no longer express their creativity in licensing texts like
licensing thermal code under the "therms" of the GPL [2]
- legalese lovers need to find another codebase to satisfy their
addiction

Note also that beside the kernel, U-Boot has adopted the same
approach for quite a while, and in the application world the Eclipse
Foundation, JavaScript NPMs and Rubygems are some examples
that adopted SPDX license ids to simplify and clarify licensing
documentation.

[1] https://github.com/nexB/scancode-toolkit
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/drivers/w1/slaves/w1_therm.c?h=3Dv4.14-rc8#n8

--=20
Cordially
Philippe Ombredanne
