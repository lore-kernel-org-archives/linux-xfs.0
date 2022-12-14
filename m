Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98054C001B2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 04:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbiLNErd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 23:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237260AbiLNErb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 23:47:31 -0500
Received: from mx0a-0016e101.pphosted.com (mx0a-0016e101.pphosted.com [148.163.145.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F81A248F0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 20:47:30 -0800 (PST)
Received: from pps.filterd (m0151353.ppops.net [127.0.0.1])
        by mx0a-0016e101.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE3bJ6i024065
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 20:47:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucsd.edu; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=campus;
 bh=U6A9qQLk9neXerGQPBZtHBFOFrQI9ojcJEdXf4e7VNo=;
 b=pgshwEzKeiwIYvkH2tezJzKcgqZzIUSUhtrtfCwpcWUPPSFocPAKrtFKm8RZN/T5AN9j
 38BLligHEqBi2fkJfwstS97fUaTxmkFDfVKy5eWSlJ0dZDTK9uOnSJ4odt5dVQN1//3u
 KauluApTT2hhjMMO9Frqx+KbVbo7mJlkMbXaMGUa+uwyMgg2LbjeXDDlTrRO6wPIsr23
 Ct4oaT9RqH9OufGz8n9+whJwrhyOnSwIAEdDe8e7tswfa/lnYEfB1NA0fZigjd7rHi7a
 o25X+2+o3xOEcBiu4e1kPaZj+LOcIGZapL5lNVBGOjqY/4Kksx8G6fifTYvEs5L2tNBA Kw== 
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        by mx0a-0016e101.pphosted.com (PPS) with ESMTPS id 3mf6r1ga0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 20:47:29 -0800
Received: by mail-qk1-f199.google.com with SMTP id bp6-20020a05620a458600b006ffd3762e78so99449qkb.13
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 20:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucsd.edu; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6A9qQLk9neXerGQPBZtHBFOFrQI9ojcJEdXf4e7VNo=;
        b=bnqiVPt3yoOeyU4rX5H7GLGH4xUQn9wtW23z9Y+NOC08JrYdhdyiHxynMCQ4+56L4G
         MJg7yOsz60C5J3+oNf0T+IqPCEirYGKz7Z9wAL88pkdAOeuyH8iSKa99XZkHC2PBPY0H
         KlMOXm16P/I9cLmISNVvZCtilgq5dm6Ofipes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U6A9qQLk9neXerGQPBZtHBFOFrQI9ojcJEdXf4e7VNo=;
        b=eE3+HPipd0pz1aYoiNlhyKM3UcBQDNFjSwkb32jn7BQKOuyS3opAZ9r4Nqi32sQDHr
         LEahWmRUOKHk+cUoAjwANI1f15mLqHRGXgc1N+cKUnOxx9uZW+GwJpJ5UqrBrBPaH7rW
         MVK/JOqu4scIy8cswsX5S1A+0dIqSuNqS+/EkENkwuAxi4tnb9YmfPuxgTViOYYzeB0y
         d4fY5zIf3PeAEccjhfN3mfEJ8HZMNeRVARp0najqpc6UT9DcbWBzEk5lLjawAHmLHQLP
         OuivqYkoNo64vMdvpccvQdsvgijam4Obk4t1l3SbgIt9vffQ4AzpkwMqn8mXguGEtv7E
         uMvg==
X-Gm-Message-State: ANoB5pkxXxSYbhZB7U7J8B2IcfR4wNIv26DFxry9Irr73PEF1gjxnYfM
        Wbukz/8AzqR/Z7uuYO6GiAyxtbiL++738i704la6fGdOvQmXn7L2mhW8nlCqYyuoupHJU+Qxx6s
        20iRZTiqG58fd/jXdVXtR6mn8xdiBlF/ThOQ=
X-Received: by 2002:a37:4656:0:b0:6ff:c156:4404 with SMTP id t83-20020a374656000000b006ffc1564404mr190607qka.528.1670993248361;
        Tue, 13 Dec 2022 20:47:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6IEsc1coe96JATsil3nHWp6rhvlTTRMPHK6wStZeDGBil3jB2icIuIVEiD2zri7qd2B+tPcWQ2sduF06DZngQ=
X-Received: by 2002:a37:4656:0:b0:6ff:c156:4404 with SMTP id
 t83-20020a374656000000b006ffc1564404mr190603qka.528.1670993247996; Tue, 13
 Dec 2022 20:47:27 -0800 (PST)
MIME-Version: 1.0
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com>
 <Y5i0ALbAdEf4yNuZ@magnolia>
In-Reply-To: <Y5i0ALbAdEf4yNuZ@magnolia>
From:   Suyash Mahar <smahar@ucsd.edu>
Date:   Tue, 13 Dec 2022 20:47:03 -0800
Message-ID: <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com>
Subject: Re: XFS reflink overhead, ioctl(FICLONE)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, tpkelly@eecs.umich.edu,
        Suyash Mahar <suyash12mahar@outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-campus_gsuite: gsuite_33445511
X-Proofpoint-GUID: uwRqvgyNnQspZcPLfDfQqYI8s4k0RRyY
X-Proofpoint-ORIG-GUID: uwRqvgyNnQspZcPLfDfQqYI8s4k0RRyY
pp_allow_relay: proofpoint_allowed
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_02,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=789 mlxscore=0
 phishscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212140036
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Thank you for the response. I have replied inline.

-Suyash

Le mar. 13 d=C3=A9c. 2022 =C3=A0 09:18, Darrick J. Wong <djwong@kernel.org>=
 a =C3=A9crit :
>
> [ugh, your email never made it to the list.  I bet the email security
> standards have been tightened again.  <insert rant about dkim and dmarc
> silent failures here>] :(
>
> On Sat, Dec 10, 2022 at 09:28:36PM -0800, Suyash Mahar wrote:
> > Hi all!
> >
> > While using XFS's ioctl(FICLONE), we found that XFS seems to have
> > poor performance (ioctl takes milliseconds for sparse files) and the
> > overhead
> > increases with every call.
> >
> > For the demo, we are using an Optane DC-PMM configured as a
> > block device (fsdax) and running XFS (Linux v5.18.13).
>
> How are you using fsdax and reflink on a 5.18 kernel?  That combination
> of features wasn't supported until 6.0, and the data corruption problems
> won't get fixed until a pull request that's about to happen for 6.2.

We did not enable the dax option. The optane DIMMs are configured to
appear as a block device.

$ mount | grep xfs
/dev/pmem0p4 on /mnt/pmem0p4 type xfs
(rw,relatime,attr2,inode64,logbufs=3D8,logbsize=3D32k,noquota)

Regardless of the block device (the plot includes results for optane
and RamFS), it seems like the ioctl(FICLONE) call is slow.

> > We create a 1 GiB dense file, then repeatedly modify a tiny random
> > fraction of it and make a clone via ioctl(FICLONE).
>
> Yay, random cow writes, that will slowly increase the number of space
> mapping records in the file metadata.
>
> > The time required for the ioctl() calls increases from large to insane
> > over the course of ~250 iterations: From roughly a millisecond for the
> > first iteration or two (which seems high, given that this is on
> > Optane and the code doesn't fsync or msync anywhere at all, ever) to 20
> > milliseconds (which seems crazy).
>
> Does the system call runtime increase with O(number_extents)?  You might
> record the number of extents in the file you're cloning by running this
> periodically:
>
> xfs_io -c stat $path | grep fsxattr.nextents

The extent count does increase linearly (just like the ioctl() call latency=
).
I used the xfs_bmap tool, let me know if this is not the right way. If
it is not, I'll update the microbenchmark to run xfs_io.

> FICLONE (at least on XFS) persists dirty pagecache data to disk, and
> then duplicates all written-space mapping records from the source file to
> the destination file.  It skips preallocated mappings created with
> fallocate.
>
> So yes, the plot is exactly what I was expecting.
>
> --D
>
> > The plot is attached to this email.
> >
> > A cursory look at the extent map suggests that it gets increasingly
> > complicated resulting in the complexity.
> >
> > The enclosed tarball contains our code, our results, and some other inf=
o
> > like a flame graph that might shed light on where the ioctl is spending
> > its time.
> >
> > - Suyash & Terence
