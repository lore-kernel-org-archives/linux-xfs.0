Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60966 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbeJFRVi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:21:38 -0400
Date: Sat, 6 Oct 2018 03:18:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/15] libfrog: change project entity variable scope
Message-ID: <20181006101855.GO28114@infradead.org>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-16-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538712196-13625-16-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

While the scope change is a good start the code is stull horrible.

I'd be much happier to kill these static variables entirely.  The
buffers can just be on stack, and getprent should just get a
fs_project_t to fill out passed by reference.  Same for
getprpathent.
