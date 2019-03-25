Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35860 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726061AbfCYXvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 19:51:47 -0400
Date: Tue, 26 Mar 2019 10:51:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: serialize unaligned dio writes against all other
 dio writes
Message-ID: <20190325235142.GD23020@dastard>
References: <20190325172448.55284-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325172448.55284-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 25, 2019 at 01:24:48PM -0400, Brian Foster wrote:
> XFS applies more strict serialization constraints to unaligned
> direct writes to accommodate things like direct I/O layer zeroing,
> unwritten extent conversion, etc. Unaligned submissions acquire the
> exclusive iolock and wait for in-flight dio to complete to ensure
> multiple submissions do not race on the same block and cause data
> corruption.
> 
> This generally works in the case of an aligned dio followed by an
> unaligned dio, but the serialization is lost if I/Os occur in the
> opposite order. If an unaligned write is submitted first and
> immediately followed by an overlapping, aligned write, the latter
> submits without the typical unaligned serialization barriers because
> there is no indication of an unaligned dio still in-flight. This can
> lead to unpredictable results.
> 
> To provide proper unaligned dio serialization, require that such
> direct writes are always the only dio allowed in-flight at one time
> for a particular inode. We already acquire the exclusive iolock and
> drain pending dio before submitting the unaligned dio. Wait once
> more after the dio submission to hold the iolock across the I/O and
> prevent further submissions until the unaligned I/O completes. This
> is heavy handed, but consistent with the current pre-submission
> serialization for unaligned direct writes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
