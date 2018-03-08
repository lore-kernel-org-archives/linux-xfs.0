Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59056 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750783AbeCHX26 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Mar 2018 18:28:58 -0500
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
References: <20180305150546.32191-1-jtulak@redhat.com>
 <20180305215659.GE18129@dastard>
 <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net>
 <20180305223148.GG18129@dastard>
 <421d1afd-5af1-aef9-e6bb-3addcdeeff3f@sandeen.net>
 <CACj3i73y_ZWvgdv3aKTKaKGuo+6uhcfy1465T3CD2uQDLE3=xQ@mail.gmail.com>
 <20180306213915.GJ18129@dastard>
 <CACj3i71SHP90DOAhpS3kWyY_6gnx9OzTqgHy7=uxAZH0cfUKMw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e7a132d5-33de-736f-840a-8de45910846c@sandeen.net>
Date: Thu, 8 Mar 2018 17:28:54 -0600
MIME-Version: 1.0
In-Reply-To: <CACj3i71SHP90DOAhpS3kWyY_6gnx9OzTqgHy7=uxAZH0cfUKMw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 3/8/18 4:57 AM, Jan Tulak wrote:
> I tested it on Fedora 27. Exit codes 2 and 4 ("File system errors
> corrected, system should be rebooted" and "File system errors left
> uncorrected") drop the user into the emergency shell. Anything else
> and the boot continues.
> 
> This happens before root volume is mounted during the boot, so I
> propose this behaviour for fsck.xfs:
> - if the volume/device is mounted, exit with 16 - usage or syntax
> error (just to be sure)
> - if the volume/device has a dirty log, exit with 4 - errors left
> uncorrected (drop to the shell)
> - if we find no errors, exit with 0 - no errors
> - if we find anything and xfs_repair ends successfully, exit with 1 -
> errors corrected
> - anything else and exit with 8 - operational error
> 
> And is there any other way how to get the "there were some errors, but
> we corrected them" other than either 1) screenscrape xfs_repair or 2)
> run xfs_repair twice, once with -n to detect and then without -n to
> fix the found errors?

If it's critical to report whether errors were fixed, it would be trivial
to add a new option to xfs_repair which causes it to test fs_is_dirty for
runs without "-n", and exit with a different value.

The approach above looks ok in general.  The main motivation for this
is to be able to use some config management tool to push out a config
to a whole fleet of machines in a lab, and have them check/fix the
root fs without interaction.  If a filesystem is failing to mount due
to a dirty log, it's likely that the admin is in a more hands-on mode
by then anyway.

A dirty log could also be "operational error" if we decree that forcefsck
and friends should only be used on a clean reboot - but I'm less certain
about that.

Perhaps a guiding principal should be that we have no easy way to repair
the root fs today in /any/ situation, so any correct/safe improvement
to that situation is an improvement, even if not all cases are handled
at this point.

-Eric
