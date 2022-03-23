Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7AAC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 14:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239785AbiCWODe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 10:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239191AbiCWODd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 10:03:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A557EA18
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 07:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10ED1616C3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B36BC340E9;
        Wed, 23 Mar 2022 14:02:02 +0000 (UTC)
Date:   Wed, 23 Mar 2022 10:02:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS tracepoint warning due to NULL string
Message-ID: <20220323100200.6f22e417@gandalf.local.home>
In-Reply-To: <YjsWzuw5FbWPrdqq@bfoster>
References: <YjsWzuw5FbWPrdqq@bfoster>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 23 Mar 2022 08:47:10 -0400
Brian Foster <bfoster@redhat.com> wrote:

> What's the best way to address this going forward with the memory usage
> verification in place? ISTM we could perhaps consider dropping the
> custom %.*s thing in favor of using %s with __string_len() and friends,
> or perhaps just replace the open-coded NULL parameter with the "(null)"
> string that the trace subsystem code seems to use on NULL pointer
> checks. The latter seems pretty simple and straightforward of a change
> to me, but I want to make sure I'm not missing something more obvious.
> Thoughts?

Can you see if the following (totally untested) patch fixes your issue?

-- Steve

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 08ea781540b5..f4de111fa18f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3673,12 +3673,17 @@ static char *trace_iter_expand_format(struct trace_iterator *iter)
 }
 
 /* Returns true if the string is safe to dereference from an event */
-static bool trace_safe_str(struct trace_iterator *iter, const char *str)
+static bool trace_safe_str(struct trace_iterator *iter, const char *str,
+			   bool star, int len)
 {
 	unsigned long addr = (unsigned long)str;
 	struct trace_event *trace_event;
 	struct trace_event_call *event;
 
+	/* Ignore strings with no length */
+	if (star && !len)
+		return true;
+
 	/* OK if part of the event data */
 	if ((addr >= (unsigned long)iter->ent) &&
 	    (addr < (unsigned long)iter->ent + iter->ent_size))
@@ -3864,7 +3869,7 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		 * instead. See samples/trace_events/trace-events-sample.h
 		 * for reference.
 		 */
-		if (WARN_ONCE(!trace_safe_str(iter, str),
+		if (WARN_ONCE(!trace_safe_str(iter, str, star, len),
 			      "fmt: '%s' current_buffer: '%s'",
 			      fmt, show_buffer(&iter->seq))) {
 			int ret;
