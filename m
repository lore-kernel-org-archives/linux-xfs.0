Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A900EC761A6
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Mar 2023 11:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjC2LAa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Mar 2023 07:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2LA3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2023 07:00:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE1B1982;
        Wed, 29 Mar 2023 04:00:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EC0D5219D6;
        Wed, 29 Mar 2023 11:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680087627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WlntJf7o2V7zgiAOORu8rqYJfOo7bj+4+/1/oCHpKZM=;
        b=O70uz98ylIGXcLJ7tRAw74ZlisJ/gsQ3xWX2zPcL3wc4WMwFcw6F/nUFgW6DVKm9KQKb2N
        weJmoqTVrZCw9OhH/AN+s+juJQYFNSVrxNFZUHZ9U1YlG9/cXHqGaQ6pIijT/vj8UPWdPu
        BIeOZT4IchkGKwkrt8/G/855aUWCtRQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680087627;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WlntJf7o2V7zgiAOORu8rqYJfOo7bj+4+/1/oCHpKZM=;
        b=XOX+77V5l+aISyep2d5UwxztnCeQDwqglAwb1LJ8tPLHdxvg6hD3JPzFDwt9arUsqczviY
        eo6FFtU3VODASNDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A52DC139D3;
        Wed, 29 Mar 2023 11:00:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 75jIJksaJGSWPAAAMHmgww
        (envelope-from <ddiss@suse.de>); Wed, 29 Mar 2023 11:00:27 +0000
Date:   Wed, 29 Mar 2023 13:02:04 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] xfs/242: fix _filter_bmap for xfs_io bmap that does
 rt file properly
Message-ID: <20230329130204.0528b402@echidna.fritz.box>
In-Reply-To: <168005149606.4147931.15638466274918510566.stgit@frogsfrogsfrogs>
References: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
        <168005149606.4147931.15638466274918510566.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 28 Mar 2023 17:58:16 -0700, Darrick J. Wong wrote:

> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfsprogs commit b1faed5f787 ("xfs_io: fix bmap command not detecting
> realtime files with xattrs") fixed the xfs_io bmap output to display
> realtime file columns for realtime files with xattrs.  As a result, the
> data and unwritten flags are in column 5 and not column 7.

Reviewed-by: David Disseldorp <ddiss@suse.de>
