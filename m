Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37795 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdGESLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2017 14:11:14 -0400
Date: Wed, 5 Jul 2017 11:11:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [proposal] making filesystem tools more machine friendly
Message-ID: <20170705181113.GA20326@infradead.org>
References: <CACj3i70p=ybXZWRncseqwnbs7HAYu-SL02+cj--7T5YnqcwVKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i70p=ybXZWRncseqwnbs7HAYu-SL02+cj--7T5YnqcwVKQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs <linux-xfs@vger.kernel.org>

Hi Jan,

I really like the idea out json output for fs/block tools.

nvme-cli has been doing it for a while, and that has been very
useful.  It comes with it's own little handrolled json output
helpers:

	https://github.com/linux-nvme/nvme-cli/blob/master/json.c

so it doesn't introduce any new dependencies.  If you want to parse
input as well a library might be a better approach, though.

I really don't like the shared object evms model mention in the thread,
as that creates hard ELF dependencies.
