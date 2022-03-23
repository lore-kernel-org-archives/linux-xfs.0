Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8253C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 14:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbiCWOxS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 10:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236610AbiCWOxS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 10:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939AD7D01F;
        Wed, 23 Mar 2022 07:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3983E61776;
        Wed, 23 Mar 2022 14:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF768C340E8;
        Wed, 23 Mar 2022 14:51:46 +0000 (UTC)
Date:   Wed, 23 Mar 2022 10:51:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] tracing: Have trace event string test handle zero
 length strings
Message-ID: <20220323105145.4550b3b7@gandalf.local.home>
In-Reply-To: <Yjsyt/6OeFSRsmcq@bfoster>
References: <20220323103912.097ad3a8@gandalf.local.home>
        <Yjsyt/6OeFSRsmcq@bfoster>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 23 Mar 2022 10:46:15 -0400
Brian Foster <bfoster@redhat.com> wrote:

> FWIW:
> 
> Tested-by: Brian Foster <bfoster@redhat.com>

Thanks, I'll add this tag.

-- Steve
