Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53300 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbeLDPYh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 10:24:37 -0500
Date: Tue, 4 Dec 2018 07:24:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/11] vfs: copy_file_range should update file timestamps
Message-ID: <20181204152437.GG32245@infradead.org>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203083416.28978-8-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 03, 2018 at 07:34:12PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Timestamps are not updated right now, so programs looking for
> timestamp updates for file modifications (like rsync) will not
> detect that files have changed. We are also accessing the source
> data when doing a copy (but not when cloning) so we need to update
> atime on the source file as well.

This needs to be done inside the method, as a few file systems
do odd things about timestamps (yes, even now that XFS doesn't do that
anymore :)).
