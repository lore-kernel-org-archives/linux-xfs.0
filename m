Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46806 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdDMPf6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 11:35:58 -0400
Date: Thu, 13 Apr 2017 08:35:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs/384 failures
Message-ID: <20170413153528.GU8502@birch.djwong.org>
References: <20170413095436.GB21980@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413095436.GB21980@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 02:54:36AM -0700, Christoph Hellwig wrote:
> Current xfs/348 reliably fails for me due to this:
> 
>  -stat: 'SCRATCH_MNT/test/SYMLINK' is a directory
>  +stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
> 
> Any idea what's going on there?

That's the new inline directory verifier code rejecting the symlink that
"became" a directory... and yes, I forgot to send the patch in my
xfstests that fixes it.

(Note for those just tuning in: Before the verifier, either you'd get
the error 'is a directory' or the system would corrupt memory and
crash later.)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
