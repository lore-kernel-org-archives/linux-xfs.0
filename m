Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F0613FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688472; cv=none; b=dgd4ZgaWBr9kINK/I2YscahxNTrcAXDYp3BlIEQ3Oo2lrtX5mJ2r4fWV0nLow6yGsfcG5aMh+I3t3R/CgsxPcMfTOpqBuVMKygjx/Q1FlRStSCsoHHlQ1HWx8XpDr78/F8ng0rn56uYdr9dli+SIauyEDRhdEg//uKropDUAJmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688472; c=relaxed/simple;
	bh=RF9YYV77esfxM1cNYnRt6V/i1GXT6uFx+hBbZhBbBFI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N/aPgkaRhIKU7NFd0vJPm2zQL8zy+j/qhTI4LN46VrovTHQImo7BWkjGIaSvMTG66i4wcTu019121loTEsItkB+hCPJ18GIoMl/TDY05hhSwVrsEyDk2ule36R4WuVel6BNJyACZmAQPflcZzSG0lzS+rvAqS4UUBhQtYK0Wr0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugueCCkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugueCCkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8BEC4CED2;
	Tue, 31 Dec 2024 23:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688472;
	bh=RF9YYV77esfxM1cNYnRt6V/i1GXT6uFx+hBbZhBbBFI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ugueCCkSf3IP3vAoy8Qm89MPvQsrFMrN9HHs9c31mkgC5qI8o0vEFeILljp4Ehsfx
	 twZ6DnqISDjYAybzMv6F2hIRbAiBBvq9lUcYHUnn3Sr7lGwsRg6BG3PhbRguoHvpK7
	 5V7eBJL/jed0g4cNW6kfQu1EEl1fMlocamX/MENppdXZIccpQM7O3N/Cm+nRdpv3OZ
	 RB039bsWu8PVWV5+61fo+Ah+iDbLljS3z2vhRagsJc+mBkwCxXwJypFphQRkEhGedT
	 SMrVcl199USN3bCHTSLIIPzG69ba/9jRjIzKGtZOtLeudcJmZ9myraIcmoMD/fJlwv
	 ZJu7Y4sTwae4g==
Date: Tue, 31 Dec 2024 15:41:11 -0800
Subject: [PATCH 09/16] xfs: create event queuing, formatting,
 and discovery infrastructure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754898.2704911.17397880399097729677.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
References: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create the basic infrastructure that we need to report health events to
userspace.  We need a compact form for recording critical information
about an event and queueing them; a means to notice that we've lost some
events; and a means to format the events into something that userspace
can handle.

Here, we've chosen json to export information to userspace.  The
structured key-value nature of json gives us enormous flexibility to
modify the schema of what we'll send to userspace because we can add new
keys at any time.  Userspace can use whatever json parsers are available
to consume the events and will not be confused by keys they don't
recognize.

Note that we do NOT allow sending json back to the kernel, nor is there
any intent to do that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h                  |    8 
 fs/xfs/libxfs/xfs_healthmon.schema.json |   63 ++++
 fs/xfs/xfs_healthmon.c                  |  542 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.h                  |   24 +
 fs/xfs/xfs_linux.h                      |    3 
 fs/xfs/xfs_trace.c                      |    2 
 fs/xfs/xfs_trace.h                      |  152 +++++++++
 7 files changed, 788 insertions(+), 6 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_healthmon.schema.json


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d1a81b02a1a3f3..d7404e6efd866d 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -1107,6 +1107,14 @@ struct xfs_health_monitor {
 	__u64	pad2[2];	/* zeroes */
 };
 
+/* Return all health status events, not just deltas */
+#define XFS_HEALTH_MONITOR_VERBOSE	(1ULL << 0)
+
+#define XFS_HEALTH_MONITOR_ALL		(XFS_HEALTH_MONITOR_VERBOSE)
+
+/* Return events in JSON format */
+#define XFS_HEALTH_MONITOR_FMT_JSON	(1)
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
diff --git a/fs/xfs/libxfs/xfs_healthmon.schema.json b/fs/xfs/libxfs/xfs_healthmon.schema.json
new file mode 100644
index 00000000000000..9772efe25f193d
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_healthmon.schema.json
@@ -0,0 +1,63 @@
+{
+	"$comment": [
+		"SPDX-License-Identifier: GPL-2.0-or-later",
+		"Copyright (c) 2024-2025 Oracle.  All Rights Reserved.",
+		"Author: Darrick J. Wong <djwong@kernel.org>",
+		"",
+		"This schema file describes the format of the json objects",
+		"readable from the fd returned by the XFS_IOC_HEALTHMON",
+		"ioctl."
+	],
+
+	"$schema": "https://json-schema.org/draft/2020-12/schema",
+	"$id": "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/fs/xfs/libxfs/xfs_healthmon.schema.json",
+
+	"title": "XFS Health Monitoring Events",
+
+	"$comment": "Events must be one of the following types:",
+	"oneOf": [
+		{
+			"$ref": "#/$events/lost"
+		}
+	],
+
+	"$comment": "Simple data types are defined here.",
+	"$defs": {
+		"time_ns": {
+			"title": "Time of Event",
+			"description": "Timestamp of the event, in nanoseconds since the Unix epoch.",
+			"type": "integer"
+		}
+	},
+
+	"$comment": "Event types are defined here.",
+	"$events": {
+		"lost": {
+			"title": "Health Monitoring Events Lost",
+			"$comment": [
+				"Previous health monitoring events were",
+				"dropped due to memory allocation failures",
+				"or queue limits."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"const": "lost"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "mount"
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain"
+			]
+		}
+	}
+}
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index c5ce5699373c63..499f6aab9bdbf3 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -40,12 +40,417 @@
  * so that the queueing and processing of the events do not pin the mount and
  * cannot slow down the main filesystem.  The healthmon object can exist past
  * the end of the filesystem mount.
+ *
+ * Please see the xfs_healthmon.schema.json file for a description of the
+ * format of the json events that are conveyed to userspace.
  */
 
+/* Allow this many events to build up in memory per healthmon fd. */
+#define XFS_HEALTHMON_MAX_EVENTS \
+		(32768 / sizeof(struct xfs_healthmon_event))
+
+struct flag_string {
+	unsigned int	mask;
+	const char	*str;
+};
+
 struct xfs_healthmon {
+	/* lock for mp and eventlist */
+	struct mutex			lock;
+
+	/* waiter for signalling the arrival of events */
+	struct wait_queue_head		wait;
+
+	/* list of event objects */
+	struct xfs_healthmon_event	*first_event;
+	struct xfs_healthmon_event	*last_event;
+
 	struct xfs_mount		*mp;
+
+	/* number of events */
+	unsigned int			events;
+
+	/*
+	 * Buffer for formatting events.  New buffer data are appended to the
+	 * end of the seqbuf, and outpos is used to determine where to start
+	 * a copy_iter.  Both are protected by inode_lock.
+	 */
+	struct seq_buf			outbuf;
+	size_t				outpos;
+
+	/* do we want all events? */
+	bool				verbose;
+
+	/* did we lose an event? */
+	bool				lost_prev_event;
 };
 
+/* Remove an event from the head of the list. */
+static inline void
+xfs_healthmon_free_head(
+	struct xfs_healthmon		*hm,
+	struct xfs_healthmon_event	*event)
+{
+	struct xfs_healthmon_event	*head;
+
+	mutex_lock(&hm->lock);
+	head = hm->first_event;
+	if (head != event) {
+		ASSERT(hm->first_event == event);
+		mutex_unlock(&hm->lock);
+		return;
+	}
+
+	if (hm->last_event == head)
+		hm->last_event = NULL;
+	hm->first_event = head->next;
+	hm->events--;
+	mutex_unlock(&hm->lock);
+
+	trace_xfs_healthmon_pop(hm->mp, head);
+	kfree(event);
+}
+
+/* Push an event onto the end of the list. */
+static inline int
+xfs_healthmon_push(
+	struct xfs_healthmon		*hm,
+	struct xfs_healthmon_event	*event)
+{
+	/*
+	 * If the queue is already full, remember the fact that we lost events.
+	 * This doesn't apply to "event lost" events; those always go through
+	 * because there should only be one at the very end of the queue.
+	 */
+	if (hm->events >= XFS_HEALTHMON_MAX_EVENTS &&
+	    event->type != XFS_HEALTHMON_LOST) {
+		trace_xfs_healthmon_lost_event(hm->mp);
+		hm->lost_prev_event = true;
+		return -ENOMEM;
+	}
+
+	if (!hm->first_event)
+		hm->first_event = event;
+	if (hm->last_event)
+		hm->last_event->next = event;
+	hm->last_event = event;
+	event->next = NULL;
+	hm->events++;
+	wake_up(&hm->wait);
+
+	trace_xfs_healthmon_push(hm->mp, event);
+
+	return 0;
+}
+
+/* Create a new event or record that we failed. */
+static struct xfs_healthmon_event *
+xfs_healthmon_alloc(
+	struct xfs_healthmon		*hm,
+	enum xfs_healthmon_type		type,
+	enum xfs_healthmon_domain	domain)
+{
+	struct timespec64		now;
+	struct xfs_healthmon_event	*event;
+
+	event = kzalloc(sizeof(*event), GFP_NOFS);
+	if (!event) {
+		trace_xfs_healthmon_lost_event(hm->mp);
+		hm->lost_prev_event = true;
+		return NULL;
+	}
+
+	event->type = type;
+	event->domain = domain;
+	ktime_get_coarse_real_ts64(&now);
+	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
+
+	return event;
+}
+
+/*
+ * Before we accept an event notification from a live update hook, we need to
+ * clear out any previously lost events.
+ */
+static inline int
+xfs_healthmon_start_live_update(
+	struct xfs_healthmon		*hm)
+{
+	struct xfs_healthmon_event	*event;
+
+	/*
+	 * If we previously lost an event or the queue is full, try to queue
+	 * a notification about lost events.
+	 */
+	if (!hm->lost_prev_event && hm->events != XFS_HEALTHMON_MAX_EVENTS)
+		return 0;
+
+	/*
+	 * A previous invocation of the live update hook could not allocate
+	 * any memory at all.  If the last event on the list is already a
+	 * notification of lost events, we're done.
+	 */
+	if (hm->last_event && hm->last_event->type == XFS_HEALTHMON_LOST)
+		return 0;
+
+	/*
+	 * There are no events or the last one wasn't about lost events.  Try
+	 * to allocate a new one to note the lost events.
+	 */
+	event = xfs_healthmon_alloc(hm, XFS_HEALTHMON_LOST,
+			XFS_HEALTHMON_MOUNT);
+	if (!event)
+		return -ENOMEM;
+
+	hm->lost_prev_event = false;
+	xfs_healthmon_push(hm, event);
+	return 0;
+}
+
+/* Render the health update type as a string. */
+STATIC const char *
+xfs_healthmon_typestring(
+	const struct xfs_healthmon_event	*event)
+{
+	static const char *type_strings[] = {
+		[XFS_HEALTHMON_LOST]		= "lost",
+	};
+
+	if (event->type >= ARRAY_SIZE(type_strings))
+		return "?";
+
+	return type_strings[event->type];
+}
+
+/* Render the health domain as a string. */
+STATIC const char *
+xfs_healthmon_domstring(
+	const struct xfs_healthmon_event	*event)
+{
+	static const char *dom_strings[] = {
+		[XFS_HEALTHMON_MOUNT]		= "mount",
+	};
+
+	if (event->domain >= ARRAY_SIZE(dom_strings))
+		return "?";
+
+	return dom_strings[event->domain];
+}
+
+/* Convert a flags bitmap into a jsonable string. */
+static inline int
+xfs_healthmon_format_flags(
+	struct seq_buf			*outbuf,
+	const struct flag_string	*strings,
+	size_t				nr_strings,
+	unsigned int			flags)
+{
+	const struct flag_string	*p;
+	ssize_t				ret;
+	unsigned int			i;
+	bool				first = true;
+
+	for (i = 0, p = strings; i < nr_strings; i++, p++) {
+		if (!(p->mask & flags))
+			continue;
+
+		ret = seq_buf_printf(outbuf, "%s\"%s\"",
+				first ? "" : ", ", p->str);
+		if (ret < 0)
+			return ret;
+
+		first = false;
+		flags &= ~p->mask;
+	}
+
+	for (i = 0; flags != 0 && i < sizeof(flags) * NBBY; i++) {
+		if (!(flags & (1U << i)))
+			continue;
+
+		/* json doesn't support hexadecimal notation */
+		ret = seq_buf_printf(outbuf, "%s%u",
+				first ? "" : ", ", (1U << i));
+		if (ret < 0)
+			return ret;
+
+		first = false;
+	}
+
+	return 0;
+}
+
+/* Convert the event mask into a jsonable string. */
+static inline int
+__xfs_healthmon_format_mask(
+	struct seq_buf			*outbuf,
+	const char			*descr,
+	const struct flag_string	*strings,
+	size_t				nr_strings,
+	unsigned int			mask)
+{
+	ssize_t				ret;
+
+	ret = seq_buf_printf(outbuf, "  \"%s\":  [", descr);
+	if (ret < 0)
+		return ret;
+
+	ret = xfs_healthmon_format_flags(outbuf, strings, nr_strings, mask);
+	if (ret < 0)
+		return ret;
+
+	return seq_buf_printf(outbuf, "],\n");
+}
+
+#define xfs_healthmon_format_mask(o, d, s, m) \
+	__xfs_healthmon_format_mask((o), (d), (s), ARRAY_SIZE(s), (m))
+
+static inline void
+xfs_healthmon_reset_outbuf(
+	struct xfs_healthmon		*hm)
+{
+	hm->outpos = 0;
+	seq_buf_clear(&hm->outbuf);
+}
+
+/*
+ * Format an event into json.  Returns 0 if we formatted the event.  If
+ * formatting the event overflows the buffer, returns -1 with the seqbuf len
+ * unchanged.
+ */
+STATIC int
+xfs_healthmon_format(
+	struct xfs_healthmon		*hm,
+	const struct xfs_healthmon_event *event)
+{
+	struct seq_buf			*outbuf = &hm->outbuf;
+	size_t				old_seqlen = outbuf->len;
+	int				ret;
+
+	trace_xfs_healthmon_format(hm->mp, event);
+
+	ret = seq_buf_printf(outbuf, "{\n");
+	if (ret < 0)
+		goto overrun;
+
+	ret = seq_buf_printf(outbuf, "  \"type\":       \"%s\",\n",
+			xfs_healthmon_typestring(event));
+	if (ret < 0)
+		goto overrun;
+
+	ret = seq_buf_printf(outbuf, "  \"domain\":     \"%s\",\n",
+			xfs_healthmon_domstring(event));
+	if (ret < 0)
+		goto overrun;
+
+	switch (event->type) {
+	case XFS_HEALTHMON_LOST:
+		/* empty */
+		break;
+	default:
+		break;
+	}
+
+	switch (event->domain) {
+	case XFS_HEALTHMON_MOUNT:
+		/* empty */
+		break;
+	}
+	if (ret < 0)
+		goto overrun;
+
+	/* The last element in the json must not have a trailing comma. */
+	ret = seq_buf_printf(outbuf, "  \"time_ns\":    %llu\n",
+			event->time_ns);
+	if (ret < 0)
+		goto overrun;
+
+	ret = seq_buf_printf(outbuf, "}\n");
+	if (ret < 0)
+		goto overrun;
+
+	ASSERT(!seq_buf_has_overflowed(outbuf));
+	return 0;
+overrun:
+	/*
+	 * We overflowed the buffer and could not format the event.  Reset the
+	 * seqbuf and tell the caller not to delete the event.
+	 */
+	trace_xfs_healthmon_format_overflow(hm->mp, event);
+	outbuf->len = old_seqlen;
+	return -1;
+}
+
+/* How many bytes are waiting in the outbuf to be copied? */
+static inline size_t
+xfs_healthmon_outbuf_bytes(
+	struct xfs_healthmon	*hm)
+{
+	unsigned int		used = seq_buf_used(&hm->outbuf);
+
+	if (used > hm->outpos)
+		return used - hm->outpos;
+	return 0;
+}
+
+/*
+ * Do we have something for userspace to do?  This can mean unmount events,
+ * events pending in the queue, or pending bytes in the outbuf.
+ */
+static inline bool
+xfs_healthmon_has_eventdata(
+	struct xfs_healthmon	*hm)
+{
+	return hm->events > 0 || xfs_healthmon_outbuf_bytes(hm) > 0;
+}
+
+/* Try to copy the rest of the outbuf to the iov iter. */
+STATIC ssize_t
+xfs_healthmon_copybuf(
+	struct xfs_healthmon	*hm,
+	struct iov_iter		*to)
+{
+	size_t			to_copy;
+	size_t			w = 0;
+
+	trace_xfs_healthmon_copybuf(hm->mp, to, &hm->outbuf, hm->outpos);
+
+	to_copy = xfs_healthmon_outbuf_bytes(hm);
+	if (to_copy) {
+		w = copy_to_iter(hm->outbuf.buffer + hm->outpos, to_copy, to);
+		if (!w)
+			return -EFAULT;
+
+		hm->outpos += w;
+	}
+
+	/*
+	 * Nothing left to copy?  Reset the seqbuf pointers and outbuf to the
+	 * start since there's no live data in the buffer.
+	 */
+	if (xfs_healthmon_outbuf_bytes(hm) == 0)
+		xfs_healthmon_reset_outbuf(hm);
+	return w;
+}
+
+/*
+ * See if there's an event waiting for us.  If the fs is no longer mounted,
+ * don't bother sending any more events.
+ */
+static inline struct xfs_healthmon_event *
+xfs_healthmon_peek(
+	struct xfs_healthmon	*hm)
+{
+	struct xfs_healthmon_event *event;
+
+	mutex_lock(&hm->lock);
+	if (hm->mp)
+		event = hm->first_event;
+	else
+		event = NULL;
+	mutex_unlock(&hm->lock);
+	return event;
+}
+
 /*
  * Convey queued event data to userspace.  First copy any remaining bytes in
  * the outbuf, then format the oldest event into the outbuf and copy that too.
@@ -55,7 +460,112 @@ xfs_healthmon_read_iter(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	return -EIO;
+	struct file		*file = iocb->ki_filp;
+	struct inode		*inode = file_inode(file);
+	struct xfs_healthmon	*hm = file->private_data;
+	struct xfs_healthmon_event *event;
+	size_t			copied = 0;
+	ssize_t			ret = 0;
+
+	/* Wait for data to become available */
+	if (!(file->f_flags & O_NONBLOCK)) {
+		ret = wait_event_interruptible(hm->wait,
+				xfs_healthmon_has_eventdata(hm));
+		if (ret)
+			return ret;
+	} else if (!xfs_healthmon_has_eventdata(hm)) {
+		return -EAGAIN;
+	}
+
+	/* Allocate formatting buffer up to 64k if necessary */
+	if (hm->outbuf.size == 0) {
+		void		*outbuf;
+		size_t		bufsize = min(65536, max(PAGE_SIZE,
+							 iov_iter_count(to)));
+
+		outbuf = kzalloc(bufsize, GFP_KERNEL);
+		if (!outbuf) {
+			bufsize = PAGE_SIZE;
+			outbuf = kzalloc(bufsize, GFP_KERNEL);
+			if (!outbuf)
+				return -ENOMEM;
+		}
+
+		inode_lock(inode);
+		if (hm->outbuf.size == 0) {
+			seq_buf_init(&hm->outbuf, outbuf, bufsize);
+			hm->outpos = 0;
+		} else {
+			kfree(outbuf);
+		}
+	} else {
+		inode_lock(inode);
+	}
+
+	trace_xfs_healthmon_read_start(hm->mp, hm->events, hm->lost_prev_event);
+
+	/*
+	 * If there's anything left in the seqbuf, copy that before formatting
+	 * more events.
+	 */
+	ret = xfs_healthmon_copybuf(hm, to);
+	if (ret < 0)
+		goto out_unlock;
+	copied += ret;
+
+	while (iov_iter_count(to) > 0) {
+		/* Format the next events into the outbuf until it's full. */
+		while ((event = xfs_healthmon_peek(hm)) != NULL) {
+			ret = xfs_healthmon_format(hm, event);
+			if (ret < 0)
+				break;
+			xfs_healthmon_free_head(hm, event);
+		}
+		/* Copy it to userspace */
+		ret = xfs_healthmon_copybuf(hm, to);
+		if (ret <= 0)
+			break;
+
+		copied += ret;
+	}
+
+out_unlock:
+	trace_xfs_healthmon_read_finish(hm->mp, hm->events, hm->lost_prev_event);
+	inode_unlock(inode);
+	return copied ?: ret;
+}
+
+/* Poll for available events. */
+STATIC __poll_t
+xfs_healthmon_poll(
+	struct file			*file,
+	struct poll_table_struct	*wait)
+{
+	struct xfs_healthmon		*hm = file->private_data;
+	__poll_t			mask = 0;
+
+	poll_wait(file, &hm->wait, wait);
+
+	if (xfs_healthmon_has_eventdata(hm))
+		mask |= EPOLLIN;
+	return mask;
+}
+
+/* Free all events */
+STATIC void
+xfs_healthmon_free_events(
+	struct xfs_healthmon		*hm)
+{
+	struct xfs_healthmon_event	*event, *next;
+
+	event = hm->first_event;
+	while (event != NULL) {
+		trace_xfs_healthmon_drop(hm->mp, event);
+		next = event->next;
+		kfree(event);
+		event = next;
+	}
+	hm->first_event = hm->last_event = NULL;
 }
 
 /* Free the health monitoring information. */
@@ -66,6 +576,14 @@ xfs_healthmon_release(
 {
 	struct xfs_healthmon	*hm = file->private_data;
 
+	trace_xfs_healthmon_release(hm->mp, hm->events, hm->lost_prev_event);
+
+	wake_up_all(&hm->wait);
+
+	mutex_destroy(&hm->lock);
+	xfs_healthmon_free_events(hm);
+	if (hm->outbuf.size)
+		kfree(hm->outbuf.buffer);
 	kfree(hm);
 
 	return 0;
@@ -76,9 +594,9 @@ static inline bool
 xfs_healthmon_validate(
 	const struct xfs_health_monitor	*hmo)
 {
-	if (hmo->flags)
+	if (hmo->flags & ~XFS_HEALTH_MONITOR_ALL)
 		return false;
-	if (hmo->format)
+	if (hmo->format != XFS_HEALTH_MONITOR_FMT_JSON)
 		return false;
 	if (memchr_inv(&hmo->pad1, 0, sizeof(hmo->pad1)))
 		return false;
@@ -90,6 +608,7 @@ xfs_healthmon_validate(
 static const struct file_operations xfs_healthmon_fops = {
 	.owner		= THIS_MODULE,
 	.read_iter	= xfs_healthmon_read_iter,
+	.poll		= xfs_healthmon_poll,
 	.release	= xfs_healthmon_release,
 };
 
@@ -122,11 +641,18 @@ xfs_ioc_health_monitor(
 		return -ENOMEM;
 	hm->mp = mp;
 
+	seq_buf_init(&hm->outbuf, NULL, 0);
+	mutex_init(&hm->lock);
+	init_waitqueue_head(&hm->wait);
+
+	if (hmo.flags & XFS_HEALTH_MONITOR_VERBOSE)
+		hm->verbose = true;
+
 	/* Set up VFS file and file descriptor. */
 	name = kasprintf(GFP_KERNEL, "XFS (%s): healthmon", mp->m_super->s_id);
 	if (!name) {
 		ret = -ENOMEM;
-		goto out_hm;
+		goto out_mutex;
 	}
 
 	fd = anon_inode_getfd(name, &xfs_healthmon_fops, hm,
@@ -134,12 +660,16 @@ xfs_ioc_health_monitor(
 	kvfree(name);
 	if (fd < 0) {
 		ret = fd;
-		goto out_hm;
+		goto out_mutex;
 	}
 
+	trace_xfs_healthmon_create(mp, hmo.flags, hmo.format);
+
 	return fd;
 
-out_hm:
+out_mutex:
+	mutex_destroy(&hm->lock);
+	xfs_healthmon_free_events(hm);
 	kfree(hm);
 	return ret;
 }
diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
index 07126e39281a0c..606f205074495c 100644
--- a/fs/xfs/xfs_healthmon.h
+++ b/fs/xfs/xfs_healthmon.h
@@ -6,6 +6,30 @@
 #ifndef __XFS_HEALTHMON_H__
 #define __XFS_HEALTHMON_H__
 
+enum xfs_healthmon_type {
+	XFS_HEALTHMON_LOST,	/* message lost */
+};
+
+enum xfs_healthmon_domain {
+	XFS_HEALTHMON_MOUNT,	/* affects the whole fs */
+};
+
+struct xfs_healthmon_event {
+	struct xfs_healthmon_event	*next;
+
+	enum xfs_healthmon_type		type;
+	enum xfs_healthmon_domain	domain;
+
+	uint64_t			time_ns;
+
+	union {
+		/* mount */
+		struct {
+			unsigned int	flags;
+		};
+	};
+};
+
 #ifdef CONFIG_XFS_HEALTH_MONITOR
 long xfs_ioc_health_monitor(struct xfs_mount *mp,
 		struct xfs_health_monitor __user *arg);
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 9a2221b4aa21ed..d13a5fa2d652ff 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -63,6 +63,9 @@ typedef __u32			xfs_nlink_t;
 #include <linux/xattr.h>
 #include <linux/mnt_idmapping.h>
 #include <linux/debugfs.h>
+#ifdef CONFIG_XFS_HEALTH_MONITOR
+# include <linux/seq_buf.h>
+#endif
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 555fe76b4d853c..41a2ac85dc5fdf 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -52,6 +52,8 @@
 #include "xfs_zone_alloc.h"
 #include "xfs_zone_priv.h"
 #include "xfs_fsrefs.h"
+#include "xfs_health.h"
+#include "xfs_healthmon.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 76f5d78b6a6e09..bd3b007d213fc6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -106,6 +106,8 @@ struct xfs_open_zone;
 struct xfs_fsrefs;
 struct xfs_fsrefs_irec;
 struct xfs_rtgroup;
+struct xfs_healthmon_event;
+struct xfs_health_update_params;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -6077,6 +6079,156 @@ TRACE_EVENT(xfs_growfs_check_rtgeom,
 );
 #endif /* CONFIG_XFS_RT */
 
+#ifdef CONFIG_XFS_HEALTH_MONITOR
+TRACE_EVENT(xfs_healthmon_lost_event,
+	TP_PROTO(const struct xfs_mount *mp),
+	TP_ARGS(mp),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+	),
+	TP_printk("dev %d:%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev))
+);
+
+#define XFS_HEALTHMON_FLAGS_STRINGS \
+	{ XFS_HEALTH_MONITOR_VERBOSE,	"verbose" }
+#define XFS_HEALTHMON_FMT_STRINGS \
+	{ XFS_HEALTH_MONITOR_FMT_JSON,	"json" }
+
+TRACE_EVENT(xfs_healthmon_create,
+	TP_PROTO(const struct xfs_mount *mp, u64 flags, u8 format),
+	TP_ARGS(mp, flags, format),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u64, flags)
+		__field(u8, format)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->flags = flags;
+		__entry->format = format;
+	),
+	TP_printk("dev %d:%d flags %s format %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_flags(__entry->flags, "|", XFS_HEALTHMON_FLAGS_STRINGS),
+		  __print_symbolic(__entry->format, XFS_HEALTHMON_FMT_STRINGS))
+);
+
+TRACE_EVENT(xfs_healthmon_copybuf,
+	TP_PROTO(const struct xfs_mount *mp, const struct iov_iter *iov,
+		 const struct seq_buf *seqbuf, size_t outpos),
+	TP_ARGS(mp, iov, seqbuf, outpos),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(size_t, seqbuf_size)
+		__field(size_t, seqbuf_len)
+		__field(size_t, outpos)
+		__field(size_t, to_copy)
+		__field(size_t, iter_count)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->seqbuf_size = seqbuf->size;
+		__entry->seqbuf_len = seqbuf->len;
+		__entry->outpos = outpos;
+		__entry->to_copy = seqbuf->len - outpos;
+		__entry->iter_count = iov_iter_count(iov);
+	),
+	TP_printk("dev %d:%d seqsize %zu seqlen %zu out_pos %zu to_copy %zu iter_count %zu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->seqbuf_size,
+		  __entry->seqbuf_len,
+		  __entry->outpos,
+		  __entry->to_copy,
+		  __entry->iter_count)
+);
+
+DECLARE_EVENT_CLASS(xfs_healthmon_class,
+	TP_PROTO(const struct xfs_mount *mp, unsigned int events, bool lost_prev),
+	TP_ARGS(mp, events, lost_prev),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, events)
+		__field(bool, lost_prev)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->events = events;
+		__entry->lost_prev = lost_prev;
+	),
+	TP_printk("dev %d:%d events %u lost_prev? %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->events,
+		  __entry->lost_prev)
+);
+#define DEFINE_HEALTHMON_EVENT(name) \
+DEFINE_EVENT(xfs_healthmon_class, name, \
+	TP_PROTO(const struct xfs_mount *mp, unsigned int events, bool lost_prev), \
+	TP_ARGS(mp, events, lost_prev))
+DEFINE_HEALTHMON_EVENT(xfs_healthmon_read_start);
+DEFINE_HEALTHMON_EVENT(xfs_healthmon_read_finish);
+DEFINE_HEALTHMON_EVENT(xfs_healthmon_release);
+DEFINE_HEALTHMON_EVENT(xfs_healthmon_unmount);
+
+#define XFS_HEALTHMON_TYPE_STRINGS \
+	{ XFS_HEALTHMON_LOST,		"lost" }
+
+#define XFS_HEALTHMON_DOMAIN_STRINGS \
+	{ XFS_HEALTHMON_MOUNT,		"mount" }
+
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_LOST);
+
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_MOUNT);
+
+DECLARE_EVENT_CLASS(xfs_healthmon_event_class,
+	TP_PROTO(const struct xfs_mount *mp, const struct xfs_healthmon_event *event),
+	TP_ARGS(mp, event),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, type)
+		__field(unsigned int, domain)
+		__field(unsigned int, mask)
+		__field(unsigned long long, ino)
+		__field(unsigned int, gen)
+		__field(unsigned int, group)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->type = event->type;
+		__entry->domain = event->domain;
+		__entry->mask = 0;
+		__entry->group = 0;
+		__entry->ino = 0;
+		__entry->gen = 0;
+		switch (__entry->domain) {
+		case XFS_HEALTHMON_MOUNT:
+			__entry->mask = event->flags;
+			break;
+		}
+	),
+	TP_printk("dev %d:%d type %s domain %s mask 0x%x ino 0x%llx gen 0x%x group 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XFS_HEALTHMON_TYPE_STRINGS),
+		  __print_symbolic(__entry->domain, XFS_HEALTHMON_DOMAIN_STRINGS),
+		  __entry->mask,
+		  __entry->ino,
+		  __entry->gen,
+		  __entry->group)
+);
+#define DEFINE_HEALTHMONEVENT_EVENT(name) \
+DEFINE_EVENT(xfs_healthmon_event_class, name, \
+	TP_PROTO(const struct xfs_mount *mp, const struct xfs_healthmon_event *event), \
+	TP_ARGS(mp, event))
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_push);
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_pop);
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_format);
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_format_overflow);
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_drop);
+#endif /* CONFIG_XFS_HEALTH_MONITOR */
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

