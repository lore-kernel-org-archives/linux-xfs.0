Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26ABC54FCB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 16:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA1BE2076E
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 16:19:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fCPGmWy0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgDVQTK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 12:19:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51304 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726112AbgDVQTJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 12:19:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587572348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Zw+mrJUnYzNwcXOPrcwPss4B5Gq+epKoudnJhN74ro=;
        b=fCPGmWy0UBTPXaH5YbX2tpkWok+bulIW4il9KI9eVprjOe6YEystWthvI3hSir2HtLHAVL
        0p815eDWuX3mFtlxeewNfOQoHOi2OGW8spDVTwT5G15v1hzDCAnTlmyUWnOEcfkd6AHryu
        Q56eNTy6ASdhgczQeClFzteSPTOaQEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404---caUz7HO8uPpjgMvaDn2Q-1; Wed, 22 Apr 2020 12:18:57 -0400
X-MC-Unique: --caUz7HO8uPpjgMvaDn2Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 434E013FB;
        Wed, 22 Apr 2020 16:18:56 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD2865DA66;
        Wed, 22 Apr 2020 16:18:55 +0000 (UTC)
Date:   Wed, 22 Apr 2020 12:18:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/19] xfs: refactor log recovery
Message-ID: <20200422161854.GB37352@bfoster>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:06:03PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series refactors log recovery by moving recovery code for each log
> item type into the source code for the rest of that log item type and
> using dispatch function pointers to virtualize the interactions.  This
> dramatically reduces the amount of code in xfs_log_recover.c and
> increases cohesion throughout the log code.
> 

So I realized pretty quickly after looking at patch 2 that I probably
need to step back and look at the big picture before getting into the
details of the patches. After skimming through the end result, my
preliminary reaction is that the concept looks interesting for intents,
but I'm not so sure about abstracting so aggressively across the core
recovery implementation simply because I don't think the current design
lends itself to it. Some high level thoughts on particular areas...

- Transaction reorder

Virtualizing the transaction reorder across all several files/types
strikes me as overkill for several reasons. From a code standpoint,
we've created a new type enumeration and a couple fields (enum type and
a function) in a generic structure to essentially abstract out the
buffer handling into a function. The latter checks another couple of blf
flags, which appears to be the only real "type specific" logic in the
whole sequence. From a complexity standpoint, the reorder operation is a
fairly low level and internal recovery operation. We have this huge
comment just to explain exactly what's happening and why certain items
have to be ordered as such, or some treated like others, etc. TBH it's
not terribly clear even with that documentation, so I don't know that
splitting the associated mapping logic off into separate files is
helpful.

- Readahead

We end up with readahead callouts for only the types that translate to
buffers (so buffers, inode, dquots), and then those callouts do some
type specific mapping (that is duplicated within the specific type
handers) and issue a readahead (which is duplicated across each ra_pass2
call). I wonder if this would be better abstracted by a ->bmap() like
call that simply maps the item to a [block,length] and returns a
non-zero length if the core recovery code should invoke readahead (after
checking for cancellation). It looks like the underlying implementation
of those bmap calls could be further factored into helpers that
translate from the raw record data into the type specific format
structures, and that could reduce duplication between the readahead
calls and the pass2 calls in a couple cases. (The more I think about,
the more I think we should introduce those kind of cleanups before
getting into the need for function pointers.)

- Recovery (pass1/pass2)

The core recovery bits seem more reasonable to factor out in general.
That said, we only have two pass1 callbacks (buffers and quotaoff). The
buffer callback does cancellation management and the quotaoff sets some
flags, so I wonder why those couldn't just remain as direct function
calls (even if we move the functions out of xfs_log_recover.c). There
are more callbacks for pass2 so the function pointers make a bit more
sense there, but at the same time it looks like the various intents are
further abstracted behind a single "intent type" pass2 call (which has a
hardcoded XLOG_REORDER_INODE_LIST reorder value and is about as clear as
mud in that context, getting to my earlier point).

Given all that, ISTM that the virtualization pattern is perhaps best
suited for the intent bits since we'll probably grow more
xlog_recover_intent_type users over time as we defer-enable more
operations, and the interfaces therein are more broadly used across the
types. I'm much more on the fence about the whole xlog_recover_item_type
thing. I've no objection to lifting more type-specific code out of
xfs_log_recover.c, but if we're going as far as creating a virt
interface then I'd probably rather see us refactor things more first and
design a cleaner interface rather than simply spread the order,
readahead, pass1, pass2 recovery sequence logic around through multiple
source files, particularly where several of the virt interfaces are used
relatively sparsely (and the landing spots for that code is shared with
other functional components...)

Which also makes me wonder if the _item.c files are the right place to
dump functional recovery code. I've always considered those files mostly
related to xfs_log_item management so it looks a little off to see some
of the functional recovery code in there. Perhaps we should split log
recovery into its own set of per-type source files and leave any common
log item/format bits in the _item.c files..? That certainly might make
more sense to me if we do go with such a low level recovery interface...

Brian

> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-log-recovery
> 

