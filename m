Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC0667F59
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 07:39:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 925988F8033
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 05:39:11 -0800 (PST)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
	[209.85.215.51]) by cuda.sgi.com with ESMTP id 1oCAOpwl83PGVDeC
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 05:39:08 -0800 (PST)
Received: by lfaz4 with SMTP id z4so8429177lfa.0
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 05:39:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151201131128.GB26129@bfoster.bfoster>
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<CAD-J=zZrKbOAUzj5dJYOPkukPQV4V7YMr_c+W6_SXHNzGgOxdQ@mail.gmail.com>
	<20151201131128.GB26129@bfoster.bfoster>
Date: Tue, 1 Dec 2015 08:39:06 -0500
Message-ID: <CAD-J=zYpXui+HarW9RTGyygE9vQn=0FXs__kmVGF3nHN3AfsYA@mail.gmail.com>
Subject: Re: sleeps and waits during io_submit
From: Glauber Costa <glauber@scylladb.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Avi Kivity <avi@scylladb.com>, xfs@oss.sgi.com

>
> The truncate will free blocks and require block allocation on subsequent
> writes. That might be something you could look into trying to avoid
> (e.g., keeping files around and reusing space), but that depends on your
> application design.


This one is a bit hard. We have a journal-like structure for the
modifications issued to the data store, which dominates most of our
write workloads (including this one that I am discussing here). We
could keep they around by renaming them outside of user visibility and
then renaming them back, but that would mean that we are now using
twice as much space. Perhaps we could use a pool that can at least
guarantee one or two allocations from a pre-existing file. I am
assuming here that renaming the file won't block. If it does, we are
better off not doing so.

> Inodes chunks are allocated and freed dynamically by
> default as well. The 'ikeep' mount option keeps inode chunks around
> indefinitely (even if individual inodes are all freed) if you wanted to
> avoid inode chunk reallocation and know you have a fairly stable working
> set of inodes.

I believe we do have a fairly stable inode working set, even though
that depends a bit on what's considered stable. For our journal-like
structure, we will keep them around until we are sure the information
is safe and them delete them - creating new ones as we receive more
data. But that's always bounded in size.

Am I correct to understand that ikeep being passed, new allocations
would just reuse space from the empty chunks on disk?


> Per-inode extent size hints might be another option to
> increase the size of allocations and perhaps reduce the number of them.
>

That's absolutely greatastic. Our files for that journal are all more
or less the same size. That's a great candidate for a hint.

> Brian

Thanks again, Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
