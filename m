Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2637155C97
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496792; cv=none; b=PmCbvf1AILkhG+YLpe6ySkStbH4LKR7SU1Dp+q4aVgmQz7Q3EnNH8YMLxPelAtyEpIyi0lbrl2w7YiL8aGrdSmhhFh46E/LPqbddsUP3b1/lrVN2LsIuVI32hqzCTpqVuM1QXOTJE4eLtX+MEqteaUJrT08A9+HLD4K/xWbMahc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496792; c=relaxed/simple;
	bh=vCsk/H2hLww7CeuMi8kQbRytqNDUXGrrkdNrxgBM+AE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wk/uXhSeWGRsZo8vXjeeydniafysfrQh2vLhl1VnK6O1dKqz593BsaQlXct9ri9Ryxer2iobSupHELBXYBSgWwUVT2PwS2bXBTntSzLVduMtXzZnjsdSG/pSStzV4WAW7sBKdrkwZ8mdhbG56WBCgY6SUQX1YUq6OuIzOWWbMgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BxpfZ5ov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BxpfZ5ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC47CC19423;
	Tue,  3 Mar 2026 00:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496791;
	bh=vCsk/H2hLww7CeuMi8kQbRytqNDUXGrrkdNrxgBM+AE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BxpfZ5ovk/R9gtW5DTXwcPZwiue0LG0/bGanFfqxd1uxK69I4hTtWk0BVWiDaqsbo
	 TVPaAEPJmPVa6zUI77Q19J74rOItoLkKidpX78+ZGj0zot9ADKLJxqfBpNAgIQo1rz
	 ECn8XlM+7SAQO1DD4cWt98Wvj/LOAvwr3kJd0PHglSs2b+389InvKIU85/whnPmUZE
	 mdIPHAo0ZxFyVd6ud9MV/qq6STN1s1fYTLM1abqhXy9RS1PCNBo8+tbO7Aj7A7oOei
	 84IJblPEUYM1DJ296hBgY0RgMRaD6i09YmqMyZwZscoD+nC+Y1SPcfBOMcqsFcqeHV
	 kj95hhhSyh6XA==
Date: Mon, 02 Mar 2026 16:13:11 -0800
Subject: [PATCH 04/36] xfs: create event queuing, formatting,
 and discovery infrastructure
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249637849.457970.12433691535320342952.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: b3a289a2a9397b2e731f334d7d36623a0f9192c5

Create the basic infrastructure that we need to report health events to
userspace.  We need a compact form for recording critical information
about an event and queueing them; a means to notice that we've lost some
events; and a means to format the events into something that userspace
can handle.  Make the kernel export C structures via read().

In a previous iteration of this new subsystem, I wanted to explore data
exchange formats that are more flexible and easier for humans to read
than C structures.  The thought being that when we want to rev (or
worse, enlarge) the event format, it ought to be trivially easy to do
that in a way that doesn't break old userspace.

I looked at formats such as protobufs and capnproto.  These look really
nice in that extending the wire format is fairly easy, you can give it a
data schema and it generates the serialization code for you, handles
endianness problems, etc.  The huge downside is that neither support C
all that well.

Too hard, and didn't want to port either of those huge sprawling
libraries first to the kernel and then again to xfsprogs.  Then I
thought, how about JSON?  Javascript objects are human readable, the
kernel can emit json without much fuss (it's all just strings!) and
there are plenty of interpreters for python/rust/c/etc.

There's a proposed schema format for json, which means that xfs can
publish a description of the events that kernel will emit.  Userspace
consumers (e.g. xfsprogs/xfs_healer) can embed the same schema document
and use it to validate the incoming events from the kernel, which means
it can discard events that it doesn't understand, or garbage being
emitted due to bugs.

However, json has a huge crutch -- javascript is well known for its
vague definitions of what are numbers.  This makes expressing a large
number rather fraught, because the runtime is free to represent a number
in nearly any way it wants.  Stupider ones will truncate values to word
size, others will roll out doubles for uint52_t (yes, fifty-two) with
the resulting loss of precision.  Not good when you're dealing with
discrete units.

It just so happens that python's json library is smart enough to see a
sequence of digits and put them in a u64 (at least on x86_64/aarch64)
but an actual javascript interpreter (pasting into Firefox) isn't
necessarily so clever.

It turns out that none of the proposed json schemas were ever ratified
even in an open-consensus way, so json blobs are still just loosely
structured blobs.  The parsing in userspace was also noticeably slow and
memory-consumptive.

Hence only the C interface survives.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c58e55b3df4099..22b86bc888de5a 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1003,12 +1003,59 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
+/* Health monitor event domains */
+
+/* affects the whole fs */
+#define XFS_HEALTH_MONITOR_DOMAIN_MOUNT		(0)
+
+/* Health monitor event types */
+
+/* status of the monitor itself */
+#define XFS_HEALTH_MONITOR_TYPE_RUNNING		(0)
+#define XFS_HEALTH_MONITOR_TYPE_LOST		(1)
+
+/* lost events */
+struct xfs_health_monitor_lost {
+	__u64	count;
+};
+
+struct xfs_health_monitor_event {
+	/* XFS_HEALTH_MONITOR_DOMAIN_* */
+	__u32	domain;
+
+	/* XFS_HEALTH_MONITOR_TYPE_* */
+	__u32	type;
+
+	/* Timestamp of the event, in nanoseconds since the Unix epoch */
+	__u64	time_ns;
+
+	/*
+	 * Details of the event.  The primary clients are written in python
+	 * and rust, so break this up because bindgen hates anonymous structs
+	 * and unions.
+	 */
+	union {
+		struct xfs_health_monitor_lost lost;
+	} e;
+
+	/* zeroes */
+	__u64	pad[2];
+};
+
 struct xfs_health_monitor {
 	__u64	flags;		/* flags */
 	__u8	format;		/* output format */
 	__u8	pad[23];	/* zeroes */
 };
 
+/* Return all health status events, not just deltas */
+#define XFS_HEALTH_MONITOR_VERBOSE	(1ULL << 0)
+
+#define XFS_HEALTH_MONITOR_ALL		(XFS_HEALTH_MONITOR_VERBOSE)
+
+/* Initial return format version */
+#define XFS_HEALTH_MONITOR_FMT_V0	(0)
+
 /*
  * ioctl commands that are used by Linux filesystems
  */

