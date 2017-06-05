Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdFEOEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2017 10:04:45 -0400
Date: Mon, 5 Jun 2017 16:04:40 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/25] xfs: verify inline directory data forks
Message-ID: <20170605140440.GB18192@kroah.com>
References: <20170603131836.26661-1-hch@lst.de>
 <20170603131836.26661-2-hch@lst.de>
 <20170605140407.GA18192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170605140407.GA18192@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Mon, Jun 05, 2017 at 04:04:07PM +0200, Greg KH wrote:
> On Sat, Jun 03, 2017 at 03:18:12PM +0200, Christoph Hellwig wrote:
> > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > 
> > When we're reading or writing the data fork of an inline directory,
> > check the contents to make sure we're not overflowing buffers or eating
> > garbage data.  xfs/348 corrupts an inline symlink into an inline
> > directory, triggering a buffer overflow bug.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> > v2: add more checks consistent with _dir2_sf_check and make the verifier
> > usable from anywhere.
> 
> What is the git commit id of this patch upstream?

Nevermind, I found it, 630a04e79dd41ff746b545d4fc052e0abb836120
