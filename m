Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:31353 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755338AbdCGTZg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 14:25:36 -0500
Date: Tue, 7 Mar 2017 09:23:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: report crtime and attribute flags to statx
Message-ID: <20170307172302.GI5280@birch.djwong.org>
References: <20170307000609.GG5280@birch.djwong.org>
 <20170307050140.GA12946@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170307050140.GA12946@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 06, 2017 at 09:01:40PM -0800, Christoph Hellwig wrote:
> On Mon, Mar 06, 2017 at 04:06:09PM -0800, Darrick J. Wong wrote:
> > statx has the ability to report inode creation times and inode flags, so
> > hook up di_crtime and di_flags to that functionality.
> 
> This would be great to have in 4.11 together with the initial statx
> implementation.  But until I see documentation and testcases for statx
> I don't really feel comfortable reviewing anything related to it.

Same feeling here -- aside from cargo-culting from the proposed ext4
patch I don't have much to go on other than floating a test balloon to
see if Mr. Howells responds.

(FWIW the samples/test-statx.c program reported the flags & btime.)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
