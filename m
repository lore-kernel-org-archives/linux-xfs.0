Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57375 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbcI3Lzl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 07:55:41 -0400
Date: Fri, 30 Sep 2016 04:55:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] misc: fix fallocate commands that need the unshare
 switch
Message-ID: <20160930115539.GA29955@infradead.org>
References: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
 <147520220822.26891.4328794307942674258.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520220822.26891.4328794307942674258.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Doesn't this have the same issues my patch that checked for -k had?
Namely that we'll only check if the command support the option, not
that the fs beeing tested actually supports them as well?

