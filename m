Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=134.100.38.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794133853;
	b=zZc0XocL3xZUGyikJWdmlQAHWHd9gjmvKd/OECzT5W0TCfrdkMs/xrbjkihJtMECzSmm
	 1nERxArUrdTBZCV8SAQ/al1xcygnc6/bySFnga7Cd8tLM2mSaW4JZb/EsxgpU13odS18P
	 NSzij2gar1+eEzmRiWzMvWVi33/YTnInAAfQcOlMcg/LaE+QPR41HRIj1LI7MnyPhB1mM
	 2bwPVU//XVw65tRDoaMmWjcncilzYWP3En0iV0LJDV28pAI7SnxnWSpCeleOzlUQRMQ+x
	 M5imhS4nVudqfFTD0F+s9Sm5FbSy6FiMySfV8PNcUXvGX2fH+d2vhZDu9U4t9/irctA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794133853;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Subject:Message-ID:Organization:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:X-Rspamd-UID:
	 X-Rspamd-UID;
	bh=J4B11OV3dV2GMpzb1s+wkmRGv9nMlc7PRwug3+SGlXk=;
	b=aXSVbdHUDNb57DVPDj0GdvQIbFeTROVjSujp3fomb0SU2S2xu4tjvccwgLqUt+zAus/2
	 7ppIj/KhMoE8MBxC2yG30VqZNn2VTh7dOoP+7bw9hbyGkLMjCs5Aj3iRTXUmD0T0tYYAU
	 m6tLq4OR8DppBFfs9M4BG4ZKCq18qvPAMcfB0MYaVjeJ9g9q7MvzTOsbM8Sj8KAQfCAv+
	 nFdLQnQnMAyJY37tTBCknJkAODMGlkRZII1XhtQ0+OrUagPXjtSnlLSZ4sT9gWVwhOYcN
	 4/hDAUPikUChfhJKCc9qIvJuTpCTJZJY0Btl8czdyb27dDjk1tgc0+byuHr3u3hhFPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uni-hamburg.de;
	spf=pass smtp.mailfrom=uni-hamburg.de;
	dkim=pass header.d=uni-hamburg.de header.i=@uni-hamburg.de header.a=rsa-sha256 header.s=rrzs003 header.b=FDa5lA9N;
	arc=none smtp.remote-ip=134.100.38.113
Received: from mailout.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF8C606A321
	for <linux-xfs@vger.kernel.org>; Sun,  8 Nov 2026 10:30:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DF8C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.a=rsa-sha256 header.s=rrzs003 header.b=FDa5lA9N
Received: from mailout.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
	by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4jMq1s2bkTz2xJx
	for <linux-xfs@vger.kernel.org>; Sun,  8 Nov 2026 11:30:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-hamburg.de;
	s=rrzs003; t=1794133841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=J4B11OV3dV2GMpzb1s+wkmRGv9nMlc7PRwug3+SGlXk=;
	b=FDa5lA9Nw+FHn2GoHpRu21thtfyX9LMyAgewWPL4SWnlkJ4E+2tEe1JK5he2xnfbFHnjIC
	9rxkI2sDRpw9+Z5456AkGK+ue7UO8Hybotu4oiwrdRvPFBSODXFl4T7rMOrcQv9EH2ePrv
	k5J79yWiGZvJ7mIuFw8P6d19j4QeyPv+EVDvdD4i0hweQ07LRW4wRexVBfzH9kl3ApA2Ax
	uISUUJi8XalaQkmMXOxyM7w49NGLvt1CKEIvhGTpc7LcyokXpK6QfVigO0hyBHvYdwKCWj
	DIthTgGT9jFCXyv3aT4pWdtbHCRwrGpZA8Ho7Uon6UyBgWGcUspEBLEfE15Bkw==
Received: from exchange.uni-hamburg.de (EX-S-MR06.uni-hamburg.de [134.100.84.89])
	by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4jMq1s1RFHz2xJs
	for <linux-xfs@vger.kernel.org>; Sun,  8 Nov 2026 11:30:41 +0100 (CET)
Received: from plasteblaster (134.100.32.91) by EX-S-MR06.uni-hamburg.de
 (134.100.84.89) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 11:30:40 +0100
Date: Sun, 8 Nov 2026 11:30:39 +0100
From: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
To: <linux-xfs@vger.kernel.org>
Subject: xfsprogs-7.2.1 non-parallel-safe make and some gcc-16.2.0 warnings
Message-ID: <20261108113039.08688362@plasteblaster>
Organization: =?UTF-8?B?VW5pdmVyc2l0w6R0?= Hamburg
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: EX-S-MR08.uni-hamburg.de (134.100.84.91) To
 EX-S-MR06.uni-hamburg.de (134.100.84.89)
X-Rspamd-UID: f49cd3
X-Rspamd-UID: 4afe72

Hi linux-xfs,

I noticed that xfsprogs-7.2.1 `make install` fails for me with make
-j13 on a (oldish Xeon) box with 12 physical cores on two sockets (24
hyperthreads). Plus, there are some warnings from gcc-16.2.0 in the
default build that you might be interested in.

The full build/install log is at
	https://src.rrz.uni-hamburg.de/extra/paste/xfsprogs-7.2.1.log.bz2

The relevant excerpts:

1. make install error with -j13

(after successful `make -j13`)

Installing include-install
../install-sh -o root -g root -m 755 -d /usr/include/xfs
../../install-sh -o root -g root -m 644 xfs_db.8 /usr/share/man/man8/xfs_db=
.8
Installing libfrog-install-dev
../../install-sh -o root -g root -m 644 xfs_estimate.8 /usr/share/man/man8/=
xfs_estimate.8
Installing libxfs-install-dev
Installing libxlog-install-dev
gmake[1]: *** No rule to make target 'xfs_rt', needed by 'defer_item.lo'.  =
Stop.
gmake[1]: *** Waiting for unfinished jobs....
gmake[1]: *** No rule to make target 'xfs_rt', needed by 'defer_item.lo'.  =
Stop.
gmake[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:139: libxfs-install-dev] Error 2
make: *** Waiting for unfinished jobs....
make: *** [Makefile:139: libxfs-install-dev] Error 2
make: *** Waiting for unfinished jobs....

Re-running `make install` with -j1 works.


2. gcc warnings

xfs_alloc.c: In function '__xfs_free_extent':
xfs_alloc.c:4017:41: warning: variable 'busy_flags' set but not used [-Wunu=
sed-but-set-variable=3D]
 4017 |         unsigned int                    busy_flags =3D 0;
      |                                         ^~~~~~~~~~

xfs_bmap.c: In function 'xfs_bmapi_convert_one_delalloc':
xfs_bmap.c:4360:33: warning: variable 'flags' set but not used [-Wunused-bu=
t-set-variable=3D]
 4360 |         uint16_t                flags =3D 0;
      |                                 ^~~~~

xfs_bmap.c: In function 'xfs_bmap_btree_to_extents':
xfs_bmap.c:598:22: warning: 'cbp' may be used uninitialized [-Wmaybe-uninit=
ialized]
  598 |         if ((error =3D xfs_btree_check_block(cur, cblock, 0, cbp)))
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
xfs_bmap.c:568:34: note: 'cbp' was declared here
  568 |         struct xfs_buf          *cbp;   /* child block's buffer */
      |                                  ^~~

xfs_log_rlimit.c: In function 'libxfs_log_get_max_trans_res':
xfs_log_rlimit.c:162:33: warning: variable 'i' set but not used [-Wunused-b=
ut-set-variable=3D]
  162 |         unsigned int            i;
      |  =20
                              ^
xfs_copy.c: In function 'main':
xfs_copy.c:562:25: warning: variable 'num_threads' set but not used [-Wunus=
ed-but-set-variable=3D]
  562 |         int             num_threads =3D 0;
      |                         ^~~~~~~~~~~

dino_chunks.c: In function 'process_uncertain_aginodes':
dino_chunks.c:1349:33: warning: variable 'cnt' set but not used [-Wunused-b=
ut-set-variable=3D]
 1349 |         int                     cnt;
      |                                 ^~~

prefetch.c: In function 'do_inode_prefetch':
prefetch.c:1027:33: warning: variable 'queues_started' set but not used [-W=
unused-but-set-variable=3D]
 1027 |         int                     queues_started =3D 0;
      |                                 ^~~~~~~~~~~~~~

btheight.c: In function 'construct_records_per_block':
btheight.c:158:11: warning: assignment discards 'const' qualifier from poin=
ter target type [-Wdiscarded-qualifiers]
  158 |         p =3D strchr(tag, ':');
      |           ^

Please just ignore me if this is irrelevant with current development
versions, I do not have time to invest in this, but thought it is more
polite to say something than to just ignore it outright.


Alrighty then,

Thomas

--=20
Dr. Thomas Orgis
HPC @ Universit=C3=A4t Hamburg
