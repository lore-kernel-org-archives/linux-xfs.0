Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53778 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755036AbeCHINJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Mar 2018 03:13:09 -0500
Date: Thu, 8 Mar 2018 00:13:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5 V2] libxfs: Catch non-empty zones on destroy
Message-ID: <20180308081308.GF15163@infradead.org>
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
 <c2dd15a8-a048-6373-2fad-3ffd28a606e0@sandeen.net>
 <7fe7fc2a-8ed6-80d7-0727-0093b19f3164@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fe7fc2a-8ed6-80d7-0727-0093b19f3164@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

> @@ -388,16 +388,20 @@ manage_zones(int release)
>  	extern void		xfs_dir_startup();
>  
>  	if (release) {	/* free zone allocation */

I really hate this style..

But not your fault, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
