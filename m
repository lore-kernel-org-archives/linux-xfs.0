Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58669 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbdK1HFL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Nov 2017 02:05:11 -0500
Subject: Re: [PATCH] xfs: Don't trim file extents during iomap
References: <1511437203-4329-1-git-send-email-nborisov@suse.com>
 <20171127174434.GB19379@magnolia> <20171128014746.GC21412@magnolia>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <12dd64f5-d511-f922-dca2-b0689a179407@suse.com>
Date: Tue, 28 Nov 2017 09:05:08 +0200
MIME-Version: 1.0
In-Reply-To: <20171128014746.GC21412@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, sandeen@redhat.com



On 28.11.2017 03:47, Darrick J. Wong wrote:
> generic/170 generic/287 generic/295 generic/326 generic/330 generic/333
> generic/372 xfs/214 xfs/237 xfs/249 xfs/258 xfs/346 xfs/420 xfs/421

right, so all of these are reflink tests which aren't run in my
configuration
