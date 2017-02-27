Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50444 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdB0JXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2017 04:23:15 -0500
Date: Mon, 27 Feb 2017 00:46:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] build: add EXTRALIBS to link with
Message-ID: <20170227084658.GB22809@infradead.org>
References: <1488107722-15022-1-git-send-email-yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488107722-15022-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-xfs@vger.kernel.org, Waldemar Brodkorb <wbx@openadk.org>

This doesn't look like the correct fix to me.  If you specify the
libs at ./configure time they should be picked up by autoconf for
the build process instead of having to specify them again.

Never mind that the configure script really should probabe for the
additional libraries to start with.
