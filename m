Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60724 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdK1OEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 09:04:54 -0500
Date: Tue, 28 Nov 2017 06:04:51 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for 4.15] libxfs: fix dev_t handling in inode forks
Message-ID: <20171128140451.GA2293@infradead.org>
References: <20171116011505.GH5119@magnolia>
 <20171117165706.GB17447@infradead.org>
 <91f84193-e3c8-c4f7-ca93-5caea3a7bb03@sandeen.net>
 <4be5c1a1-d274-11b8-935b-ddf23d5b5e64@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4be5c1a1-d274-11b8-935b-ddf23d5b5e64@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 27, 2017 at 02:16:47PM -0600, Eric Sandeen wrote:
> Maybe what I'm missing is that it's stupid to carry all those conversions
> around if they're not needed.   ;)  
> 
> I'll stuff the xfs format device number into the "linux" i_rdev, with a comment

Yes, that was the idea.
