Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51004 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3000393AbdD3Azx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Apr 2017 20:55:53 -0400
Date: Sun, 30 Apr 2017 01:54:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] VFS API for getting filesystem's UUID
Message-ID: <20170430005455.GV29622@ZenIV.linux.org.uk>
References: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
 <20170429230159.GM12369@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170429230159.GM12369@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mfasheh@versity.com>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sun, Apr 30, 2017 at 09:01:59AM +1000, Dave Chinner wrote:

> Doesn't this make the struct export_opierations .get_uuid method
> somewhat redundant?  Shouldn't that now be replaced with generic
> functions that looks at SB_I_HAVE_UUID before allowing PNFS export
> is allowed and then just use s_uuid directly in the PNFS code?

Do we even need a flag?  Checking if 16 bytes are not all zeroes isn't hard,
after all...
