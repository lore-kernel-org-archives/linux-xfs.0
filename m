Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138327;
	b=dZTIdnrT20qDvTGRu6qDC9vnmAx7lLHqR884gl77D/f0QnNRBEmbAGfhJFUC6fKNe+RL
	 LtOGiIpfPPegusiOqzmfUhE5ip7oeMcG3LO2twrzH6RaAGaiZ/jH3lIvuEi5gvQIxEUKc
	 ThIIzbE7WwWEnqaqXUPgCKRlJGka0Wah/ZH3Lc4njGeDM4ZwQoAY1ZAGyVofkOk1QPafy
	 iwJsv8LuK1fEzD2ZGQQkoy7iQR7ScC4HaCMqO9XxCkU+5TQmvAG/a8/sCtKpfcR+1+83w
	 NmDXUzc8cdL8Clv9eEd7BTwad3L+tzNYikiwxbL/kiL8HW8giaxqzsh5VA7Pjspi3kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138327;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e12N8ZX0Lkx8DYQBw3EDvB2XZn5mBgH3gy7qGfPn8tk=;
	b=BYN8Xd0XDBq+Kc7uEJkZX1bMcupUbz+3+yw/Mr31Hw6rfNtqoKAc6KjQbDZEyFFvatId
	 eHj1JJW9/CGts4I1mSxoHwhIpCJjafBcHlznaRsTC+qaXgxLGUyJUA5bC9dQiFQ4kCNQU
	 QU6MALLwbnFlJWV9JjBgt8C/QprfemJUqn3znNQFnL4g/Jh3caFgnaEGbKM+kQiu31H9y
	 PcTV/Z/D5Y+UpXy9ZTnelWFKtuKI47KRk9mMU/5rjuvTUwwSkOs/XSI6Iu29qUbmlsqvj
	 HdtmOXq0PCrCAxXv2T3bBKSCDaaKiQhUrU2NAFY/9o70u+XTvFkFyuqW5gNIEJiny6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eQwHA+wR;
	arc=none smtp.remote-ip=209.85.128.179
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D1960A2600
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:58:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06D1960A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eQwHA+wR
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b05bf699easo3169317b3.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138326; x=1793743126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e12N8ZX0Lkx8DYQBw3EDvB2XZn5mBgH3gy7qGfPn8tk=;
        b=eQwHA+wR5NE+HXgiR5HUCOJFE1l47lvRHqLSfvJXUC00kKnsCg6MBczkGfRCKhmhKv
         mQxMLpxbLQQUf5w+OBRIVVg4C3PoQGgAV05PHuFxRLLtRiTmQ0RIvUQ7vr6yI0qow3wB
         ozNI97J60cqdBEsPyoRVEOqc8scQVHTRj67EO8Xk98ROXBxPQxiGY2Y3+OD2sZYqLo5g
         JJr5Pvm9hVCsNsEzixlT0cYo7Z5PhjY7zrbBh8aJhF10zpHlcp20QxjIDfutJtdehGPA
         M/vytdXpo04VEquIB4f2coa8t2K2ehuJkWb8sGcFThMUZ00CudWtZOEnLRXXaxdX993Q
         sL2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138326; x=1793743126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e12N8ZX0Lkx8DYQBw3EDvB2XZn5mBgH3gy7qGfPn8tk=;
        b=hk7Zwv5QeE3gK9d5CBE8YRRh/NTm/ZBi/33IvI9ccDJAMBEu3TeUdgutuWgeK2MNlT
         cwC/eq2GCnbrEaOoWhgH/injT5oVyUG4H19r+ur1rt/++0hZj7b2Sk2sfdLL4PUhIcmU
         KbaJZWPAr9XFSJcFoRwxwPxv8bwJxH7BWPe/mwo661ylalzsrZDKT7ai44Gp7XuaWw9P
         hGvJqLFd5LEzsqNt9DXbmQH6M2fUykUM0uTtrNYN2eIlla1nQVG7fc3Ko8ChjzHWMIQM
         aUqMUDSx7QnhermOIRyGUaIBf7RXbDckNda2u7SQXiVCqdpYxjVaftAKYY3t7ukt9vqZ
         IeNg==
X-Forwarded-Encrypted: i=1; AKwUvBze3K8N82emI8cYoIaZ1LR09JOy+dE/8XxxAADfcrX+ECQBgcCUnFF0uiXqlEdE1Y8q3tN6jFtVSVU=@vger.kernel.org
X-Gm-Message-State: AFq9FYKWKasrbe8j8jA3Xr8wMTEsVo1WDarJCrbTsF4emeFtw4Fu4gg/
	/Qot7o0fLqtCem9HIpyff+2IYgwezyCTd7D6ozz0jv6N747f5gaL7n+c
X-Gm-Gg: AYBFou1JciFYJLJ8e7Zyf3OGQ2jvj/EUZF/LvZonfWqNDcZEDdErOYNDYUpVCkrFLcZ
	rymflsGoOx5lhDUcxyGCJwNPEbmFMp2ieMUsGysV250sdLGeQgedZdVTg0cJemUFQa7XB0tn7pf
	dlFyvwChFnfbZz1OreHPXwQZ3r4meKx5F28r5tfHzMkTFNqjC7uGzJVLovolbSvdMm0/hAfD2ZA
	lRBfwbZ3zuug5XdusLa9UseLNEMKMzKCvd5D9ZLBvRTt5+K7BCSoHT77T1JGOWLOlXqZmNcO2ba
	x7mYBlVdGDfrsdg6yFTTfUh869E4iYpKxT2+RitZZ3LRf6w/Y9s5tl9CrCOAfbrxjYhaZ3Sv2HL
	jrXcX/ycKobCIX3CFQprlBwoGuCNpD2UFeVEMjhm7p6XWqwgT7ObluOEkQDXLydRkXZvmmokK59
	aoYiZcFTOxSx3TVozNOD6VLt8jfgWsMFUjLcop9C4J9DNxMMSTFR7mV6xwdjcG5Xg0I3cNABlPp
	R3FzebXaAclFHTM7zjUxqxWtwp7kC2AbBRqieiaGgYXyCAjAo6hFBGXEM5jZKgn/gqDK+LWXNnQ
	5TpmEukG8ktFIt1sNne12YGGciEAPTM=
X-Received: by 2002:a05:690c:3484:b0:873:5c6b:a305 with SMTP id 00721157ae682-8b1b5d1ab22mr1935707b3.51.1793138325796;
        Tue, 27 Oct 2026 14:58:45 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e5a30bfsm18804397b3.24.2026.10.27.14.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:45 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 5/5] Documentation: iomap: update docs to reflect iomap_iter_next model
Date: Tue, 27 Oct 2026 14:53:26 -0700
Message-ID: <20261027215326.2693300-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Filesystems no longer pass a struct iomap_ops with separate
->iomap_begin() and ->iomap_end() callbacks. Instead, every iomap
operation takes a single iomap_iter_next() callback directly.
iomap_iter_next() finishes the previous mapping (if any) and produces
the next one. Most filesystems build it from begin and end helpers via
the iomap_iter_next() helper.

Update the iomap documentation to match this change.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 Documentation/filesystems/iomap/design.rst    | 140 +++++++++++++-----
 .../filesystems/iomap/operations.rst          |  68 ++++-----
 Documentation/filesystems/iomap/porting.rst   |  16 +-
 3 files changed, 151 insertions(+), 73 deletions(-)

diff --git a/Documentation/filesystems/iomap/design.rst b/Documentation/filesystems/iomap/design.rst
index 681e0cbb6944..508e63ce205c 100644
--- a/Documentation/filesystems/iomap/design.rst
+++ b/Documentation/filesystems/iomap/design.rst
@@ -75,7 +75,10 @@ At a high level, an iomap operation `looks like this
 
 1. For each byte in the operation range...
 
-   1. Obtain a space mapping via ``->iomap_begin``
+   1. Obtain the next space mapping via the ``iomap_iter_next_fn`` callback.
+      From the second iteration onwards this same callback first finishes
+      the previous mapping (committing or unreserving space as needed)
+      and then produces the next one.
 
    2. For each sub-unit of work...
 
@@ -86,7 +89,13 @@ At a high level, an iomap operation `looks like this
 
    3. Increment operation cursor
 
-   4. Release the mapping via ``->iomap_end``, if necessary
+iomap repeats this until the range is fully consumed.  The ``iomap_iter_next_fn``
+callback returns ``1`` while there is more of the range left to process,
+``0`` once it is fully consumed, or a negative errno on error.
+Filesystems rarely implement this callback by hand. The ``iomap_iter_next``
+helper implements the finish-then-produce sequence in terms of two smaller
+callbacks, ``begin`` and ``end``. See `The Mapping Callback`_ below for more
+info.
 
 Each iomap operation will be covered in more detail below.
 This library was covered previously by an `LWN article
@@ -189,7 +198,7 @@ The fields are as follows:
    * **IOMAP_DELALLOC**: A promise to allocate space at a later time
      ("delayed allocation").
      If the filesystem returns IOMAP_F_NEW here and the write fails, the
-     ``->iomap_end`` function must delete the reservation.
+     ``end`` function must delete the reservation.
      The ``addr`` field must be set to ``IOMAP_NULL_ADDR``.
 
    * **IOMAP_MAPPED**: The file range maps to specific space on the
@@ -208,12 +217,11 @@ The fields are as follows:
 
    * **IOMAP_INLINE**: The file range maps to the memory buffer
      specified by ``inline_data``.
-     For write operation, the ``->iomap_end`` function presumably
-     handles persisting the data.
+     For write operation, the ``end`` function must persist the data.
      The ``addr`` field must be set to ``IOMAP_NULL_ADDR``.
 
  * ``flags`` describe the status of the space mapping.
-   These flags should be set by the filesystem in ``->iomap_begin``:
+   These flags should be set by the filesystem in ``begin``:
 
    * **IOMAP_F_NEW**: The space under the mapping is newly allocated.
      Areas that will not be written to must be zeroed.
@@ -262,15 +270,15 @@ The fields are as follows:
      update.
 
    These flags can be set by iomap itself during file operations.
-   The filesystem should supply an ``->iomap_end`` function if it needs
+   The filesystem should supply an ``end`` function if it needs
    to observe these flags:
 
    * **IOMAP_F_SIZE_CHANGED**: The file size has changed as a result of
      using this mapping.
 
    * **IOMAP_F_STALE**: The mapping was found to be stale.
-     iomap will call ``->iomap_end`` on this mapping and then
-     ``->iomap_begin`` to obtain a new mapping.
+     iomap will call ``end`` on this mapping and then ``begin`` to obtain a
+     new mapping.
 
    Currently, these flags are only set by pagecache operations.
 
@@ -289,41 +297,103 @@ The fields are as follows:
 
  * ``private`` is a pointer to `filesystem-private information
    <https://lore.kernel.org/all/20180619164137.13720-7-hch@lst.de/>`_.
-   This value will be passed unchanged to ``->iomap_end``.
+   This value will be passed unchanged to ``end``.
 
  * ``validity_cookie`` is a magic freshness value set by the filesystem
    that should be used to detect stale mappings.
    For pagecache operations this is critical for correct operation
    because page faults can occur, which implies that filesystem locks
-   should not be held between ``->iomap_begin`` and ``->iomap_end``.
+   should not be held between ``begin`` and ``end``.
    Filesystems with completely static mappings need not set this value.
    Only pagecache operations revalidate mappings; see the section about
    ``iomap_valid`` for details.
 
-``struct iomap_ops``
+The Mapping Callback
 --------------------
 
-Every iomap function requires the filesystem to pass an operations
-structure to obtain a mapping and (optionally) to release the mapping:
+Every iomap operation takes an ``iomap_iter_next_fn`` callback from the
+filesystem. iomap calls it once per iteration of the file range:
 
 .. code-block:: c
 
- struct iomap_ops {
-     int (*iomap_begin)(struct inode *inode, loff_t pos, loff_t length,
-                        unsigned flags, struct iomap *iomap,
-                        struct iomap *srcmap);
+ typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
+                              struct iomap *iomap, struct iomap *srcmap);
 
-     int (*iomap_end)(struct inode *inode, loff_t pos, loff_t length,
-                      ssize_t written, unsigned flags,
-                      struct iomap *iomap);
- };
+``iomap_iter_next_fn``
+~~~~~~~~~~~~~~~~~~~~~~
+
+This must finish the previous mapping, if any, and then produce the next
+mapping for the current iteration position described by ``iter``.
+The mapping is returned through ``iomap`` (and through ``srcmap`` for
+operations that read from one mapping while writing to another; see
+``begin`` below).
+
+The callback returns ``1`` to continue iterating, ``0`` once the file
+range has been fully consumed, or a negative errno on error.
+
+Most filesystems are not expected to implement all of these behaviors
+in this callback themselves.  They should instead call ``iomap_iter_next`` as
+described below.
+
+``iomap_iter_next``
+~~~~~~~~~~~~~~~~~~~
+
+Filesystems rarely need a hand-written ``iomap_iter_next_fn`` callback.  The
+``iomap_iter_next`` helper implements the finish-then-produce sequence in
+terms of two smaller callbacks, ``begin`` and ``end``, so most
+``iomap_iter_next_fn`` implementations are simply:
+
+.. code-block:: c
+
+ static int my_iomap_next(const struct iomap_iter *iter,
+                          struct iomap *iomap, struct iomap *srcmap)
+ {
+         return iomap_iter_next(iter, iomap, srcmap,
+                                my_iomap_begin, my_iomap_end);
+ }
+
+This boilerplate is normally generated with the ``DEFINE_IOMAP_ITER_NEXT()``
+and ``DEFINE_IOMAP_ITER_NEXT_END()`` macros rather than written by hand.  Use
+``DEFINE_IOMAP_ITER_NEXT()`` for the common case with no ``end`` callback, and
+``DEFINE_IOMAP_ITER_NEXT_END()`` when an ``end`` callback is needed:
+
+.. code-block:: c
+
+ /* no end() callback */
+ static DEFINE_IOMAP_ITER_NEXT(my_iomap_next, my_iomap_begin);
+
+ /* with an end() callback */
+ static DEFINE_IOMAP_ITER_NEXT_END(my_iomap_next, my_iomap_begin,
+                                   my_iomap_end);
+
+The macro generates a function with external linkage.  Prefix the invocation
+with ``static`` for a file-local callback, or leave it non-``static`` and add
+a matching declaration to a header when the callback is referenced from
+another file.
+
+``end`` may be ``NULL`` when the filesystem has nothing to finish.
+The two callbacks have these prototypes:
+
+.. code-block:: c
+
+ typedef int (*iomap_begin_fn)(struct inode *inode, loff_t pos,
+                               loff_t length, unsigned flags,
+                               struct iomap *iomap, struct iomap *srcmap);
+
+ typedef int (*iomap_end_fn)(struct inode *inode, loff_t pos,
+                             loff_t length, ssize_t written,
+                             unsigned flags, struct iomap *iomap);
+
+``iomap_iter_next`` is an inline helper, so when it is called with fixed
+``begin`` and ``end`` functions the compiler can inline both into the
+filesystem's ``iomap_iter_next_fn`` callback, keeping indirect calls out of the
+iteration hot path.  The two callbacks are described next.
 
-``->iomap_begin``
-~~~~~~~~~~~~~~~~~
+``begin``
+~~~~~~~~~
 
-iomap operations call ``->iomap_begin`` to obtain one file mapping for
-the range of bytes specified by ``pos`` and ``length`` for the file
-``inode``.
+The ``begin`` callback obtains one file mapping for the range of bytes
+specified by ``pos`` and ``length`` for the file ``inode``.
 This mapping should be returned through the ``iomap`` pointer.
 The mapping must cover at least the first byte of the supplied file
 range, but it does not need to cover the entire requested range.
@@ -377,18 +447,18 @@ information via ``srcmap``.
 Only pagecache and fsdax operations support reading from one mapping and
 writing to another.
 
-``->iomap_end``
-~~~~~~~~~~~~~~~
+``end``
+~~~~~~~
 
-After the operation completes, the ``->iomap_end`` function, if present,
-is called to signal that iomap is finished with a mapping.
+After the operation completes, the ``end`` callback, if present, is called to
+signal that iomap is finished with a mapping.
 Typically, implementations will use this function to tear down any
-context that were set up in ``->iomap_begin``.
+context that was set up in ``begin``.
 For example, a write might wish to commit the reservations for the bytes
 that were operated upon and unreserve any space that was not operated
 upon.
 ``written`` might be zero if no bytes were touched.
-``flags`` will contain the same value passed to ``->iomap_begin``.
+``flags`` will contain the same value passed to ``begin``.
 iomap ops for reads are not likely to need to supply this function.
 
 Both functions should return a negative errno code on error, or zero on
@@ -421,8 +491,8 @@ iomap is concerned:
    accessing the folio until writeback is underway.
 
    * The **lower** level primitive is taken by the filesystem in the
-     ``->iomap_begin`` and ``->iomap_end`` functions to coordinate
-     access to the file space mapping information.
+     ``begin`` and ``end`` functions to coordinate access to the file space
+     mapping information.
      The fields of the iomap object should be filled out while holding
      this primitive.
      The upper level synchronization primitive, if any, remains held
diff --git a/Documentation/filesystems/iomap/operations.rst b/Documentation/filesystems/iomap/operations.rst
index da982ca7e413..a5784dee0850 100644
--- a/Documentation/filesystems/iomap/operations.rst
+++ b/Documentation/filesystems/iomap/operations.rst
@@ -17,6 +17,12 @@ Supported File Operations
 Below are a discussion of the high level file operations that iomap
 implements.
 
+Each operation takes an ``iomap_iter_next_fn`` callback that supplies the file
+mappings, as described in the iomap design document.  The per-operation
+``flags`` documented below are passed to that callback; references to
+``begin`` and ``end`` name the two steps a typical callback is built from
+via ``iomap_iter_next``.
+
 Buffered I/O
 ============
 
@@ -90,10 +96,10 @@ iomap calls these functions:
     <https://lore.kernel.org/all/20180619164137.13720-6-hch@lst.de/>`_
     that was set up by ``->get_folio``.
 
-  - ``iomap_valid``: The filesystem may not hold locks between
-    ``->iomap_begin`` and ``->iomap_end`` because pagecache operations
-    can take folio locks, fault on userspace pages, initiate writeback
-    for memory reclamation, or engage in other time-consuming actions.
+  - ``iomap_valid``: The filesystem may not hold locks between ``begin`` and
+    ``end`` because pagecache operations can take folio locks, fault on
+    userspace pages, initiate writeback for memory reclamation, or engage in
+    other time-consuming actions.
     If a file's space mapping data are mutable, it is possible that the
     mapping for a particular pagecache folio can `change in the time it
     takes
@@ -114,12 +120,12 @@ iomap calls these functions:
     If the mapping is not valid, the mapping will be sampled again.
 
     To support making the validity decision, the filesystem's
-    ``->iomap_begin`` function may set ``struct iomap::validity_cookie``
+    ``begin`` function may set ``struct iomap::validity_cookie``
     at the same time that it populates the other iomap fields.
     A simple validation cookie implementation is a sequence counter.
     If the filesystem bumps the sequence counter every time it modifies
     the inode's extent map, it can be placed in the ``struct
-    iomap::validity_cookie`` during ``->iomap_begin``.
+    iomap::validity_cookie`` during ``begin``.
     If the value in the cookie is found to be different to the value
     the filesystem holds when the mapping is passed back to
     ``->iomap_valid``, then the iomap should considered stale and the
@@ -199,7 +205,7 @@ Buffered Readahead and Reads
 The ``iomap_readahead`` function initiates readahead to the pagecache.
 The ``iomap_read_folio`` function reads one folio's worth of data into
 the pagecache.
-The ``flags`` argument to ``->iomap_begin`` will be set to zero.
+The ``flags`` argument to ``begin`` will be set to zero.
 The pagecache takes whatever locks it needs before calling the
 filesystem.
 
@@ -231,7 +237,7 @@ Buffered Writes
 The ``iomap_file_buffered_write`` function writes an ``iocb`` to the
 pagecache.
 ``IOMAP_WRITE`` or ``IOMAP_WRITE`` | ``IOMAP_NOWAIT`` will be passed as
-the ``flags`` argument to ``->iomap_begin``.
+the ``flags`` argument to ``begin``.
 Callers commonly take ``i_rwsem`` in either shared or exclusive mode
 before calling this function.
 
@@ -241,7 +247,7 @@ mmap Write Faults
 The ``iomap_page_mkwrite`` function handles a write fault to a folio in
 the pagecache.
 ``IOMAP_WRITE | IOMAP_FAULT`` will be passed as the ``flags`` argument
-to ``->iomap_begin``.
+to ``begin``.
 Callers commonly take the mmap ``invalidate_lock`` in shared or
 exclusive mode before calling this function.
 
@@ -256,7 +262,7 @@ such `reservations
 <https://lore.kernel.org/linux-xfs/20220817093627.GZ3600936@dread.disaster.area/>`_
 because writeback will not consume the reservation.
 The ``iomap_write_delalloc_release`` can be called from a
-``->iomap_end`` function to find all the clean areas of the folios
+``end`` function to find all the clean areas of the folios
 caching a fresh (``IOMAP_F_NEW``) delalloc mapping.
 It takes the ``invalidate_lock``.
 
@@ -274,7 +280,7 @@ Filesystems can call ``iomap_zero_range`` to perform zeroing of the
 pagecache for non-truncation file operations that are not aligned to
 the fsblock size.
 ``IOMAP_ZERO`` will be passed as the ``flags`` argument to
-``->iomap_begin``.
+``begin``.
 Callers typically hold ``i_rwsem`` and ``invalidate_lock`` in exclusive
 mode before calling this function.
 
@@ -285,7 +291,7 @@ Filesystems can call ``iomap_file_unshare`` to force a file sharing
 storage with another file to preemptively copy the shared data to newly
 allocate storage.
 ``IOMAP_WRITE | IOMAP_UNSHARE`` will be passed as the ``flags`` argument
-to ``->iomap_begin``.
+to ``begin``.
 Callers typically hold ``i_rwsem`` and ``invalidate_lock`` in exclusive
 mode before calling this function.
 
@@ -298,7 +304,7 @@ operation.
 ``truncate_setsize`` or ``truncate_pagecache`` will take care of
 everything after the EOF block.
 ``IOMAP_ZERO`` will be passed as the ``flags`` argument to
-``->iomap_begin``.
+``begin``.
 Callers typically hold ``i_rwsem`` and ``invalidate_lock`` in exclusive
 mode before calling this function.
 
@@ -341,8 +347,8 @@ The fields are as follows:
     though it will `reuse mappings
     <https://lore.kernel.org/all/20231207072710.176093-15-hch@lst.de/>`_
     for runs of contiguous dirty fsblocks within a folio.
-    Do not return ``IOMAP_INLINE`` mappings here; the ``->iomap_end``
-    function must deal with persisting written data.
+    Do not return ``IOMAP_INLINE`` mappings here; the ``end`` function must
+    deal with persisting written data.
     Do not return ``IOMAP_DELALLOC`` mappings here; iomap currently
     requires mapping to allocated space.
     Filesystems can skip a potentially expensive mapping lookup if the
@@ -428,7 +434,7 @@ writes for files.
 .. code-block:: c
 
  ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
-                      const struct iomap_ops *ops,
+                      iomap_iter_next_fn iomap_next,
                       const struct iomap_dio_ops *dops,
                       unsigned int dio_flags, void *private,
                       size_t done_before);
@@ -511,7 +517,7 @@ Return Values
  * ``-ENOTBLK``: Fall back to buffered I/O.
    iomap itself will return this value if it cannot invalidate the page
    cache before issuing the I/O to storage.
-   The ``->iomap_begin`` or ``->iomap_end`` functions may also return
+   The ``begin`` or ``end`` functions may also return
    this value.
 
  * ``-EIOCBQUEUED``: The asynchronous direct I/O request has been
@@ -526,7 +532,7 @@ A direct I/O read initiates a read I/O from the storage device to the
 caller's buffer.
 Dirty parts of the pagecache are flushed to storage before initiating
 the read io.
-The ``flags`` value for ``->iomap_begin`` will be ``IOMAP_DIRECT`` with
+The ``flags`` value for ``begin`` will be ``IOMAP_DIRECT`` with
 any combination of the following enhancements:
 
  * ``IOMAP_NOWAIT``, as defined previously.
@@ -542,7 +548,7 @@ caller's buffer.
 Dirty parts of the pagecache are flushed to storage before initiating
 the write io.
 The pagecache is invalidated both before and after the write io.
-The ``flags`` value for ``->iomap_begin`` will be ``IOMAP_DIRECT |
+The ``flags`` value for ``begin`` will be ``IOMAP_DIRECT |
 IOMAP_WRITE`` with any combination of the following enhancements:
 
  * ``IOMAP_NOWAIT``, as defined previously.
@@ -644,7 +650,7 @@ fsdax Reads
 
 A fsdax read performs a memcpy from storage device to the caller's
 buffer.
-The ``flags`` value for ``->iomap_begin`` will be ``IOMAP_DAX`` with any
+The ``flags`` value for ``begin`` will be ``IOMAP_DAX`` with any
 combination of the following enhancements:
 
  * ``IOMAP_NOWAIT``, as defined previously.
@@ -657,7 +663,7 @@ fsdax Writes
 
 A fsdax write initiates a memcpy to the storage device from the caller's
 buffer.
-The ``flags`` value for ``->iomap_begin`` will be ``IOMAP_DAX |
+The ``flags`` value for ``begin`` will be ``IOMAP_DAX |
 IOMAP_WRITE`` with any combination of the following enhancements:
 
  * ``IOMAP_NOWAIT``, as defined previously.
@@ -680,9 +686,9 @@ fsdax mmap Faults
 The ``dax_iomap_fault`` function handles read and write faults to fsdax
 storage.
 For a read fault, ``IOMAP_DAX | IOMAP_FAULT`` will be passed as the
-``flags`` argument to ``->iomap_begin``.
+``flags`` argument to ``begin``.
 For a write fault, ``IOMAP_DAX | IOMAP_FAULT | IOMAP_WRITE`` will be
-passed as the ``flags`` argument to ``->iomap_begin``.
+passed as the ``flags`` argument to ``begin``.
 
 Callers commonly hold the same locks as they do to call their iomap
 pagecache counterparts.
@@ -692,8 +698,8 @@ fsdax Truncation, fallocate, and Unsharing
 
 For fsdax files, the following functions are provided to replace their
 iomap pagecache I/O counterparts.
-The ``flags`` argument to ``->iomap_begin`` are the same as the
-pagecache counterparts, with ``IOMAP_DAX`` added.
+The ``flags`` argument to ``begin`` are the same as the pagecache counterparts,
+with ``IOMAP_DAX`` added.
 
  * ``dax_file_unshare``
  * ``dax_zero_range``
@@ -719,8 +725,7 @@ SEEK_DATA
 
 The ``iomap_seek_data`` function implements the SEEK_DATA "whence" value
 for llseek.
-``IOMAP_REPORT`` will be passed as the ``flags`` argument to
-``->iomap_begin``.
+``IOMAP_REPORT`` will be passed as the ``flags`` argument to ``begin``.
 
 For unwritten mappings, the pagecache will be searched.
 Regions of the pagecache with a folio mapped and uptodate fsblocks
@@ -734,8 +739,7 @@ SEEK_HOLE
 
 The ``iomap_seek_hole`` function implements the SEEK_HOLE "whence" value
 for llseek.
-``IOMAP_REPORT`` will be passed as the ``flags`` argument to
-``->iomap_begin``.
+``IOMAP_REPORT`` will be passed as the ``flags`` argument to ``begin``.
 
 For unwritten mappings, the pagecache will be searched.
 Regions of the pagecache with no folio mapped, or a !uptodate fsblock
@@ -750,8 +754,7 @@ Swap File Activation
 The ``iomap_swapfile_activate`` function finds all the base-page aligned
 regions in a file and sets them up as swap space.
 The file will be ``fsync()``'d before activation.
-``IOMAP_REPORT`` will be passed as the ``flags`` argument to
-``->iomap_begin``.
+``IOMAP_REPORT`` will be passed as the ``flags`` argument to ``begin``.
 All mappings must be mapped or unwritten; cannot be dirty or shared, and
 cannot span multiple block devices.
 Callers must hold ``i_rwsem`` in exclusive mode; this is already
@@ -767,8 +770,7 @@ FS_IOC_FIEMAP
 
 The ``iomap_fiemap`` function exports file extent mappings to userspace
 in the format specified by the ``FS_IOC_FIEMAP`` ioctl.
-``IOMAP_REPORT`` will be passed as the ``flags`` argument to
-``->iomap_begin``.
+``IOMAP_REPORT`` will be passed as the ``flags`` argument to ``begin``.
 Callers commonly hold ``i_rwsem`` in shared mode before calling this
 function.
 
diff --git a/Documentation/filesystems/iomap/porting.rst b/Documentation/filesystems/iomap/porting.rst
index 3d49a32c0fff..b995f426808a 100644
--- a/Documentation/filesystems/iomap/porting.rst
+++ b/Documentation/filesystems/iomap/porting.rst
@@ -50,8 +50,14 @@ Build the kernel, run fstests with the ``-g all`` option across a wide
 variety of your filesystem's supported configurations to build a
 baseline of which tests pass and which ones fail.
 
-The recommended approach is first to implement ``->iomap_begin`` (and
-``->iomap_end`` if necessary) to allow iomap to obtain a read-only
+Every iomap operation is driven by an ``iomap_iter_next_fn`` callback.
+Filesystems normally do not write one by hand: implement ``begin``
+(and ``end`` if necessary) and generate the callback with the
+``DEFINE_IOMAP_ITER_NEXT()`` macro, or ``DEFINE_IOMAP_ITER_NEXT_END()`` if an
+``end`` callback is needed.
+
+The recommended approach is first to implement ``begin`` (and
+``end`` if necessary) to allow iomap to obtain a read-only
 mapping of a file range.
 In most cases, this is a relatively trivial conversion of the existing
 ``get_block()`` function for read-only mappings.
@@ -62,7 +68,7 @@ If FIEMAP is returning the correct information, it's a good sign that
 other read-only mapping operations will do the right thing.
 
 Next, modify the filesystem's ``get_block(create = false)``
-implementation to use the new ``->iomap_begin`` implementation to map
+implementation to use the new ``begin`` implementation to map
 file space for selected read operations.
 Hide behind a debugging knob the ability to switch on the iomap mapping
 functions for selected call paths.
@@ -82,14 +88,14 @@ I/O path because of bufferheads.
 The buffered read I/O paths doesn't need to be converted yet, though the
 direct I/O read path should be converted in this phase.
 
-At this point, you should look over your ``->iomap_begin`` function.
+At this point, you should look over your ``begin`` function.
 If it switches between large blocks of code based on dispatching of the
 ``flags`` argument, you should consider breaking it up into
 per-operation iomap ops with smaller, more cohesive functions.
 XFS is a good example of this.
 
 The next thing to do is implement ``get_blocks(create == true)``
-functionality in the ``->iomap_begin``/``->iomap_end`` methods.
+functionality in the ``begin``/``end`` methods.
 It is strongly recommended to create separate mapping functions and
 iomap ops for write operations.
 Then convert the direct I/O write path to iomap, and start running fsx
-- 
2.52.0

