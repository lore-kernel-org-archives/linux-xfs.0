Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:56:51 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7OBuk4p012759
	for <linux-xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:56:49 -0700
Date: Fri, 24 Aug 2007 12:36:31 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 969192: Default mount option "noikeep" makes the inode generation number non-persistent
Message-ID: <20070824113631.GA26868@infradead.org>
References: <46CE581A.2000405@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CE581A.2000405@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: linux-xfs@oss.sgi.com

On Fri, Aug 24, 2007 at 02:01:30PM +1000, Vlad Apostolov wrote:
> To avoid the problem with identical DMAPI handles, the XFSMNT_IDELETE mount
> option should be set as default, only if the filesystem is not mounted with
> XFSMNT_DMAPI.

Note that we have the same problem with nfs exports aswell.  Dateo maybe we
need a real fix insteead and keep a block of generation numbers around even
if and inode cluster is freed or something similar.
