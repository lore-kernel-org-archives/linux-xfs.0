Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3627E0FF
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864779; cv=none; b=KqdqifqsFaIuuyYRTjCUv/d3uSqw2JX7AvjbWG7hMW5alZokZ6/KMc0AHmS731f7ipOBS1GydQmkCdm/yzZb3zgD6DAzP9IUCnLe7ZVAM90gKYv2do2qlY4+fkLgLJIUuJpGZoz4twejykD/DYa6wTByIN2TaW1+CFLh2hYrHaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864779; c=relaxed/simple;
	bh=63/0Kv5r8FqxWX6JXFUnTZDvXltWb0upCWtTNSS9/RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MH+K1oo9bnl9zHL7rnhHOd7YaOLdXdLWUGO9XFsk6Q/w8U7xiB/uMU7zEHTNj5FCex4gZtjQ+YpaSfPwLH/Irxm1wn2h4D0g9hDXxB/quxcw5oOwfJwbBAlBy+K5RiCwC1IXaO5qqaZAqhZ5ldHRDyUIh4/Sm5fZMNUmCHQ6/8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QHxkOVrJ; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHxkOVrJ"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e94c26f9e0so30927a34.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864774; x=1783469574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWmAPbfTuazNorMoktd5H5ZeMCXNf+S5zVplhcnmwgM=;
        b=QHxkOVrJFlhKt3g26cWu8itQ9MMNZfJF3XJs1gypNLf7w2WQepuyhTJo4OTwspXsxk
         EIaW18CAb8QaEK6zZvmcSZiCGkcFDzLyZCb4c2Cxfr4AqcyjVucpMPFl0YRbSZdM/7PN
         5/Oykhn6rstuvtTWaiAAWI8Qs0oR9tl/j0Q789JdgntwQSKPRLNPV/TsAs9YBknJ1T2K
         CikkIYHtJMCYc+rC1Hru5pQZtfDUxkzGjT/8MtP8lL597qGwqCkQX8qsAsL2/PwzC6Ex
         eTwmhfkiMcxO11UNm7zYtLFoIAjHyAxnrTge3lkv3Ks+zacAspP5e6K7kz5XgdRBWHWK
         +jAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864774; x=1783469574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oWmAPbfTuazNorMoktd5H5ZeMCXNf+S5zVplhcnmwgM=;
        b=LZ5B4/W68UviIzXMBv0R7p6zMoNF4fCJ7/zBTqBLqQbWgRHb1awmUOTH9myyatV7yG
         TFEmZhuxMPmIVWl6Lc1vVHnViOmQk0PUxgQYSdgQWTvnhJaHPkvRZnPsjucrX4BM8yjf
         zu3hobSoe/Pd79IfFm2UiISmQ8xQpotdxEb+cRD/gdsA80Bzp6hKTZt3BsXuZepy/vFY
         b37k8RTRSpk7OPRvIUeR73itALznsM+4UvG4HkNZ72zNfdl4sY5LKr+bHhnSk422t9gF
         0KBkm4GZSH19Sf8HsChTxgrlAncqO4Mx6TszieArSIhyrjrnWZxBB6eb9lhP3Ay4Lw62
         klsg==
X-Forwarded-Encrypted: i=1; AFNElJ9HweTsSWotli2KEqzEMUNHKXlJa4w0ZhpU74kidk3y9qcQS1J15c4tS/a7ZHDGtCyPpDoKmflmIMY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWJDZ3xxoP8pOmDQLtwhykb2MWpBghbFMJ92YEUqscSQDoxNLE
	eiAAYflqTH3A8BYnVdqxjH0nEfsTojYoJuaJYstIDfQge8/yg15BHE1W2LEeVw==
X-Gm-Gg: AfdE7clEiLBOWpiMdsVPOvwoYBhLqhW2wI9Q7Zx0tSyEfcDur34HCmGMpIIeMA3zbId
	kgTIBXVfEmpoRxPQZVKuynPpR2TiQN05Kbeus7wU9PT0uz8noA1M7lwckPQP8RWxhPawbBTQhZA
	e6oMc1mKaBTTgO+GeWb7t2mQsN0Sanzc93dNTugt4k8bSY1EpL8EEvu6TONcCo5pIu/2Mx5KJ+e
	8ct0ArWm62qvXdzDEG6TNZi2Hlyk7R9Sf+7/mBoJubtfBcOB5k9afTzO58LiOOyEGxd6Qu9pdmG
	jbBW4s1qQyd5WmJAmqelppz0gkWR6f+PcV6MU9siP531Wuvvan+CDgJKHjeq2uHRnGVhL7DDtxc
	MRLM4vxoMFLHDy2Op7APBREkkbfGjwx1dd/VZl4SLpMkV8N5KjHIhGc1symVNhAQoTCgzJAYVdo
	xx1VRjQHQxvuZ0/agCRsE85+WJQ0tMgW2W2Q6AtndnAnmv/nXTRqqOdNhKrfMRn7Az
X-Received: by 2002:a05:6830:3c84:b0:7e7:8dc0:3951 with SMTP id 46e09a7af769-7e9ec5c9bb1mr4437550a34.8.1782864773921;
        Tue, 30 Jun 2026 17:12:53 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:41::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9ec2e200asm3513301a34.19.2026.06.30.17.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:12:53 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 18/18] Documentation: iomap: update docs to reflect iomap_next model
Date: Tue, 30 Jun 2026 17:09:33 -0700
Message-ID: <20260701000949.1666714-19-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Filesystems no longer pass a struct iomap_ops with separate
->iomap_begin() and ->iomap_end() callbacks.  Instead, every iomap
operation takes a single iomap_next() callback directly. iomap_next()
finishes the previous mapping (if any) and produces the next one. Most
filesystems build it from begin and end helpers via the iomap_process()
helper.

Update the iomap documentation to match this change.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 Documentation/filesystems/iomap/design.rst    | 115 +++++++++++++-----
 .../filesystems/iomap/operations.rst          |  60 +++++----
 Documentation/filesystems/iomap/porting.rst   |  22 +++-
 3 files changed, 132 insertions(+), 65 deletions(-)

diff --git a/Documentation/filesystems/iomap/design.rst b/Documentation/filesystems/iomap/design.rst
index 0f7672676c0b..7a37e303eea8 100644
--- a/Documentation/filesystems/iomap/design.rst
+++ b/Documentation/filesystems/iomap/design.rst
@@ -75,7 +75,10 @@ At a high level, an iomap operation `looks like this
 
 1. For each byte in the operation range...
 
-   1. Obtain a space mapping via ``->iomap_begin``
+   1. Obtain the next space mapping via the ``iomap_next`` callback.
+      From the second iteration onwards this same callback first finishes
+      the previous mapping (committing or unreserving space as needed)
+      and then produces the next one.
 
    2. For each sub-unit of work...
 
@@ -86,7 +89,13 @@ At a high level, an iomap operation `looks like this
 
    3. Increment operation cursor
 
-   4. Release the mapping via ``->iomap_end``, if necessary
+iomap repeats this until the range is fully consumed.  The ``iomap_next``
+callback returns ``1`` while there is more of the range left to process,
+``0`` once it is fully consumed, and a negative errno on error.
+Filesystems rarely implement ``->iomap_next`` by hand. The ``iomap_process``
+helper implements the finish-then-produce sequence in +terms of two smaller
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
@@ -208,12 +217,12 @@ The fields are as follows:
 
    * **IOMAP_INLINE**: The file range maps to the memory buffer
      specified by ``inline_data``.
-     For write operation, the ``->iomap_end`` function presumably
-     handles persisting the data.
+     For write operation, the ``end`` function presumably handles
+     persisting the data.
      The ``addr`` field must be set to ``IOMAP_NULL_ADDR``.
 
  * ``flags`` describe the status of the space mapping.
-   These flags should be set by the filesystem in ``->iomap_begin``:
+   These flags should be set by the filesystem in ``begin``:
 
    * **IOMAP_F_NEW**: The space under the mapping is newly allocated.
      Areas that will not be written to must be zeroed.
@@ -262,15 +271,15 @@ The fields are as follows:
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
+     iomap will call ``end`` on this mapping and then
+     ``begin`` to obtain a new mapping.
 
    Currently, these flags are only set by pagecache operations.
 
@@ -289,41 +298,80 @@ The fields are as follows:
 
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
+Every iomap operation takes an ``iomap_next_fn`` callback from the
+filesystem. iomap calls it once per iteration of the file range:
 
 .. code-block:: c
 
- struct iomap_ops {
-     int (*iomap_begin)(struct inode *inode, loff_t pos, loff_t length,
-                        unsigned flags, struct iomap *iomap,
-                        struct iomap *srcmap);
+ typedef int (*iomap_next_fn)(const struct iomap_iter *iter,
+                              struct iomap *iomap, struct iomap *srcmap);
 
-     int (*iomap_end)(struct inode *inode, loff_t pos, loff_t length,
-                      ssize_t written, unsigned flags,
-                      struct iomap *iomap);
- };
+``->iomap_next``
+~~~~~~~~~~~~~~~~
+
+Each call must finish the previous mapping, if any, and then produce the
+next mapping for the current iteration position described by ``iter``.
+The mapping is returned through ``iomap`` (and through ``srcmap`` for
+operations that read from one mapping while writing to another; see
+``begin`` below).
 
-``->iomap_begin``
+The callback returns ``1`` to continue iterating, ``0`` once the file
+range has been fully consumed, and a negative errno on error.
+
+``iomap_process``
 ~~~~~~~~~~~~~~~~~
 
-iomap operations call ``->iomap_begin`` to obtain one file mapping for
-the range of bytes specified by ``pos`` and ``length`` for the file
-``inode``.
+Filesystems rarely need a hand-written ``iomap_next`` callback.  The
+``iomap_process`` helper implements the finish-then-produce sequence in
+terms of two smaller callbacks, ``begin`` and ``end``, so most
+``->iomap_next`` implementations are simply:
+
+.. code-block:: c
+
+ static int my_iomap_next(const struct iomap_iter *iter,
+                          struct iomap *iomap, struct iomap *srcmap)
+ {
+         return iomap_process(iter, iomap, srcmap,
+                              my_iomap_begin, my_iomap_end);
+ }
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
+``iomap_process`` is an inline helper, so when it is called with fixed
+``begin`` and ``end`` functions the compiler can inline both into the
+filesystem's ``->iomap_next``, keeping indirect calls out of the
+iteration hot path.  The two callbacks are described next.
+
+``begin``
+~~~~~~~~~
+
+The ``begin`` callback obtains one file mapping for the range of bytes
+specified by ``pos`` and ``length`` for the file ``inode``.
 This mapping should be returned through the ``iomap`` pointer.
 The mapping must cover at least the first byte of the supplied file
 range, but it does not need to cover the entire requested range.
@@ -377,18 +425,19 @@ information via ``srcmap``.
 Only pagecache and fsdax operations support reading from one mapping and
 writing to another.
 
-``->iomap_end``
-~~~~~~~~~~~~~~~
+``end``
+~~~~~~~
 
-After the operation completes, the ``->iomap_end`` function, if present,
-is called to signal that iomap is finished with a mapping.
+The ``end`` callback, if present, is called when iomap is
+finished with a mapping: before each subsequent mapping is produced, and
+once more after the final mapping when the operation completes.
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
@@ -421,7 +470,7 @@ iomap is concerned:
    accessing the folio until writeback is underway.
 
    * The **lower** level primitive is taken by the filesystem in the
-     ``->iomap_begin`` and ``->iomap_end`` functions to coordinate
+     ``begin`` and ``end`` functions to coordinate
      access to the file space mapping information.
      The fields of the iomap object should be filled out while holding
      this primitive.
diff --git a/Documentation/filesystems/iomap/operations.rst b/Documentation/filesystems/iomap/operations.rst
index da982ca7e413..e065398dad95 100644
--- a/Documentation/filesystems/iomap/operations.rst
+++ b/Documentation/filesystems/iomap/operations.rst
@@ -17,6 +17,12 @@ Supported File Operations
 Below are a discussion of the high level file operations that iomap
 implements.
 
+Each operation takes an ``iomap_next_fn`` callback that supplies the file
+mappings, as described in the iomap design document.  The per-operation
+``flags`` documented below are passed to that callback; references to
+``begin`` and ``end`` name the two steps a typical callback is built from
+via ``iomap_process``.
+
 Buffered I/O
 ============
 
@@ -91,9 +97,9 @@ iomap calls these functions:
     that was set up by ``->get_folio``.
 
   - ``iomap_valid``: The filesystem may not hold locks between
-    ``->iomap_begin`` and ``->iomap_end`` because pagecache operations
-    can take folio locks, fault on userspace pages, initiate writeback
-    for memory reclamation, or engage in other time-consuming actions.
+    ``begin`` and ``end`` because pagecache operations can take folio locks,
+    fault on userspace pages, initiate writeback for memory reclamation, or
+    engage in other time-consuming actions.
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
+                      iomap_next_fn iomap_next,
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
@@ -692,7 +698,7 @@ fsdax Truncation, fallocate, and Unsharing
 
 For fsdax files, the following functions are provided to replace their
 iomap pagecache I/O counterparts.
-The ``flags`` argument to ``->iomap_begin`` are the same as the
+The ``flags`` argument to ``begin`` are the same as the
 pagecache counterparts, with ``IOMAP_DAX`` added.
 
  * ``dax_file_unshare``
@@ -720,7 +726,7 @@ SEEK_DATA
 The ``iomap_seek_data`` function implements the SEEK_DATA "whence" value
 for llseek.
 ``IOMAP_REPORT`` will be passed as the ``flags`` argument to
-``->iomap_begin``.
+``begin``.
 
 For unwritten mappings, the pagecache will be searched.
 Regions of the pagecache with a folio mapped and uptodate fsblocks
@@ -735,7 +741,7 @@ SEEK_HOLE
 The ``iomap_seek_hole`` function implements the SEEK_HOLE "whence" value
 for llseek.
 ``IOMAP_REPORT`` will be passed as the ``flags`` argument to
-``->iomap_begin``.
+``begin``.
 
 For unwritten mappings, the pagecache will be searched.
 Regions of the pagecache with no folio mapped, or a !uptodate fsblock
@@ -751,7 +757,7 @@ The ``iomap_swapfile_activate`` function finds all the base-page aligned
 regions in a file and sets them up as swap space.
 The file will be ``fsync()``'d before activation.
 ``IOMAP_REPORT`` will be passed as the ``flags`` argument to
-``->iomap_begin``.
+``begin``.
 All mappings must be mapped or unwritten; cannot be dirty or shared, and
 cannot span multiple block devices.
 Callers must hold ``i_rwsem`` in exclusive mode; this is already
@@ -768,7 +774,7 @@ FS_IOC_FIEMAP
 The ``iomap_fiemap`` function exports file extent mappings to userspace
 in the format specified by the ``FS_IOC_FIEMAP`` ioctl.
 ``IOMAP_REPORT`` will be passed as the ``flags`` argument to
-``->iomap_begin``.
+``begin``.
 Callers commonly hold ``i_rwsem`` in shared mode before calling this
 function.
 
diff --git a/Documentation/filesystems/iomap/porting.rst b/Documentation/filesystems/iomap/porting.rst
index 3d49a32c0fff..3591b5f28021 100644
--- a/Documentation/filesystems/iomap/porting.rst
+++ b/Documentation/filesystems/iomap/porting.rst
@@ -50,8 +50,20 @@ Build the kernel, run fstests with the ``-g all`` option across a wide
 variety of your filesystem's supported configurations to build a
 baseline of which tests pass and which ones fail.
 
-The recommended approach is first to implement ``->iomap_begin`` (and
-``->iomap_end`` if necessary) to allow iomap to obtain a read-only
+Every iomap operation is driven by an ``iomap_next`` callback.
+Filesystems normally do not write one by hand: implement ``begin``
+(and ``end`` if necessary) and wire them up through
+``iomap_process``::
+
+ static int my_iomap_next(const struct iomap_iter *iter,
+                          struct iomap *iomap, struct iomap *srcmap)
+ {
+         return iomap_process(iter, iomap, srcmap,
+                              my_iomap_begin, my_iomap_end);
+ }
+
+The recommended approach is first to implement ``begin`` (and
+``end`` if necessary) to allow iomap to obtain a read-only
 mapping of a file range.
 In most cases, this is a relatively trivial conversion of the existing
 ``get_block()`` function for read-only mappings.
@@ -62,7 +74,7 @@ If FIEMAP is returning the correct information, it's a good sign that
 other read-only mapping operations will do the right thing.
 
 Next, modify the filesystem's ``get_block(create = false)``
-implementation to use the new ``->iomap_begin`` implementation to map
+implementation to use the new ``begin`` implementation to map
 file space for selected read operations.
 Hide behind a debugging knob the ability to switch on the iomap mapping
 functions for selected call paths.
@@ -82,14 +94,14 @@ I/O path because of bufferheads.
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

