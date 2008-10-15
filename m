Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 18:39:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F1dLKI002550
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 18:39:21 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 173514FCBB0
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 18:41:03 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id dJ9WASyw5D7jsnxR for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 18:41:03 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KpvF8-0005Bv-QS
	for xfs@oss.sgi.com; Wed, 15 Oct 2008 12:32:06 +1100
Date: Wed, 15 Oct 2008 12:32:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Attribution of patches in the git tree...
Message-ID: <20081015013206.GT10716@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Folks,

Just noticed that all the btree factoring patches in the
master tree are attributed to Christoph, even when his patch
descriptions gave a different attribution for the source of the
patch. e.g:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=ea8fb246ad5230263f13e45635fad80cc04e28a0

> [XFS] implement generic xfs_btree_increment
>
> From: Dave Chinner <dgc@sgi.com>
>
> Because this is the first major generic btree routine this patch includes
> some infrastrucure, first a few routines to deal with a btree block that
> can be either in short or long form, second xfs_btree_read_buf_block,
> which is the new central routine to read a btree block given a cursor, and
> third the new xfs_btree_ptr_addr routine to calculate the address for a
> given btree pointer record.

The description has a "From: blah" line indicates the author
of the patch was not the person who sent the patch. i.e. the git
"author" is incorrect, and the only way to find that out is by
looking at the commit description.

In future, can we please get the attribution for patches correct
in the git tree so that things like pull requests and historical
mining of the trees accurately reflect who the author of the patches
really are?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
