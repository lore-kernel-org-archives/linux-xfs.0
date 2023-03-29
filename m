Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0AEC77B60
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Mar 2023 11:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjC2LBU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Mar 2023 07:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2LBT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2023 07:01:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D6C1982;
        Wed, 29 Mar 2023 04:01:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 723EA219E2;
        Wed, 29 Mar 2023 11:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680087677; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wgg5I8m6Lxgglbmj5X1lDlueyyYL8oHkWfGIRuYZSxc=;
        b=2D6Bn52N83q/knkzifd0rJ3lU8FGyhLvOWZtK5IAVRc7pxQN4yFxxpsR3Skhx7pQLrNXIx
        n16tGWXBKkku1AlAWjcxcvngcDT5NQzBMD/qeh1MXt1wZjhpynyt5FZLbQu0qOiDIJrvgI
        KOUI5dKPyX1An9RWxBRX0oPMH6SMZI4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680087677;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wgg5I8m6Lxgglbmj5X1lDlueyyYL8oHkWfGIRuYZSxc=;
        b=+L9OPTaz4gE/m4H+/n99B3ybR/y0XL1VMLm9XWS0Kh5Y12jrZFdksC9/d4rtWDZzHlxWqR
        r21roSAtMjSDw8AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 37899139D3;
        Wed, 29 Mar 2023 11:01:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id h1QXDH0aJGQHPQAAMHmgww
        (envelope-from <ddiss@suse.de>); Wed, 29 Mar 2023 11:01:17 +0000
Date:   Wed, 29 Mar 2023 13:02:53 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] common/report: fix typo in FSSTRESS_AVOID
Message-ID: <20230329130253.30d5c2c5@echidna.fritz.box>
In-Reply-To: <168005150172.4147931.1361107257343712396.stgit@frogsfrogsfrogs>
References: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
        <168005150172.4147931.1361107257343712396.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 28 Mar 2023 17:58:21 -0700, Darrick J. Wong wrote:

> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix a minor typo.

Reviewed-by: David Disseldorp <ddiss@suse.de>
