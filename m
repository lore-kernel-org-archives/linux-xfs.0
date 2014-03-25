Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC57129DF7
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 11:08:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7856B304048
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 09:08:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wP2vTP7QdCT15DqH for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 09:08:44 -0700 (PDT)
Date: Tue, 25 Mar 2014 12:08:08 -0400
From: Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: [PATCH 2/2] remove ancient sys_getdents code paths
Message-ID: <20140325160808.GB28869@redacted.bos.redhat.com>
References: <20140324181920.GG23291@redacted.bos.redhat.com>
	<20140325141553.GB18691@bfoster.bfoster>
	<20140325153422.GA31551@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140325153422.GA31551@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Mar 25, 2014 at 08:34:22AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 25, 2014 at 10:15:55AM -0400, Brian Foster wrote:
> > I wonder if we could clean up the d_name offset checks to check it once
> > and use a flag. Or use a signed type for size_diff and trigger off that.
> > Just a thought, fwiw.
> 
> I'd just leave the code as-is and just remove the ifdef cruft.  If
> anyone is motivated enough to do real work on this area the callers
> should simply be switched to readdir(3) and friends instead of
> bikeshedding the current cruft.  I just don't want to put even more load
> on Kyle how just wants to get xfsdump running on arm64..
> 

Heh, actually, I started doing exactly that last night, after looking at
all the getdents_wrap callers...

That's probably a bit more... error-sensitive patch though, so I'd
prefer if at least 1/2 and/or 2/2 went in separately for debuggability.

--Kyle

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
