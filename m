Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:60169 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755612AbdJIXmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 19:42:17 -0400
Date: Tue, 10 Oct 2017 10:27:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/17] Set up infastructure for deferred attribute
 operations
Message-ID: <20171009232701.GU3666@dastard>
References: <1507327548-3221-1-git-send-email-allison.henderson@oracle.com>
 <1507327548-3221-3-git-send-email-allison.henderson@oracle.com>
 <20171009042026.GJ3666@dastard>
 <acc1732a-7c7a-5a11-ace3-e052134b1590@oracle.com>
 <8dafd7c1-fd4e-6ec4-28dd-72d4eeff602c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8dafd7c1-fd4e-6ec4-28dd-72d4eeff602c@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2017 at 03:51:42PM -0700, Allison Henderson wrote:
> On 10/09/2017 02:25 PM, Allison Henderson wrote:
> >On 10/8/2017 9:20 PM, Dave Chinner wrote:
> >>On Fri, Oct 06, 2017 at 03:05:33PM -0700, Allison Henderson wrote:
> >>>Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> >>>    /*
> >>>   * Inode Log Item Format definitions.
> >>>@@ -863,4 +872,45 @@ struct xfs_icreate_log {
> >>>      __be32        icl_gen;    /* inode generation number to use */
> >>>  };
> >>>  +/* Flags for defered attribute operations */
> >>>+#define ATTR_OP_FLAGS_SET    0x01    /* Set the attribute */
> >>>+#define ATTR_OP_FLAGS_REMOVE    0x02    /* Remove the attribute */
> >>>+#define ATTR_OP_FLAGS_MAX    0x02    /* Max flags */
> >>>+
> >>>+/*
> >>>+ * ATTRI/ATTRD log format definitions
> >>>+ */
> >>>+struct xfs_attr {
> >>>+    xfs_ino_t    attr_ino;
> >>>+    uint32_t    attr_op_flags;
> >>>+    uint32_t    attr_nameval_len;
> >>>+    uint32_t    attr_name_len;
> >>>+    uint32_t        attr_flags;
> >>>+    uint8_t        attr_nameval[MAX_NAMEVAL_LEN];
> >>>+};
> >>
> >>"struct xfs_attr" is very generic. This ends up in the log on disk,
> >>right? So it's a log format structure? struct xfs_attr_log_format?
> >>
> >>This also needs padding to ensure it's size is 64bit aligned.
> >>
> Hmm, if this structure is meant to be stored on disk, is it really a
> good idea to put pointers in here as you mentioned in your
> conclusion below?  If we get remounted or rebooted and loose the
> pointer that may not work.  Or am I not understanding what you
> meant?

The log format structure on disk needs to be encoded correctly - it
will contain data, not pointers. The in-memory log item will contain
the pointers to the xattr name/value buffers. i.e.

struct xfs_attr_log_item {
	struct xfs_log_item	item;
	....
	int			namelen;
	void			*name_buf;
	int			valuelen;
	void			*value_buf;
	struct xfs_attr_log_format alf;
};

And the log format structure looks like:

struct xfs_attr_log_format {
	be64		ino;
	be32		gen;
	be32		intent_id;
	be32		op_flags;
	be32		attr_flags;
	be32		namelen;
	be32		valuelen;
	/* name gets copied here into first trailing log iovec */
	/* value gets copied here into second trailing log iovec */
};

note that the intent id is used by recovery to make the intent item
to the done item - that's probably what the "id" variable in the
original structure you had was supposed to be used for. :P

So essentially the ->item_size code does:

	/* log format header */
	nvecs++;
	nbytes += sizeof(struct xfs_attr_log_format);
	if (opflags == remove ||
	    opflags == flipflags)
		return;

	/* add/set */
	nvecs += 2;
	nbytes += namelen;
	nbytes += valuelen;
	return;

And the ->item_format code does something like:

	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_FORMAT,
	                &alip->alf, sizeof(struct xfs_attr_log_format));

	if (opflags == remove ||
	    opflags == flipflags)
		return;

	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
	                alip->name_buf, alip->namelen);
	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
	                alip->value_buf, alip->valuelen);

Make a bit more sense now?

I suspect taht because we won't ever relog a "set" intent, we can
clear the name_buf/value_buf pointers from the log item once we've
copied them into the log vector. That means we can use pointers to
the buffers containing the name and value already allocated in the
attr code and so won't need to allocate another set of buffers just
for the log item.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
