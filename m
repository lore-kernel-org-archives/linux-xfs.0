Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0855AC47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 14:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D103F6121D
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 14:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhFCO4X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 10:56:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12132 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230319AbhFCO4G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 10:56:06 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153Ed54W185335;
        Thu, 3 Jun 2021 10:54:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=mUbe1lk/PG0v8kW5ZivmztkK3PnWj5Q8hpLRIokUU5U=;
 b=WylHoaRFasmu4VcfKEh2emmOX6UiYNDy94AHvIVKYVGKfxO2fxADtykFh/DxQwC6YVWH
 +KBFM93cJRJmM4nPP/2/Mf1QvoLDxg/FhIwFPT5UYfEgHfm6xNpNrseUVCpXph42ANDk
 /tKi57hhLE8WknkNFbRfxQerbqKyjUNfPr3KOQyrQ9Y2RILWitlNjCQZUdo4zW624fLI
 +UhW0nMpBeIckpDGY1fX7uYa1ao0/LM2Ro6azQ/gd61pz9mVxpObBtUH0H7vYkprud1k
 5NYBMcBPTusqXlxy11rwcf3p6yLTt9AXeOV4gfDNnmyhcyhDV1fLPl+Bi/UMIk+X8EGx Cg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38xw68gd0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 10:54:18 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 153ErN6t031132;
        Thu, 3 Jun 2021 14:54:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 38ud88b210-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 14:54:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 153EsEpQ29622692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Jun 2021 14:54:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C0DBAE058;
        Thu,  3 Jun 2021 14:54:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0932DAE051;
        Thu,  3 Jun 2021 14:54:14 +0000 (GMT)
Received: from localhost (unknown [9.85.75.172])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Jun 2021 14:54:13 +0000 (GMT)
Date:   Thu, 3 Jun 2021 20:24:13 +0530
From:   riteshh <riteshh@linux.ibm.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't take a spinlock unconditionally in the DIO
 fastpath
Message-ID: <20210603145413.5dzvl5tubfswol7f@riteshh-domain>
References: <20210519011920.450421-1-david@fromorbit.com>
 <20210531175825.mahfjai3pqftdlrv@riteshh-domain>
 <20210601231520.GG664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601231520.GG664593@dread.disaster.area>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TdGgE7WXuWj1FFde6d3seHjnA7xc24dg
X-Proofpoint-GUID: TdGgE7WXuWj1FFde6d3seHjnA7xc24dg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_09:2021-06-02,2021-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030100
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 21/06/02 09:15AM, Dave Chinner wrote:
> On Mon, May 31, 2021 at 11:28:25PM +0530, riteshh wrote:
> > On 21/05/19 11:19AM, Dave Chinner wrote:
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -384,21 +384,30 @@ xfs_file_write_checks(
> > >  		}
> > >  		goto restart;
> > >  	}
> > > +
> > >  	/*
> > >  	 * If the offset is beyond the size of the file, we need to zero any
> > >  	 * blocks that fall between the existing EOF and the start of this
> > > -	 * write.  If zeroing is needed and we are currently holding the
> > > -	 * iolock shared, we need to update it to exclusive which implies
> > > -	 * having to redo all checks before.
> > > +	 * write.  If zeroing is needed and we are currently holding the iolock
> > > +	 * shared, we need to update it to exclusive which implies having to
> > > +	 * redo all checks before.
> > > +	 *
> > > +	 * We need to serialise against EOF updates that occur in IO completions
> > > +	 * here. We want to make sure that nobody is changing the size while we
> > > +	 * do this check until we have placed an IO barrier (i.e.  hold the
> > > +	 * XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.  The
> > > +	 * spinlock effectively forms a memory barrier once we have the
> > > +	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value and
> > > +	 * hence be able to correctly determine if we need to run zeroing.
> > >  	 *
> > > -	 * We need to serialise against EOF updates that occur in IO
> > > -	 * completions here. We want to make sure that nobody is changing the
> > > -	 * size while we do this check until we have placed an IO barrier (i.e.
> > > -	 * hold the XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.
> > > -	 * The spinlock effectively forms a memory barrier once we have the
> > > -	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value
> > > -	 * and hence be able to correctly determine if we need to run zeroing.
> > > +	 * We can do an unlocked check here safely as IO completion can only
> > > +	 * extend EOF. Truncate is locked out at this point, so the EOF can
> > > +	 * not move backwards, only forwards. Hence we only need to take the
> > > +	 * slow path and spin locks when we are at or beyond the current EOF.
> > >  	 */
> > > +	if (iocb->ki_pos <= i_size_read(inode))
> > > +		goto out;
> > > +
> > >  	spin_lock(&ip->i_flags_lock);
> > >  	isize = i_size_read(inode);
> > >  	if (iocb->ki_pos > isize) {
> >
> > Hello Dave/Jan,
> >
> > Sorry about some silly queries here. But locking sometimes can get confusing and
> > needs a background context/history.
> >
> > So,
> > I was going through the XFS DIO path and I couldn't completely get this below
> > difference between xfs_file_dio_write_unaligned() v/s
> > xfs_file_dio_write_aligned() checks for taking xfs iolock (inode rwsem)
> > with different exclusivity(exclusive v/s shared).
> >
> > I in xfs_**_unaligned() function, we also check if (ki_pos + count >= isize()).
> > If yes, then we go for an exclusive iolock.
> > While in xfs_**_aligned() function, we always take shared iolock.
> >
> > Can you please help me understand why is that? In case of an extending aligned
> > write, won't we need an exclusive iolock for XFS?
>
> No. Extending the file is a slowpath operation which requires
> exclusive locking. We always take the shared lock first if we can
> because that's the normal fast path operation and so we optimise for
> that case.
>
> In the aligned DIO case, we check for sub-block EOF zeroing in
> xfs_file_write_checks(). If needed, we upgrade the lock to exclusive
> while the EOF zeroing is done. Once we return back to the aligned IO
> code, we'll demote that exclusive lock back to shared for the block
> aligned IO that we are issuing.
>
> > Or IIUC, this exclusive lock is mostly needed to prevent two sub-bock zeroing
> > from running in parallel (which if this happens could cause corruption)
> > and this can only happen with unaligned writes.
>
> The exclusive lock is needed for serialising zeroing operations,
> whether it be zeroing for EOF extension or sub-block zeroing for
> unaligned writes.
>
> The reason for the EOF checks in the unaligned case is right there
> in the comment above the EOF checks:
>
>         /*
>          * Extending writes need exclusivity because of the sub-block zeroing
>          * that the DIO code always does for partial tail blocks beyond EOF, so
>          * don't even bother trying the fast path in this case.
>          */
>
> IOWs, there is no possible "fast path" shared locking case for
> unaligned extending DIOs, so we just take the exlusive lock right
> from the start.
>
> > Whereas, I guess ext4, still does exclusive lock even with aligned extending
> > writes, possibly because of updation of inode->i_size and orphan inode
> > handling requires it to take exclusive inode rwsem.
> >
> > While for XFS inode->i_size updation happens with a different spinlock which is
> > ip->i_flags_lock.
>
> XFS is serialising DIO completion against DIO submission here rather
> than anything else to do with inode size updates which are,
> generally speaking, serialised at a higher level by various
> combinations of i_rwsem, MMAPLOCK, ILOCK and inode_dio_wait().

Thanks a lot Dave for detailed explaination about this.
This makes things quite clear now from XFS side.

-ritesh

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
