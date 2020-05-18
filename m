Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602A8C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 19:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30657207F5
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 19:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CSBk0jIa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgERTYT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 15:24:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60024 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728079AbgERTYT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 15:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589829856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=HcGXwl85YOIvv2twDKuhyMuZaBzn8cu6Z6QWAYsQteA=;
        b=CSBk0jIaxkoAQZHwL6P0SsFDqHnmBr14bhoNUTiQFCkL82kSIEe/nVAEESxhSEiLVok4Ki
        ZsbgQRk3SqBcpLUecmrvDt6IMM6lmBdNkir6c37sCzfNybCgqWDZmCRTdNUqtISV8mDcrD
        zDX59pN3joHjuFcsTVoebE3zJruddbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-8UpSWfNOMJifZZrsGT8OOg-1; Mon, 18 May 2020 15:24:15 -0400
X-MC-Unique: 8UpSWfNOMJifZZrsGT8OOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32ABC1005512
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 19:24:14 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 059A8398
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 19:24:13 +0000 (UTC)
Subject: [PATCH 1/1] xfs_quota: allow individual timer extension
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <b75aef11-0e7a-7b2d-f6f0-d36af80d5e27@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <fb0b46ab-98a1-4427-fa5e-4a770c9d0805@redhat.com>
Date:   Mon, 18 May 2020 14:24:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b75aef11-0e7a-7b2d-f6f0-d36af80d5e27@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The only grace period which can be set via xfs_quota today is for id 0,
i.e. the default grace period for all users.  However, setting an
individual grace period is useful; for example:

 Alice has a soft quota of 100 inodes, and a hard quota of 200 inodes
 Alice uses 150 inodes, and enters a short grace period
 Alice really needs to use those 150 inodes past the grace period
 The administrator extends Alice's grace period until next Monday

vfs quota users such as ext4 can do this today, with setquota -T

xfs_quota can now accept an optional user id or name (symmetric with
how warn limits are specified), in which case that user's grace period
is extended to expire the given amount of time from now(). 

To maintain compatibility with old command lines, if none of 
[-d|id|name] are specified, default limits are set as before.

(kernelspace requires updates to enable all this as well.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index e6fe7cd1..dd0479cd 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -457,14 +457,46 @@ must be specified.
 .B \-bir
 ]
 .I value
+[
+.B -d
+|
+.I id
+|
+.I name
+]
 .br
 Allows the quota enforcement timeout (i.e. the amount of time allowed
 to pass before the soft limits are enforced as the hard limits) to
 be modified. The current timeout setting can be displayed using the
 .B state
-command. The value argument is a number of seconds, but units of
-\&'minutes', 'hours', 'days', and 'weeks' are also understood
+command.
+.br
+When setting the default timer via the
+.B \-d
+option, or for
+.B id
+0, or if no argument is given after
+.I value
+the
+.I value
+argument is a number of seconds indicating the relative amount of time after
+soft limits are exceeded, before hard limits are enforced.
+.br
+When setting any other individual timer by
+.I id
+or
+.I name,
+the
+.I value
+is the number of seconds from now, at which time the hard limits will be enforced.
+This allows extending the grace time of an individual user who has exceeded soft
+limits.
+.br
+For
+.I value,
+units of \&'minutes', 'hours', 'days', and 'weeks' are also understood
 (as are their abbreviations 'm', 'h', 'd', and 'w').
+.br
 .HP
 .B warn
 [
diff --git a/quota/edit.c b/quota/edit.c
index 442b608c..b60d0b13 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -419,6 +419,7 @@ restore_f(
 
 static void
 set_timer(
+	uint32_t	id,
 	uint		type,
 	uint		mask,
 	char		*dev,
@@ -427,14 +428,41 @@ set_timer(
 	fs_disk_quota_t	d;
 
 	memset(&d, 0, sizeof(d));
+
+	/*
+	 * If id is specified we are extending grace time by value
+	 * Otherwise we are setting the default grace time
+	 */
+	if (id) {
+		time_t	now;
+
+		if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
+			exitcode = 1;
+			fprintf(stderr, _("%s: cannot get quota: %s\n"),
+					progname, strerror(errno));
+				return;
+		}
+
+		time(&now);
+
+		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
+			d.d_btimer = now + value;
+		if (d.d_ino_softlimit && d.d_icount > d.d_ino_softlimit)
+			d.d_itimer = now + value;
+		if (d.d_rtb_softlimit && d.d_rtbcount > d.d_rtb_softlimit)
+			d.d_rtbtimer = now + value;
+	} else {
+		d.d_btimer = value;
+		d.d_itimer = value;
+		d.d_rtbtimer = value;
+	}
+
 	d.d_version = FS_DQUOT_VERSION;
 	d.d_flags = type;
 	d.d_fieldmask = mask;
-	d.d_itimer = value;
-	d.d_btimer = value;
-	d.d_rtbtimer = value;
+	d.d_id = id;
 
-	if (xfsquotactl(XFS_SETQLIM, dev, type, 0, (void *)&d) < 0) {
+	if (xfsquotactl(XFS_SETQLIM, dev, type, id, (void *)&d) < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set timer: %s\n"),
 				progname, strerror(errno));
@@ -447,10 +475,15 @@ timer_f(
 	char		**argv)
 {
 	uint		value;
-	int		c, type = 0, mask = 0;
+	char		*name = NULL;
+	uint32_t	id = 0;
+	int		c, type = 0, mask = 0, flags = 0;
 
-	while ((c = getopt(argc, argv, "bgipru")) != EOF) {
+	while ((c = getopt(argc, argv, "bdgipru")) != EOF) {
 		switch (c) {
+		case 'd':
+			flags |= DEFAULTS_FLAG;
+			break;
 		case 'b':
 			mask |= FS_DQ_BTIMER;
 			break;
@@ -474,23 +507,45 @@ timer_f(
 		}
 	}
 
-	if (argc != optind + 1)
+	 /*
+	 * Older versions of the command did not accept -d|id|name,
+	 * so in that case we assume we're setting default timer,
+	 * and the last arg is the timer value.
+	 *
+	 * Otherwise, if the defaults flag is set, we expect 1 more arg for
+	 * timer value ; if not, 2 more args: 1 for value, one for id/name.
+	 */
+	if (!(flags & DEFAULTS_FLAG) && (argc == optind + 1)) {
+		value = cvttime(argv[optind++]);
+	} else if (flags & DEFAULTS_FLAG) {
+		if (argc != optind + 1)
+			return command_usage(&timer_cmd);
+		value = cvttime(argv[optind++]);
+	} else if (argc == optind + 2) {
+		value = cvttime(argv[optind++]);
+		name = (flags & DEFAULTS_FLAG) ? "0" : argv[optind++];
+	} else
 		return command_usage(&timer_cmd);
 
-	value = cvttime(argv[optind++]);
 
+	/* if none of -bir specified, set them all */
 	if (!mask)
 		mask = FS_DQ_TIMER_MASK;
 
 	if (!type) {
 		type = XFS_USER_QUOTA;
 	} else if (type != XFS_GROUP_QUOTA &&
-	           type != XFS_PROJ_QUOTA &&
-	           type != XFS_USER_QUOTA) {
+		   type != XFS_PROJ_QUOTA &&
+		   type != XFS_USER_QUOTA) {
 		return command_usage(&timer_cmd);
 	}
 
-	set_timer(type, mask, fs_path->fs_name, value);
+	if (name)
+		id = id_from_string(name, type);
+
+	if (id >= 0)
+		set_timer(id, type, mask, fs_path->fs_name, value);
+
 	return 0;
 }
 
@@ -616,9 +671,9 @@ edit_init(void)
 
 	timer_cmd.name = "timer";
 	timer_cmd.cfunc = timer_f;
-	timer_cmd.argmin = 2;
+	timer_cmd.argmin = 1;
 	timer_cmd.argmax = -1;
-	timer_cmd.args = _("[-bir] [-g|-p|-u] value");
+	timer_cmd.args = _("[-bir] [-g|-p|-u] value [-d|id|name]");
 	timer_cmd.oneline = _("set quota enforcement timeouts");
 	timer_cmd.help = timer_help;
 	timer_cmd.flags = CMD_FLAG_FOREIGN_OK;


