Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 20:54:15 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.225])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k863s8DW011764
	for <linux-xfs@oss.sgi.com>; Tue, 5 Sep 2006 20:54:09 -0700
Received: by wx-out-0506.google.com with SMTP id h29so2415237wxd
        for <linux-xfs@oss.sgi.com>; Tue, 05 Sep 2006 20:53:31 -0700 (PDT)
Message-ID: <2260b150609052053h31731a0eycababfab603749c9@mail.gmail.com>
Date: Wed, 6 Sep 2006 13:53:31 +1000
From: "Chris Seufert" <seufert@gmail.com>
Subject: Re: XFS Journal on md device
In-Reply-To: <20060906034027.GA7393@piper.madduck.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2260b150609051640y288629cbtcbc133d05b2b40dd@mail.gmail.com>
	 <44FE28A8.5000803@oss.sgi.com>
	 <2260b150609051853w1286eda7ve59a5df2c7e0ae1c@mail.gmail.com>
	 <20060906034027.GA7393@piper.madduck.net>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Seufert <seufert@gmail.com>, "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

I'm running Debian Testing (is that Etch), updated about a week ago,
on AMD64, with Kernel 2.6.18-rc5-mm1 + md hotfix(1) with md built-in,
no initrd, so raid autodetect works.

My root (/) volume is ext3 running on /dev/md0 (RAID 1), the problem
is with my /data volume thats xfs, running on /dev/sda, with log on
/dev/md4.

1: The patch is required becase mm1 killed the KConfig for md devices.

On 9/6/06, martin f krafft <madduck@madduck.net> wrote:
> also sprach Chris Seufert <seufert@gmail.com> [2006.09.06.0353 +0200]:
> > However on reboot xfs does a journal rebuild/repair. and the md
> > does a re-sync of the md device.
>
> Which distro?
>
> I am the Debian maintainer for mdadm and have run into the problem
> that the array used for / cannot be stopped until after / is
> unmounted, at which point nothing stops the array for there is no
> shutdownramfs.
>
> However, we (Debian) remount / read-only and I never see
> a filesystem check on reboot.
>
> --
> martin;              (greetings from the heart of the sun.)
>   \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
>
> spamtraps: madduck.bogus@madduck.net
>
> the micro$oft hoover: finally, a product that's supposed to suck!
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.5 (GNU/Linux)
>
> iD8DBQFE/kMrIgvIgzMMSnURAoSgAJ4mQ8a1RH6sYd7VRn4yZsRNKxbeSACdEGFv
> HeWvLK1N+R1nvxMfeqlDZk8=
> =LyfV
> -----END PGP SIGNATURE-----
>
>
>
