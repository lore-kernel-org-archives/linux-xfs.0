Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36788 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbeJPCPY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Oct 2018 22:15:24 -0400
Date: Mon, 15 Oct 2018 11:28:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/25] vfs: make remapping to source file eof more
 explicit
Message-ID: <20181015182855.GA20655@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938925737.8361.3995899966552253527.stgit@magnolia>
 <20181014172433.GG30673@infradead.org>
 <20181015153219.GG28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015153219.GG28243@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Oct 15, 2018 at 08:32:19AM -0700, Darrick J. Wong wrote:
> > Why not put that in the name to make it more descriptive?
> 
> I'm all ears for better suggestions. :)

I think the best idea is no flag - just carry through the special
zero..
