Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:40368 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdKUN5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Nov 2017 08:57:47 -0500
Received: by mail-wr0-f173.google.com with SMTP id s41so5943800wrc.7
        for <linux-xfs@vger.kernel.org>; Tue, 21 Nov 2017 05:57:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171120153105.38d2b892@alans-desktop>
References: <20171116183306.103584007@linutronix.de> <20171116184358.475929943@linutronix.de>
 <CAFGhKbxbW87yowc7trkiczjXV=37SqswwmOriTdSoxCXzFk-0A@mail.gmail.com>
 <CA+55aFz06uWZwjdgod4wd=dCY3wbU+4SdbhgNwsNzMFqUn2SiA@mail.gmail.com> <20171120153105.38d2b892@alans-desktop>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Tue, 21 Nov 2017 14:57:05 +0100
Message-ID: <CAOFm3uE52WQ5JO1oRYctDjOfxiPLUi38xCxjV7vty=a=TiBWiA@mail.gmail.com>
Subject: Re: [patch V2 02/11] LICENSES: Add the GPL 2.0 license
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Charlemagne Lasse <charlemagnelasse@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Alan, Linus,

On Mon, Nov 20, 2017 at 4:31 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> On Sat, 18 Nov 2017 11:14:00 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> You may be confusing things because of a newer version.
>>
>> On Sat, Nov 18, 2017 at 11:03 AM, Charlemagne Lasse
>> <charlemagnelasse@gmail.com> wrote:
>> >
>> > That should be "GNU Lesser General Public" and not "GNU Library General Public"
>>
>> That's just FSF revisionism.

Linus:

Revisionism it is indeed! Please see the fun and twisted tale of the
five official GPL texts below.


>> It used to be called "Library" over "Lesser", in the original GPL2.
>>
>> I suspect your other issues are similar "there's been different
>> versions over time" things. the address being one of them.
>>
>> We've actually taken some of the FSF updates over the years ("19yy" ->
>> "<year>", and the address change) but the main COPYING file still
>> calls the LGPL the "GNU Library General Public License".
>>
>> I refuse to change the original copyright wording due to idiotic
>> internal FSF politics that tried to change history.
>
> Do we have any files which had the later LGPL text attached to them - if
> so then they should be keeping that header.
>
> Which raises another question. If there are multiple GPL 2.0 texts which
> are *supposedly* legally identical but this has never been tested in law
> -that implies SPDX is wrong in tagging them identically in case they turn
> out not to be...

Alan:

This last comment rings as a red herring to me. There are many minute
variations of the GPL around and these are unlikely relevant.
No sane judge would consider any of these variations material IMHO and
should fine and throw in jail for contempt anyone arguing that this is
important.

Now, on the fun side, I discovered a while back through fixing a bug
in scancode-toolkit that there are FIVE versions of the official GPL
2.0 texts published by the FSF over the years. I am ashamed that I end
up doing this research and I would never thought I would need to
rummage through this pile.... but that came up while reviewing kernel
license scans and a few other scans to support Thomas and Greg
licensing clarification efforts.

Shocking, isn't it?

Let me call these GPL versions the GPL-2.0.0, GPL-2.0.1, GPL-2.0.2,
GPL-2.0.3 and GPL-2.0.4 :D

(but please this one time only!, let's forget about these afterwards)

GPL-2.0.4 v5. The most recent one was published after the GPL 3.0
publication [1] [2]. It refers to the `Franklin Street` address and to
the `GNU Lesser General Public License` top and bottom

GPL-2.0.3 v4. Slightly after the HTML publication of the new address
in v3, the address was changed in the text version [3]: It refers to
the  `Franklin Street` address and to the `GNU Library General Public
License` top and bottom.

GPL-2.0.2 v3. The previous one in force before the publication of the
GPL 3.0 came about the time of the FSF office move on May 1, 2005 to
Franklin Street [4] In this HTML version, it refers to the `Franklin
St` address and uses the `GNU Library General Public License` at the
top and `GNU Lesser General Public License`  at the bottom with a
conflicted opinion on which one of the LGPL 2 or 2.1 version to use.

GPL-2.0.1 v2. Around December 2003, a variation was published [5]. It
also predates the move to Franklin and it refers to the `Temple Place`
address and the `GNU Library General Public License` at the top and
`GNU Lesser General Public License`  at the bottom. Still split on
confused about which LGPL version to recommend.

GPL-2.0.1 v1. The one true and only original GPL 2.0.... the oldest
cached version [6] predates the move and it refers to the `Temple
Place` address and the `GNU Library General Public License`
throughout.

FWIW, I made sure I have all these texts as scancode detection rules
so I would get 100% exact hash matches on these oddities.

Now you will surely agree with me that the sole sane conclusion of
studying this mess is that there must some unhappy ghost that
triggered these text changes when the FSF moved from Temple Place to
Franklin Street in protest for the move. The only other possible
explanation I could fathom would be a bug in their teletype [7].

[1] https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
[2] http://web.archive.org/web/20070716031727/http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
[3] http://web.archive.org/web/20050511030123/http://www.fsf.org/licensing/licenses/gpl.txt
[4] http://web.archive.org/web/20050507090312/http://www.fsf.org/licensing/licenses/gpl.html
[5] http://web.archive.org/web/20031202220858/http://www.fsf.org/copyleft/gpl.html
[6] http://web.archive.org/web/19980119061851/http://www.fsf.org/copyleft/gpl.html
[7] https://en.wikipedia.org/wiki/IBM_Selectric_typewriter
-- 
Cordially
Philippe Ombredanne
