Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbdLDXIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Dec 2017 18:08:36 -0500
Date: Mon, 4 Dec 2017 12:53:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 10/13] fstests: crash consistency fsx test using
 dm-log-writes
Message-ID: <20171204205312.GB4910@magnolia>
References: <CAOQ4uxiGryFy7GLZUa0EWcbT+50cMfBb8a2dYa1mZ7tEf+UURg@mail.gmail.com>
 <20171128172152.ktvpnwv233govfwl@destiny>
 <CAOQ4uxgeKdZnxXcvt10MG2kT4PTZ4eZH+-v2R0zPJXTcRvONeQ@mail.gmail.com>
 <20171128200035.26kqhetxtemnm7z4@destiny>
 <CAOQ4uxh2OX9Lbnauv-ip5GC_8oCJ38hYsjjvp0+JFGYLqRk7nw@mail.gmail.com>
 <CAOQ4uxhQu-1AK71zg4Ce0cJd+xRt3Gf9zMMVb=Rs00zFuWA3hQ@mail.gmail.com>
 <20171128223308.GC21412@magnolia>
 <CAOQ4uxhj0-SBO_6cORsdJURmyrwvv_nxBRhKjMAb-PvxyeU6ew@mail.gmail.com>
 <CAOQ4uxhXWxkre7L7RDvpH8E4cwsHGZzVHKmCpBESfTUZhmQpUg@mail.gmail.com>
 <CAOQ4uxjBQ9ZzPe9GKCRYCjNFv3jP8NMAVQDb=LiNqNcEeRp47w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjBQ9ZzPe9GKCRYCjNFv3jP8NMAVQDb=LiNqNcEeRp47w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>

On Mon, Dec 04, 2017 at 10:17:30PM +0200, Amir Goldstein wrote:
> On Thu, Nov 30, 2017 at 10:28 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Wed, Nov 29, 2017 at 5:33 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> [...]
> > So far I was able to determine that your patch
> > "xfs: log recovery should replay deferred ops in order" is NOT the
> > cause of the problem.
> > This took some time, because at one point it took me 23 hr to get to
> > the dirty log
> > in test partition with modified 455 (no dm-log-writes).
> >
> > Attached metadump of corrupt test partition.
> > The xfs code this test was running with is v4.14-rc8.
> > I did not try to bisect any further because of the time it takes per commit.
> >
> > Let me know if you need any other info or if you want me to run the test
> > on my setup for specific patch and/or bisection points.
> >
> 
> I figured out what was going on in my test setup.
> The answer was in the attached dmesg, but I overlooked it:
> 
> [33816.533286] ata3.00: failed command: FLUSH CACHE EXT
> [33816.533294] ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 21
>                         res 40/00:00:20:44:ba/00:00:0c:00:00/40 Emask
> 0x10 (ATA bus error)
> [33816.533300] ata3.00: status: { DRDY }
> [33816.533309] ata3: hard resetting link
> 
> It appears that that test machine had a faulty SATA cable.
> 
> This is probably more cruel to fs than a dm-flakey/dm-log-writes test...

Not as bad as the time when I discovered that one of my UASP bridges was
arbitrarily injecting 'USBUSBUSB' into bus transfers.

> Cable replaced. Back to sanity. Sorry for the noise.

:)

--D

> Amir.


