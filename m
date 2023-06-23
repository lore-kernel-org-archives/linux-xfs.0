Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0098EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jun 2023 11:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbjFWLv2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jun 2023 07:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjFWLvO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2023 07:51:14 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AEE19A1
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 04:50:10 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-25e89791877so276201a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 04:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687520948; x=1690112948;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jIVGxuYHcKp6BxqTOvRVEKGYp8htVDT/+3RxdVPcA8s=;
        b=DTcQsJxRW7cEuyJXEO+bxtafYuTOgTHXTkPDzyZcQOOD+CP48haZrtMz44DIq+wNOa
         l2xdePtN9ZLpqys7POUbUzpFeezImUW4j2z+rYznFT/C+3KYKEsYm1uroUsLBdV+j9+l
         nJVtWasJWU9+CTBjjOeHEU0eI+sKaUOk3n3sGB/ZXq/wB5frai+25OxIWWZvi7QTRxwy
         +WUJJtz2bHqKyWBP6mXE+5mUO8vhv7Gz3hQTuN5RwE0h7dr4SJdIn4slgMVni359XXjc
         zlAiOUzCseOyAi01519B3yE/3n8+Oc8V26AtPofUfnF/Vtvr2pCAPwOi8GT8tKKeOMg9
         m4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687520948; x=1690112948;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jIVGxuYHcKp6BxqTOvRVEKGYp8htVDT/+3RxdVPcA8s=;
        b=Tmu5juRabhhEi0n/IL/PrQSfy4rftaTYxNRxrM0Sr12akwONpR8dw7UKjN1ZxU9yQg
         UAl6dQHPzg0WJXNpzL3kcC9wS/7aj9jUu8MRCv3PjhR9g9jIXeQNWdsAmL/goLPAxTtG
         oKkZVh5CphqMzQvdcmSOz48dlpQVdLWYgF42kJjU+2IYPQCG6geZ0UJE5TlGii/PaGv/
         dHJ1Ec8qL0sBgmA635yOAnhMDM8KIb1lNbtiaT9Xne0oh5KnvJg1APd1JbytJrn24eT+
         hUaFlQTxU7S0lqY5eZrguVJ8IwiD4uG+UAl9HYVEVS5kkbTJrgi7951xt79j9DBXVPLq
         EuyQ==
X-Gm-Message-State: AC+VfDw4wY4oU4H8n4aHskBbEX3kBYBsN+IN/n8QrwlFYgGKt0O3Hgb2
        bAwOk6hQJWSgSQNJvW/lv7Eah8WsmBI=
X-Google-Smtp-Source: ACHHUZ6SVpz8WhG5+uU6MYaI2sfLLRYDL5k6gcaAYFaEQtZs9KUK6G48WUuJ0CyczFjmMmNjEI/xNw==
X-Received: by 2002:a17:902:e748:b0:1b5:40fd:7b76 with SMTP id p8-20020a170902e74800b001b540fd7b76mr15653785plf.40.1687520948511;
        Fri, 23 Jun 2023 04:49:08 -0700 (PDT)
Received: from dw-tp ([49.207.220.159])
        by smtp.gmail.com with ESMTPSA id jl21-20020a170903135500b001acaf7e22bdsm7087813plb.14.2023.06.23.04.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:49:07 -0700 (PDT)
Date:   Fri, 23 Jun 2023 17:19:04 +0530
Message-Id: <871qi24cwf.fsf@doe.com>
From:   Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Masahiko Sawada <sawada.mshk@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: Question on slow fallocate
In-Reply-To: <ZJVu3Kf/HTWGnA/O@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Fri, Jun 23, 2023 at 01:59:58PM +0530, Ritesh Harjani wrote:
>> Dave Chinner <david@fromorbit.com> writes:
>> 
>> > On Thu, Jun 22, 2023 at 02:34:18PM +0900, Masahiko Sawada wrote:
>> >> Hi all,
>> >> 
>> >> When testing PostgreSQL, I found a performance degradation. After some
>> >> investigation, it ultimately reached the attached simple C program and
>> >> turned out that the performance degradation happens on only the xfs
>> >> filesystem (doesn't happen on neither ext3 nor ext4). In short, the
>> >> program alternately does two things to extend a file (1) call
>> >> posix_fallocate() to extend by 8192 bytes
>> >
>> > This is a well known anti-pattern - it always causes problems. Do
>> > not do this.
>> >
>> >> and (2) call pwrite() to
>> >> extend by 8192 bytes. If I do only either (1) or (2), the program is
>> >> completed in 2 sec, but if I do (1) and (2) alternatively, it is
>> >> completed in 90 sec.
>> >
>> > Well, yes. Using fallocate to extend the file has very different
>> > constraints to using pwrite to extend the file.
>> >
>> >> $ gcc -o test test.c
>> >> $ time ./test test.1 1
>> >> total   200000
>> >> fallocate       200000
>> >> filewrite       0
>> >
>> > No data is written here, so this is just a series of 8kB allocations
>> > and file size extension operations. There are no constraints here
>> > because it is a pure metadata operation.
>> >
>> >> real    0m1.305s
>> >> user    0m0.050s
>> >> sys     0m1.255s
>> >> 
>> >> $ time ./test test.2 2
>> >> total   200000
>> >> fallocate       100000
>> >> filewrite       100000
>> >>
>> >> real    1m29.222s
>> >> user    0m0.139s
>> >> sys     0m3.139s
>> >
>> > Now we have fallocate extending the file and doing unwritten extent
>> > allocation, followed by writing into that unwritten extent which
>> > then does unwritten extent conversion.
>> >
>> > This introduces data vs metadata update ordering constraints to the
>> > workload.
>> >
>> > The problem here in that the "truncate up" operation that
>> > fallocate is doing to move the file size. The "truncate up" is going
>> > to move the on-disk file size to the end of the fallocated range via
>> > a journal transaction, and so it will expose the range of the
>> > previous write as containing valid data.
>> >
>> > However, the previous data write is still only in memory and not on
>> > disk. The result of journalling the file size change is that if we
>> > crash after the size change is made but the data is not on disk,
>> > we end up with lost data - the file contains zeros (or NULLs) where
>> > the in memory data previously existed.
>> >
>> > Go google for "NULL file data exposure" and you'll see this is a
>> > problem we fixed in ~2006, caused by extending the file size on disk
>> > without first having written all the in-memory data into the file.
>> 
>> I guess here is the <patch> you are speaking of. So this prevents from
>> exposing nulls within a file in case of a crash.
>
> Well, we're not really "exposing NULLs". No data got written before
> the crash, so a read from that range after a crash will find a hole
> or unwritten extents in the file and return zeros.
>

Yes, I agree. 
I meant writing "null file problem".

>> I guess the behavior is not the same with ext4. ext4 does not seem to be
>> doing filemap_write_and_wait_range() if the new i_disksize is more than
>> oldsize. So then I think ext4 must be ok if in case of a crash the
>> file has nulls in between. That's why I think the observation of slow
>> performance is not seen in ext4.
>
> ext4 also has a similar problem issue where crashes can lead to
> files full of zeroes, and many of the mitigations they use were
> copied from the XFS mitigations for the same problem.  However, ext4
> has a completely different way of handling failures after truncate
> (via an orphan list, IIRC) so it doesn't need to actually write
> the data to avoid potential stale data exposure issues.
>

Sorry, but I still haven't understood the real problem here for which
XFS does filemap_write_and_wait_range(). Is it a stale data exposure
problem? 

Now, in this code here in fs/xfs/xfs_iops.c we refer to the problem as
"expose ourselves to the null files problem".
What is the "expose ourselves to the null files problem here"
for which we do filemap_write_and_wait_range()?


	/*
	 * We are going to log the inode size change in this transaction so
	 * any previous writes that are beyond the on disk EOF and the new
	 * EOF that have not been written out need to be written here.  If we
	 * do not write the data out, we expose ourselves to the null files
	 * problem. Note that this includes any block zeroing we did above;
	 * otherwise those blocks may not be zeroed after a crash.
	 */
	if (did_zeroing ||
	    (newsize > ip->i_disk_size && oldsize != ip->i_disk_size)) {
		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
						ip->i_disk_size, newsize - 1);
		if (error)
			return error;
	}


Talking about ext4, it handles truncates to a file using orphan
handline, yes. In case if the truncate operation spans multiple txns and
if the crash happens say in the middle of a txn, then the subsequent crash
recovery will truncate the blocks spanning i_disksize.

But we aren't discussing shrinking here right. We are doing pwrite
followed by fallocate to grow the file size. With pwrite we use delalloc
so the blocks only get allocated during writeback time and with
fallocate we will allocate unwritten extents, so there should be no
stale data expose problem in this case right? 

Hence my question was to mainly understand what does "expose ourselves to
the null files problem" means in XFS?


Thanks!
-ritesh
