Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882A4C07545
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 05:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjJYFRa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 01:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjJYFR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 01:17:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD5CB0
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 22:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698211004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fjTjDsyrum46VZzPrCLBfr86LrqujihFNafODzlO4bo=;
        b=TP1ZSCNtmFesj9Ttg+di11c+qsKBEVRje9wZK283PPgeTIs9a7sAPWsPbOPghA6hEEPgyi
        9bhiVTn7vOA9ZWaKhH+Ul5eEirYq/nrYt3hHZ1tf1ML0njWqisfEwgDE6+YdbeMhBYOh93
        bXtSRIbWDe7WzVslMOYNUZu/f1VF6V4=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-UbXcboBTOt6NNA9F8KET_g-1; Wed, 25 Oct 2023 01:16:36 -0400
X-MC-Unique: UbXcboBTOt6NNA9F8KET_g-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-581df11b5b4so7496600eaf.0
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 22:16:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698210995; x=1698815795;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjTjDsyrum46VZzPrCLBfr86LrqujihFNafODzlO4bo=;
        b=wJwnG++0vylPpLmn2ac+6klUktCevPAnMO0Y3/2qV4RTz99bnkL7l24PKqrpGstzmJ
         Wmc7C9Q8W28yIkwtg3MEDDoWydRsMuUPECJ1M9jMSCF8PnAmmXrjJbZy0PPn7lryW+8R
         J42lk7+S5gUVWdZoEbd7p0dsoaeYd5sa1QTaurnZYbDrkVIknKMOACj6hpN1iGSlh9Dz
         NAG5yoe58cOtKKqnS+kY1EX4YKCFxICJO22QMR5JYe4hHX4kuud7yViMZjSjmVn+Yxh1
         DFyrW5EHwSowsikf16GuF21+xzbfVnleKJRJU/b9chHNNIEOKq5XG1eosZ9zkTfpgxXS
         UnBA==
X-Gm-Message-State: AOJu0YyQubXt62FiqneATnmMcPwlt3GaxxLcTk/mISTbqJVmFB4sGsp8
        QtH4vSl92EkhTjg7TRKFFg7Wbo65EeGdY8+hWkhFSSpbJmWbzOjY+bdOO9bgDnepYCspnj9gYk8
        LvtvikJ92A3aOum8dsNuW
X-Received: by 2002:a05:6358:9d99:b0:168:e843:9000 with SMTP id d25-20020a0563589d9900b00168e8439000mr6118204rwo.26.1698210995172;
        Tue, 24 Oct 2023 22:16:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFV0d/4M8E4d/q9nHZZQXHHDKoTAK0V+dYmcQHSqdtC5fHkpd6a0k3NZazzm+CelAo3jDxylg==
X-Received: by 2002:a05:6358:9d99:b0:168:e843:9000 with SMTP id d25-20020a0563589d9900b00168e8439000mr6118189rwo.26.1698210994602;
        Tue, 24 Oct 2023 22:16:34 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i18-20020aa796f2000000b0068fcb70ccafsm8289587pfq.129.2023.10.24.22.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 22:16:34 -0700 (PDT)
Date:   Wed, 25 Oct 2023 13:16:31 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] generic/251: check min and max length and minlen for
 FSTRIM
Message-ID: <20231025051631.3lsxl7ytyltapoir@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231019143627.GD11391@frogsfrogsfrogs>
 <20231021131448.jjayss67pq5ztjdy@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20231021230024.GT3195650@frogsfrogsfrogs>
 <20231022061834.2km47c7vmhp5uen2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20231023044647.GE11391@frogsfrogsfrogs>
 <20231023131652.37xfq73zwyozvbbn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20231023174954.GH11391@frogsfrogsfrogs>
 <20231024055930.3tjuevh6nee6lfo3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20231024152854.GI11391@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024152854.GI11391@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 08:28:54AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 24, 2023 at 01:59:30PM +0800, Zorro Lang wrote:
> > On Mon, Oct 23, 2023 at 10:49:54AM -0700, Darrick J. Wong wrote:
> > > On Mon, Oct 23, 2023 at 09:16:52PM +0800, Zorro Lang wrote:
> > > > On Sun, Oct 22, 2023 at 09:46:47PM -0700, Darrick J. Wong wrote:
> > > > > On Sun, Oct 22, 2023 at 02:18:34PM +0800, Zorro Lang wrote:
> > > > > > On Sat, Oct 21, 2023 at 04:00:24PM -0700, Darrick J. Wong wrote:
> > > > > > > On Sat, Oct 21, 2023 at 09:14:48PM +0800, Zorro Lang wrote:
> > > > > > > > On Thu, Oct 19, 2023 at 07:36:27AM -0700, Darrick J. Wong wrote:
> > > > > > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > > > > > 
> > > > > > > > > Every now and then, this test fails with the following output when
> > > > > > > > > running against my development tree when configured with an 8k fs block
> > > > > > > > > size:
> > > > > > > > > 
> > > > > > > > > --- a/tests/generic/251.out	2023-07-11 12:18:21.624971186 -0700
> > > > > > > > > +++ b/tests/generic/251.out.bad	2023-10-15 20:54:44.636000000 -0700
> > > > > > > > > @@ -1,2 +1,4677 @@
> > > > > > > > >  QA output created by 251
> > > > > > > > >  Running the test: done.
> > > > > > > > > +fstrim: /opt: FITRIM ioctl failed: Invalid argument
> > > > > > > > > +fstrim: /opt: FITRIM ioctl failed: Invalid argument
> > > > > > > > > ...
> > > > > > > > > +fstrim: /opt: FITRIM ioctl failed: Invalid argument
> > > > > > > > > 
> > > > > > > > > Dumping the exact fstrim command lines to seqres.full produces this at
> > > > > > > > > the end:
> > > > > > > > > 
> > > > > > > > > /usr/sbin/fstrim -m 32544k -o 30247k -l 4k /opt
> > > > > > > > > /usr/sbin/fstrim -m 32544k -o 30251k -l 4k /opt
> > > > > > > > > ...
> > > > > > > > > /usr/sbin/fstrim -m 32544k -o 30255k -l 4k /opt
> > > > > > > > > 
> > > > > > > > > The count of failure messages is the same as the count as the "-l 4k"
> > > > > > > > > fstrim invocations.  Since this is an 8k-block filesystem, the -l
> > > > > > > > > parameter is clearly incorrect.  The test computes random -m and -l
> > > > > > > > > options.
> > > > > > > > > 
> > > > > > > > > Therefore, create helper functions to guess at the minimum and maximum
> > > > > > > > > length and minlen parameters that can be used with the fstrim program.
> > > > > > > > > In the inner loop of the test, make sure that our choices for -m and -l
> > > > > > > > > fall within those constraints.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > > > > > ---
> > > > > > > > 
> > > > > > > > Hi Darrick, with this patch I 100% hit below failure (on default 4k xfs
> > > > > > > > and ext4):
> > > > > > > > 
> > > > > > > > # ./check generic/251
> > > > > > > > FSTYP         -- xfs (debug)
> > > > > > > > PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> > > > > > > > MKFS_OPTIONS  -- -f /dev/loop0
> > > > > > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop0 /mnt/scratch
> > > > > > > > 
> > > > > > > > generic/251 260s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/251.out.bad)
> > > > > > > >     --- tests/generic/251.out   2022-04-29 23:07:23.263498297 +0800
> > > > > > > >     +++ /root/git/xfstests/results//generic/251.out.bad 2023-10-21 21:02:37.687088360 +0800
> > > > > > > >     @@ -1,2 +1,5 @@
> > > > > > > >      QA output created by 251
> > > > > > > >      Running the test: done.
> > > > > > > >     +5834a5835
> > > > > > > >     +> aa60581221897d3d7dd60458e1cca2fa  ./results/generic/251.full
> > > > > > > >     +!!!Checksums has changed - Filesystem possibly corrupted!!!\n
> > > > > > > >     ...
> > > > > > > >     (Run 'diff -u /root/git/xfstests/tests/generic/251.out /root/git/xfstests/results//generic/251.out.bad'  to see the entire diff)
> > > > > > > 
> > > > > > > Huh.  I don't see that on ext4 on my machine.  Can you send me all your
> > > > > > 
> > > > > > The failure on ext4:
> > > > > > 
> > > > > > # ./check generic/251
> > > > > > FSTYP         -- ext4
> > > > > > PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> > > > > > MKFS_OPTIONS  -- -F /dev/loop0
> > > > > > MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0 /dev/loop0 /mnt/scratch
> > > > > > 
> > > > > > generic/251 249s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/251.out.bad)
> > > > > >     --- tests/generic/251.out   2022-04-29 23:07:23.263498297 +0800
> > > > > >     +++ /root/git/xfstests/results//generic/251.out.bad 2023-10-22 14:17:07.248059405 +0800
> > > > > >     @@ -1,2 +1,5 @@
> > > > > >      QA output created by 251
> > > > > >      Running the test: done.
> > > > > >     +5838a5839
> > > > > >     +> aa60581221897d3d7dd60458e1cca2fa  ./results/generic/251.full
> > > > > >     +!!!Checksums has changed - Filesystem possibly corrupted!!!\n
> > > > > >     ...
> > > > > >     (Run 'diff -u /root/git/xfstests/tests/generic/251.out /root/git/xfstests/results//generic/251.out.bad'  to see the entire diff)
> > > > > > Ran: generic/251
> > > > > > Failures: generic/251
> > > > > > Failed 1 of 1 tests
> > > > > > 
> > > > > > > /root/git/xfstests/results//generic/251* files so that I can have a
> > > > > > > look?
> > > > > > 
> > > > > > Sure, thanks! There're .full and .out.bad files:
> > > > > > 
> > > > > > # cat results/generic/251.full 
> > > > > > MINLEN max=100000 min=2
> > > > > > LENGTH max=100000 min=4
> > > > > > # cat results/generic/251.out.bad 
> > > > > > QA output created by 251
> > > > > > Running the test: done.
> > > > > > 5833a5834
> > > > > > > aa60581221897d3d7dd60458e1cca2fa  ./results/generic/251.full
> > > > > > !!!Checksums has changed - Filesystem possibly corrupted!!!\n
> > > 
> > > Hang on, why is $seqres.full being included in the generic/251 integrity
> > > checks?
> > > 
> > > *OH* it's this piece that runs before we start the fstrim loop:
> > > 
> > > 	content=$here
> > > 	(
> > > 	cd $content
> > > 	find -P . -xdev -type f -print0 | xargs -0 md5sum | sort -o
> > > 	$tmp/content.sums
> > > 	)
> > 
> > Err... generic/251 is an old case, was written 12 years ago. It trys to do
> > 
> >   content=$here
> >   cp -axT $content/ $SCRATCH_MNT/$p/
> > 
> > to use the whole xfstests/* as testing data. I doubt that's recommended.
> > How about we run fsstress a while, to get a fixed original data directory,
> > then copy it to test. Likes we did in generic/560.
> > 
> > Any better ides? If you think it's good, and would like to wait. I can make
> > this change at first. Then you make a rebase and send this patch again.
> 
> I /think/ generic/251 is the only test that copies $here repeatedly and
> checksums the file contents of the copies.  Perhaps it'd be simpler to
> copy $here to $SCRATCH_DEV, checksum the *copy*, and only then start the
> loop that creates and deletes more copies while FITRIMming?

Sure, the $here is changing when the fstests is running. But we can copy $here
to other place to be a fixed original data at the beginning.

> 
> Anyway, I'll go try that and see what happens.

Thanks!

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > If you don't explicitly set RESULT_BASE before running fstests, you get
> > > the default setting of:
> > > 
> > > 	export RESULT_BASE="$here/results/"
> > > 
> > > Hence $seqres.full is really $here/results/generic/251.full.  Logging
> > > the MINLEN/LENGTH settings to $seqres.full changes the contents of the
> > > file, which changes the contents of the directory tree that we
> > > repeatedly copy into $SCRATCH_MNT while racing with FSTRIM.  That's the
> > > cause of the "Checksums has changed" message.
> > > 
> > > The checksums differ because the logging messages I added now result in
> > > the test changing the outcome of the test by observing it.  I never
> > > noticed because my test setup sets RESULT_BASE to a NFS server so that I
> > > always get /something/ to look at, even if the node crashes.
> > > 
> > > Not sure what you want to do about this, because this is a subtle bug
> > > for test authors to fall into.  I guess a mitigation could be to _notrun
> > > if $seqres.full is under $here but ... yeughck.
> > > 
> > > Thoughts?
> > > 
> > > --D
> > > 
> > > > > > 
> > > > > > The SCRATCH_DEV is loop0, its info as below:
> > > > > > # xfs_info /dev/loop0
> > > > > > meta-data=/dev/loop0             isize=512    agcount=4, agsize=720896 blks
> > > > > >          =                       sectsz=512   attr=2, projid32bit=1
> > > > > >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> > > > > >          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> > > > > > data     =                       bsize=4096   blocks=2883584, imaxpct=25
> > > > > >          =                       sunit=0      swidth=0 blks
> > > > > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > > > > > log      =internal log           bsize=4096   blocks=16384, version=2
> > > > > >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > > > > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > > > 
> > > > > Huh.  What filesystem contains the file that /dev/loop0 points to?
> > > > 
> > > > A xfs, but with multi-stripes:
> > > > 
> > > > # xfs_info /
> > > > meta-data=/dev/mapper/fedora_hp--dl380pg8--01-root isize=512    agcount=16, agsize=8192000 blks
> > > >          =                       sectsz=512   attr=2, projid32bit=1
> > > >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> > > >          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> > > > data     =                       bsize=4096   blocks=131072000, imaxpct=25
> > > >          =                       sunit=64     swidth=64 blks
> > > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > > > log      =internal log           bsize=4096   blocks=64000, version=2
> > > >          =                       sectsz=512   sunit=64 blks, lazy-count=1
> > > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > > 
> > > > > 
> > > > > --D
> > > > > 
> > > > > > More other information:
> > > > > > # rpm -qf /usr/sbin/fstrim
> > > > > > util-linux-2.39.2-1.fc40.x86_64
> > > > > > # uname -r
> > > > > > 6.6.0-rc6-mainline+
> > > > > > # rpm -q xfsprogs
> > > > > > xfsprogs-6.4.0-1.fc39.x86_64
> > > > > > 
> > > > > > Thanks,
> > > > > > Zorro
> > > > > > 
> > > > > > > 
> > > > > > > --D
> > > > > > > 
> > > > > > > > Ran: generic/251
> > > > > > > > Failures: generic/251
> > > > > > > > Failed 1 of 1 tests
> > > > > > > > 
> > > > > > > > And test passed without this patch.
> > > > > > > > 
> > > > > > > > # ./check generic/251
> > > > > > > > FSTYP         -- xfs (debug)
> > > > > > > > PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> > > > > > > > MKFS_OPTIONS  -- -f /dev/loop0
> > > > > > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop0 /mnt/scratch
> > > > > > > > 
> > > > > > > > generic/251 260s ...  249s
> > > > > > > > Ran: generic/251
> > > > > > > > Passed all 1 tests
> > > > > > > > 
> > > > > > > > Thanks,
> > > > > > > > Zorro
> > > > > > > > 
> > > > > > > > >  tests/generic/251 |   59 ++++++++++++++++++++++++++++++++++++++++++++++-------
> > > > > > > > >  1 file changed, 51 insertions(+), 8 deletions(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/tests/generic/251 b/tests/generic/251
> > > > > > > > > index 8ee74980cc..40cfd7c381 100755
> > > > > > > > > --- a/tests/generic/251
> > > > > > > > > +++ b/tests/generic/251
> > > > > > > > > @@ -53,14 +53,46 @@ _fail()
> > > > > > > > >  	kill $mypid 2> /dev/null
> > > > > > > > >  }
> > > > > > > > >  
> > > > > > > > > -_guess_max_minlen()
> > > > > > > > > +# Set FSTRIM_{MIN,MAX}_MINLEN to the lower and upper bounds of the -m(inlen)
> > > > > > > > > +# parameter to fstrim on the scratch filesystem.
> > > > > > > > > +set_minlen_constraints()
> > > > > > > > >  {
> > > > > > > > > -	mmlen=100000
> > > > > > > > > -	while [ $mmlen -gt 1 ]; do
> > > > > > > > > +	local mmlen
> > > > > > > > > +
> > > > > > > > > +	for ((mmlen = 100000; mmlen > 0; mmlen /= 2)); do
> > > > > > > > >  		$FSTRIM_PROG -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> > > > > > > > > -		mmlen=$(($mmlen/2))
> > > > > > > > >  	done
> > > > > > > > > -	echo $mmlen
> > > > > > > > > +	test $mmlen -gt 0 || \
> > > > > > > > > +		_notrun "could not determine maximum FSTRIM minlen param"
> > > > > > > > > +	FSTRIM_MAX_MINLEN=$mmlen
> > > > > > > > > +
> > > > > > > > > +	for ((mmlen = 1; mmlen < FSTRIM_MAX_MINLEN; mmlen *= 2)); do
> > > > > > > > > +		$FSTRIM_PROG -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> > > > > > > > > +	done
> > > > > > > > > +	test $mmlen -le $FSTRIM_MAX_MINLEN || \
> > > > > > > > > +		_notrun "could not determine minimum FSTRIM minlen param"
> > > > > > > > > +	FSTRIM_MIN_MINLEN=$mmlen
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > > > +# Set FSTRIM_{MIN,MAX}_LEN to the lower and upper bounds of the -l(ength)
> > > > > > > > > +# parameter to fstrim on the scratch filesystem.
> > > > > > > > > +set_length_constraints()
> > > > > > > > > +{
> > > > > > > > > +	local mmlen
> > > > > > > > > +
> > > > > > > > > +	for ((mmlen = 100000; mmlen > 0; mmlen /= 2)); do
> > > > > > > > > +		$FSTRIM_PROG -l ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> > > > > > > > > +	done
> > > > > > > > > +	test $mmlen -gt 0 || \
> > > > > > > > > +		_notrun "could not determine maximum FSTRIM length param"
> > > > > > > > > +	FSTRIM_MAX_LEN=$mmlen
> > > > > > > > > +
> > > > > > > > > +	for ((mmlen = 1; mmlen < FSTRIM_MAX_LEN; mmlen *= 2)); do
> > > > > > > > > +		$FSTRIM_PROG -l ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> > > > > > > > > +	done
> > > > > > > > > +	test $mmlen -le $FSTRIM_MAX_LEN || \
> > > > > > > > > +		_notrun "could not determine minimum FSTRIM length param"
> > > > > > > > > +	FSTRIM_MIN_LEN=$mmlen
> > > > > > > > >  }
> > > > > > > > >  
> > > > > > > > >  ##
> > > > > > > > > @@ -70,13 +102,24 @@ _guess_max_minlen()
> > > > > > > > >  ##
> > > > > > > > >  fstrim_loop()
> > > > > > > > >  {
> > > > > > > > > +	set_minlen_constraints
> > > > > > > > > +	set_length_constraints
> > > > > > > > > +	echo "MINLEN max=$FSTRIM_MAX_MINLEN min=$FSTRIM_MIN_MINLEN" >> $seqres.full
> > > > > > > > > +	echo "LENGTH max=$FSTRIM_MAX_LEN min=$FSTRIM_MIN_LEN" >> $seqres.full
> > > > > > > > > +
> > > > > > > > >  	trap "_destroy_fstrim; exit \$status" 2 15
> > > > > > > > >  	fsize=$(_discard_max_offset_kb "$SCRATCH_MNT" "$SCRATCH_DEV")
> > > > > > > > > -	mmlen=$(_guess_max_minlen)
> > > > > > > > >  
> > > > > > > > >  	while true ; do
> > > > > > > > > -		step=$((RANDOM*$RANDOM+4))
> > > > > > > > > -		minlen=$(((RANDOM*($RANDOM%2+1))%$mmlen))
> > > > > > > > > +		while true; do
> > > > > > > > > +			step=$((RANDOM*$RANDOM+4))
> > > > > > > > > +			test "$step" -ge "$FSTRIM_MIN_LEN" && break
> > > > > > > > > +		done
> > > > > > > > > +		while true; do
> > > > > > > > > +			minlen=$(( (RANDOM * (RANDOM % 2 + 1)) % FSTRIM_MAX_MINLEN ))
> > > > > > > > > +			test "$minlen" -ge "$FSTRIM_MIN_MINLEN" && break
> > > > > > > > > +		done
> > > > > > > > > +
> > > > > > > > >  		start=$RANDOM
> > > > > > > > >  		if [ $((RANDOM%10)) -gt 7 ]; then
> > > > > > > > >  			$FSTRIM_PROG $SCRATCH_MNT &
> > > > > > > > > 
> > > > > > > > 
> > > > > > > 
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 

