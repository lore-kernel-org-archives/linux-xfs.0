Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60188 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbeLEOMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 09:12:54 -0500
Date: Wed, 5 Dec 2018 06:12:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] vfs: copy_file_range source range over EOF should
 fail
Message-ID: <20181205141252.GB21109@infradead.org>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-2-david@fromorbit.com>
 <CAOQ4uxhOQY8M5rbgHKREN5qpeDGHv0-xK3r37Lj6XfqFoE4qjg@mail.gmail.com>
 <20181204151332.GA32245@infradead.org>
 <20181204212948.GO6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204212948.GO6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

> Realistically, though, I think an attempt to read beyond EOF for the
> copy should result in behaviour like read() (i.e. return 0 bytes),
> not EINVAL. The existing behaviour needs to change, though.

I agree with this statement.  So we don't we implement these semantics?
