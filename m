Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFAFC636D3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 05:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjBIFN7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 00:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBIFN6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 00:13:58 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A435D2384B;
        Wed,  8 Feb 2023 21:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ONRabJKQvkpkh/6B3e5p2LLX1m39l1XFi/IHAgwhvzQ=; b=vtsf1jmgiuOHvBodLcT3RW16Fi
        3QEfJLlCm4B4AJOjGp22Ai/CPc2bFcrFW7VAdGk71fIFyr8gfikhFeW8sJhucjZHhINvAb3dbK7ME
        gj0KK32FNaWdne9BWllE4fWVQvnMQMdnpawMYJwnRoloML0rTSADGI//TkKoApw/YaTMkwX5NjKUY
        XANNw/jfPJ+j9YpJRWWHeKOWCaN0piYloflD/Si3M9CQT5HrhT+Q0VFLjiRS1QG4hVuuxlwxy8QQv
        j8Fi0kiRYUA8yf+jjI+6soLhNNluck4I8CVXqmQI89mCIxz/YAsVSYFfgqYEFR58aDGgs7jSUEdPh
        mv2n8Cyw==;
Received: from [2001:4bb8:182:9f5b:acdc:d3c1:a8cd:f858] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pPzFs-000Bsc-VL; Thu, 09 Feb 2023 05:13:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: run more tests in the auto group
Date:   Thu,  9 Feb 2023 06:13:48 +0100
Message-Id: <20230209051355.358942-1-hch@lst.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series adds a more tests to the auto and quick groups so that they
are run as part of the usual regressions tests.
