Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37311 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbdDMKvR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 06:51:17 -0400
Date: Thu, 13 Apr 2017 12:51:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: transaction reservations for deleting of shared extents
Message-ID: <20170413105115.GA29974@lst.de>
References: <20170220072945.GA17608@lst.de> <20170221014356.GA5844@birch.djwong.org> <20170412135231.GA3891@lst.de> <20170412230612.GS8502@birch.djwong.org> <20170413035250.GT8502@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413035250.GT8502@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 08:52:50PM -0700, Darrick J. Wong wrote:
> Hmm... can you try out the attached RFC(RAP) xfstests testcase to see if
> it can reproduce the problem you're seeing,

That one gives me a softlockup in xlog_grant_head_wait, so I think we're
having even more problems in this area.  Let me try with a larger log
size and deeg into the issues..
