Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C169351C0B
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 12:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823850; cv=none; b=KxqAOoSRFOrbcelm2aqTSIldqbkxHPUfjp2LBAiGyxVlyTCYjy2InDtdLwsteYSe44EaSoh7S2PduxrMYAF2xthmdT9pLgnu3oMw+bpHJiJ31gUDwuoy0GN9DlPe8MIs7gfmUJ47BSQJyPvP9L1/d7SX20708um0Ba5qFQ6e80w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823850; c=relaxed/simple;
	bh=thi2y64iSCDVMJfIFEAh0afM+OR2WACN/moAXbQDHio=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=H153aizUZWKqLdkEAgEJvSaAJZcrMS5JWsE6K5hhQDhXklY9y/ZkjKYqLA0q8FGgWhjMXkGbV+hPAelPTIf0XLq5gMGQtwpHPW3dh9gbKaEuCPWo4gWpTWe/b4smnNhLjpfrtBkVW/YxJKKnToXR1jYLMEbWVrXtl1r2DH31xLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JN08pUOJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yk5nDEat; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JN08pUOJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yk5nDEat"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775823847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=6jMJX8APtyJJY6rqgDJ3eN1iB9co1g8CjS5y7DXx+Vk=;
	b=JN08pUOJ1jzkzcL2hJT0+uT3AXk2zAsL03BRHxUunQVAji3BtFGixvF5KdhTXRtOKmsX6m
	SclTkbtrxGdTf1MOeigCWzbxVtygaOIgv1kyZ5ll3beTP0xW0XkjxRKOuFGVBeFZbER2Tl
	lGq0LePV/andVQL0XlSXibcMaiMf0xQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-XABrQxL-PeaHsY-xcXOfcg-1; Fri, 10 Apr 2026 08:24:06 -0400
X-MC-Unique: XABrQxL-PeaHsY-xcXOfcg-1
X-Mimecast-MFC-AGG-ID: XABrQxL-PeaHsY-xcXOfcg_1775823845
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43cfbe041b2so1075036f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 05:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775823845; x=1776428645; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6jMJX8APtyJJY6rqgDJ3eN1iB9co1g8CjS5y7DXx+Vk=;
        b=Yk5nDEathyrJaihvtpMZkage5swEx2n2v8JQoBlujRTg3rU2KgiC1yeb7fdHpnJZWF
         AI2UzDXMks7derYmnte+y7NWAsEZwljqv9NuopJAtbfFOByqPlOCxz87RUn200fIUFHB
         /F6jcxe4G7K1kPpCSUXY5Y6ABOInQugVQpR+SyFjn/dsev2hr/1XVeyU1XYc/sJrnfAx
         qye2XlmtTFWMoG8BGCF3SFN0IzxQDnDk6KJ5PsoNvQZ1+JDGOUF1hn2Dhp9J8TFMCwyD
         UaPTSjdsK7LuSMdtBqq4nmgYLroxyAFFLKYzV/An699USWqCJQVtgxqi+ewYz+7N0ufN
         ZiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775823845; x=1776428645;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6jMJX8APtyJJY6rqgDJ3eN1iB9co1g8CjS5y7DXx+Vk=;
        b=s/yKiLiA21dtxSPUQAW+eoRJISQ72ty7NaiM8FiWBhahkOhiQJmqSxErq315JTtcvh
         nbO//TglVJoQ/svOxkDEhQsVs58bGLVzL/a/+P1fivNRaQ3nMhv0A6NTY02isajXvGgp
         YtyDnR+DVeNRA/KLrr4OHFqpYo8I4/qrwGiLgM36nJHqOLU9aiQxF+ELXHvo9HeIeiRX
         y9Wj0bJmLg5k12vRE8WJkOqE5RElfVgCT7nLM0CV+e1qYC0aYqY6usLwBCX8ri3lpKzD
         nTYqGkLeS5RrELQl/AjaQcuQQB1ahE39QArV+dllFB15PxXkNbKljTBY64D8sX8TCMkr
         X6tw==
X-Gm-Message-State: AOJu0Yws6Ufun1FE6tQbyvXrx2fnS7at9zOvqR1LE+SsWdihP2iYMyTv
	rYFWd16afu7wJSoBpjnQGDtW54xzWp5/2Gw4wPMGIPIdk5ZeSGXld3Z26M3rrWWLfO33IoXiX7y
	74TilV2WNzhRfpBA7aiONZKb4XNv3lgW61ytiRhcd/FpVzM44GSY72q/mpI7Cee/M9CtKbKNnov
	obDSWEkljBHrfpDTiWiFHzZcPPIdrRBNvf5id05lygBO0C
X-Gm-Gg: AeBDiev91kaMjUX6VTUPkGbV411XdwM0NnUEs05WsE/ZUlRaB5fY49Y0w2vnxJFv01i
	nbjYE46bnrYcHzBC3/EEXddzBFCqrtf2Upw/s0aheLtb/yNdVKTY+l0IVZlGyITnRwZanxnebuB
	Jg202AWFzEwMT+RX2kkt1qgi3jWkpwZvI+ocSJzUSc2iz/lNAuo6sN2XOLfD+vvVBfz2iWPk+CT
	nVgah3ffnJ+ShceTohNhCnQhHHeHRxDAqoNInjl0guFsnkhgKYgesCJra8ZZGoW4dlrqTyxkgyg
	Y36rd0LXYkRUXD9Y9+YnqhPHxyv9x4Lbcti1N+BLvIn0NoI9NR2qbSa2Pdw7QewMSI8ayMlu0IF
	cJrjpXKUFg4ok6A==
X-Received: by 2002:a05:6000:1619:b0:43b:97d8:9a40 with SMTP id ffacd0b85a97d-43d595c4e3amr8156407f8f.17.1775823844422;
        Fri, 10 Apr 2026 05:24:04 -0700 (PDT)
X-Received: by 2002:a05:6000:1619:b0:43b:97d8:9a40 with SMTP id ffacd0b85a97d-43d595c4e3amr8156334f8f.17.1775823843597;
        Fri, 10 Apr 2026 05:24:03 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63dec28asm7003324f8f.15.2026.04.10.05.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 05:24:03 -0700 (PDT)
Date: Fri, 10 Apr 2026 14:24:02 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 8ef7291a272e
Message-ID: <cds5qn5pzl6f4fz5ccme2os5lrscu352vekfq37hvj3ivbjqrs@nikakouxtjrm>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

8ef7291a272e4e29e38dda90afec56a983776187

New commits:

Christoph Hellwig (6):
      [9ad485e75832] scrub: remove the unused io_disk field in struct read_verify
      [f529481a7a72] scrub: simplify the read_verify_pool_alloc interface
      [6ce165b0f44a] scrub: use enum xfs_device for read verification
      [1ef66d39b75b] scrub: simplify verifier threads calculation
      [9cd59bf3cf78] xfs_scrub: move disk media verification error injection
      [d0ba8a9348ae] scrub: don't allocate disk for ioctl-based media verify

Darrick J. Wong (41):
      [b2fc3c686b2a] libfrog: add a function to grab the path from an open fd and a file handle
      [3774cbe05939] libfrog: create healthmon event log library functions
      [6839b8314a49] libfrog: add support code for starting systemd services programmatically
      [27ddec39aa0d] libfrog: hoist a couple of service helper functions
      [67fc0c99ea51] libfrog: add wrappers for listmount and statmount
      [92043e66ae68] man2: document the healthmon ioctl
      [d93adb823122] man2: document the media verification ioctl
      [eba72901c88c] xfs_io: monitor filesystem health events
      [bbed6dcf85f3] xfs_io: add a media verify command
      [b9b03770197d] xfs_healer: create daemon to listen for health events
      [6f0f35a87c87] xfs_healer: enable repairing filesystems
      [17d840245c0e] xfs_healer: use getparents to look up file names
      [88825fe0de0d] xfs_healer: create a per-mount background monitoring service
      [428bd63ab404] xfs_healer: create a service to start the per-mount healer service
      [ea178059ff72] xfs_healer: don't start service if kernel support unavailable
      [bf8b99270c6b] xfs_healer: use the autofsck fsproperty to select mode
      [a162dc462186] xfs_healer: run full scrub after lost corruption events or targeted repair failure
      [54c0ba68b007] xfs_healer: use getmntent to find moved filesystems
      [327f964dd6f0] xfs_healer: use statmount to find moved filesystems even faster
      [c2425375f293] xfs_healer: validate that repair fds point to the monitored fs
      [c5d8a2ad1d28] xfs_healer: add a manual page
      [99a6f427c4fd] xfs_scrub: print systemd service names
      [505afcfda5c5] xfs_io: add listmount and statmount commands
      [8aed3354e429] mkfs: enable online repair if all backrefs are enabled
      [dfee401c10bc] debian/control: listify the build dependencies
      [bd61d2b9c852] debian: enable xfs_healer on the root filesystem by default
      [e768971e2fdf] libfrog: allow bitmap_free to handle a null bitmap pointer
      [50d8b74334f1] mkfs: rename byte unit conversion macros
      [e8249d9649ec] libfrog: lift *BYTES helpers to convert.h
      [4e0c9692f6a8] xfs_scrub: report truncated devices as media errors
      [b2a12740b115] xfs_scrub: fix i18n of the decode_special_owner return value
      [acc91b2a53cd] xfs_scrub: move read verification scheduling to phase6.c
      [56e731dac4df] xfs_scrub: don't pass the io_end_arg around everywhere
      [cc2c8a000836] xfs_scrub: rename nr_io_threads
      [02760878dd86] xfs_scrub: use the verify media ioctl during phase 6 if possible
      [95a92c5cecb2] xfs_scrub: perform media scanning of the log region
      [8a537ebc7066] xfs_scrub: index read-verify pools by xfs_device ids
      [58fca77c2d2a] xfs_scrub: move failmap and other outputs into read_verify_pool
      [c2e07d407aee] xfs_scrub: clean up device-related error messages
      [5eb6d67a8319] xfs_scrub: drop SCSI_VERIFY code from disk.
      [8ef7291a272e] xfs_scrub: raise media verification IO limits

Code Diffstat:

 Makefile                                       |   5 +
 configure.ac                                   |  13 +
 db/bmap_inflate.c                              |   2 +-
 debian/control                                 |  14 +-
 debian/postinst                                |   8 +
 debian/prerm                                   |  13 +
 debian/rules                                   |   3 +-
 doc/README-env-vars.txt                        |   1 -
 healer/Makefile                                |  69 +++
 healer/fsrepair.c                              | 342 ++++++++++++
 healer/system-xfs_healer.slice                 |  31 ++
 healer/weakhandle.c                            | 296 +++++++++++
 healer/xfs_healer.c                            | 693 +++++++++++++++++++++++++
 healer/xfs_healer.h                            |  92 ++++
 healer/xfs_healer@.service.in                  | 108 ++++
 healer/xfs_healer_start.c                      | 371 +++++++++++++
 healer/xfs_healer_start.service.in             |  85 +++
 include/builddefs.in                           |  15 +
 include/linux.h                                |   8 +-
 io/Makefile                                    |   9 +-
 io/healthmon.c                                 | 191 +++++++
 io/init.c                                      |   3 +
 io/io.h                                        |   8 +
 io/listmount.c                                 | 367 +++++++++++++
 io/verify_media.c                              | 181 +++++++
 libfrog/Makefile                               |  19 +
 libfrog/bitmap.c                               |   3 +
 libfrog/convert.c                              |   7 -
 libfrog/convert.h                              |   7 +
 libfrog/flagmap.c                              |  79 +++
 libfrog/flagmap.h                              |  23 +
 libfrog/fsproperties.h                         |   5 +
 libfrog/getparents.c                           |  93 +++-
 libfrog/getparents.h                           |   4 +
 libfrog/healthevent.c                          | 477 +++++++++++++++++
 libfrog/healthevent.h                          |  55 ++
 libfrog/statmount.c                            |  76 +++
 libfrog/statmount.h                            | 104 ++++
 libfrog/systemd.c                              | 188 +++++++
 libfrog/systemd.h                              |  55 ++
 m4/package_libcdev.m4                          | 129 +++++
 man/man2/ioctl_xfs_health_fd_on_monitored_fs.2 |  75 +++
 man/man2/ioctl_xfs_health_monitor.2            | 464 +++++++++++++++++
 man/man2/ioctl_xfs_verify_media.2              | 197 +++++++
 man/man8/Makefile                              |  40 +-
 man/man8/xfs_healer.8                          | 121 +++++
 man/man8/xfs_healer_start.8                    |  37 ++
 man/man8/xfs_io.8                              | 133 +++++
 mdrestore/xfs_mdrestore.c                      |   5 +-
 mkfs/xfs_mkfs.c                                |  47 +-
 repair/agbtree.c                               |   3 +-
 repair/bmap_repair.c                           |   3 +-
 repair/rmap.c                                  |   3 +-
 repair/xfs_repair.c                            |   5 +-
 scrub/Makefile                                 |  16 +-
 scrub/common.c                                 |  19 +-
 scrub/disk.c                                   | 204 --------
 scrub/disk.h                                   |   2 -
 scrub/fscounters.c                             |   4 +-
 scrub/fscounters.h                             |   2 +-
 scrub/phase1.c                                 |  91 +++-
 scrub/phase5.c                                 |   6 +-
 scrub/phase6.c                                 | 424 ++++++++-------
 scrub/phase7.c                                 |   7 +-
 scrub/phase8.c                                 |   3 +-
 scrub/read_verify.c                            | 451 +++++++++++-----
 scrub/read_verify.h                            |  34 +-
 scrub/spacemap.h                               |   5 +
 scrub/xfs_scrub.c                              |  83 ++-
 scrub/xfs_scrub.h                              |  12 +-
 70 files changed, 6051 insertions(+), 697 deletions(-)
 create mode 100644 debian/prerm
 create mode 100644 healer/Makefile
 create mode 100644 healer/fsrepair.c
 create mode 100644 healer/system-xfs_healer.slice
 create mode 100644 healer/weakhandle.c
 create mode 100644 healer/xfs_healer.c
 create mode 100644 healer/xfs_healer.h
 create mode 100644 healer/xfs_healer@.service.in
 create mode 100644 healer/xfs_healer_start.c
 create mode 100644 healer/xfs_healer_start.service.in
 create mode 100644 io/healthmon.c
 create mode 100644 io/listmount.c
 create mode 100644 io/verify_media.c
 create mode 100644 libfrog/flagmap.c
 create mode 100644 libfrog/flagmap.h
 create mode 100644 libfrog/healthevent.c
 create mode 100644 libfrog/healthevent.h
 create mode 100644 libfrog/statmount.c
 create mode 100644 libfrog/statmount.h
 create mode 100644 libfrog/systemd.c
 create mode 100644 libfrog/systemd.h
 create mode 100644 man/man2/ioctl_xfs_health_fd_on_monitored_fs.2
 create mode 100644 man/man2/ioctl_xfs_health_monitor.2
 create mode 100644 man/man2/ioctl_xfs_verify_media.2
 create mode 100644 man/man8/xfs_healer.8
 create mode 100644 man/man8/xfs_healer_start.8

-- 
- Andrey

