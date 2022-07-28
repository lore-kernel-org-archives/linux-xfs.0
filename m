Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47080C19F2C
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 20:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiG1UQc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 16:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbiG1UQb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 16:16:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0137539D;
        Thu, 28 Jul 2022 13:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0jYx9X8yLdV7jtkq9bjc+sIG+7ajo4JUz65Gqsv4Nck=; b=DJrkkxTOBURWG3WMCgYGK40Sa/
        HIQ91kmxv6TFdRhylmtGfceXClhRV+nvVUjDejkgxAtyNbPH4fO69ubILhev2w+DU8buSzNxl3Xze
        YqM8Nw3X77soNmjk2S/V8+DKXVNvPUmNum/Wa6+RaXNRZP4kTNAdASwjObAJHQMuXrSkfCSTnV779
        R/afKZ3CwYXFfxG9j0uuu3ssHTrQCMgiUfzCvnhEeDBUh5qDFHdvvjLKhMGmO15hSW8MkhMdQVzfP
        0uLcUsUG0TXPoVPIY7Y7juLoM2jbbROzMGkXL31qfoSQgnMqwSKdTTpkS51NFeJHAF3uVNLQ1gW4g
        rzP6B7rA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oH9vo-00EXOB-Cj; Thu, 28 Jul 2022 20:16:28 +0000
Date:   Thu, 28 Jul 2022 13:16:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] xfs/432: fix this test when external devices are in
 use
Message-ID: <YuLunHKTHbw1wcvZ@infradead.org>
References: <165903222941.2338516.818684834175743726.stgit@magnolia>
 <165903223512.2338516.9583051314883581667.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165903223512.2338516.9583051314883581667.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 28, 2022 at 11:17:15AM -0700, Darrick J. Wong wrote:
> +SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
> +	echo "xfs_repair on restored fs returned $?"

Wouldn;t it make more sense to have a version of _scratch_xfs_repair
rather than doing a somewhat unexpected override of this global
variable?
