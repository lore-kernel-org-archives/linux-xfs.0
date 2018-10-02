Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42556 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeJBILr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 04:11:47 -0400
Date: Tue, 2 Oct 2018 02:31:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] vfs: check ->get_link return value
Message-ID: <20181002013105.GL32577@ZenIV.linux.org.uk>
References: <20181001224500.GE5872@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001224500.GE5872@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Mon, Oct 01, 2018 at 03:45:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach callers of inode->i_op->get_link in the vfs code to check for a
> NULL return value and return an error status instead of blindly
> dereferencing the returned NULL pointer.

IDGI.  If you want it to fail with -EUCLEAN, then by all means return
it as you would any other error.

I've no problem with "fs image is fucked, return an error".  However,
"fs driver is fucked, paper over that if we'd caught one of the
symptoms" is a different story.

NAK in that form.  If we have that happen, let the damn thing oops.
Quietly papering over bugs like that is just plain wrong.
