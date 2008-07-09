Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 23:48:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m696m4Qi018870
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 23:48:05 -0700
Received: from pomaz-ex.szeredi.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A4CD114C40C
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 23:49:09 -0700 (PDT)
Received: from pomaz-ex.szeredi.hu (fxip-0047f.externet.hu [88.209.222.127]) by cuda.sgi.com with ESMTP id P9z6l9n5ACyhL8hd for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 23:49:09 -0700 (PDT)
In-reply-to: <20080708234120.5072111f@infradead.org> (message from Arjan van
	de Ven on Tue, 8 Jul 2008 23:41:20 -0700)
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080630212450t-sato@mail.jp.nec.com>
	<20080701081026.GB16691@infradead.org>
	<20080707110730.GG5643@ucw.cz>
	<20080708231026.GP11558@disturbed>
	<20080708232031.GE18195@elf.ucw.cz>
	<20080709005254.GQ11558@disturbed>
	<20080709010922.GE9957@mit.edu>
	<E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
	<20080709061621.GA5260@infradead.org>
	<E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org>
Message-Id: <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jul 2008 08:48:42 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: arjan@infradead.org
Cc: miklos@szeredi.hu, hch@infradead.orgmiklos@szeredi.hu, tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Tue, 8 Jul 2008, Arjan van de Ven wrote:
> nah he needs to do
> 
> make_snapshot ; backup-command ; unref_snapshot.
> 
> freezing isn't the right solution for the backup problem ;)

Confused, what's freezing _is_ for then?  Patch description says:

  Currently, ext3 in mainline Linux doesn't have the freeze feature which
  suspends write requests.  So, we cannot take a backup which keeps
  the filesystem's consistency with the storage device's features
  (snapshot and replication) while it is mounted.
  In many case, a commercial filesystem (e.g. VxFS) has
  the freeze feature and it would be used to get the consistent backup.
  If Linux's standard filesytem ext3 has the freeze feature, we can do it
  without a commercial filesystem.

Miklos
