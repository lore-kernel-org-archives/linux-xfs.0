Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56535 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755747AbcIKMws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2016 08:52:48 -0400
Date: Sun, 11 Sep 2016 05:52:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/71] xfs: log refcount intent items
Message-ID: <20160911125246.GA1399@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
 <147216802075.867.12945255918683675311.stgit@birch.djwong.org>
 <20160906152155.GJ24287@infradead.org>
 <20160908191404.GB8969@birch.djwong.org>
 <20160908231326.GA30056@dastard>
 <20160908231656.GC8969@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160908231656.GC8969@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 04:16:56PM -0700, Darrick J. Wong wrote:
> > Carfeul there - enums are not defined to have a fixed size and so
> > can change from compiler version to compiler version. IOWs, the
> > enum values can be written idirectly to an on-disk structure, but
> > the on-disk structure should not be using the enum as the type
> > definition for whatever gets stored on disk.
> 
> <nod>  I left the fields (and the #define flags) definitions alone,
> so it's only writing enum values indirectly into a fixed size (u32)
> variable on-disk.
> 
> i.e. I'm not using enums in the on-disk structure definitions.

now add a byte swap for the flags and everything should be fine.
The whole idea of architecture-dependent log items was a horrible
idea, and I still have hopes of fixing it eventually.
