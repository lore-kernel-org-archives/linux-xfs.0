Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 00:39:20 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6A7dGWu018290
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 00:39:16 -0700
Received: from outhouse.melbourne.sgi.com (outhouse.melbourne.sgi.com [134.14.52.145])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F126304076
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 00:39:12 -0700 (PDT)
Received: from itchy.melbourne.sgi.com (postfix@itchy.melbourne.sgi.com [134.14.55.96])
	by outhouse.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id m6A7d8jm2589202
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 17:39:09 +1000 (AEST)
From: Niv Sardi <xaiki@sgi.com>
Subject: [UPDATED RFC] Create with EA initial work
Date: Thu, 10 Jul 2008 17:39:01 +1000
Message-Id: <1215675545-2707-1-git-send-email-xaiki@sgi.com>
In-Reply-To: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Thanks to everyone for the review of the former patchset, this ones
fixes the bugs found by dgc, changes the naming of the *_trans_*
functions, splits out xfs_bmap_add_attrfork{,_trans} to have one
version doing the whole allocation and calling into the other as
suggested by hch, and has the x_t -> struct x changes too.

There is a bug in this, that I can see with the Parent Pointers code
going on top of it (that will be posted soon), it is basically calling
xfs_attr_set_int_trans() in xfs_create() just before the last
commit. For some reason, the first call to xfs_roll_trans (after
xfs_bmap_add_attrfork_trans()) will complain about the inode being
unlocked after xfs_trans_commit(). I understand I need to call
xfs_trans_ihold(ip) on it, but we already do in xfs_create() so I
think I must be missing something else… any ideas ?
