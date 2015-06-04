Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5ECB7FA9
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 17:44:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4BE7304043
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 15:44:22 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zREnFv98Zuuh4TB4 for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 15:44:20 -0700 (PDT)
Date: Fri, 5 Jun 2015 08:44:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Rules for calling ->releasepage()
Message-ID: <20150604224407.GV24666@dastard>
References: <20150604083953.GB5923@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150604083953.GB5923@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: mfasheh@suse.de, xfs@oss.sgi.com, linux-mm@kvack.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jun 04, 2015 at 10:39:53AM +0200, Jan Kara wrote:
>   Hello,
> 
>   we were recently debugging an issue where customer was hitting warnings
> in xfs_vm_releasepage() which was complaining that the page it was called
> for has delay-allocated buffers. After some debugging we realized that
> indeed try_to_release_page() call from shrink_active_list() can happen for
> a page in arbitrary state (that call happens only if
> buffer_heads_over_limit is set so that is the reason why we normally don't
> see that).
> 
> Hence comes my question: What are the rules for when can ->releasepage() be
> called? And what is the expected outcome? We are certainly guaranteed to
> hold page lock. try_to_release_page() also makes sure the page isn't under
> writeback.  But what is ->releasepage() supposed to do with a dirty page?

According to the comments on try_to_free_page:

 * The @gfp_mask argument specifies whether I/O may be performed to release
 * this page (__GFP_IO), and whether the call may block (__GFP_WAIT & __GFP_FS).

It seems to me like we're supposed to try to clean it if possible,
but it is clear that it can be called from contexts that don't allow
IO and/or blocking so filesystems have to be able to reject dirty
pages and the callers must be able to handle it.  IOWs, calling
->releasepage() with a dirty page must be allowed to fail.

IMO, trying to free a page that is dirty indicates poor reclaim
selection, especially in the case of shrink_active_list() which is
likely to be called in a GFP_NOFS context and so it shouldn't be
asking for dirty pages to be reclaimed because we simply won't do
the IO (i.e. same conditions where we warn and reject ->writepage
calls).

> Generally IFAIU we aren't supposed to discard dirty data but I wouldn't bet
> on all filesystems getting it right because the common call paths make sure
> page is clean.

*nod*

> I would almost say we should enforce !PageDirty in
> try_to_release_page() if it was not for that ext3 nastyness of cleaning
> buffers under a dirty page - hum, but maybe the right answer for that is
> ripping ext3 out of tree (which would also allow us to get rid of some code
> in the blocklayer for bouncing journaled data buffers when stable writes
> are required).

XFS is behaving correctly in that it rejects the attempt to release
the dirty page, but the warning is there to indicate something
higher up is doing something unusual. I'm happy for the higher up
code to be fixed never to try to release a dirty page, even if that
means finally removing the ext3 code base from the tree..

FWIW, dirty pages and therefore pinned bufferheads are limited by
dirty thresholds, so really removing bufferheads from clean pages
is really all that is necessary to bring it back below thresholds.

Cheers,

Dave.

PS: This is yet another reason why I'm working towards removing
bufferheads from XFS....
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
