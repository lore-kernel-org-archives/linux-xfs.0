Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53210 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750738AbeAPHzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 02:55:46 -0500
Date: Mon, 15 Jan 2018 23:55:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Reproducible XFS filesystem artifacts
Message-ID: <20180116075541.GO5602@magnolia>
References: <CA+0CQ21AhCGcBdNo5RY4Q=oakNQO1S_jgHU2f-BdG-fL71ZyFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+0CQ21AhCGcBdNo5RY4Q=oakNQO1S_jgHU2f-BdG-fL71ZyFw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Philipp Schrader <philipp@peloton-tech.com>
Cc: linux-xfs@vger.kernel.org, Austin Schuh <austin@peloton-tech.com>, Alison Chaiken <alison@peloton-tech.com>

On Mon, Jan 15, 2018 at 08:49:02PM -0800, Philipp Schrader wrote:
> Hi all,
> 
> We're currently trying to clean up our build processes to make sure
> that all binary output is reproducible (along the lines of
> https://reproducible-builds.org/).
> 
> A few of our build artifacts are filesystem images. We have VFAT and
> XFS images. They represent the system updates for units in the field
> and at developers' desks.
> 
> We're trying to make these images reproducible and I'm in need of some
> help. As far as I can tell, one of the biggest culprits is VFAT's
> "creation time" and XFS' ctime fields.
> 
> Example of VFAT's differences:
> $ hexdump -C ~/swu-tests/swu1/dvt-controller-kernel.vfat >
> ~/swu-tests/swu1/dvt-controller-kernel.vfat.dump
> $ hexdump -C ~/swu-tests/swu3/dvt-controller-kernel.vfat >
> ~/swu-tests/swu3/dvt-controller-kernel.vfat.dump
> $ diff -u ~/swu-tests/swu1/dvt-controller-kernel.vfat.dump
> ~/swu-tests/swu3/dvt-controller-kernel.vfat.dump
> --- /x1/home/philipp/swu-tests/swu1/dvt-controller-kernel.vfat.dump
>  2017-12-28 12:19:57.349880993 -0800
> +++ /x1/home/philipp/swu-tests/swu3/dvt-controller-kernel.vfat.dump
>  2017-12-28 12:19:50.253881196 -0800
> ...
> @@ -1011,13 +1011,13 @@
>  *
>  00006200  41 7a 00 49 00 6d 00 61  00 67 00 0f 00 7c 65 00  |Az.I.m.a.g...|e.|
>  00006210  00 00 ff ff ff ff ff ff  ff ff 00 00 ff ff ff ff  |................|
> -00006220  5a 49 4d 41 47 45 20 20  20 20 20 20 00 00 63 9b  |ZIMAGE      ..c.|
> +00006220  5a 49 4d 41 47 45 20 20  20 20 20 20 00 64 d8 95  |ZIMAGE      .d..|
>  00006230  9c 4b 9c 4b 00 00 00 00  21 00 03 00 a0 2d 4a 00  |.K.K....!....-J.|
>  00006240  42 6f 00 6c 00 6c 00 65  00 72 00 0f 00 67 2d 00  |Bo.l.l.e.r...g-.|
>  00006250  64 00 76 00 74 00 2e 00  64 00 00 00 74 00 62 00  |d.v.t...d...t.b.|
> ...
> 
> As per the structure, that's the ctime (creation time) being different.
> https://www.kernel.org/doc/Documentation/filesystems/vfat.txt

Yep.

> I've not had much luck digging into the XFS spec to see prove that the
> ctime is different, but I'm pretty certain. When I mount the images, I
> can see that ctime is different:
> $ stat -c %x,%y,%z,%n /mnt/{a,b}/log/syslog
> 2017-12-28 11:26:53.552000096 -0800,1969-12-31 16:00:00.000000000
> -0800,2017-12-28 11:28:50.524000060 -0800,/mnt/a/log/syslog
> 2017-12-28 10:46:38.739999913 -0800,1969-12-31 16:00:00.000000000
> -0800,2017-12-28 10:48:17.180000049 -0800,/mnt/b/log/syslog
> 
> As far as I can tell, there are no mount options to null out the ctime
> fields. (As an aside I'm curious as to the reason for this).

Correct, there's (afaict) no userspace interface to change ctime, since
it reflects the last time the inode metadata was updated by the kernel.

> Is there a tool that lets me null out ctime fields on a XFS filesystem
> image

None that I know of.

> Or maybe is there a library that lets me traverse the file
> system and set the fields to zero manually?

Not really, other than messing up the image with the debugger.

> Does what I'm asking make sense? I feel like I'm not the first person
> to tackle this, but I haven't been lucky with finding anything to
> address this.

I'm not sure I understand the use case for exactly reproducible filesystem
images (as opposed to the stuff inside said fs), can you tell us more?

--D

> Thanks,
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
