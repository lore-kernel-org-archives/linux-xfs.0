Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34471 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfDOCLN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Apr 2019 22:11:13 -0400
MIME-Version: 1.0
References: <20190415012229.20689-1-ming.lei@redhat.com> <SN6PR04MB4527DD7C84A15184AE5F7947862B0@SN6PR04MB4527.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB4527DD7C84A15184AE5F7947862B0@SN6PR04MB4527.namprd04.prod.outlook.com>
From: Ming Lei <tom.leiming@gmail.com>
Date: Mon, 15 Apr 2019 10:10:59 +0800
Message-ID: <CACVXFVMa1Zvqm=GYf=4_oB+wTuoKMGaStfsKSTGBbVKACGvGQQ@mail.gmail.com>
Subject: Re: [PATCH] nvme/012 & 013: avoid extremely slow xfs IO
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc: Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Eric Sandeen <esandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Apr 15, 2019 at 10:02 AM Chaitanya Kulkarni
<Chaitanya.Kulkarni@wdc.com> wrote:
>
> Thanks for the patch Ming. Couple of comments below.
> On 4/14/19 6:22 PM, Ming Lei wrote:
> > It is observed that nvme/012 may take ~17 minutes to complete on aarch64,
> > even worse it may trigger IO timeout on nvme-loop.
> >
> > Eric and Dave replied that it is because of too small log size on small
> > disk.
> >
> > So pass '-l size=32m' to avoid the issue.
> >
> > With this patch, nvme/012 can be completed in one minute.
> >
> Then we should set the QUICK=1 if its taking shorter time.

That should have been a QUICK test, it is fine to set it, but it shouldn't
belong to this patch.

>
> > Cc: Eric Sandeen <esandeen@redhat.com>
> > Cc: Dave Chinner <dchinner@redhat.com>
> > Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> > Cc: linux-xfs@vger.kernel.org
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   tests/nvme/012 | 2 +-
> >   tests/nvme/013 | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tests/nvme/012 b/tests/nvme/012
> > index 9a6801511df7..d7a8751ec752 100755
> > --- a/tests/nvme/012
> > +++ b/tests/nvme/012
> > @@ -46,7 +46,7 @@ test() {
> >
> >       umount ${mount_dir} > /dev/null 2>&1
> >
> > -     mkfs.xfs -f /dev/"${nvmedev}n1" > /dev/null 2>&1
> > +     mkfs.xfs -l size=32m -f /dev/"${nvmedev}n1" > /dev/null 2>&1
> >
> As a part of this series lets move this to the helper mkfs in the
> nvme/rc and use that call in all the file-backed ns related testcases.
> Let me know if you want me to do that or you would like to do that as a
> part of this series. I'm okay with anything.

I am fine with either way.

Thanks,
Ming Lei
