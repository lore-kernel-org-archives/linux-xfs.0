Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33385 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbdGQTAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2017 15:00:24 -0400
Received: by mail-io0-f176.google.com with SMTP id 5so1294228iow.0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2017 12:00:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
From: Stefan Ring <stefanrin@gmail.com>
Date: Mon, 17 Jul 2017 21:00:19 +0200
Message-ID: <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
Subject: Re: Collecting aged XFS profiles
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Saurabh Kadekodi <saukad@cs.cmu.edu>
Cc: linux-xfs@vger.kernel.org

On Sun, Jul 16, 2017 at 2:11 AM, Saurabh Kadekodi <saukad@cs.cmu.edu> wrote=
:
> Hi,
>
> I am a PhD student studying file and storage systems and I am currently c=
onducting research on local file system aging. My research aims at understa=
nding realistic aging patterns and analyzing the effects of aging on file s=
ystem data structures and its performance. For this purpose, I would like t=
o capture characteristics of naturally aged file systems (i.e. not aged via=
 synthetic workload generators).
>
> In order to facilitate this profile capture, I have written a shell / pyt=
hon based profiling tool (fsagestats - https://github.com/saurabhkadekodi/f=
sagestats)  that does a file system tree walk and captures different charac=
teristics (file age, file size and directory depth) of files and directorie=
s and produces distributions. I do not care about file names or data within=
 each file. It also runs xfs_db in order to capture the free space fragment=
ation, file fragmentation, directory fragmentation and overall fragmentatio=
n; all of which are directly correlated with the file system performance. I=
t dumps the results in the results dir, which is to be specified when you r=
un fsagestats. You can send me the aging profile by tarring up the results =
directory and sending it via email.
>
> Since I do not have access to XFS systems that see a lot of churn, I am r=
eaching out to the XFS community in order to find volunteers willing to run=
 my script and capture their XFS aging profile. Please feel free to modify =
the script as per your installation or as you see fit. Since fsagestats col=
lects no private information, I eventually intend to host these profiles pu=
blicly (unless explicitly requested not to) to aid other researchers / enth=
usiasts.
>
> In case you have any questions on concerns, please let me know.

I have a nicely aged filesystem (1 TB) on our dev server with around
10 million files on it. I will not run a script that executes two
xfs_io calls *for each file* on it. Why don't you just use Python's
stat.stat to get at the ctime and the size?
