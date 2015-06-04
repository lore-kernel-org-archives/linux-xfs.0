Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BAD127FF3
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 03:40:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47944AC003
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 01:40:00 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id BwA0Wu67hfxB8RV5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 01:39:58 -0700 (PDT)
Date: Thu, 4 Jun 2015 10:39:53 +0200
From: Jan Kara <jack@suse.cz>
Subject: Rules for calling ->releasepage()
Message-ID: <20150604083953.GB5923@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
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
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, mfasheh@suse.de, linux-ext4@vger.kernel.org, mgorman@suse.de, xfs@oss.sgi.com

  Hello,

  we were recently debugging an issue where customer was hitting warnings
in xfs_vm_releasepage() which was complaining that the page it was called
for has delay-allocated buffers. After some debugging we realized that
indeed try_to_release_page() call from shrink_active_list() can happen for
a page in arbitrary state (that call happens only if
buffer_heads_over_limit is set so that is the reason why we normally don't
see that).

Hence comes my question: What are the rules for when can ->releasepage() be
called? And what is the expected outcome? We are certainly guaranteed to
hold page lock. try_to_release_page() also makes sure the page isn't under
writeback.  But what is ->releasepage() supposed to do with a dirty page?
Generally IFAIU we aren't supposed to discard dirty data but I wouldn't bet
on all filesystems getting it right because the common call paths make sure
page is clean. I would almost say we should enforce !PageDirty in
try_to_release_page() if it was not for that ext3 nastyness of cleaning
buffers under a dirty page - hum, but maybe the right answer for that is
ripping ext3 out of tree (which would also allow us to get rid of some code
in the blocklayer for bouncing journaled data buffers when stable writes
are required).

Thoughts?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
