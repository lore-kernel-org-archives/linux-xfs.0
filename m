Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1C8C5DF60
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 16:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AE832190F
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 16:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dImEHs/q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390051AbfKEQJc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 11:09:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30142 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390035AbfKEQJc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 11:09:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572970171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p7XT/i6EjHATg3W12Z+xXo3HZ6ujHcB4Li2T871t50I=;
        b=dImEHs/qeCJjhODtR9x3nqpG+Zig5C99hgrccVDNmaNDcfn/lrR+9w9FndroMVOOzslOGy
        U9VDY/zevMn/l6PMpqtrelK2XoB4yO/F5uBQ+5RztcLBOx0weTQsVtsm5ccFTWXLrCGKml
        LWnUwtkGNrPCOOR9cegkL86NchRThkg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-4ev4wz7RMeqMXH_Ym2xLUA-1; Tue, 05 Nov 2019 11:09:28 -0500
Received: by mail-wm1-f72.google.com with SMTP id f2so7828022wmf.8
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 08:09:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=4E3XnloiGNdUfXor32dkNPNy0+5Sqs/q3m3KToCkQ74=;
        b=GNDRqarVWnXjdJKTFOas1aG2DYztA8/Tbzq6Q8+HL8pWt9x5hqwx4FzQE0ue5Vidmf
         lcxrR0RAvlMCJLLCyH4MI6RkFqQqoqEkENVjdbVFsSBJ1wI/0k5GAss6a2mj02l7koLI
         EQuRVof+Za+OY/yeu7GJstOMCEt0fLF33y292XQ+JFop7BFG/g67ZNVS78VSEabLQU5u
         LrGUMXBaKNEW5HO8vvO7oUjzcMPStuKPPR1zt70vD1Ne+uszuFvjC4GVpe+Ha27pzMn0
         2oTZkol/K6jqyMczBdT/nFGQEBUYqB86bpWfuBTFbLZsx1CVLP3gMufw487tgmH0HbiV
         TTSw==
X-Gm-Message-State: APjAAAXJ6Pdp7sajnkApOMeTlPfdJgdw+R1YrTltsSVI0qvq28kk5MqH
        glmOAvUuQiw6/Ap9xW10RkwMsMAIoCJFS9mVumtIAWSHEjKjDf172Xi6NGbOhIArNMqAs2pIz9v
        f8aUigjW+oBcjxee1KeJF
X-Received: by 2002:adf:ed11:: with SMTP id a17mr15939675wro.392.1572970167208;
        Tue, 05 Nov 2019 08:09:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9GOtM7WM9G85gf/8nXHbhVb2SrxTny4tMbXTVpSMJ9ztT3xtl6x7/uJ4HQxUk7oyLdkoc6Q==
X-Received: by 2002:adf:ed11:: with SMTP id a17mr15939633wro.392.1572970166763;
        Tue, 05 Nov 2019 08:09:26 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id c144sm20290026wmd.1.2019.11.05.08.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 08:09:26 -0800 (PST)
Date:   Tue, 5 Nov 2019 17:09:24 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Sitsofe Wheeler <sitsofe@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Tasks blocking forever with XFS stack traces
Message-ID: <20191105160924.755ruhm3docwyipo@orion>
Mail-Followup-To: Sitsofe Wheeler <sitsofe@gmail.com>,
        linux-xfs@vger.kernel.org
References: <CALjAwxiuTYAVvGGUXLx6Bo-zNuW5+WXL=A8DqR5oD6D5tsKwng@mail.gmail.com>
 <20191105085446.abx27ahchg2k7d2w@orion>
 <CALjAwxiNExFd_eeMAFNLrMU8EKn0FNWrRrgeMWj-CCT4s7DRjA@mail.gmail.com>
 <20191105103652.n5zwf6ty3wvhti5f@orion>
 <CALjAwxiMqjfBX3tZJv3MqMQ776v1aNcwme0B-AuhmEgMNUqgMw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxiMqjfBX3tZJv3MqMQ776v1aNcwme0B-AuhmEgMNUqgMw@mail.gmail.com>
X-MC-Unique: 4ev4wz7RMeqMXH_Ym2xLUA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

> > > <snip>
> > > > >
> > > > > Other directories on the same filesystem seem fine as do other XF=
S
> > > > > filesystems on the same system.
> > > >
> > > > The fact you mention other directories seems to work, and the first=
 stack trace
> > > > you posted, it sounds like you've been keeping a singe AG too busy =
to almost
> > > > make it unusable. But, you didn't provide enough information we can=
 really make
> > > > any progress here, and to be honest I'm more inclined to point the =
finger to
> > > > your MD device.
> > >
> > > Let's see if we can pinpoint something :-)
> > >
> > > > Can you describe your MD device? RAID array? What kind? How many di=
sks?
> > >
> > > RAID6 8 disks.
> >
> > >
> > > > What's your filesystem configuration? (xfs_info <mount point>)
> > >
> > > meta-data=3D/dev/md126             isize=3D512    agcount=3D32, agsiz=
e=3D43954432 blks
> > >          =3D                       sectsz=3D4096  attr=3D2, projid32b=
it=3D1
> > >          =3D                       crc=3D1        finobt=3D1 spinodes=
=3D0 rmapbt=3D0
> > >          =3D                       reflink=3D0
> > > data     =3D                       bsize=3D4096   blocks=3D1406538240=
, imaxpct=3D5
> > >          =3D                       sunit=3D128    swidth=3D768 blks
> >
> > > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=
=3D1
> > > log      =3Dinternal               bsize=3D4096   blocks=3D521728, ve=
rsion=3D2
> > >          =3D                       sectsz=3D4096  sunit=3D1 blks, laz=
y-count=3D1
> >                                                 ^^^^^^  This should hav=
e been
> >                                                         configured to 8=
 blocks, not 1
> >
> > > Yes there's more. See a slightly elided dmesg from a longer run on
> > > https://sucs.org/~sits/test/kern-20191024.log.gz .
> >
> > At a first quick look, it looks like you are having lots of IO contenti=
on in the
> > log, and this is slowing down the rest of the filesystem. What caught m=
y
>=20
> Should it become so slow that a task freezes entirely and never
> finishes? Once the problem hits it's not like anything makes any more
> progress on those directories nor was there very much generating dirty
> data.
>=20

I am not sure how long you waited until you assumed it 'never finishes' :),
but...
I've seen systems starve to death due large amounts of RMW being generated,
mainly when disks are slow or problematic. Since you are using SSDs and not
spindles, I wonder if the SSDs write cycle might play a role here, but it's=
 just
a question I'm asking myself, I am not sure if it can play a role in making
things even worse.

In the file you sent above, you basically have:

xfs-sync worker thread, which forced a log flush, and now is sleeping waiti=
ng
for the flush to complete:

Oct 24 16:27:11 <host> kernel: [115151.674164] Call Trace:
Oct 24 16:27:11 <host> kernel: [115151.674170]  __schedule+0x24e/0x880
Oct 24 16:27:11 <host> kernel: [115151.674175]  schedule+0x2c/0x80
Oct 24 16:27:11 <host> kernel: [115151.674178]  schedule_timeout+0x1cf/0x35=
0
Oct 24 16:27:11 <host> kernel: [115151.674184]  ? sched_clock+0x9/0x10
Oct 24 16:27:11 <host> kernel: [115151.674187]  ? sched_clock+0x9/0x10
Oct 24 16:27:11 <host> kernel: [115151.674191]  ? sched_clock_cpu+0x11/0xb0
Oct 24 16:27:11 <host> kernel: [115151.674196]  wait_for_completion+0xba/0x=
140
Oct 24 16:27:11 <host> kernel: [115151.674199]  ? wake_up_q+0x80/0x80
Oct 24 16:27:11 <host> kernel: [115151.674203]  __flush_work+0x15b/0x210
Oct 24 16:27:11 <host> kernel: [115151.674206]  ? worker_detach_from_pool+0=
xa0/0xa0
Oct 24 16:27:11 <host> kernel: [115151.674210]  flush_work+0x10/0x20
Oct 24 16:27:11 <host> kernel: [115151.674250]  xlog_cil_force_lsn+0x7b/0x2=
10 [xfs]
Oct 24 16:27:11 <host> kernel: [115151.674253]  ? __switch_to_asm+0x41/0x70
Oct 24 16:27:11 <host> kernel: [115151.674256]  ? __switch_to_asm+0x35/0x70
Oct 24 16:27:11 <host> kernel: [115151.674259]  ? __switch_to_asm+0x41/0x70
Oct 24 16:27:11 <host> kernel: [115151.674262]  ? __switch_to_asm+0x35/0x70
Oct 24 16:27:11 <host> kernel: [115151.674264]  ? __switch_to_asm+0x41/0x70
Oct 24 16:27:11 <host> kernel: [115151.674267]  ? __switch_to_asm+0x35/0x70
Oct 24 16:27:11 <host> kernel: [115151.674306]  _xfs_log_force+0x8f/0x2a0 [=
xfs]


Which wake up and wait for xlog_cil_push on the following thread:

Oct 24 16:29:12 <host> kernel: [115272.503324] kworker/52:2    D    0 56479=
      2 0x80000080
Oct 24 16:29:12 <host> kernel: [115272.503381] Workqueue: xfs-cil/md126 xlo=
g_cil_push_work [xfs]
Oct 24 16:29:12 <host> kernel: [115272.503383] Call Trace:
Oct 24 16:29:12 <host> kernel: [115272.503389]  __schedule+0x24e/0x880
Oct 24 16:29:12 <host> kernel: [115272.503394]  schedule+0x2c/0x80
Oct 24 16:29:12 <host> kernel: [115272.503444]  xlog_state_get_iclog_space+=
0x105/0x2d0 [xfs]
Oct 24 16:29:12 <host> kernel: [115272.503449]  ? wake_up_q+0x80/0x80
Oct 24 16:29:12 <host> kernel: [115272.503492]  xlog_write+0x163/0x6e0 [xfs=
]
Oct 24 16:29:12 <host> kernel: [115272.503536]  xlog_cil_push+0x2a7/0x410 [=
xfs]
Oct 24 16:29:12 <host> kernel: [115272.503577]  xlog_cil_push_work+0x15/0x2=
0 [xfs]
Oct 24 16:29:12 <host> kernel: [115272.503581]  process_one_work+0x1de/0x42=
0
Oct 24 16:29:12 <host> kernel: [115272.503584]  worker_thread+0x32/0x410
Oct 24 16:29:12 <host> kernel: [115272.503587]  kthread+0x121/0x140
Oct 24 16:29:12 <host> kernel: [115272.503590]  ? process_one_work+0x420/0x=
420
Oct 24 16:29:12 <host> kernel: [115272.503593]  ? kthread_create_worker_on_=
cpu+0x70/0x70
Oct 24 16:29:12 <host> kernel: [115272.503596]  ret_from_fork+0x35/0x40


xlog_state_get_iclog_space() is waiting at:

xlog_wait(&log->l_flush_wait, &log->l_icloglock);

Which should be awaken by xlog_state_do_callback() which is called by
xlog_state_done_syncing(), which in short, IIRC, comes from bio end io
callbacks.

I'm saying this by a quick look at the current code though. So, I think it =
ends
up by your system waiting for journal IO completion to make progress (or ma=
ybe
your storage stack missed an IO and XFS is stuck waiting for the completion
which will never come, maybe it's deadlocked somewhere I am not seeing).

I may very well be wrong though, it's been a while since I don't work on th=
is
part of the code, so, I'll just wait somebody else to give a different POV,
other than risking pointing you in the wrong direction.

I'll try to keep looking at it when I get some extra time, but well, at the=
 end
you will probably need to update your kernel to a recent version and try to
reproduce the problem again, chasing bugs on old kernels is not really the =
scope
of this list, but I'll give it some more thought when I get some extra time=
 (if
nobody sees what's wrong before :)


> If this were to happen again though what extra information would be
> helpful (I'm guessing things like /proc/meminfo output)?
>

> > attention at first was the wrong configured log striping for the filesy=
stem and
> > I wonder if this isn't the responsible for the amount of IO contention =
you are
> > having in the log. This might well be generating lots of RMW cycles whi=
le
> > writing to the log generating the IO contention and slowing down the re=
st of the
> > filesystem, I'll try to take a more careful look later on.
>=20
> My understanding is that the md "chunk size" is 64k so basically
> you're saying the sectsz should have been manually set to be as big as
> possible at mkfs time? I never realised this never happened by default
> (I see the sunit seems to be correct given the block size of 4096 but
> I'm unsure about swidth)...

Your RAID chunk is 512k according to the information you provided previousl=
y:

md126 : active raid6 sdj[6] sdg[3] sdi[2] sdh[7] sdc[4] sdd[0] sda[5] sdb[1=
]
      5626152960 blocks level 6, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]
      bitmap: 0/7 pages [0KB], 65536KB chunk

And I believe you used default mkfs options when you created the filesystem=
, so
xfs properly identified and automatically configured it for you:

sunit=3D128    swidth=3D768 blks

(128*4096) =3D 512Kib

And the swidth matches exactly the amount of data disks I'd expect from you=
r
array, i.e. 6 Data Disks (+ 2 parity):
(768/128) =3D 6

What I meant is the Log sunit is weird in your configuration, see the 'suni=
t' in
the Log section. The XFS log stripe unit can range from 32Kib to 256Kib. An=
d
mkfs configures it to match the data sunit, UNLESS the data sunit is bigger=
 tha
256KiB, which then mkfs will set it to 32KiB by default, which, in your cas=
e,
using default mkfs configuration, I was expecting to see a log sunit=3D8
(8*4096) =3D 32KiB

Maybe your xfsprogs version had any bug, or maybe somebody set it manually.
I can't really say.

--=20
Carlos

