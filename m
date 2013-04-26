Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A1B27CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 11:07:08 -0500 (CDT)
Date: Fri, 26 Apr 2013 11:07:04 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: shutdown filesystem if xfs_perag_get fails
Message-ID: <20130426160704.GF29359@sgi.com>
References: <5174603A.8030208@sandeen.net> <51753EDE.6000301@sgi.com>
	<51754A13.5000808@sandeen.net> <5175532B.3050509@sgi.com>
	<20130422233033.GK30622@dastard> <51769111.3050103@sgi.com>
	<1366732475.3762.32402.camel@chandra-dt.ibm.com>
	<20130423204956.GM10481@dastard>
	<1366929706.4098.6.camel@chandra-dt.ibm.com>
	<517A9E12.1030907@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <517A9E12.1030907@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, sekharan@us.ibm.com, xfs@oss.sgi.com

Hi Mark and Chandra,

On Fri, Apr 26, 2013 at 10:32:34AM -0500, Mark Tinguely wrote:
> On 04/25/13 17:41, Chandra Seetharaman wrote:
> >In which case something along the lines of
> >
> >---
> >diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> >index 3806088..3fb2fa6 100644
> >--- a/fs/xfs/xfs_mount.c
> >+++ b/fs/xfs/xfs_mount.c
> >@@ -203,7 +203,13 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t
> >agno)
> >         if (pag) {
> >                 ASSERT(atomic_read(&pag->pag_ref)>= 0);
> >                 ref = atomic_inc_return(&pag->pag_ref);
> >-       }
> >+       } else
> >+               /*
> >+                * xfs_perag_get() is called with invalid agno,
> >+                * which cannot happen. This indicates a problem
> >+                * in the calling code.
> >+                */
> >+               BUG();
> >         rcu_read_unlock();
> >         trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
> >         return pag;
> >--------
> >
> >would be useful ?. Since we have a NULL pag, we will trip somewhere
> >else. At least with this, there is a pointer to the debugger/sysadmin
> >about where/what to look for (may be with more valuable/correct comment
> >than above).
> >
> 
> We will have to make sure the callers of xfs_perag_get() handle the NULL
> before dereferencing it. Sometimes the NULL is normal and just means the
> perag structure has not been initialize yet.
> 
> Properly handling the NULL from xfs_perag_get() in the caller will also
> mean that the callers of the callers of xfs_perag_get() have to handle
> the NULL returned to them. I will come back to this once the CRC stuff
> has been put to rest.

I agree that we want to address this.  Our worst case should be a forced
shutdown, rather than a NULL ptr deref, or a BUG().  Ideally one corrupted
filesystem does not result in a full system outage, right?  ;)

There are some others like this.  e.g.  xfs_da_read_buf can return 0 with a
null buffer pointer, and we rarely check for that before using bp.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
