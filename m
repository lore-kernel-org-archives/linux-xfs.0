Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 14:21:12 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l77LL5bm008761
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 14:21:06 -0700
Date: Tue, 7 Aug 2007 21:51:49 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/25] VFS: move attr_kill logic from notify_change into helper function
Message-ID: <20070807205145.GB30159@infradead.org>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com

> +void attr_kill_to_mode(struct inode *inode, struct iattr *attr)

This function badly needs a kerneldoc description.  Also I can't say
I like the name a lot, but without a clearly better idea I should
probably not complain :)

We should at least add a generic_ prefix to indicate it's a generic
helper valid for most filesystem (and the kerneldoc comment can explain
the details)
