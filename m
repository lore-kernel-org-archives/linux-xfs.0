Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755765AbdIRP45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:56:57 -0400
Date: Mon, 18 Sep 2017 08:56:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: [Bug 196895] New: SLUB debugging prevents booting encrypted
 XFS partition
Message-ID: <20170918155656.GA8102@infradead.org>
References: <20170915141250.e4e9f759fe0cd0469db75924@linux-foundation.org>
 <1505748732.29502.5.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1505748732.29502.5.camel@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: s.panicho@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, "Darrick J.Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org


Not sure how they related to slub debugging, but the warnings you
see below mean that XFS got an I/O error back from the layer below,
so that might be the best place to look.
