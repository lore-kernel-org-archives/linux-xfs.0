Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 30A987F3F
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 23:19:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 102868F8065
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 21:19:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2bi41H1NsajDudRU for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 21:19:36 -0700 (PDT)
Message-ID: <5438AFD8.6060105@sandeen.net>
Date: Fri, 10 Oct 2014 23:19:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: lock for removing item from cil->xc_cil in
	xlog_cil_push
References: <929991500.42327290.1412926226461.JavaMail.zimbra@redhat.com>	<2090211370.42327532.1412926306812.JavaMail.zimbra@redhat.com>
	<20141010120754.GB18297@bfoster.bfoster>
In-Reply-To: <20141010120754.GB18297@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Xu Wang <xuw@redhat.com>
Cc: xfs@oss.sgi.com

On 10/10/14 7:07 AM, Brian Foster wrote:
 
> Isn't this fixed by the following commit?
> 
> 8af3dcd3 xfs: xlog_cil_force_lsn doesn't always wait correctly
> 
> With that patch, xlog_cil_push() adds the ctx to the committing list
> before draining the ctx and updating the current sequence number.
> xlog_cil_force_lsn() walks the committing list and checks the sequence
> number and ctx list, all under the push lock.
> 
> That means that xlog_cil_force_lsn() should see the ctx either on the
> committing list and wait for it (commit_lsn != NULL), or not on the
> committing list at all. If it's not on the committing list yet,
> xlog_cil_push() won't have either drained the ctx or updated the
> sequence number, as it adds to the committing list first and that
> requires the push lock (which xlog_cil_force_lsn() holds and doesn't
> release until after the restart check).
> 
> Am I missing something? Do you reproduce a problem with the latest tree
> that includes the above patch?

We clarified that Dave's patch does fix the problem; this was a Red Hat
bug, and I hadn't put the upstream commit into it yet, sorry about that.

George, thanks for working on it!

-Eric

> Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
