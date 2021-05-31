Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4731C47080
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 17:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AFCF61263
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 17:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhEaSAP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 14:00:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31662 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231826AbhEaSAO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 14:00:14 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VHYDtf140246;
        Mon, 31 May 2021 13:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=I/mr+N99rIfTBscjFOhwttTK5SKNA41rHkkqNVuPrtw=;
 b=JYYHu/11wmqjHAe75OPv9pfwv6TBLRHwrMRhUvZKUCCwYrZn9GjHZQ4yhsiND+KpY6xN
 xQRYvn3MfdCjdAWAcu1yQwiKKMUxMdS4tFMwPz+dNMIx95FCAStuchLO8nIOq67ZE2/A
 zagUWzPS88GzBDKo+lAnGWJVO/lT7dfKEB4XwpWO/6XyM6lhwgYFz2UHTnZYxClHiNdK
 Uhqj2pPqaXWd7Z7Fd5tWWwfHrAa05rN+9yNxYzs+nTkzJk3OxXHOLiysAaBh9nASi6EL
 C5+5LS81uqtSADjfZpydhXrO8qCf/cq5W1bPf1C8yZeMD+F2caMHXS8ncXfMY2iK8CRA Rg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38w38n1r77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 13:58:30 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14VHvupb023552;
        Mon, 31 May 2021 17:58:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 38ud87rmyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 17:58:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14VHwQng18350506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 May 2021 17:58:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08E7BA4054;
        Mon, 31 May 2021 17:58:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACFB1A405B;
        Mon, 31 May 2021 17:58:25 +0000 (GMT)
Received: from localhost (unknown [9.85.71.200])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 May 2021 17:58:25 +0000 (GMT)
Date:   Mon, 31 May 2021 23:28:25 +0530
From:   riteshh <riteshh@linux.ibm.com>
To:     Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't take a spinlock unconditionally in the DIO
 fastpath
Message-ID: <20210531175825.mahfjai3pqftdlrv@riteshh-domain>
References: <20210519011920.450421-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210519011920.450421-1-david@fromorbit.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kGcsTsmjuVxZuPz_B9rnbq5Jex2qP5NR
X-Proofpoint-ORIG-GUID: kGcsTsmjuVxZuPz_B9rnbq5Jex2qP5NR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_12:2021-05-31,2021-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105310132
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 21/05/19 11:19AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Because this happens at high thread counts on high IOPS devices
> doing mixed read/write AIO-DIO to a single file at about a million
> iops:
>
>    64.09%     0.21%  [kernel]            [k] io_submit_one
>    - 63.87% io_submit_one
>       - 44.33% aio_write
>          - 42.70% xfs_file_write_iter
>             - 41.32% xfs_file_dio_write_aligned
>                - 25.51% xfs_file_write_checks
>                   - 21.60% _raw_spin_lock
>                      - 21.59% do_raw_spin_lock
>                         - 19.70% __pv_queued_spin_lock_slowpath
>
> This also happens of the IO completion IO path:
>
>    22.89%     0.69%  [kernel]            [k] xfs_dio_write_end_io
>    - 22.49% xfs_dio_write_end_io
>       - 21.79% _raw_spin_lock
>          - 20.97% do_raw_spin_lock
>             - 20.10% __pv_queued_spin_lock_slowpath                                                                                                            ▒
>
> IOWs, fio is burning ~14 whole CPUs on this spin lock.
>
> So, do an unlocked check against inode size first, then if we are
> at/beyond EOF, take the spinlock and recheck. This makes the
> spinlock disappear from the overwrite fastpath.
>
> I'd like to report that fixing this makes things go faster. It
> doesn't - it just exposes the the XFS_ILOCK as the next severe
> contention point doing extent mapping lookups, and that now burns
> all the 14 CPUs this spinlock was burning.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 42 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 31 insertions(+), 11 deletions(-)
>
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 396ef36dcd0a..c068dcd414f4 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -384,21 +384,30 @@ xfs_file_write_checks(
>  		}
>  		goto restart;
>  	}
> +
>  	/*
>  	 * If the offset is beyond the size of the file, we need to zero any
>  	 * blocks that fall between the existing EOF and the start of this
> -	 * write.  If zeroing is needed and we are currently holding the
> -	 * iolock shared, we need to update it to exclusive which implies
> -	 * having to redo all checks before.
> +	 * write.  If zeroing is needed and we are currently holding the iolock
> +	 * shared, we need to update it to exclusive which implies having to
> +	 * redo all checks before.
> +	 *
> +	 * We need to serialise against EOF updates that occur in IO completions
> +	 * here. We want to make sure that nobody is changing the size while we
> +	 * do this check until we have placed an IO barrier (i.e.  hold the
> +	 * XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.  The
> +	 * spinlock effectively forms a memory barrier once we have the
> +	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value and
> +	 * hence be able to correctly determine if we need to run zeroing.
>  	 *
> -	 * We need to serialise against EOF updates that occur in IO
> -	 * completions here. We want to make sure that nobody is changing the
> -	 * size while we do this check until we have placed an IO barrier (i.e.
> -	 * hold the XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.
> -	 * The spinlock effectively forms a memory barrier once we have the
> -	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value
> -	 * and hence be able to correctly determine if we need to run zeroing.
> +	 * We can do an unlocked check here safely as IO completion can only
> +	 * extend EOF. Truncate is locked out at this point, so the EOF can
> +	 * not move backwards, only forwards. Hence we only need to take the
> +	 * slow path and spin locks when we are at or beyond the current EOF.
>  	 */
> +	if (iocb->ki_pos <= i_size_read(inode))
> +		goto out;
> +
>  	spin_lock(&ip->i_flags_lock);
>  	isize = i_size_read(inode);
>  	if (iocb->ki_pos > isize) {

Hello Dave/Jan,

Sorry about some silly queries here. But locking sometimes can get confusing and
needs a background context/history.

So,
I was going through the XFS DIO path and I couldn't completely get this below
difference between xfs_file_dio_write_unaligned() v/s
xfs_file_dio_write_aligned() checks for taking xfs iolock (inode rwsem)
with different exclusivity(exclusive v/s shared).

I in xfs_**_unaligned() function, we also check if (ki_pos + count >= isize()).
If yes, then we go for an exclusive iolock.
While in xfs_**_aligned() function, we always take shared iolock.

Can you please help me understand why is that? In case of an extending aligned
write, won't we need an exclusive iolock for XFS?
Or IIUC, this exclusive lock is mostly needed to prevent two sub-bock zeroing
from running in parallel (which if this happens could cause corruption)
and this can only happen with unaligned writes.

Whereas, I guess ext4, still does exclusive lock even with aligned extending
writes, possibly because of updation of inode->i_size and orphan inode
handling requires it to take exclusive inode rwsem.

While for XFS inode->i_size updation happens with a different spinlock which is
ip->i_flags_lock.

Is my understanding complete and correct?
Or did I miss anything here?

Thanks
ritesh


> @@ -426,7 +435,7 @@ xfs_file_write_checks(
>  			drained_dio = true;
>  			goto restart;
>  		}
> -
> +
>  		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
>  		error = iomap_zero_range(inode, isize, iocb->ki_pos - isize,
>  				NULL, &xfs_buffered_write_iomap_ops);
> @@ -435,6 +444,7 @@ xfs_file_write_checks(
>  	} else
>  		spin_unlock(&ip->i_flags_lock);
>
> +out:
>  	return file_modified(file);
>  }
>
> @@ -500,7 +510,17 @@ xfs_dio_write_end_io(
>  	 * other IO completions here to update the EOF. Failing to serialise
>  	 * here can result in EOF moving backwards and Bad Things Happen when
>  	 * that occurs.
> +	 *
> +	 * As IO completion only ever extends EOF, we can do an unlocked check
> +	 * here to avoid taking the spinlock. If we land within the current EOF,
> +	 * then we do not need to do an extending update at all, and we don't
> +	 * need to take the lock to check this. If we race with an update moving
> +	 * EOF, then we'll either still be beyond EOF and need to take the lock,
> +	 * or we'll be within EOF and we don't need to take it at all.
>  	 */
> +	if (offset + size <= i_size_read(inode))
> +		goto out;
> +
>  	spin_lock(&ip->i_flags_lock);
>  	if (offset + size > i_size_read(inode)) {
>  		i_size_write(inode, offset + size);
> --
> 2.31.1
>
