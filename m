Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB182564
	for <linux-xfs@vger.kernel.org>; Sun, 21 Jul 2024 23:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721602868; cv=none; b=YY6oJfhYIOF1XzNXstGAoG9a/o7XXJCrzBVxfhWnx0ZraTOeHpFpAzwCe7t2SE8B/2DpRLMY4tS+pp7NR/M7L1tp92f71hl1LT8VvqZE0ppg8liCmiLCqfc8zSLyOtocV556XuALDYslk9HfgbV9Qd+ApCdDbIwtLVEBDyJ3jyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721602868; c=relaxed/simple;
	bh=Bl5pKCjF/oLxuSqAffjHiKO80GR6RBG3mHD1LkYDCow=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PbrA9uIh2mVODu3R6JzS7mGzdabg7vA4YuWSrTfdruIMreNRVxdaJ4FyBhfymFR8dXfGMxDDfdEXUGwR+RfOa6A2oCoSPNor9wV4E9BTXOR1tAa67s72botWPyQTOBmAxKrm5MLpl5c+CPNX5AJOqBBpwPxGVIXTJftWc4d6MFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=unI8UFIj; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="unI8UFIj"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2c964f5a037so1915511a91.0
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jul 2024 16:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721602865; x=1722207665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=lFUv89JntwQ5zikIDpkGa9HgAplOOsgodroqiK5ghZ8=;
        b=unI8UFIjT2IBiMtxlz4lTYOletCU1oQRpJC7lBTJgssN9G+Tz3FuRYnzhd3NK5IUIw
         EUSDrDkKUzCmn2xJsqnqGH74z4v9JOnm20kt8hWuLV2HwXojzMwJLABSCqkfOTWHNIEb
         MogAKU9UAZ8q+eTwXgfE5FbmLhuXC+5jQDhvtj+T6HhjDRi7WorubeQZSbUCG3n+xFmE
         gL/ElAC6C4gIZVLO4Bp+Towzs1DC4/VeqtSNoHZ2Cn1EwF/+QljcAEN6XNsoAbmyiFu+
         bOEClo0LY8dUnaqcARIaaMqvwYr9XQVrH5LAxPEIP6QpPjIT1n5BWN+zSmDprE3HNcFd
         0YYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721602865; x=1722207665;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lFUv89JntwQ5zikIDpkGa9HgAplOOsgodroqiK5ghZ8=;
        b=qcLvOqzHWn174F2Qfp2NF+Ff7w/bozHNomrbtBLb/3/g35YfuDIDXa5FOzFq9LecVI
         lhhKfXckoFfu7UhvsihZ4uHMW8QGrJi3EmpshCIRNLa0EmwuR3mdgIC/d7rYm1s4fcbM
         tSzaz66k19h7UCi5JuZbXV7744yQglr4q0BCrvJ7woBUAKmDjKY5uKv8zlHzPbhclFCE
         R1dJ6l7pHk/vTeB053tC9YPki2n1wpI29AAu4fk5RpTc1VE4YtWd0bkqBMpeVy9yY+gb
         QMPzeW0sXRKxj+WjtEGFkKHkb9rF+jQpX9mC1nWs+EMbkBWVtyPI7Ml6OEKU1KhBrxsI
         GxJw==
X-Gm-Message-State: AOJu0YwG40UVh63NrB8oZECd7FBjX02K+/0AJi97AowqdnbuLCSp4rqw
	PmmAE9R5BKuzWmgi9n7uSnydAWtcLUaoQZRPgsS5dcv24rcFvWL0onnEbsVK2Ex9GRJq6yJz9Gu
	O
X-Google-Smtp-Source: AGHT+IEi1PWaCV5Bza3RF0uq3qFIOGb2xD0SLY1mbyPLSdNKjpv0hPygrD7InLFOo1mpyR4B5I2meQ==
X-Received: by 2002:a05:6a20:7a30:b0:1c2:8b95:de15 with SMTP id adf61e73a8af0-1c4229b24b9mr3249341637.53.1721602864547;
        Sun, 21 Jul 2024 16:01:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-16-122.pa.nsw.optusnet.com.au. [49.195.16.122])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb77504fa2sm6698179a91.46.2024.07.21.16.01.03
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 16:01:03 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1sVfY4-006fQe-2w
	for linux-xfs@vger.kernel.org;
	Mon, 22 Jul 2024 09:01:00 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1sVfY4-0000000HS88-1Ye2
	for linux-xfs@vger.kernel.org;
	Mon, 22 Jul 2024 09:01:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH] [RFC] xfs: filesystem expansion design documentation
Date: Mon, 22 Jul 2024 09:01:00 +1000
Message-ID: <20240721230100.4159699-1-david@fromorbit.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

xfs-expand is an attempt to address the container/vm orchestration
image issue where really small XFS filesystems are grown to massive
sizes via xfs_growfs and end up with really insane, suboptimal
geometries.

Rather that grow a filesystem by appending AGs, expanding a
filesystem is based on allowing existing AGs to be expanded to
maximum sizes first. If further growth is needed, then the
traditional "append more AGs" growfs mechanism is triggered.

This document describes the structure of an XFS filesystem needed to
achieve this expansion, as well as the design of userspace tools
needed to make the mechanism work.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Documentation/filesystems/xfs/index.rst       |   1 +
 .../filesystems/xfs/xfs-expand-design.rst     | 312 ++++++++++++++++++
 2 files changed, 313 insertions(+)
 create mode 100644 Documentation/filesystems/xfs/xfs-expand-design.rst

diff --git a/Documentation/filesystems/xfs/index.rst b/Documentation/filesystems/xfs/index.rst
index ab66c57a5d18..cb570fc886b2 100644
--- a/Documentation/filesystems/xfs/index.rst
+++ b/Documentation/filesystems/xfs/index.rst
@@ -12,3 +12,4 @@ XFS Filesystem Documentation
    xfs-maintainer-entry-profile
    xfs-self-describing-metadata
    xfs-online-fsck-design
+   xfs-expand-design
diff --git a/Documentation/filesystems/xfs/xfs-expand-design.rst b/Documentation/filesystems/xfs/xfs-expand-design.rst
new file mode 100644
index 000000000000..fffc0b44518d
--- /dev/null
+++ b/Documentation/filesystems/xfs/xfs-expand-design.rst
@@ -0,0 +1,312 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================
+XFS Filesystem Expansion Design
+===============================
+
+Background
+==========
+
+XFS has long been able to grow the size of the filesystem dynamically whilst
+mounted. The functionality has been used extensively over the past 3 decades
+for managing filesystems on expandable storage arrays, but over the past decade
+there has been significant growth in filesystem image based orchestration
+frameworks that require expansion of the filesystem image during deployment.
+
+These frameworks want the initial image to be as small as possible to minimise
+the cost of deployment, but then want that image to scale to whatever size the
+deployment requires. This means that the base image can be as small as a few
+hundred megabytes and be expanded on deployment to tens of terabytes.
+
+Growing a filesystem by 4-5 orders of magnitude is a long way outside the scope
+of the original xfs_growfs design requirements. It was designed for users who
+were adding physical storage to already large storage arrays; a single order of
+magnitude in growth was considered a very large expansion.
+
+As a result, we have a situation where growing a filesystem works well up to a
+certain point, yet we have orchestration frameworks that allows users to expand
+filesystems a long way past this point without them being aware of the issues
+it will cause them further down the track.
+
+
+Scope
+=====
+
+The need to expand filesystems with a geometry optimised for small storage
+volumes onto much larger storage volumes results in a large filesystem with
+poorly optimised geometry. Growing a small XFS filesystem by several orders of
+magnitude results in filesystem with many small allocation groups (AGs). This is
+bad for allocation effciency, contiguous free space management, allocation
+performance as the filesystem fills, and so on. The filesystem will also end up
+with a very small journal for the size of the filesystem which can limit the
+metadata performance and concurrency in the filesystem drastically.
+
+These issues are a result of the filesystem growing algorithm. It is an
+append-only mechanism which takes advantage of the fact we can safely initialise
+the metadata for new AGs beyond the end of the existing filesystem without
+impacting runtime behaviour. Those newly initialised AGs can then be enabled
+atomically by running a single transaction to expose that newly initialised
+space to the running filesystem.
+
+As a result, the growing algorithm is a fast, transparent, simple and crash-safe
+algorithm that can be run while the filesystem is mounted. It's a very good
+algorithm for growing a filesystem on a block device that has has new physical
+storage appended to it's LBA space.
+
+However, this algorithm shows it's limitations when we move to system deployment
+via filesystem image distribution. These deployments optimise the base
+filesystem image for minimal size to minimise the time and cost of deploying
+them to the newly provisioned system (be it VM or container). They rely on the
+filesystem's ability to grow the filesystem to the size of the destination
+storage during the first system bringup when they tailor the deployed filesystem
+image for it's intented purpose and identity.
+
+If the deployed system has substantial storage provisioned, this means the
+filesystem image will be expanded by multiple orders of magnitude during the
+system initialisation phase, and this is where the existing append-based growing
+algorithm falls apart. This is the issue that this design seeks to resolve.
+
+
+XFS Internal Block Addressing
+=============================
+
+XFS has three different ways of addressing a storage block in the on-disk
+format. It can address storage blocks by:
+
+- DADDR addressing (xfs_daddr_t).
+  This is the linear LBA space of the underlying block device.
+
+- AGBNO addressing (xfs_agblock_t).
+  This is a linear address space starting at zero that indexes filesystem blocks
+  relative to the first block in an allocation group.
+
+- FSBNO addressing (xfs_fsblock_t).
+  This is a sparse encoding of (xfs_agnumber_t, xfs_agblock_t) that can address
+  any block in the entire filesystem.
+
+We are going to ignore the DADDR encoding for the moment as we first must
+understand how AGBNO and FSBNO addressing are related.
+
+The FSBNO encoding is a 64 bit number with the AG and AGBNO encoding within it
+being determined by fields in the superblock that are set at mkfs.xfs time and
+fixed for the life of the filesystem. The key point is that these fields
+determine the amount of FSBNO address space the AGBNO is encoded into::
+
+	FSBNO = (AG << sb_agblklog) | AGBNO
+
+This results in the FSBNO being a sparse encoding of the location of the block
+within the filesystem whenever the number of blocks in an AG is not an exact
+power of 2. The linear AGBNO address space for all the blocks in a single AG of
+size sb_agblocks looks like this::
+
+	0		      sb_agblocks	(1 << sb_agblklog)
+	+--------------------------+.................+
+
+If we have multiple AGs, the FSBNO address space looks like this::
+
+		    addressable space		unavailable
+	AG 0	+--------------------------+.................+
+	AG 1	+--------------------------+.................+
+	AG 2	+--------------------------+.................+
+	AG 3	+--------------------------+.................+
+
+Hence we have holes in the address FSBNO address space where there is no
+underlying physical LBA address space. The amount of unavailable space is
+determined by mkfs.xfs - it simply rounds the AG size up to the next highest
+power of 2. This power of 2 rounding means that encoding can be efficiently
+translated by the kernel with shifts and masks.
+
+This minimal expansion of the AGBNO address space also allows the number of AGs
+to be increased to scale the filesystem all the way out to the full 64 bit FSBNO
+address space, thereby allowing filesystems even with small AG sizes to be able
+to reach exabyte capacities.
+
+The reality of supporting millions of AGs, however, mean this simply isn't
+feasible. e.g. mkfs requires several million IOs to initialise all the AG
+headers, mount might have to read all those headers, etc.
+
+This is the fundamental problem with the existing filesystem growing mechanism
+when we start with very small AGs. Growing to thousands of AGs results in the
+FSBNO address space becoming so fragmented and requiring so many headers on disk
+to index it that the per-AG management algorithms do not work efficiently
+anymore.
+
+To solve this problem, we need is a way of preventing the FSBNO space from
+becoming excessively fragmented when we grow from small to very large. The
+solution, surprisingly, lies in the very fact that the FSBNO space is sparse,
+fragmented and fixed for the life of the filesystem.
+
+
+Exploiting Sparse FSBNO Addressing
+==================================
+
+The FSBNO address encoding is fixed at mkfs.xfs time because it is very
+difficult to change once the filesystem starts to index objects in FSBNO
+encoding. This is because the LBA address of the objects don't change, but
+the FSBNO encoding of that location changes.
+
+Hence changing sb_agblklog would require finding and re-encoding every
+FSBNO and inode number in the filesystem. While it is possible we could do
+this offline via xfs_repair, it would not be fast and there is no possibility
+it could be done transparently online. Changing inode numbers also has other
+downsides such as invalidating various long term backup strategies.
+
+However, there is a way we can change the AG size without needing to change
+sb_agblklog.  Earlier we showed how the FSBNO and AGBNO spaces are related, but
+now we need know how the FSBNO address space relates to the DADDR (block device
+LBA) address space.
+
+Recall the earlier diagram showing that that the FSBNO space is made up of
+available and unavailable AGBNO space across multiple AGs. Now lets lay out
+those 4 AGs and AGBNO space over the DADDR space. If "X" is the size of an AG
+in the DADDR space, we get something like this::
+
+	DADDR	0	X	2X	3X	4X
+	AG 0	+-------+...+
+	AG 1		+-------+...+
+	AG 1			+-------+...+
+	AG 1				+-------+...+
+
+
+The available AGBNO space in each AG is laid nose to tail over the DADDR space,
+whilst the unavailable AGBNO address space for each AG overlays the available
+AGBNO space of the next AG. For the last AG, the unavailable address space
+extends beyond the end of the filesystem and the available DADDR address space.
+
+Given this layout, it should now be obvious why it is very difficult to change
+the physical size of an AG and why the existing grow mechanism simply appends
+new AGs to the filesystem. Changing the size of an AG requires that we
+have to move all the higher AGs either up or down in the DADDR space. That
+requires physically moving data around in the block device LBA space.
+
+Hence if we wanted to expand the AG size out to the max defined by sb_agblklog
+(call that size Y), we'd have to move AG 3 from 3X to 3Y, AG 2 from 2X to 2Y, etc,
+until we ended up with this::
+
+	DADDR	0	X	2X	3X	4X
+	DADDR	0	    Y		2Y	    3Y		4Y
+	AG 0	+-------+...+
+	AG 1		    +-------+...+
+	AG 1				+-------+...+
+	AG 1					    +-------+...+
+
+And then we can change the AG size (sb_agblocks) to match the size defined
+by sb_agblklog. That would then give us::
+
+	DADDR	0	    Y		2Y	    3Y		4Y
+	AG 0	+-----------+
+	AG 1		    +-----------+
+	AG 1				+-----------+
+	AG 1					    +-----------+
+
+None of the FSBNO encodings have changed in this process. We have physically
+changed the location of the start of every AG so that they are still laid out
+nose to tail, but they are now maximally sized for the filesystem's defined
+sb_agblklog value.
+
+That, however, is the downside of this mechanism: We can only grow the AG size
+to the maximum defined by sb_agblklog. And we already know that mkfs.xfs rounds
+that value up to the next highest power of 2. Hence this mechanism can, at best,
+only double the size of an AG in an existing filesystem. That's not enough to
+solve the problem we are trying to address.
+
+The solution should already be obvious: we can exploit the sparseness of FSBNO
+addressing to allow AGs to grow to 1TB (maximum size) simply by configuring
+sb_agblklog appropriately at mkfs.xfs time. Hence if we have 16MB AGs (minimum
+size) and sb_agblklog = 30 (1TB max AG size), we can expand the AG size up
+to their maximum size before we start appending new AGs.
+
+
+Optimising Physical AG Realignment
+==================================
+
+The elephant in the room at this point in time is the fact that we have to
+physically move data around to expand AGs. While this makes AG size expansion
+prohibitive for large filesystems, they should already have large AGs and so
+using the existing grow mechanism will continue to be the right tool to use for
+expanding them.
+
+However, for small filesystems and filesystem images in the order of hundreds of
+MB to a few GB in size, the cost of moving data around is much more tolerable.
+If we can optimise the IO patterns to be purely sequential, offload the movement
+to the hardware, or even use address space manipulation APIs to minimise the
+cost of this movement, then resizing AGs via realignment becomes even more
+appealing.
+
+Realigning AGs must avoid overwriting parts of AGs that have not yet been
+realigned. That means we can't realign the AGs from AG 1 upwards - doing so will
+overwrite parts of AG2 before we've realigned that data. Hence realignment must
+be done from the highest AG first, and work downwards.
+
+Moving the data within an AG could be optimised to be space usage aware, similar
+to what xfs_copy does to build sparse filesystem images. However, the space
+optimised filesystem images aren't going to have a lot of free space in them,
+and what there is may be quite fragmented. Hence doing free space aware copying
+of relatively full small AGs may be IOPS intensive. Given we are talking about
+AGs in the typical size range from 64-512MB, doing a sequential copy of the
+entire AG isn't going to take very long on any storage. If we have to do several
+hundred seeks in that range to skip free space, then copying the free space will
+cost less than the seeks and the partial RAID stripe writes that small IOs will
+cause.
+
+Hence the simplest, sequentially optimised data moving algorithm will be:
+
+.. code-block:: c
+
+	for (agno = sb_agcount - 1; agno > 0; agno--) {
+		src = agno * sb_agblocks;
+		dst = agno * new_agblocks;
+		copy_file_range(src, dst, sb_agblocks);
+	}
+
+This also leads to optimisation via server side or block device copy offload
+infrastructure. Instead of streaming the data through kernel buffers, the copy
+is handed to the server/hardware to moves the data internally as quickly as
+possible.
+
+For filesystem images held in files and, potentially, on sparse storage devices
+like dm-thinp, we don't even need to copy the data.  We can simply insert holes
+into the underlying mapping at the appropriate place.  For filesystem images,
+this is:
+
+.. code-block:: c
+
+	len = new_agblocks - sb_agblocks;
+	for (agno = 1; agno < sb_agcount; agno++) {
+		src = agno * sb_agblocks;
+		fallocate(FALLOC_FL_INSERT_RANGE, src, len)
+	}
+
+Then the filesystem image can be copied to the destination block device in an
+efficient manner (i.e. skipping holes in the image file).
+
+Hence there are several different realignment stratgeies that can be used to
+optimise the expansion of the filesystem. The optimal strategy will ultimately
+depend on how the orchestration software sets up the filesystem for
+configuration at first boot. The userspace xfs expansion tool should be able to
+support all these mechanisms directly so that higher level infrastructure
+can simply select the option that best suits the installation being performed.
+
+
+Limitations
+===========
+
+This document describes an offline mechanism for expanding the filesystem
+geometery. It doesn't add new AGs, just expands they existing AGs. If the
+filesystem needs to be made larger than maximally sized AGs can address, then
+a subsequent online xfs_growfs operation is still required.
+
+For container/vm orchestration software, this isn't a huge issue as they
+generally grow the image from within the initramfs context on first boot. That
+is currently a "mount; xfs_growfs" operation pair; adding expansion to this
+would simply require adding expansion before the mount. i.e. first boot becomes
+a "xfs_expand; mount; xfs_growfs" operation. Depending on the eventual size of
+the target filesystem, the xfs-growfs operation may be a no-op.
+
+Whether expansion can be done online is an open question. AG expansion cahnges
+fundamental constants that are calculated at mount time (e.g. maximum AG btree
+heights), and so an online expand would need to recalculate many internal
+constants that are used throughout the codebase. This seems like a complex
+problem to solve and isn't really necessary for the use case we need to address,
+so online expansion remain as a potential future enhancement that requires a lot
+more thought.
-- 
2.45.1

