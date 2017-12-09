Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:37574 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdLILEh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Dec 2017 06:04:37 -0500
Received: by mail-wr0-f170.google.com with SMTP id k61so13016386wrc.4
        for <linux-xfs@vger.kernel.org>; Sat, 09 Dec 2017 03:04:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171204212120.484179273@linutronix.de>
References: <20171204211927.673291734@linutronix.de> <20171204212120.484179273@linutronix.de>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Sat, 9 Dec 2017 12:03:55 +0100
Message-ID: <CAOFm3uFkrMFZkUuXEgkDj+3fUHh8Nt0jz9BDpBXNW2JR+mLGJQ@mail.gmail.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Thomas,

On Mon, Dec 4, 2017 at 10:19 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
[...]

> +The common way of expressing the license of a source file is to add the
> +matching boiler plate text into the top comment of the file.  Due to

I would likely go with boilerplate instead. Unless you are talking
about the real flat thing [1][2] of course!

[1] http://www.virtualmuseum.ca/Exhibitions/Railway/en/ag/lg16.jpg
[2] http://whynameitthat.blogspot.be/2013/10/boiler-plate.html

> +formatting, typos etc. these "boiler plates" are hard to validate for
> +tools which are used in the context of license compliance.

Same as above, "boilerplates" might be better.

> +
> +An alternative to boilerplate text is the use of Software Package Data

And that's the correct way to go IMHO, so going boilerplate all the
way makes sense.

I shall add that while they --the boilerplates-- may be a source of
unexpected excitement for first-year law students, each time someone
sends a patch with these, there is a kitten that dies somewhere. And
we all love kitten, do we?

Thank you for using some of your precious real time writing this doc.

Jonathan,
As an English Major, does this make sense to you? (using boilerplate
as a single word, not the kitten thing)

-- 
Cordially
Philippe Ombredanne
