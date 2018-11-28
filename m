Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35309 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727341AbeK1SxP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Nov 2018 13:53:15 -0500
Date: Wed, 28 Nov 2018 08:52:31 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: COW improvements and always_cow support V2
Message-ID: <20181128075231.GA21281@lst.de>
References: <20181119134619.16812-1-hch@lst.de> <4455584.hbaYzlDTmr@localhost.localdomain> <1984636.oWepG2GJO6@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1984636.oWepG2GJO6@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

Hi Chandan,

thanks for the report.  I don't think we need a new dirty bit,
we just need be a bit better at handling holes.  I'll resend a new
version for testing once I get a little more time for testing.
