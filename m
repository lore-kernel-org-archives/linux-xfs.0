Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:43190 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdJBNOL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Oct 2017 09:14:11 -0400
Received: by mail-io0-f176.google.com with SMTP id k101so4678107iod.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 Oct 2017 06:14:10 -0700 (PDT)
Received: from [10.11.12.250] ([50.31.213.205])
        by smtp.gmail.com with ESMTPSA id w133sm4404329itc.7.2017.10.02.06.14.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Oct 2017 06:14:09 -0700 (PDT)
From: "R. Jason Adams" <rjasonadams@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Suggested XFS setup/options for 10TB file system w/ 18-20M files.
Message-Id: <65736D53-5B93-46DD-95D2-02496B59D09C@gmail.com>
Date: Mon, 2 Oct 2017 09:14:07 -0400
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

I have a use case where I'm writing ~500Kb (avg size) files to a 10TB =
XFS file systems. Each of system has 36 of these 10TB drives.

The application opens the file, writes the data (single call), and =
closes the file. In addition there are a few lines added to the extended =
attributes. The filesystem ends up with 18 to 20 million files when the =
drive is full. The files are currently spread over 128x128 directories =
using a hash of the filename.

The format command I'm using:

mkfs.xfs -f -i size=3D1024 ${DRIVE}

Mount options:

rw,noatime,attr2,inode64,allocsize=3D2048k,logbufs=3D8,logbsize=3D256k,noq=
uota

As the drive is filling, the first few % of the drive seems fine. Using =
iostat the avgrq-sz is close to the average file size. What I'm noticing =
is as the drive starts to fill (say around 5-10%) the reads start =
increasing (r/s in iostat). In addition, the avgrq-sz starts to =
decrease. Pretty soon the r/s can be 1/3 to 1/2 as many as our w/s. At =
first we thought this was related to using extended attributes, but =
disabling that didn=E2=80=99t make a difference at all.

Considering I know the app isn=E2=80=99t making any read request, I=E2=80=99=
m guessing this is related to updating metadata etc. Any guidance on how =
to resolve/reduce/etc? For example, would a different directory =
structure help (more files in less directories)?

Thanks,
R. Jason Adams

