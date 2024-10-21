Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C03D282F0
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729550688; cv=none; b=iLQtB717PrGvVpIEMqekLDooYP3meJobjObQ1z+IA7IQoTUbdvKvJGviOU4g+FYLPchpUjL7DXkyXxPAA3GoXQTxZ0CJvymPbHVxkeNaov2RBYUVPb7vL+3JgMUod/nt1l4inF6cxqLiV7xB7P86GZYIqlnSDv8bYTO3CrZ955I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729550688; c=relaxed/simple;
	bh=fvBdXU5wdNYyyb0YdMIwM6Zof0HtqskXysq5kTzkOJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=haMOKbvA9b2FTs/McrjzvcVAe3nyuivNSyvz50P3OAT4D3jAqBBedUEgwnhX2EUMgDa7eCuV5rRBT7tGDnJnoUWYCStLbaQ5Onrn5R/SxsDYK8fP/a4I9PXsF5oNBTgpnTpjLDGBeNR8LnSC6YHcPWeMYB7hYejyPV/fF0s1QQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Eu/DMtJI; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Eu/DMtJI"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2e2dc61bc41so3359293a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 15:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729550686; x=1730155486; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v9dYHyq/nO2kjsKJljIwgu2XBEVXjwR+MspuvtZff/o=;
        b=Eu/DMtJIpd40O2ed5g9eFydSa1a4GmTmROIj2lD9FQDfKAGJLwwZAuvIRxQ31ckjbE
         LUZ4eRhW4oIJ/cJD7VlqhIPTEwfSfbXoWIYp54/i7wi8oYP5zPLqETrTYosdB97wdwHa
         Khaleew0eDYbLm6u94USWFGcRSiK0t8pTdXpi3y29J69CDnhlhaQEVyPfoeAOafDtPfU
         VhM5EdMaZP7CyXJ0xwoJ61C6gwh/tbhXOjLNikIolIDOlTNH5qntm/4XT749n54g2qIe
         DEVOXRJP7coLlir351qpWktCW6iXBlKS/5O7UlHEK4tyf5wC2wOFs/iL8p41M84mBzZj
         AnxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729550686; x=1730155486;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v9dYHyq/nO2kjsKJljIwgu2XBEVXjwR+MspuvtZff/o=;
        b=C05lbpPghqrfzIvVMmfwmmiddQaEbyO18d7+0Y5HsSsI7q6JdFbHfF6LCWSQLSpytE
         wXPxraBqz6DtrODuJ1uwl/CCJywVr3SDFUfdM8xepKGDphFWJS+Rdb6ezvX0Z+tfANNC
         2BO4TyX1vL2FIgthjHajsJ8DpZZBOiH7IChEmJrjdPPk5VHHT6e6Yu1jyW93wSqZPW8d
         5VWDOJzN/X1A8TMvZoEIFqlGhToPm8C/rHSilbNIrEaUHmZNkn9R/vp4E6fwqyZkMDnF
         f1KZtZRZHHxuybLDSvpu72OhWLgJMGCZYJsNVO5VFi0i15puYRjqskgmk5+sJaHTa0Wu
         83bQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTD7fgx0JtHc2sVF9/lMiRsZ+1JrgME+pl1fCxpIfWlf68fs4vN3NZ5+xNAu1C3dEdePyvE2CdDlk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1qSF5HTwYakx2IqtaSxKnBpEgIt/vyrOC0NAJ/i2HMnFjxWwB
	nu61b8qw7Z5EDHcBTYJ/mPL9iSWMF5jsn0liLQs//WIJZvQnnf9ClXxCXznDUxo=
X-Google-Smtp-Source: AGHT+IGhdnySufxWPfyYesh8DzNaeadpQJfwQ7ArqAHGT1qeQ1opDWNb+N7doDqEnIoCBf6sf7SXqg==
X-Received: by 2002:a17:90a:ce8d:b0:2e2:973b:f8e7 with SMTP id 98e67ed59e1d1-2e5619f788amr13821134a91.38.1729550686240;
        Mon, 21 Oct 2024 15:44:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ddb41548sm285199a91.39.2024.10.21.15.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 15:44:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t318l-003zgG-0d;
	Tue, 22 Oct 2024 09:44:43 +1100
Date: Tue, 22 Oct 2024 09:44:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot+611be8174be36ca5dbc9@syzkaller.appspotmail.com>,
	cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_ail_push_all_sync (2)
Message-ID: <ZxbZW5Q9sC0c+bqU@dread.disaster.area>
References: <67104ab3.050a0220.d9b66.0175.GAE@google.com>
 <ZxBgAU7aasIzcBfj@dread.disaster.area>
 <CANp29Y6Rv2vUg463F3SYTsSNDr=Hmnarbz377tS=Hash7pT4xw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y6Rv2vUg463F3SYTsSNDr=Hmnarbz377tS=Hash7pT4xw@mail.gmail.com>

On Fri, Oct 18, 2024 at 12:13:33PM +0200, Aleksandr Nogikh wrote:
> Hi Dave,
> 
> On Thu, Oct 17, 2024 at 2:53 AM 'Dave Chinner' via syzkaller-bugs
> <syzkaller-bugs@googlegroups.com> wrote:
> >
> > On Wed, Oct 16, 2024 at 04:22:27PM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    09f6b0c8904b Merge tag 'linux_kselftest-fixes-6.12-rc3' of..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=14af3fd0580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=7cd9e7e4a8a0a15b
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=611be8174be36ca5dbc9
> > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16c7705f980000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d2fb27980000
> >
> 
> It's better to just leave the issue open until syzbot actually stops
> triggering it. Otherwise, after every "#syz invalid", the crash will
> be eventually seen again and re-sent to the mailing lists.
> 
> In the other email you mentioned
> "/sys/fs/xfs/<dev>/error/metadata/EIO/max_retries" as the only way to
> prevent this hang. Must max_retries be set every time after xfs is
> mounted? Or is it possible to somehow preconfigure it once at VM boot
> and then no longer worry about it during fuzzing?

It's a post mount config because the filesystem has to be mounted
before the error config files show up in /sys/fs/xfs/<dev>/....

For example, in fstests we set "fail_at_unmount" specifically when
running a test that will error out all writes and then unmount.

The code that does this is in common/xfs:

# Prepare a mounted filesystem for an IO error shutdown test by disabling retry
# for metadata writes.  This prevents a (rare) log livelock when:
#
# - The log has given out all available grant space, preventing any new
#   writers from tripping over IO errors (and shutting down the fs/log),
# - All log buffers were written to disk, and
# - The log tail is pinned because the AIL keeps hitting EIO trying to write
#   committed changes back into the filesystem.
#
# Real users might want the default behavior of the AIL retrying writes forever
# but for testing purposes we don't want to wait.
#
# The sole parameter should be the filesystem data device, e.g. $SCRATCH_DEV.
_xfs_prepare_for_eio_shutdown()
{
        local dev="$1"
        local ctlfile="error/fail_at_unmount"

        # Once we enable IO errors, it's possible that a writer thread will
        # trip over EIO, cancel the transaction, and shut down the system.
        # This is expected behavior, so we need to remove the "Internal error"
        # message from the list of things that can cause the test to be marked
        # as failed.
        _add_dmesg_filter "Internal error"

        # Don't retry any writes during the (presumably) post-shutdown unmount
        _has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 1

        # Disable retry of metadata writes that fail with EIO
        for ctl in max_retries retry_timeout_seconds; do
                ctlfile="error/metadata/EIO/$ctl"

                _has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 0
        done
}

However, this does not address the same issue when a filesystem
freeze is run (because it has to bring the on-disk state down to the
same as a clean unmounted filesystem). Hence for syzbot, the only
way to avoid this sort of issue is to cap the maximum number of
retries so that metadata writes fail as soon as the device starts
rejecting them.

Realistically, we want syzbot to exercise both the retry logic and
the hard fail logic. Right now it is only exercising the retry
logic, so setting the max retries to, say, three retries would
exercise both the retry logic and the hard fail logic and still
avoid all the potential "livelock until user intervention" test
hangs...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
