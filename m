Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44143 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbdISUeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 16:34:05 -0400
Date: Tue, 19 Sep 2017 13:34:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: io_submit() blocks for writes for substantial amount of time
Message-ID: <20170919203403.GA731@infradead.org>
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster>
 <20170919145827.GA21523@infradead.org>
 <04cb3ee7-e7d5-6bba-6adb-8ac1c28e68dc@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04cb3ee7-e7d5-6bba-6adb-8ac1c28e68dc@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, Tomasz Grabiec <tgrabiec@scylladb.com>, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 07:31:04PM +0300, Avi Kivity wrote:
> For DIO, does it really need the mm_struct? It can just pin the pages and
> pass them to the workqueue function.

We can't pin all the pages for a huge I/O at the same time.
